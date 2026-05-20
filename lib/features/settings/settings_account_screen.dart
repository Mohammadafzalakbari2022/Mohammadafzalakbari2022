import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/core/api/pride_api_auth.dart';
import 'package:pride_v3/core/api/pride_api_config.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../auth/auth_providers.dart';
import '../../auth/offline_credential_storage.dart';
import '../../core/persistence/shared_preferences_provider.dart';

/// Account details and self-service password change (`plan-15`).
class SettingsAccountScreen extends ConsumerStatefulWidget {
  const SettingsAccountScreen({super.key});

  @override
  ConsumerState<SettingsAccountScreen> createState() =>
      _SettingsAccountScreenState();
}

class _SettingsAccountScreenState extends ConsumerState<SettingsAccountScreen> {
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit(AppLocalizations l10n) async {
    final current = _currentCtrl.text;
    final next = _newCtrl.text;
    final confirm = _confirmCtrl.text;
    if (current.isEmpty || next.isEmpty || confirm.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.loginFieldRequired)),
      );
      return;
    }
    if (next != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.settingsAccountPasswordMismatch)),
      );
      return;
    }
    final auth = ref.read(authSessionProvider);
    final token = auth.accessToken;
    if (token == null || token.isEmpty) return;
    setState(() => _submitting = true);
    final err = await postPrideApiChangePassword(
      accessToken: token,
      currentPassword: current,
      newPassword: next,
    );
    if (!mounted) return;
    setState(() => _submitting = false);
    if (err == null) {
      final shopId = auth.shopId;
      final username = auth.username;
      if (shopId != null &&
          shopId.isNotEmpty &&
          username != null &&
          username.isNotEmpty) {
        await OfflineCredentialStorage.updatePasswordHash(
          ref.read(sharedPreferencesProvider),
          shopId: shopId,
          username: username,
          newPassword: next,
        );
      }
      _currentCtrl.clear();
      _newCtrl.clear();
      _confirmCtrl.clear();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.settingsAccountChangePasswordOk)),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.settingsAccountChangePasswordFail(err))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final auth = ref.watch(authSessionProvider);
    final apiOn = PrideApiConfig.isConfigured && auth.hasApiSession;
    final roleLabel =
        auth.isShopOwner ? l10n.settingsRoleOwner : l10n.settingsRoleUser;
    final username = auth.username?.trim();
    final displayName = (username == null || username.isEmpty)
        ? l10n.settingsCurrentUserGuest
        : username;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsAccountTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.settingsAccountUsernameLabel,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    displayName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.settingsAccountUsernameHint,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.settingsAccountRoleLabel,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(roleLabel),
                  if (auth.shopId != null && auth.shopId!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      l10n.settingsShopIdChip(auth.shopId!),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.settingsAccountChangePasswordTitle,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 4),
          Text(
            l10n.settingsAccountChangePasswordSubtitle,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          if (!apiOn)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(l10n.settingsAccountOfflineHint),
              ),
            )
          else ...[
            TextField(
              controller: _currentCtrl,
              obscureText: true,
              enabled: !_submitting,
              decoration: InputDecoration(
                labelText: l10n.settingsAccountCurrentPasswordLabel,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _newCtrl,
              obscureText: true,
              enabled: !_submitting,
              decoration: InputDecoration(
                labelText: l10n.settingsAccountNewPasswordLabel,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _confirmCtrl,
              obscureText: true,
              enabled: !_submitting,
              decoration: InputDecoration(
                labelText: l10n.settingsAccountConfirmPasswordLabel,
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (_) => _submit(l10n),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _submitting ? null : () => _submit(l10n),
              icon: _submitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.lock_reset),
              label: Text(l10n.settingsAccountChangePasswordCta),
            ),
          ],
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => context.push('/auth/forgot-password'),
            child: Text(l10n.settingsAccountForgotPasswordCta),
          ),
        ],
      ),
    );
  }
}
