import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../l10n/app_localizations.dart';

/// Asks the user before closing the app (Android back on root tabs).
Future<bool> confirmAppExit(
  BuildContext context,
  AppLocalizations l10n,
) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.appExitConfirmTitle),
      content: Text(l10n.appExitConfirmBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text(l10n.appExitConfirmNo),
        ),
        FilledButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text(l10n.appExitConfirmYes),
        ),
      ],
    ),
  );
  return result ?? false;
}

/// Handles system back when the navigation stack cannot pop further.
Future<void> handleAppExitBack(
  BuildContext context,
  AppLocalizations l10n,
) async {
  if (!context.mounted) return;
  if (await confirmAppExit(context, l10n)) {
    await SystemNavigator.pop();
  }
}
