import 'package:flutter/material.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../security/delete_by_typing_name.dart';

/// Simple yes/no before applying a non-destructive order field edit.
Future<bool> confirmOrderFieldEdit(BuildContext context, AppLocalizations l10n) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.ordersEditConfirmTitle),
      content: Text(l10n.ordersEditConfirmBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text(l10n.saveCta),
        ),
      ],
    ),
  ).then((v) => v == true);
}

/// Status change (except cancel): message only.
Future<bool> confirmOrderStatusChange(
  BuildContext context,
  AppLocalizations l10n,
  String statusLabel,
) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.ordersStatusChangeConfirmTitle),
      content: Text(l10n.ordersStatusChangeConfirmBody(statusLabel)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text(MaterialLocalizations.of(ctx).okButtonLabel),
        ),
      ],
    ),
  ).then((v) => v == true);
}

/// Cancel order: type customer name (no owner password).
Future<bool> confirmOrderCancelByCustomerName(
  BuildContext context,
  AppLocalizations l10n,
  String customerName,
) {
  return confirmDeleteByTypingName(
    context,
    l10n: l10n,
    title: l10n.ordersCancelOrderConfirmTitle,
    explanation: l10n.ordersCancelOrderConfirmBody,
    expectedName: customerName.trim(),
  );
}
