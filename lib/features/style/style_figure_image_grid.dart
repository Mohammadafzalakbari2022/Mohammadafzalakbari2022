import 'package:flutter/material.dart';

import '../../data/local/style/style_figure_display_name.dart';
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
    this.showDisplayNames = false,
  });

  final List<StyleFigureSummary> figures;
  final String? selectedFigureId;
  final Set<String>? selectedFigureIds;
  final ValueChanged<String?>? onSelectionChanged;
  final ValueChanged<Set<String>>? onMultiSelectionChanged;
  final int crossAxisCount;
  final EdgeInsets padding;
  final bool showDisplayNames;

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

    final scheme = Theme.of(context).colorScheme;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: showDisplayNames ? 0.78 : 1,
      ),
      itemCount: figures.length,
      itemBuilder: (context, index) {
        final f = figures[index];
        final selected = _isSelected(f.internalId);
        return Material(
          color: scheme.surfaceContainerLowest,
          elevation: selected ? 2 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: selected ? scheme.primary : scheme.outlineVariant,
              width: selected ? 3 : 1,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: interactive ? () => _onTap(f.internalId) : null,
            child: showDisplayNames
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(6),
                              child: StyleFigureImage(
                                imageRef: f.imageRef,
                                fit: BoxFit.contain,
                                expand: true,
                              ),
                            ),
                            if (selected)
                              Positioned(
                                top: 4,
                                right: 4,
                                child: Icon(
                                  Icons.check_circle,
                                  color: scheme.primary,
                                  size: 22,
                                ),
                              ),
                            if (!f.isActive)
                              Positioned(
                                top: 4,
                                left: 4,
                                child: Icon(
                                  Icons.visibility_off_outlined,
                                  size: 16,
                                  color: scheme.outline,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(6, 0, 6, 6),
                        child: Text(
                          resolveStyleFigureSummaryDisplayName(f),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                    ],
                  )
                : Stack(
                    fit: StackFit.expand,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(6),
                        child: StyleFigureImage(
                          imageRef: f.imageRef,
                          fit: BoxFit.contain,
                          expand: true,
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
