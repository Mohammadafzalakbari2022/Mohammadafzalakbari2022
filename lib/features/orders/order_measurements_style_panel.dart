import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../core/input/pride_ltr_input.dart';
import '../../data/local/measurement_profile_formatting.dart';
import '../../data/local/order_summary.dart';
import '../../data/local/style/order_shape_selection_formatter.dart';
import '../../data/providers/local_data_providers.dart';
import 'order_shape_display_section.dart';
import '../../data/local/style/order_shape_format_labels.dart';
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

  OrderShapeSelectionFormatLabels _labels(AppLocalizations l10n) =>
      orderShapeFormatLabels(l10n);

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
            return figuresAsync.when(
              data: (allFigures) {
                final measurementItems = measurementSnap?.items ?? [];
                final hasMeasurements = measurementItems.isNotEmpty ||
                    order.measurementsSnapshot.trim().isNotEmpty;
                final styleDisplay = formatOrderShapeSelectionDisplay(
                  snapshot: styleSnap,
                  styleName: order.styleName,
                  styleSelectionJson: order.styleSelectionJson,
                  styleSummary: order.styleSummary,
                  catalogFigures: allFigures,
                  labels: _labels(l10n),
                );
                final hasStyle = !styleDisplay.isEmpty || hasStyleOnOrder;

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
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
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
                            trailing: PrideLtrText(
                              text:
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
                        padding:
                            EdgeInsets.symmetric(vertical: compact ? 8 : 12),
                        child: Divider(
                          height: 1,
                          color: Theme.of(context)
                              .colorScheme
                              .outlineVariant
                              .withValues(alpha: 0.6),
                        ),
                      ),
                    if (hasStyle)
                      styleDisplay.isEmpty
                          ? OrderStyleFiguresPanel(order: order)
                          : OrderShapeDisplaySection(
                              display: styleDisplay,
                              labels: _labels(l10n),
                              crossAxisCount: _crossAxisCount(
                                MediaQuery.sizeOf(context).width,
                              ),
                            ),
                  ],
                );
              },
              loading: () => const LinearProgressIndicator(),
              error: (_, _) => OrderStyleFiguresPanel(order: order),
            );
          },
          loading: () => const LinearProgressIndicator(),
          error: (_, _) => OrderStyleFiguresPanel(order: order),
        );
      },
      loading: () => const LinearProgressIndicator(),
      error: (e, _) => Text('$e'),
    );
  }
}
