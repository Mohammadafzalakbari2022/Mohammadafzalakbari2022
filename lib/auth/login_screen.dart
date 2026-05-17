import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/core/api/pride_api_auth.dart';
import 'package:pride_v3/core/api/pride_api_config.dart';
import 'package:pride_v3/core/branding/app_branding.dart';
import 'package:pride_v3/core/api/pride_api_shop.dart';
import 'package:pride_v3/core/persistence/shared_preferences_provider.dart';
import 'package:pride_v3/core/persistence/sync_cursor_storage.dart';
import 'package:pride_v3/core/persistence/sync_diagnostics_storage.dart';
import 'package:pride_v3/shell/shell_sync_providers.dart';
import 'package:pride_v3/l10n/app_localizations.dart';
import 'package:pride_v3/licensing/license_clock_guard.dart';
import 'package:pride_v3/licensing/license_notifier.dart';
import 'package:pride_v3/licensing/license_providers.dart';
import 'package:pride_v3/licensing/license_snapshot_persist.dart';

import '../core/widgets/pride_form_bottom_bar.dart';

import 'admin_me_provider.dart';
import 'auth_providers.dart';
import 'auth_session_storage.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _shopId = TextEditingController();
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _createShopName = TextEditingController();
  final _createOwnerUser = TextEditingController();
  final _createOwnerPass = TextEditingController();
  bool _busy = false;
  bool _busyCreate = false;

  @override
  void dispose() {
    _shopId.dispose();
    _username.dispose();
    _password.dispose();
    _createShopName.dispose();
    _createOwnerUser.dispose();
    _createOwnerPass.dispose();
    super.dispose();
  }

  Future<void> _persistLoginOk(PrideApiLoginOk ok) async {
    ref.read(authSessionProvider).signInFromApi(
          accessToken: ok.accessToken,
          userId: ok.userId,
          username: ok.username,
          shopId: ok.shopId,
          isShopOwner: ok.isShopOwner,
        );
    ref.read(licenseNotifierProvider).applyLicenseSnapshotMap(ok.licenseSnapshot);
    final prefs = ref.read(sharedPreferencesProvider);
    final serverUtc = snapshotServerUtcFromLicenseJson(ok.licenseSnapshot);
    await LicenseClockGuard.onTrustedServerSnapshot(
      prefs,
      serverNowUtc: serverUtc,
    );
    ref.read(licenseNotifierProvider).setSuspectedTimeTamper(
          LicenseClockGuard.readTamperFlag(prefs),
        );
    final licRaw = ok.licenseSnapshot['status'];
    final licStr =
        licRaw is String && licRaw.isNotEmpty ? licRaw : 'trial_active';
    final expRaw = ok.licenseSnapshot['expires_at'];
    final expStr = expRaw is String && expRaw.isNotEmpty ? expRaw : null;
    final lastRaw = ok.licenseSnapshot['last_successful_check_at'] ??
        ok.licenseSnapshot['server_now'];
    final lastStr = lastRaw is String && lastRaw.isNotEmpty ? lastRaw : null;
    await AuthSessionStorage.persist(
      prefs,
      accessToken: ok.accessToken,
      userId: ok.userId,
      shopId: ok.shopId,
      username: ok.username,
      isShopOwner: ok.isShopOwner,
      licenseStatusApi: licStr,
      licenseExpiresAtIso: expStr,
      licenseLastSuccessfulCheckAtIso: lastStr,
    );
    if (PrideApiConfig.isDeveloperLogin(
      shopId: ok.shopId,
      username: ok.username,
    )) {
      await AuthSessionStorage.markDeveloperPortalUnlocked(prefs);
    }
    ref.invalidate(adminMeProvider);
  }

  Future<void> _signIn(AppLocalizations l10n) async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _busy = true);
    try {
      if (PrideApiConfig.isConfigured) {
        final sid = _shopId.text.trim();
        final result = sid.isNotEmpty
            ? await postPrideApiShopJoin(
                username: _username.text,
                password: _password.text,
                shopId: sid,
              )
            : await postPrideApiLogin(
                username: _username.text,
                password: _password.text,
              );
        if (!mounted) return;

        if (result is PrideApiLoginFailure) {
          final msg = result.statusCode == 401
              ? l10n.loginApiUnauthorized
              : l10n.loginApiError(result.message);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
          return;
        }

        final ok = result as PrideApiLoginOk;
        await _persistLoginOk(ok);
      } else {
        final prefs = ref.read(sharedPreferencesProvider);
        final sid = ref.read(authSessionProvider).shopId?.trim();
        await AuthSessionStorage.clear(prefs);
        if (sid != null && sid.isNotEmpty) {
          await SyncCursorStorage.clearForShop(prefs, sid);
        }
        await SyncDiagnosticsStorage.clear(prefs);
        ref.read(lastSuccessfulSyncAtProvider.notifier).state = null;
        final username = _username.text;
        final shopId = _shopId.text;
        ref.read(authSessionProvider).signInMock(
              username: username,
              password: _password.text,
              shopId: shopId,
            );
        await AuthSessionStorage.persistMock(
          prefs,
          username: username,
          shopId: shopId,
        );
        ref.read(licenseNotifierProvider)
          ..setStatus(LicenseStatus.trialActive)
          ..setSuspectedTimeTamper(false);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _createShop(AppLocalizations l10n) async {
    FocusScope.of(context).unfocus();
    final name = _createShopName.text.trim();
    final ou = _createOwnerUser.text.trim();
    final pass = _createOwnerPass.text;
    if (name.isEmpty || ou.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.loginFieldRequired)),
      );
      return;
    }
    setState(() => _busyCreate = true);
    try {
      final result = await postPrideApiShopCreate(
        shopName: name,
        ownerUsername: ou,
        ownerPassword: pass,
      );
      if (!mounted) return;
      if (result is PrideApiLoginFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.loginShopCreateError(result.message))),
        );
        return;
      }
      final ok = result as PrideApiLoginOk;
      await _persistLoginOk(ok);
    } finally {
      if (mounted) setState(() => _busyCreate = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: prideFormScrollPadding(
            context,
            baseBottom: 24,
            reserveKeyboardInset: true,
          ).copyWith(
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                Center(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(36),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.18,
                          ),
                          blurRadius: 28,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(36),
                      child: Image.asset(
                        kAppBrandIconAsset,
                        width: 168,
                        height: 168,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.storefront_rounded,
                          size: 96,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.appTitle,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.loginTitle,
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.loginSubtitle,
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  PrideApiConfig.isConfigured
                      ? l10n.loginApiHint
                      : l10n.loginMockHint,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _shopId,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: l10n.loginShopIdLabel,
                    hintText: l10n.loginShopIdHint,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _username,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: l10n.loginUsernameLabel,
                    hintText: l10n.loginUsernameHint,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (v) {
                    if ((v ?? '').trim().isEmpty) {
                      return l10n.loginFieldRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _password,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _signIn(l10n),
                  decoration: InputDecoration(
                    labelText: l10n.loginPasswordLabel,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (v) {
                    if ((v ?? '').isEmpty) {
                      return l10n.loginFieldRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _busy ? null : () => _signIn(l10n),
                  child: _busy
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: theme.colorScheme.onPrimary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(l10n.loginSigningIn),
                          ],
                        )
                      : Text(l10n.loginSignInCta),
                ),
                if (PrideApiConfig.isConfigured) ...[
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: _busy
                          ? null
                          : () => context.push('/auth/forgot-password'),
                      child: Text(l10n.loginForgotPasswordCta),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ExpansionTile(
                    title: Text(l10n.loginShopCreateSectionTitle),
                    subtitle: Text(l10n.loginShopCreateSubtitle),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextField(
                              controller: _createShopName,
                              decoration: InputDecoration(
                                labelText: l10n.loginShopCreateNameLabel,
                                border: const OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _createOwnerUser,
                              decoration: InputDecoration(
                                labelText:
                                    l10n.loginShopCreateOwnerUsernameLabel,
                                border: const OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _createOwnerPass,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText:
                                    l10n.loginShopCreateOwnerPasswordLabel,
                                border: const OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 16),
                            FilledButton(
                              onPressed: _busyCreate
                                  ? null
                                  : () => _createShop(l10n),
                              child: _busyCreate
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: theme
                                                .colorScheme.onPrimary,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(l10n.loginShopCreating),
                                      ],
                                    )
                                  : Text(l10n.loginShopCreateCta),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
                if (kDebugMode) ...[
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () async {
                      final prefs = ref.read(sharedPreferencesProvider);
                      final sid = ref.read(authSessionProvider).shopId?.trim();
                      await AuthSessionStorage.clear(prefs);
                      if (sid != null && sid.isNotEmpty) {
                        await SyncCursorStorage.clearForShop(prefs, sid);
                      }
                      await SyncDiagnosticsStorage.clear(prefs);
                      ref.read(lastSuccessfulSyncAtProvider.notifier).state =
                          null;
                      ref.read(authSessionProvider).setAuthenticated(true);
                    },
                    child: Text(l10n.loginDevContinue),
                  ),
                ],
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
