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

/// List / scroll body padding above a [PrideFormBottomBar] or similar footer.
///
/// Do not add keyboard insets here when the footer already uses
/// [KeyboardSafeBottomBar] — double-reserving space rebuilds the scroll view and
/// can dismiss the keyboard after the first keystroke.
EdgeInsets prideFormScrollPadding(
  BuildContext context, {
  double baseBottom = 96,
  bool reserveKeyboardInset = false,
}) {
  final kb = reserveKeyboardInset ? MediaQuery.viewInsetsOf(context).bottom : 0.0;
  return EdgeInsets.fromLTRB(16, 16, 16, baseBottom + kb);
}
