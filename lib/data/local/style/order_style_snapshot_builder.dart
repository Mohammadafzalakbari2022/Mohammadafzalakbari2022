import '../order_style_snapshot_figure_input.dart';
import '../style_figure_summary.dart';
import 'style_order_selection.dart';

/// Builds persisted style snapshot rows from composer selection.
List<OrderStyleSnapshotFigureInput> buildOrderStyleSnapshotFigureInputs({
  required StyleOrderSelection selection,
  required List<StyleFigureSummary> allFigures,
}) {
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
        figureNameSnapshot: figure.name.trim(),
        imageRefSnapshot: figure.imageRef,
        sortOrder: order++,
      ),
    );
  }
  return inputs;
}
