import 'package:flutter/material.dart';

import '../../app/app_theme.dart';

/// Toolbar close / dismiss with a clear tonal background (easy to spot after forms).
class PrideCloseIconButton extends StatelessWidget {
  const PrideCloseIconButton({
    super.key,
    required this.onPressed,
    this.tooltip,
    this.icon = Icons.close_rounded,
  });

  final VoidCallback? onPressed;
  final String? tooltip;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final actions = Theme.of(context).extension<PrideActionColors>()!;
    final button = Material(
      color: actions.cancelContainer,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(
            icon,
            size: 22,
            color: onPressed == null
                ? actions.onCancelContainer.withValues(alpha: 0.45)
                : actions.onCancelContainer,
          ),
        ),
      ),
    );
    if (tooltip != null && tooltip!.isNotEmpty) {
      return Tooltip(message: tooltip!, child: button);
    }
    return button;
  }
}
