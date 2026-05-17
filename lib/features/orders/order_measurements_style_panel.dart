import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/local/measurement_profile_formatting.dart';
import '../../data/local/order_style_snapshot_view.dart';
import '../../data/local/order_summary.dart';
import '../../data/local/style/order_style_figures_resolver.dart';
import '../../data/providers/local_data_providers.dart';
import '../settings/style/style_figure_image.dart';
import 'order_style_figures_panel.dart';

/// Measurements and style in one block (order detail, customer history, receipts).
class OrderMeasurementsStylePanel extends ConsumerWidget {
  const OrderMeasurementsStylePanel({
    super.key,
    required this.order,
    this.compact = false,
  });

  final OrderSummary order;
  final bool compact;

  int _crossAxisCount(double width) {
    if (width >= 700) return 5;
    if (width >= 500) return 4;
    return 3;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final measurementAsync =
        ref.watch(orderMeasurementSnapshotProvider(order.internalId));
    final styleAsync = ref.watch(orderStyleSnapshotProvider(order.internalId));
    final figuresAsync = ref.watch(styleAllFiguresStreamProvider);

    final hasStyleOnOrder = order.styleName.trim().isNotEmpty ||
        order.styleSummary.trim().isNotEmpty ||
        order.styleSelectionJson.trim().isNotEmpty;

    return measurementAsync.when(
      data: (measurementSnap) {
        return styleAsync.when(
          data: (styleSnap) {
            final measurementItems = measurementSnap?.items ?? [];
            final hasMeasurements = measurementItems.isNotEmpty ||
                order.measurementsSnapshot.trim().isNotEmpty;

            final styleName = (styleSnap?.styleNameSnapshot ?? order.styleName)
                .trim();
            final styleFigures = styleSnap?.figures ?? [];
            final hasStyle = styleName.isNotEmpty ||
                styleFigures.isNotEmpty ||
                hasStyleOnOrder;

            if (!hasMeasurements && !hasStyle) {
              return Text(
                l10n.ordersDetailSnapshotEmpty,
                style: Theme.of(context).textTheme.bodyMedium,
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (order.sourceMeasurementProfileLabel.isNotEmpty) ...[
                  Text(
                    l10n.ordersDetailMeasurementsFromProfile(
                      order.sourceMeasurementProfileLabel,
                    ),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 8),
                ],
                if (hasMeasurements) ...[
                  if (measurementItems.isNotEmpty)
                    ...measurementItems.map(
                      (it) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: compact,
                        visualDensity: compact
                            ? VisualDensity.compact
                            : VisualDensity.standard,
                        title: Text(it.typeName),
                        trailing: Text(
                          '${it.value.trim()}'
                          '${MeasurementProfileFormatting.unitSuffix(it.unitCode)}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    )
                  else
                    Text(
                      order.measurementsSnapshot.trim(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                ],
                if (hasMeasurements && hasStyle)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: compact ? 8 : 12),
                    child: Divider(
                      height: 1,
                      color: Theme.of(context)
                          .colorScheme
                          .outlineVariant
                          .withValues(alpha: 0.6),
                    ),
                  ),
                if (hasStyle) ...[
                  if (styleName.isNotEmpty)
                    Text(
                      styleName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  if (styleFigures.isNotEmpty) ...[
                    if (styleName.isNotEmpty) const SizedBox(height: 8),
                    _SnapshotFigureGrid(
                      figures: styleFigures,
                      crossAxisCount:
                          _crossAxisCount(MediaQuery.sizeOf(context).width),
                    ),
                  ] else
                    figuresAsync.when(
                      data: (allFigures) {
                        final selected = resolveOrderStyleFigures(
                          styleSelectionJson: order.styleSelectionJson,
                          allFigures: allFigures,
                        );
                        if (selected.isEmpty &&
                            order.styleSummary.trim().isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return OrderStyleFiguresPanel(order: order);
                      },
                      loading: () => const LinearProgressIndicator(),
                      error: (e, _) => OrderStyleFiguresPanel(order: order),
                    ),
                ],
              ],
            );
          },
          loading: () => const LinearProgressIndicator(),
          error: (e, _) => OrderStyleFiguresPanel(order: order),
        );
      },
      loading: () => const LinearProgressIndicator(),
      error: (e, _) => Text('$e'),
    );
  }
}

class _SnapshotFigureGrid extends StatelessWidget {
  const _SnapshotFigureGrid({
    required this.figures,
    required this.crossAxisCount,
  });

  final List<OrderStyleSnapshotFigureView> figures;
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.85,
      ),
      itemCount: figures.length,
      itemBuilder: (context, index) {
        final f = figures[index];
        final name = f.figureNameSnapshot;
        final imageRef = f.imageRefSnapshot;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: scheme.outlineVariant),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child: StyleFigureImage(
                    imageRef: imageRef,
                    expand: true,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        );
      },
    );
  }
}
