import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/local/order_style_snapshot_view.dart';
import '../../data/local/order_summary.dart';
import '../../data/local/style/order_shape_selection_formatter.dart';
import '../../data/local/style_figure_summary.dart';
import '../../data/providers/local_data_providers.dart';
import 'order_shape_display_section.dart';

/// Order style section: main label plus selected figure thumbnails and details.
class OrderStyleFiguresPanel extends ConsumerWidget {
  const OrderStyleFiguresPanel({super.key, required this.order});

  final OrderSummary order;

  int _crossAxisCount(double width) {
    if (width >= 700) return 5;
    if (width >= 500) return 4;
    return 3;
  }

  OrderShapeSelectionFormatLabels _labels(AppLocalizations l10n) {
    return OrderShapeSelectionFormatLabels(
      mainStyle: l10n.orderStyleDisplayMainStyleLabel,
      shape: l10n.orderStyleDisplayShapeLabel,
      preset: l10n.orderStyleDisplayPresetLabel,
      text: l10n.orderStyleDisplayTextLabel,
      size: l10n.orderStyleDisplaySizeLabel,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final styleAsync = ref.watch(orderStyleSnapshotProvider(order.internalId));
    final figuresAsync = ref.watch(styleAllFiguresStreamProvider);

    return styleAsync.when(
      data: (styleSnap) => figuresAsync.when(
        data: (allFigures) => _buildContent(
          context,
          l10n,
          styleSnap: styleSnap,
          allFigures: allFigures,
        ),
        loading: () => _buildContent(context, l10n, styleSnap: styleSnap),
        error: (_, _) => _buildContent(context, l10n, styleSnap: styleSnap),
      ),
      loading: () => const LinearProgressIndicator(),
      error: (_, _) => figuresAsync.when(
        data: (allFigures) => _buildContent(
          context,
          l10n,
          allFigures: allFigures,
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
    List<StyleFigureSummary> allFigures = const [],
  }) {
    final display = formatOrderShapeSelectionDisplay(
      snapshot: styleSnap,
      styleName: order.styleName,
      styleSelectionJson: order.styleSelectionJson,
      styleSummary: order.styleSummary,
      catalogFigures: allFigures,
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
