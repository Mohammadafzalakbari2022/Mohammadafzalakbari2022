import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/local/order_item_snapshot_key.dart';
import '../../data/local/order_item_summary.dart';
import '../../data/local/order_style_snapshot_view.dart';
import '../../data/local/style/order_shape_selection_formatter.dart';
import '../../data/local/style_figure_summary.dart';
import '../../data/providers/local_data_providers.dart';
import 'order_shape_display_section.dart';
import '../../data/local/style/order_shape_format_labels.dart';

/// Per-garment style section on order detail.
class OrderItemStyleFiguresPanel extends ConsumerWidget {
  const OrderItemStyleFiguresPanel({
    super.key,
    required this.orderInternalId,
    required this.item,
  });

  final String orderInternalId;
  final OrderItemSummary item;

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
    final snapKey = OrderItemSnapshotKey(
      orderInternalId: orderInternalId,
      orderItemInternalId: item.internalId,
    );
    final styleAsync = ref.watch(orderItemStyleSnapshotProvider(snapKey));
    final figuresAsync =
        ref.watch(styleFiguresForGarmentProvider(item.garmentType));

    return styleAsync.when(
      data: (styleSnap) => figuresAsync.when(
        data: (figures) => _buildContent(
          context,
          l10n,
          styleSnap: styleSnap,
          catalogFigures: figures,
        ),
        loading: () => _buildContent(context, l10n, styleSnap: styleSnap),
        error: (_, _) => _buildContent(context, l10n, styleSnap: styleSnap),
      ),
      loading: () => const LinearProgressIndicator(),
      error: (_, _) => figuresAsync.when(
        data: (figures) => _buildContent(
          context,
          l10n,
          catalogFigures: figures,
        ),
        loading: () => const LinearProgressIndicator(),
        error: (e, _) => Text('$e'),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    AppLocalizations l10n, {
    OrderStyleSnapshotView? styleSnap,
    List<StyleFigureSummary> catalogFigures = const [],
  }) {
    final display = formatOrderShapeSelectionDisplay(
      snapshot: styleSnap,
      styleName: item.styleName,
      styleSelectionJson: item.styleSelectionJson,
      styleSummary: item.styleSummary,
      catalogFigures: catalogFigures,
      labels: _labels(l10n),
    );

    if (display.isEmpty) return const SizedBox.shrink();

    return OrderShapeDisplaySection(
      display: display,
      labels: _labels(l10n),
      crossAxisCount: _crossAxisCount(MediaQuery.sizeOf(context).width),
      showMainStyleHeading: false,
    );
  }
}
