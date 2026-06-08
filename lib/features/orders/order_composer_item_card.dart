import 'package:flutter/material.dart';
import 'package:pride_v3/app/app_theme.dart';
import 'package:pride_v3/core/widgets/pride_money_field.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/local/entities/garment_type.dart';
import '../../data/local/order_item_draft.dart';

String composerGarmentLabel(AppLocalizations l10n, GarmentType type) {
  return switch (type) {
    GarmentType.perahanTunban => l10n.garmentPerahanTunban,
    GarmentType.waistcoat => l10n.garmentWaistcoat,
  };
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
    required this.priceController,
    required this.expanded,
    required this.onExpandedChanged,
    required this.onOpenMeasurements,
    required this.onOpenStyle,
    required this.onOpenFabric,
    required this.onPriceChanged,
    this.measurementsTrailing,
    this.styleTrailing,
    this.fabricTrailing,
    this.onUseSameFabric,
  });

  final AppLocalizations l10n;
  final GarmentType garmentType;
  final OrderItemDraft draft;
  final TextEditingController priceController;
  final bool expanded;
  final ValueChanged<bool> onExpandedChanged;
  final VoidCallback onOpenMeasurements;
  final VoidCallback onOpenStyle;
  final VoidCallback onOpenFabric;
  final VoidCallback onPriceChanged;
  final Widget? measurementsTrailing;
  final Widget? styleTrailing;
  final Widget? fabricTrailing;
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
            if (measurementsTrailing != null) measurementsTrailing!,
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
            if (styleTrailing != null) styleTrailing!,
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
            if (fabricTrailing != null) fabricTrailing!,
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: Text(
                l10n.ordersComposerFabricOptional,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: PrideMoneyField(
                controller: priceController,
                labelText: l10n.ordersComposerItemPriceLabel,
                hintText: l10n.ordersComposerPriceHint,
                onChanged: (_) => onPriceChanged(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
