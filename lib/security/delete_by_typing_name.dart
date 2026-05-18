import 'package:flutter/material.dart';
import 'package:pride_v3/core/widgets/pride_action_buttons.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

/// Confirms a destructive delete by requiring the user to type [expectedName] exactly.
///
/// Used for orders (order number) and customers (customer name). Returns `true` when
/// the typed value matches after trim.
Future<bool> confirmDeleteByTypingName(
  BuildContext context, {
  required AppLocalizations l10n,
  required String title,
  required String explanation,
  required String expectedName,
}) async {
  final controller = TextEditingController();
  var mismatch = false;

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(explanation),
            const SizedBox(height: 12),
            Text(l10n.deleteByTypingConfirmHint(expectedName)),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(
                labelText: l10n.deleteByTypingConfirmFieldLabel,
                errorText: mismatch ? l10n.deleteByTypingConfirmMismatch : null,
              ),
              onChanged: (_) {
                if (mismatch) setState(() => mismatch = false);
              },
            ),
          ],
        ),
        actions: prideDialogCancelDelete(
          context: ctx,
          onCancel: () => Navigator.of(ctx).pop(false),
          onConfirm: () {
            final typed = controller.text.trim();
            if (typed != expectedName.trim()) {
              setState(() => mismatch = true);
              return;
            }
            Navigator.of(ctx).pop(true);
          },
          deleteLabel: l10n.deleteCta,
        ),
      ),
    ),
  );

  controller.dispose();
  return confirmed == true;
}
