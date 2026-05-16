import 'package:flutter/material.dart';
import 'package:pride_v3/core/widgets/pride_action_buttons.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

/// Owner password dialog for Settings (plan-15).
Future<String?> promptOwnerPasswordForSettings(BuildContext context) async {
  final l10n = AppLocalizations.of(context)!;
  final controller = TextEditingController();
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.ownerPasswordTitle),
      content: TextField(
        controller: controller,
        obscureText: true,
        decoration: InputDecoration(
          labelText: l10n.ownerPasswordLabel,
        ),
      ),
      actions: prideDialogCancelSave(
        context: context,
        onCancel: () => Navigator.of(context).pop(false),
        onConfirm: () => Navigator.of(context).pop(true),
        saveLabel: MaterialLocalizations.of(context).okButtonLabel,
      ),
    ),
  );
  if (ok != true) return null;
  final value = controller.text.trim();
  if (value.isEmpty) return null;
  return value;
}
