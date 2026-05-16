import 'package:flutter/material.dart';

import 'keyboard_safe_bottom_bar.dart';
import 'pride_action_buttons.dart';

/// Bottom bar for forms: optional cancel (tonal) + primary action, stays above keyboard.
class PrideFormBottomBar extends StatelessWidget {
  const PrideFormBottomBar({
    super.key,
    this.onCancel,
    this.cancelLabel,
    required this.primary,
  });

  final VoidCallback? onCancel;
  final String? cancelLabel;
  final Widget primary;

  @override
  Widget build(BuildContext context) {
    final ml = MaterialLocalizations.of(context);
    final cancel = onCancel;
    return KeyboardSafeBottomBar(
      child: cancel == null
          ? primary
          : Row(
              children: [
                Expanded(
                  child: PrideCancelButton(
                    onPressed: cancel,
                    label: cancelLabel ?? ml.cancelButtonLabel,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: primary),
              ],
            ),
    );
  }
}

/// List / scroll body padding that grows when the software keyboard is open.
EdgeInsets prideFormScrollPadding(
  BuildContext context, {
  double baseBottom = 96,
}) {
  final kb = MediaQuery.viewInsetsOf(context).bottom;
  return EdgeInsets.fromLTRB(16, 16, 16, baseBottom + kb);
}
