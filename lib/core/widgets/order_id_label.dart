import 'package:flutter/material.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../formatting/display_order_no_format.dart';

/// Secondary order identifier — smaller visual weight than [CustomerIdBadge].
class OrderIdLabel extends StatelessWidget {
  const OrderIdLabel({
    super.key,
    required this.storedOrderNo,
    this.style,
    this.icon,
  });

  final String storedOrderNo;
  final TextStyle? style;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = displayOrderNumberLabel(
      AppLocalizations.of(context)!,
      storedOrderNo,
    );
    final resolvedStyle = style ??
        theme.textTheme.bodySmall?.copyWith(
          color: scheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        );

    if (icon == null) {
      return Text(text, style: resolvedStyle);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: scheme.onSurfaceVariant),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            style: resolvedStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
