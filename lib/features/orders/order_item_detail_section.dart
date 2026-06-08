import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/app/app_theme.dart';
import 'package:pride_v3/core/widgets/pride_carved_section.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/local/measurement_profile_formatting.dart';
import '../../data/local/order_item_snapshot_key.dart';
import '../../data/local/order_item_summary.dart';
import '../../data/local/order_summary.dart';
import '../../data/providers/local_data_providers.dart';
import '../catalog/catalog_item_image.dart';
import 'order_composer_item_card.dart';
import 'order_detail_edit_actions.dart';
import 'order_detail_item_edit_actions.dart';
import 'order_garment_summary.dart';
import 'order_item_fabric_panel.dart';
import 'order_item_style_figures_panel.dart';

/// Collapsible garment block on order detail (measurements, style, fabric, catalog).
class OrderItemDetailSection extends ConsumerWidget {
  const OrderItemDetailSection({
    super.key,
    required this.order,
    required this.item,
    required this.canEdit,
    required this.l10n,
    required this.formatMoney,
  });

  final OrderSummary order;
  final OrderItemSummary item;
  final bool canEdit;
  final AppLocalizations l10n;
  final String Function(int minor) formatMoney;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final garmentLabel = composerGarmentLabel(l10n, item.garmentType);
    final snapKey = OrderItemSnapshotKey(
      orderInternalId: order.internalId,
      orderItemInternalId: item.internalId,
    );
    final snapshotAsync =
        ref.watch(orderItemMeasurementSnapshotProvider(snapKey));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 4, 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  l10n.ordersDetailGarmentSectionTitle(garmentLabel),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              Text(
                formatMoney(item.priceAmountMinor),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
        PrideCarvedSection(
          title: l10n.ordersDetailSectionMeasurements,
          subtitle: item.sourceMeasurementProfileLabel.isNotEmpty
              ? item.sourceMeasurementProfileLabel
              : null,
          trailing: orderDetailEditTrailing(
            l10n: l10n,
            onPressed: canEdit
                ? () => orderDetailItemEditMeasurements(
                      context,
                      ref,
                      l10n,
                      order,
                      item,
                    )
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (item.sourceMeasurementProfileLabel.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    l10n.ordersDetailMeasurementsFromProfile(
                      item.sourceMeasurementProfileLabel,
                    ),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ),
              snapshotAsync.when(
                data: (snap) {
                  final items = snap?.items ?? [];
                  if (items.isNotEmpty) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (var i = 0; i < items.length; i++)
                          _OrderDetailMeasurementRow(
                            label: items[i].typeName,
                            value:
                                '${items[i].value.trim()}${MeasurementProfileFormatting.unitSuffix(items[i].unitCode)}',
                            altBackground: i.isOdd,
                          ),
                      ],
                    );
                  }
                  return Text(
                    item.measurementsSnapshot.trim().isEmpty
                        ? l10n.ordersDetailSnapshotEmpty
                        : item.measurementsSnapshot,
                    style: Theme.of(context).textTheme.bodyMedium,
                  );
                },
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text('$e'),
              ),
            ],
          ),
        ),
        if (item.catalogDesignNameSnapshot.trim().isNotEmpty)
          PrideCarvedSection(
            title: l10n.orderDetailCatalogDesignTitle,
            subtitle: item.catalogDesignNameSnapshot.trim(),
            trailing: orderDetailEditTrailing(
              l10n: l10n,
              onPressed: canEdit
                  ? () => orderDetailItemEditStyle(
                        context,
                        ref,
                        l10n,
                        order,
                        item,
                      )
                  : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CatalogItemImage(
                    imagePath: item.catalogImagePathSnapshot ??
                        item.catalogThumbnailPathSnapshot,
                  ),
                ),
                const SizedBox(height: 10),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: prideFriendlyTileFill(
                      Theme.of(context).colorScheme,
                      variant: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .outlineVariant
                          .withValues(alpha: 0.55),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(12, 10, 12, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          item.catalogDesignNameSnapshot.trim(),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        if (item.catalogDesignerShopNameSnapshot
                            .trim()
                            .isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            item.catalogDesignerShopNameSnapshot.trim(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                if (item.catalogItemInternalId != null) ...[
                  const SizedBox(height: 8),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: TextButton(
                      onPressed: () => context.push(
                        '/app/catalog/${item.catalogItemInternalId}',
                      ),
                      child: Text(l10n.catalogDetailTitle),
                    ),
                  ),
                ],
              ],
            ),
          ),
        PrideCarvedSection(
          title: l10n.ordersDetailSectionStyle,
          subtitle: item.styleName.trim().isNotEmpty
              ? item.styleName.trim()
              : l10n.ordersComposerStyleRequired,
          trailing: orderDetailEditTrailing(
            l10n: l10n,
            onPressed: canEdit
                ? () => orderDetailItemEditStyle(
                      context,
                      ref,
                      l10n,
                      order,
                      item,
                    )
                : null,
          ),
          child: item.hasStyle
              ? OrderItemStyleFiguresPanel(
                  orderInternalId: order.internalId,
                  item: item,
                )
              : Text(
                  l10n.ordersDetailSnapshotEmpty,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
        ),
        PrideCarvedSection(
          title: l10n.orderDetailFabricTitle,
          subtitle: item.hasFabric
              ? orderItemFabricSummaryLine(l10n, item)
              : l10n.ordersComposerFabricUnset,
          trailing: orderDetailEditTrailing(
            l10n: l10n,
            onPressed: canEdit
                ? () => orderDetailItemEditFabric(
                      context,
                      ref,
                      l10n,
                      order,
                      item,
                    )
                : null,
          ),
          child: item.hasFabric
              ? OrderItemFabricPanel(item: item)
              : Text(
                  l10n.ordersDetailSnapshotEmpty,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
        ),
      ],
    );
  }
}

class _OrderDetailMeasurementRow extends StatelessWidget {
  const _OrderDetailMeasurementRow({
    required this.label,
    required this.value,
    this.altBackground = false,
  });

  final String label;
  final String value;
  final bool altBackground;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: altBackground
            ? prideFriendlyTileFill(scheme, variant: 1)
            : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
