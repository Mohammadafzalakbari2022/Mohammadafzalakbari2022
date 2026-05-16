import 'package:flutter/material.dart';

import '../../data/local/style_figure_summary.dart';
import '../settings/style/style_figure_image.dart';

/// Image grid for style figures; tap toggles selection (single or multi).
class StyleFigureImageGrid extends StatelessWidget {
  const StyleFigureImageGrid({
    super.key,
    required this.figures,
    this.selectedFigureId,
    this.selectedFigureIds,
    this.onSelectionChanged,
    this.onMultiSelectionChanged,
    this.crossAxisCount = 3,
    this.padding = const EdgeInsets.all(4),
  });

  final List<StyleFigureSummary> figures;
  final String? selectedFigureId;
  final Set<String>? selectedFigureIds;
  final ValueChanged<String?>? onSelectionChanged;
  final ValueChanged<Set<String>>? onMultiSelectionChanged;
  final int crossAxisCount;
  final EdgeInsets padding;

  bool _isSelected(String figureId) {
    if (selectedFigureIds != null) {
      return selectedFigureIds!.contains(figureId);
    }
    return selectedFigureId == figureId;
  }

  void _onTap(String figureId) {
    if (onMultiSelectionChanged != null && selectedFigureIds != null) {
      final next = Set<String>.from(selectedFigureIds!);
      if (next.contains(figureId)) {
        next.remove(figureId);
      } else {
        next.add(figureId);
      }
      onMultiSelectionChanged!(next);
      return;
    }
    if (onSelectionChanged == null) return;
    final selected = selectedFigureId == figureId;
    onSelectionChanged!(selected ? null : figureId);
  }

  @override
  Widget build(BuildContext context) {
    if (figures.isEmpty) {
      return const SizedBox.shrink();
    }

    final interactive =
        onSelectionChanged != null || onMultiSelectionChanged != null;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        childAspectRatio: 1,
      ),
      itemCount: figures.length,
      itemBuilder: (context, index) {
        final f = figures[index];
        final selected = _isSelected(f.internalId);
        return Material(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: interactive ? () => _onTap(f.internalId) : null,
            child: Stack(
              fit: StackFit.expand,
              children: [
                StyleFigureImage(
                  imageRef: f.imageRef,
                  fit: BoxFit.cover,
                  expand: true,
                ),
                if (selected)
                  DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 3,
                      ),
                    ),
                  ),
                if (selected)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Icon(
                      Icons.check_circle,
                      color: Theme.of(context).colorScheme.primary,
                      size: 22,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
