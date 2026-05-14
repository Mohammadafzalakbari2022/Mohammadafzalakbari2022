import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/core/api/pride_api_config.dart';
import 'package:pride_v3/core/api/pride_api_password_reset.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.loginForgotPasswordFieldsRequired)),
      );
      return;
    }
    setState(() => _busy = true);
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.loginApiError(message))),
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
            onSubmitted: (_) => _submit(l10n),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _busy ? null : () => _submit(l10n),
            child: _busy
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.loginForgotPasswordSubmit),
          ),
        ],
      ),
    );
  }
}
