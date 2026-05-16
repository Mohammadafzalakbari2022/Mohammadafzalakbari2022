import 'package:flutter/material.dart';

import '../../app/app_theme.dart';

/// Clear, icon-led alert for validation and guidance (order composer, etc.).
Future<T?> showPrideAlertDialog<T>({
  required BuildContext context,
  required String title,
  required Widget content,
  required IconData icon,
  Color? iconColor,
  List<Widget>? actions,
}) {
  final scheme = Theme.of(context).colorScheme;
  final prideActions = Theme.of(context).extension<PrideActionColors>()!;
  final color = iconColor ?? prideActions.warning;
  final bg = color.withValues(alpha: 0.14);

  return showDialog<T>(
    context: context,
    builder: (ctx) => AlertDialog(
      icon: Container(
        width: 52,
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: color, size: 28),
      ),
      iconPadding: const EdgeInsets.only(top: 20),
      title: Text(title, textAlign: TextAlign.center),
      content: DefaultTextStyle(
        style: Theme.of(ctx).textTheme.bodyMedium!.copyWith(
              color: scheme.onSurfaceVariant,
            ),
        child: content,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: actions,
    ),
  );
}

/// Bullet row for validation lists inside [showPrideAlertDialog].
class PrideAlertDialogBullet extends StatelessWidget {
  const PrideAlertDialogBullet({
    super.key,
    required this.icon,
    required this.label,
    this.iconColor,
  });

  final IconData icon;
  final String label;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = iconColor ?? scheme.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrideColoredLeading(
            icon: icon,
            color: color,
            background: color.withValues(alpha: 0.12),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(label),
            ),
          ),
        ],
      ),
    );
  }
}
