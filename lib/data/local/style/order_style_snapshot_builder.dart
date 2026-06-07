import '../order_style_snapshot_figure_input.dart';
import '../style_figure_summary.dart';
import 'style_figure_display_name.dart';
import 'style_order_selection.dart';

/// Builds persisted style snapshot rows from composer selection.
List<OrderStyleSnapshotFigureInput> buildOrderStyleSnapshotFigureInputs({
  required StyleOrderSelection selection,
  required List<StyleFigureSummary> allFigures,
}) {
  if (selection.shapeItems.isNotEmpty) {
    final figureById = {for (final f in allFigures) f.internalId: f};
    final sortedItems = List<OrderShapeSelectionItem>.from(selection.shapeItems)
      ..sort((a, b) {
        final fa = figureById[a.shapeId]?.sortOrder ?? 0;
        final fb = figureById[b.shapeId]?.sortOrder ?? 0;
        return fa.compareTo(fb);
      });

    final inputs = <OrderStyleSnapshotFigureInput>[];
    var order = 0;
    for (final item in sortedItems) {
      final figure = figureById[item.shapeId];
      if (figure == null && item.shapeId.isEmpty) continue;
      final nameSnapshot = item.shapeNameSnapshot.trim().isNotEmpty
          ? item.shapeNameSnapshot.trim()
          : resolveStyleFigureSummaryDisplayName(
              figure ??
                  StyleFigureSummary(
                    internalId: item.shapeId,
                    shopId: '',
                    partInternalId: '',
                    name: '',
                    imageRef: item.imageRefSnapshot,
                    sortOrder: 0,
                    isActive: true,
                  ),
            );
      final imageRef = item.imageRefSnapshot.isNotEmpty
          ? item.imageRefSnapshot
          : (figure?.imageRef ?? '');
      inputs.add(
        OrderStyleSnapshotFigureInput.fromShapeItem(
          OrderShapeSelectionItem(
            shapeId: item.shapeId,
            shapeNameSnapshot: nameSnapshot,
            imageRefSnapshot: imageRef,
            textOptions: item.textOptions,
            sizeOptions: item.sizeOptions,
            noteSnapshot: item.noteSnapshot,
          ),
          sortOrder: order++,
        ),
      );
    }
    return inputs;
  }

  final figureById = {for (final f in allFigures) f.internalId: f};
  final sortedIds = selection.selectedFigureIds.toList()
    ..sort((a, b) {
      final fa = figureById[a]?.sortOrder ?? 0;
      final fb = figureById[b]?.sortOrder ?? 0;
      return fa.compareTo(fb);
    });

  final inputs = <OrderStyleSnapshotFigureInput>[];
  var order = 0;
  for (final id in sortedIds) {
    final figure = figureById[id];
    if (figure == null) continue;
    inputs.add(
      OrderStyleSnapshotFigureInput(
        styleFigureInternalId: figure.internalId,
        figureNameSnapshot: resolveStyleFigureSummaryDisplayName(figure),
        imageRefSnapshot: figure.imageRef,
        sortOrder: order++,
      ),
    );
  }
  return inputs;
}
