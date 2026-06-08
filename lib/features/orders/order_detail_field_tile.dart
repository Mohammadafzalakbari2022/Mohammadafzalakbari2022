import 'package:flutter/material.dart';

import 'package:pride_v3/app/app_theme.dart';

/// Bordered label/value tile for order detail sections.
class OrderDetailFieldTile extends StatelessWidget {
  const OrderDetailFieldTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.trailing,
    this.selectable = false,
    this.emphasizeValue = false,
    this.tintVariant,
  });

  final IconData icon;
  final String label;
  final String value;
  final Widget? trailing;
  final bool selectable;
  final bool emphasizeValue;
  final int? tintVariant;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final variant = tintVariant ?? label.hashCode.abs() % 3;

    final valueStyle = theme.textTheme.bodyMedium?.copyWith(
      fontWeight: emphasizeValue ? FontWeight.w800 : FontWeight.w600,
      color: emphasizeValue ? scheme.primary : scheme.onSurface,
    );

    final valueWidget = selectable
        ? SelectableText(value, style: valueStyle)
        : Text(value, style: valueStyle);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: prideFriendlyTileFill(scheme, variant: variant),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: scheme.outlineVariant.withValues(alpha: 0.55),
          ),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(12, 10, 12, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 20, color: scheme.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                      maxLines: 3,
                      softWrap: true,
                    ),
                    const SizedBox(height: 3),
                    valueWidget,
                  ],
                ),
              ),
              // ignore: use_null_aware_elements -- isar_generator cannot parse `?trailing`.
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}

/// Compact bordered chip for metadata (dates, order #) in order detail hero.
class OrderDetailMetaChip extends StatelessWidget {
  const OrderDetailMetaChip({
    super.key,
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: prideFriendlyTileFill(scheme, variant: 0),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.55),
        ),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(8, 5, 10, 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: scheme.onSurfaceVariant),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: scheme.onSurface,
                ),
                maxLines: 3,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
