import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/auth/auth_providers.dart';
import 'package:pride_v3/core/api/pride_api_admin.dart';
import 'package:pride_v3/core/api/pride_api_config.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

/// Developer portal: change the signed-in operator password only (`POST /admin/me/password`).
class DeveloperPortalAccountTab extends ConsumerStatefulWidget {
  const DeveloperPortalAccountTab({super.key});

  @override
  ConsumerState<DeveloperPortalAccountTab> createState() =>
      _DeveloperPortalAccountTabState();
}

class _DeveloperPortalAccountTabState
    extends ConsumerState<DeveloperPortalAccountTab> {
  final _current = TextEditingController();
  final _newPw = TextEditingController();
  final _confirm = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _current.dispose();
    _newPw.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit(AppLocalizations l10n) async {
    if (!PrideApiConfig.isConfigured) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.devPortalStubAction)),
      );
      return;
    }
    final token = ref.read(authSessionProvider).accessToken;
    if (token == null) return;
    final n = _newPw.text.trim();
    if (n.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.devPortalChangePasswordFail)),
      );
      return;
    }
    if (n != _confirm.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.devPortalPasswordMismatch)),
      );
      return;
    }
    setState(() => _busy = true);
    final r = await postPrideApiAdminChangeMyPassword(
      accessToken: token,
      currentPassword: _current.text,
      newPassword: n,
    );
    if (!mounted) return;
    setState(() => _busy = false);
    if (r.ok) {
      _current.clear();
      _newPw.clear();
      _confirm.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.devPortalChangePasswordOk)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(r.error ?? l10n.devPortalChangePasswordFail)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          l10n.devPortalMyPasswordTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(l10n.devPortalMyPasswordSubtitle),
        const SizedBox(height: 24),
        TextField(
          controller: _current,
          obscureText: true,
          decoration: InputDecoration(
            labelText: l10n.devPortalCurrentPasswordLabel,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _newPw,
          obscureText: true,
          decoration: InputDecoration(
            labelText: l10n.devPortalNewPasswordLabel,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _confirm,
          obscureText: true,
          decoration: InputDecoration(
            labelText: l10n.devPortalConfirmPasswordLabel,
          ),
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: _busy ? null : () => _submit(l10n),
          child: _busy
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.devPortalChangePasswordCta),
        ),
      ],
    );
  }
}
