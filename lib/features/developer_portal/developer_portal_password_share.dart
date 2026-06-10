import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pride_v3/l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';

/// Copy or share a new password with the shop user (support workflow).
Future<void> showDeveloperPortalPasswordShareDialog(
  BuildContext context,
  AppLocalizations l10n, {
  required String shopLabel,
  required String username,
  required String password,
}) {
  final shareText = l10n.devPortalPasswordShareMessage(
    shopLabel,
    username,
    password,
  );
  return showDialog<void>(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: Text(l10n.devPortalPasswordShareTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.devPortalPasswordShareUserLabel(shopLabel, username),
              style: Theme.of(ctx).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            SelectableText(
              password,
              style: Theme.of(ctx).textTheme.headlineSmall?.copyWith(
                    fontFamily: 'monospace',
                    letterSpacing: 1.2,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(MaterialLocalizations.of(ctx).closeButtonLabel),
          ),
          TextButton.icon(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: password));
              if (!ctx.mounted) return;
              Navigator.of(ctx).pop();
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.devPortalPasswordCopied)),
              );
            },
            icon: const Icon(Icons.copy_outlined),
            label: Text(l10n.devPortalCodesCopyCta),
          ),
          FilledButton.icon(
            onPressed: () async {
              await Share.share(
                shareText,
                subject: l10n.devPortalPasswordShareSubject,
              );
            },
            icon: const Icon(Icons.share_outlined),
            label: Text(l10n.devPortalCodesShareCta),
          ),
        ],
      );
    },
  );
}

/// Dialog to enter a new password (min 6 chars) before applying.
Future<String?> showDeveloperPortalSetPasswordDialog(
  BuildContext context,
  AppLocalizations l10n, {
  String? subtitle,
}) {
  final pwCtrl = TextEditingController();
  return showDialog<String>(
    context: context,
    builder: (ctx) {
      String? localError;
      return StatefulBuilder(
        builder: (ctx, setLocal) {
          return AlertDialog(
            title: Text(l10n.devPortalResetsSetPasswordTitle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (subtitle != null && subtitle.isNotEmpty) ...[
                  Text(subtitle),
                  const SizedBox(height: 12),
                ],
                Text(l10n.devPortalResetsSetPasswordHint),
                const SizedBox(height: 12),
                TextField(
                  controller: pwCtrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: l10n.loginPasswordLabel,
                    errorText: localError,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
              ),
              FilledButton(
                onPressed: () {
                  final pw = pwCtrl.text;
                  if (pw.trim().length < 6) {
                    setLocal(() => localError = l10n.devPortalResetsSetPasswordHint);
                    return;
                  }
                  Navigator.of(ctx).pop(pw);
                },
                child: Text(l10n.devPortalResetsResolveCta),
              ),
            ],
          );
        },
      );
    },
  );
}
