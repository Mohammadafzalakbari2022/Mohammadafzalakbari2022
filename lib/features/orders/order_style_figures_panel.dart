import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/order_summary.dart';
import '../../data/local/style/order_style_figures_resolver.dart';
import '../../data/providers/local_data_providers.dart';
import '../style/style_figure_image_grid.dart';

/// Order style section: main label plus selected figure thumbnails.
class OrderStyleFiguresPanel extends ConsumerWidget {
  const OrderStyleFiguresPanel({super.key, required this.order});

  final OrderSummary order;

  int _crossAxisCount(double width) {
    if (width >= 700) return 5;
    if (width >= 500) return 4;
    return 3;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final figuresAsync = ref.watch(styleAllFiguresStreamProvider);

    return figuresAsync.when(
      data: (allFigures) {
        final selected = resolveOrderStyleFigures(
          styleSelectionJson: order.styleSelectionJson,
          allFigures: allFigures,
        );
        final mainStyle = order.styleName.trim();
        final summary = order.styleSummary.trim();

        if (mainStyle.isEmpty && selected.isEmpty && summary.isEmpty) {
          return const SizedBox.shrink();
        }

        final showSummaryFallback = summary.isNotEmpty && selected.isEmpty;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (mainStyle.isNotEmpty)
              Text(
                mainStyle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            if (selected.isNotEmpty) ...[
              if (mainStyle.isNotEmpty) const SizedBox(height: 8),
              StyleFigureImageGrid(
                figures: selected,
                crossAxisCount: _crossAxisCount(MediaQuery.sizeOf(context).width),
                padding: EdgeInsets.zero,
              ),
            ],
            if (showSummaryFallback)
              Text(
                summary,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
          ],
        );
      },
      loading: () => const LinearProgressIndicator(),
      error: (e, _) => Text('$e'),
    );
  }
}
