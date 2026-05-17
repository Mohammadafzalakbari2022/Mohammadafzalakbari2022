import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pride_v3/l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';

/// Copy or share an activation code with a shop-ready message.
Future<void> showDeveloperPortalActivationCodeDialog(
  BuildContext context,
  AppLocalizations l10n, {
  required String code,
  required int planDays,
}) {
  return showDialog<void>(
    context: context,
    builder: (ctx) {
      final shareText = l10n.devPortalCodesShareMessage(code, planDays);
      return AlertDialog(
        title: Text(l10n.devPortalCodesDetailTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SelectableText(
              code,
              style: Theme.of(ctx).textTheme.headlineSmall?.copyWith(
                    fontFamily: 'monospace',
                    letterSpacing: 1.2,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.devPortalCodesPlanDaysLabel,
              style: Theme.of(ctx).textTheme.labelMedium,
            ),
            Text(
              '$planDays',
              style: Theme.of(ctx).textTheme.bodyLarge,
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
              await Clipboard.setData(ClipboardData(text: code));
              if (!ctx.mounted) return;
              Navigator.of(ctx).pop();
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.devPortalCodesCopied)),
              );
            },
            icon: const Icon(Icons.copy_outlined),
            label: Text(l10n.devPortalCodesCopyCta),
          ),
          FilledButton.icon(
            onPressed: () async {
              await Share.share(
                shareText,
                subject: l10n.devPortalCodesShareSubject,
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
