import 'dart:convert';

import '../style_figure_summary.dart';

/// Per-order figure picks (any combination; not grouped by garment part).
class StyleOrderSelection {
  const StyleOrderSelection(this.selectedFigureIds);

  final Set<String> selectedFigureIds;

  const StyleOrderSelection.empty() : selectedFigureIds = const {};

  static StyleOrderSelection fromJsonString(String? json) {
    if (json == null || json.trim().isEmpty) {
      return const StyleOrderSelection.empty();
    }
    try {
      final decoded = jsonDecode(json);
      if (decoded is List) {
        final ids = <String>{};
        for (final e in decoded) {
          final id = e?.toString() ?? '';
          if (id.isNotEmpty) ids.add(id);
        }
        return StyleOrderSelection(ids);
      }
      if (decoded is Map) {
        final ids = <String>{};
        for (final e in decoded.entries) {
          final v = e.value?.toString() ?? '';
          if (v.isNotEmpty) ids.add(v);
        }
        return StyleOrderSelection(ids);
      }
      return const StyleOrderSelection.empty();
    } catch (_) {
      return const StyleOrderSelection.empty();
    }
  }

  String toJsonString() {
    final list = selectedFigureIds.toList()..sort();
    return jsonEncode(list);
  }

  bool get isEmpty => selectedFigureIds.isEmpty;

  /// Human-readable lines for receipts and order summary.
  static String buildSummary({
    required String mainStyleName,
    required StyleOrderSelection selection,
    required List<StyleFigureSummary> figures,
  }) {
    final buf = StringBuffer();
    final style = mainStyleName.trim();
    if (style.isNotEmpty) {
      buf.writeln(style);
    }
    final figureById = {for (final f in figures) f.internalId: f};
    final sortedIds = selection.selectedFigureIds.toList()
      ..sort((a, b) {
        final fa = figureById[a]?.sortOrder ?? 0;
        final fb = figureById[b]?.sortOrder ?? 0;
        return fa.compareTo(fb);
      });
    for (final figureId in sortedIds) {
      final figure = figureById[figureId];
      if (figure == null) continue;
      final label = figure.name.trim();
      if (label.isNotEmpty) {
        buf.writeln(label);
      }
    }
    return buf.toString().trim();
  }
}
