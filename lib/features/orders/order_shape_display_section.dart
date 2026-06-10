import 'package:flutter/material.dart';

import '../../core/input/pride_ltr_input.dart';
import '../../data/local/style/order_shape_selection_formatter.dart';
import '../settings/style/style_figure_image.dart';

/// Renders snapshot-first shape images and per-shape option details.
class OrderShapeDisplaySection extends StatelessWidget {
  const OrderShapeDisplaySection({
    super.key,
    required this.display,
    required this.labels,
    required this.crossAxisCount,
    this.showMainStyleHeading = true,
  });

  final OrderShapeSelectionDisplay display;
  final OrderShapeSelectionFormatLabels labels;
  final int crossAxisCount;
  final bool showMainStyleHeading;

  @override
  Widget build(BuildContext context) {
    if (display.isEmpty) return const SizedBox.shrink();

    if (display.figures.isEmpty) {
      final text = display.detailedText.isNotEmpty
          ? display.detailedText
          : display.summaryFallbackText;
      if (text.isEmpty) return const SizedBox.shrink();
      return Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium,
      );
    }

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showMainStyleHeading && display.mainStyleName.isNotEmpty) ...[
          Text(
            display.mainStyleName,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
        ],
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 12,
            crossAxisSpacing: 8,
            childAspectRatio: 0.72,
          ),
          itemCount: display.figures.length,
          itemBuilder: (context, index) {
            final figure = display.figures[index];
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
                        imageRef: figure.imageRef,
                        expand: true,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  figure.shapeName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (figure.detailLabel.isNotEmpty ||
                    figure.sizeLabel.isNotEmpty ||
                    figure.note.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  _FigureOptionLines(
                    labels: labels,
                    detailLabel: figure.detailLabel,
                    sizeLabel: figure.sizeLabel,
                    note: figure.note,
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}

class _FigureOptionLines extends StatelessWidget {
  const _FigureOptionLines({
    required this.labels,
    required this.detailLabel,
    required this.sizeLabel,
    required this.note,
  });

  final OrderShapeSelectionFormatLabels labels;
  final String detailLabel;
  final String sizeLabel;
  final String note;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.labelSmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
      height: 1.25,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (detailLabel.isNotEmpty)
          PrideLabelValueLine(
            label: labels.detail,
            value: detailLabel,
            style: style,
          ),
        if (sizeLabel.isNotEmpty)
          PrideLabelValueLine(
            label: labels.size,
            value: sizeLabel,
            style: style,
          ),
        if (note.isNotEmpty)
          PrideLabelValueLine(
            label: labels.note,
            value: note,
            style: style,
          ),
      ],
    );
  }
}
