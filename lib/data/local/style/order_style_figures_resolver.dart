import '../style_figure_summary.dart';
import 'style_order_selection.dart';

/// Resolves persisted [StyleOrderSelection] ids to active catalog figures.
List<StyleFigureSummary> resolveOrderStyleFigures({
  required String styleSelectionJson,
  required List<StyleFigureSummary> allFigures,
}) {
  final selection = StyleOrderSelection.fromJsonString(styleSelectionJson);
  if (selection.isEmpty) return const [];

  final byId = {for (final f in allFigures) f.internalId: f};
  final ids = selection.selectedFigureIds.toList()
    ..sort(
      (a, b) => (byId[a]?.sortOrder ?? 0).compareTo(byId[b]?.sortOrder ?? 0),
    );

  final out = <StyleFigureSummary>[];
  for (final id in ids) {
    final figure = byId[id];
    if (figure != null) out.add(figure);
  }
  return out;
}
