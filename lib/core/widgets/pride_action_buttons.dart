import 'package:flutter/material.dart';

import '../../app/app_theme.dart';

/// Cancel / dismiss (neutral outlined).
class PrideCancelButton extends StatelessWidget {
  const PrideCancelButton({
    super.key,
    required this.onPressed,
    required this.label,
  });

  final VoidCallback? onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: prideButtonStyle(context, PrideButtonVariant.cancel),
      child: Text(label),
    );
  }
}

/// Save / OK / apply (violet primary).
class PrideSaveButton extends StatelessWidget {
  const PrideSaveButton({
    super.key,
    required this.onPressed,
    required this.label,
  });

  final VoidCallback? onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: prideButtonStyle(context, PrideButtonVariant.primary),
      child: Text(label),
    );
  }
}

/// Destructive confirm (red).
class PrideDeleteButton extends StatelessWidget {
  const PrideDeleteButton({
    super.key,
    required this.onPressed,
    required this.label,
  });

  final VoidCallback? onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: prideButtonStyle(context, PrideButtonVariant.delete),
      child: Text(label),
    );
  }
}

/// Create / add new (emerald).
class PrideAddButton extends StatelessWidget {
  const PrideAddButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
  });

  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final style = prideButtonStyle(context, PrideButtonVariant.add);
    if (icon != null) {
      return FilledButton.icon(
        onPressed: onPressed,
        style: style,
        icon: Icon(icon),
        label: Text(label),
      );
    }
    return FilledButton(onPressed: onPressed, style: style, child: Text(label));
  }
}

/// Edit / change (blue).
class PrideEditButton extends StatelessWidget {
  const PrideEditButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
  });

  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final style = prideButtonStyle(context, PrideButtonVariant.edit);
    if (icon != null) {
      return FilledButton.icon(
        onPressed: onPressed,
        style: style,
        icon: Icon(icon),
        label: Text(label),
      );
    }
    return FilledButton(onPressed: onPressed, style: style, child: Text(label));
  }
}

/// Standard dialog footer: cancel + primary confirm.
List<Widget> prideDialogCancelSave({
  required BuildContext context,
  required VoidCallback onCancel,
  required VoidCallback onConfirm,
  required String saveLabel,
  PrideButtonVariant confirmVariant = PrideButtonVariant.primary,
}) {
  return [
    PrideCancelButton(
      onPressed: onCancel,
      label: MaterialLocalizations.of(context).cancelButtonLabel,
    ),
    FilledButton(
      onPressed: onConfirm,
      style: prideButtonStyle(context, confirmVariant),
      child: Text(saveLabel),
    ),
  ];
}

/// Standard dialog footer: cancel + destructive confirm.
List<Widget> prideDialogCancelDelete({
  required BuildContext context,
  required VoidCallback onCancel,
  required VoidCallback onConfirm,
  required String deleteLabel,
}) {
  return [
    PrideCancelButton(
      onPressed: onCancel,
      label: MaterialLocalizations.of(context).cancelButtonLabel,
    ),
    PrideDeleteButton(onPressed: onConfirm, label: deleteLabel),
  ];
}

/// List-row icon action with a colored tonal circle (edit, delete, etc.).
class PrideIconAction extends StatelessWidget {
  const PrideIconAction({
    super.key,
    required this.icon,
    required this.variant,
    required this.onPressed,
    this.tooltip,
  });

  final IconData icon;
  final PrideButtonVariant variant;
  final VoidCallback? onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<PrideActionColors>()!;
    final (bg, fg) = switch (variant) {
      PrideButtonVariant.edit => (colors.editContainer, colors.onEditContainer),
      PrideButtonVariant.delete => (
        colors.deleteContainer,
        colors.onDeleteContainer,
      ),
      PrideButtonVariant.add => (colors.addContainer, colors.onAddContainer),
      PrideButtonVariant.warning => (
        colors.warningContainer,
        colors.onWarningContainer,
      ),
      PrideButtonVariant.payment => (
        colors.paymentContainer,
        colors.onPaymentContainer,
      ),
      _ => (colors.editContainer, colors.onEditContainer),
    };

    final button = Material(
      color: bg,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, color: fg, size: 22),
        ),
      ),
    );

    if (tooltip != null && tooltip!.isNotEmpty) {
      return Tooltip(message: tooltip!, child: button);
    }
    return button;
  }
}
