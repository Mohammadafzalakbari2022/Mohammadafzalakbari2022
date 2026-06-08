import '../style_figure_summary.dart';
import '../style_part_summary.dart';

typedef StyleFigureSection = ({
  StylePartSummary part,
  List<StyleFigureSummary> figures,
});

List<StyleFigureSection> groupStyleFiguresByPart({
  required List<StyleFigureSummary> figures,
  required List<StylePartSummary> parts,
}) {
  final byPart = <String, List<StyleFigureSummary>>{};
  for (final figure in figures) {
    byPart.putIfAbsent(figure.partInternalId, () => []).add(figure);
  }

  final orderedParts = parts.toList()
    ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

  final sections = <StyleFigureSection>[];
  for (final part in orderedParts) {
    final list = byPart[part.internalId];
    if (list == null || list.isEmpty) continue;
    list.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    sections.add((part: part, figures: list));
  }
  return sections;
}
