import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import 'auth_providers.dart';

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

  @override
  void dispose() {
    _shopId.dispose();
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  void _signIn(AppLocalizations l10n) {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    ref.read(authSessionProvider).signInMock(
          username: _username.text,
          password: _password.text,
          shopId: _shopId.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                Text(
                  l10n.loginTitle,
                  style: theme.textTheme.headlineMedium,
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
                  l10n.loginMockHint,
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
                  onPressed: () => _signIn(l10n),
                  child: Text(l10n.loginSignInCta),
                ),
                if (kDebugMode) ...[
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () {
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
