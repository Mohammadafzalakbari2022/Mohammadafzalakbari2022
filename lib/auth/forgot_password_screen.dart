import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/core/api/pride_api_config.dart';
import 'package:pride_v3/core/api/pride_api_password_reset.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import 'auth_form_feedback_banner.dart';
import 'auth_user_messages.dart';

/// Request password reset (developer completes in portal) — `plan-18`.
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _shopId = TextEditingController();
  final _username = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _shopId.dispose();
    _username.dispose();
    super.dispose();
  }

  Future<void> _submit(AppLocalizations l10n) async {
    if (!PrideApiConfig.isConfigured) return;
    final shop = _shopId.text.trim();
    final user = _username.text.trim();
    if (shop.isEmpty || user.isEmpty) {
      setState(() => _error = l10n.loginForgotPasswordFieldsRequired);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final r = await postPrideApiPasswordResetRequest(
        shopId: shop,
        username: user,
      );
      if (!mounted) return;
      switch (r) {
        case PrideApiPasswordResetRequestOk():
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.loginForgotPasswordQueued)),
          );
          context.pop();
        case PrideApiPasswordResetRequestFailure(:final message):
          setState(
            () => _error = passwordResetFailureUserMessage(
              l10n,
              rawMessage: message,
            ),
          );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _busy ? null : () => context.pop(),
        ),
        title: Text(l10n.loginForgotPasswordTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l10n.loginForgotPasswordBody),
          const SizedBox(height: 16),
          if (_busy)
            AuthFormFeedbackBanner(
              loadingTitle: l10n.loginForgotPasswordSubmitting,
              loadingHint: l10n.loginForgotPasswordSubmitHint,
            )
          else if (_error != null)
            AuthFormFeedbackBanner(errorMessage: _error),
          if (_busy || _error != null) const SizedBox(height: 16),
          TextField(
            controller: _shopId,
            decoration: InputDecoration(
              labelText: l10n.loginShopIdLabel,
              border: const OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.next,
            enabled: !_busy,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _username,
            decoration: InputDecoration(
              labelText: l10n.loginUsernameLabel,
              border: const OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.done,
            enabled: !_busy,
            onSubmitted: (_) {
              if (!_busy) _submit(l10n);
            },
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _busy ? null : () => _submit(l10n),
            child: Text(
              _busy
                  ? l10n.loginForgotPasswordSubmitting
                  : l10n.loginForgotPasswordSubmit,
            ),
          ),
        ],
      ),
    );
  }
}
