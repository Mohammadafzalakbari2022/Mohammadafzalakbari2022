import 'package:flutter/material.dart';
import 'package:pride_v3/app/app_theme.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/local/entities/garment_type.dart';
import '../../data/local/order_item_draft.dart';

String composerGarmentLabel(AppLocalizations l10n, GarmentType type) {
  return switch (type) {
    GarmentType.perahanTunban => l10n.garmentPerahanTunban,
    GarmentType.waistcoat => l10n.garmentWaistcoat,
  };
}

IconData composerGarmentIcon(GarmentType type) {
  return switch (type) {
    GarmentType.perahanTunban => Icons.checkroom_outlined,
    GarmentType.waistcoat => Icons.layers_outlined,
  };
}

/// Distinct garment glyphs: long Perahan/Tunban robe vs sleeveless waistcoat.
class ComposerGarmentIcon extends StatelessWidget {
  const ComposerGarmentIcon({
    super.key,
    required this.type,
    this.size = 22,
    this.color,
  });

  final GarmentType type;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final iconColor =
        color ?? IconTheme.of(context).color ?? Theme.of(context).colorScheme.onSurfaceVariant;
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _ComposerGarmentIconPainter(type: type, color: iconColor),
      ),
    );
  }
}

class _ComposerGarmentIconPainter extends CustomPainter {
  const _ComposerGarmentIconPainter({required this.type, required this.color});

  final GarmentType type;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.shortestSide * 0.09
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final fill = Paint()
      ..color = color.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;

    if (type == GarmentType.perahanTunban) {
      _paintPerahan(canvas, size, stroke, fill);
    } else {
      _paintWaistcoat(canvas, size, stroke, fill);
    }
  }

  void _paintPerahan(Canvas canvas, Size size, Paint stroke, Paint fill) {
    final w = size.width;
    final h = size.height;
    final body = Path()
      ..moveTo(w * 0.35, h * 0.12)
      ..lineTo(w * 0.65, h * 0.12)
      ..lineTo(w * 0.72, h * 0.28)
      ..lineTo(w * 0.68, h * 0.92)
      ..lineTo(w * 0.32, h * 0.92)
      ..lineTo(w * 0.28, h * 0.28)
      ..close();
    canvas.drawPath(body, fill);
    canvas.drawPath(body, stroke);
    canvas.drawLine(Offset(w * 0.5, h * 0.12), Offset(w * 0.5, h * 0.92), stroke);
    canvas.drawLine(Offset(w * 0.18, h * 0.32), Offset(w * 0.35, h * 0.22), stroke);
    canvas.drawLine(Offset(w * 0.82, h * 0.32), Offset(w * 0.65, h * 0.22), stroke);
  }

  void _paintWaistcoat(Canvas canvas, Size size, Paint stroke, Paint fill) {
    final w = size.width;
    final h = size.height;
    final vest = Path()
      ..moveTo(w * 0.22, h * 0.18)
      ..lineTo(w * 0.38, h * 0.30)
      ..lineTo(w * 0.5, h * 0.24)
      ..lineTo(w * 0.62, h * 0.30)
      ..lineTo(w * 0.78, h * 0.18)
      ..lineTo(w * 0.74, h * 0.88)
      ..lineTo(w * 0.26, h * 0.88)
      ..close();
    canvas.drawPath(vest, fill);
    canvas.drawPath(vest, stroke);
    canvas.drawLine(Offset(w * 0.5, h * 0.24), Offset(w * 0.5, h * 0.88), stroke);
    for (var i = 0; i < 3; i++) {
      final y = h * (0.42 + i * 0.14);
      canvas.drawLine(Offset(w * 0.5, y), Offset(w * 0.5, y + h * 0.06), stroke);
    }
  }

  @override
  bool shouldRepaint(covariant _ComposerGarmentIconPainter oldDelegate) =>
      oldDelegate.type != type || oldDelegate.color != color;
}

String composerItemCompletionSummary(AppLocalizations l10n, OrderItemDraft draft) {
  final parts = <String>[];
  if (draft.hasMeasurements) {
    parts.add(l10n.ordersComposerMeasurementsSummary);
  } else {
    parts.add(l10n.ordersComposerMeasurementsRequired);
  }
  if (draft.hasStyle) {
    parts.add(l10n.ordersComposerProgressStyle);
  } else {
    parts.add(l10n.ordersComposerStyleRequired);
  }
  if (draft.hasRequiredPrice) {
    parts.add(l10n.ordersComposerItemReady);
  } else {
    parts.add(l10n.ordersComposerItemPriceRequired);
  }
  return parts.join(' · ');
}

/// Expandable garment line inside the new-order composer.
class OrderComposerItemCard extends StatelessWidget {
  const OrderComposerItemCard({
    super.key,
    required this.l10n,
    required this.garmentType,
    required this.draft,
    required this.expanded,
    required this.onExpandedChanged,
    required this.onOpenMeasurements,
    required this.onOpenStyle,
    required this.onOpenFabric,
    this.onUseSameFabric,
  });

  final AppLocalizations l10n;
  final GarmentType garmentType;
  final OrderItemDraft draft;
  final bool expanded;
  final ValueChanged<bool> onExpandedChanged;
  final VoidCallback onOpenMeasurements;
  final VoidCallback onOpenStyle;
  final VoidCallback onOpenFabric;
  final VoidCallback? onUseSameFabric;

  String get _styleSubtitle {
    if (!draft.hasStyle) return l10n.ordersComposerStyleRequired;
    if (draft.catalogDesignName.trim().isNotEmpty) {
      final styleHead = draft.styleSummary.trim().isNotEmpty
          ? draft.styleSummary.trim().split('\n').first
          : draft.styleName.trim();
      return '$styleHead · ${draft.catalogDesignName.trim()}';
    }
    return draft.styleSummary.trim().isNotEmpty
        ? draft.styleSummary.trim().split('\n').first
        : draft.styleName.trim();
  }

  String get _fabricSubtitle {
    if (!draft.hasFabric) return l10n.ordersComposerFabricUnset;
    if (draft.fabricId.trim().isNotEmpty &&
        draft.fabricName.trim().isNotEmpty &&
        draft.fabricColor.trim().isNotEmpty) {
      return l10n.ordersComposerFabricSummary(
        draft.fabricName.trim(),
        draft.fabricColor.trim(),
        draft.fabricId.trim(),
      );
    }
    return l10n.ordersComposerFabricPartialSummary(
      draft.fabricName.trim().isEmpty ? '—' : draft.fabricName.trim(),
      draft.fabricColor.trim().isEmpty ? '—' : draft.fabricColor.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = composerGarmentLabel(l10n, garmentType);
    final colorIndex = garmentType == GarmentType.perahanTunban ? 1 : 2;

    return Card(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            title: Text(title),
            subtitle: Text(
              composerItemCompletionSummary(l10n, draft),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Icon(
              expanded ? Icons.expand_less : Icons.expand_more,
            ),
            onTap: () => onExpandedChanged(!expanded),
          ),
          if (expanded) ...[
            const Divider(height: 1),
            ListTile(
              title: Text(l10n.ordersComposerMeasurementsTitle),
              subtitle: Text(
                draft.hasMeasurements
                    ? l10n.ordersComposerMeasurementsSummary
                    : l10n.ordersComposerMeasurementsRequired,
              ),
              leading: PrideColoredLeading(
                icon: Icons.straighten,
                color: prideSettingsIconColor(colorIndex),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: onOpenMeasurements,
            ),
            ListTile(
              title: Text(l10n.ordersComposerStyleTitle),
              subtitle: Text(_styleSubtitle, maxLines: 3),
              isThreeLine: _styleSubtitle.length > 48,
              leading: PrideColoredLeading(
                icon: Icons.checkroom_outlined,
                color: prideSettingsIconColor(colorIndex + 1),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: onOpenStyle,
            ),
            ListTile(
              title: Text(l10n.ordersComposerFabricTitle),
              subtitle: Text(_fabricSubtitle, maxLines: 2),
              leading: PrideColoredLeading(
                icon: Icons.texture_outlined,
                color: prideSettingsIconColor(colorIndex + 2),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: onOpenFabric,
            ),
            if (onUseSameFabric != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: TextButton.icon(
                    onPressed: onUseSameFabric,
                    icon: const Icon(Icons.copy_outlined, size: 18),
                    label: Text(l10n.ordersComposerUseSameFabricCta),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Text(
                l10n.ordersComposerFabricOptional,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
