import '../../data/local/style/style_figure_display_name.dart';
import '../../data/local/style/style_order_selection.dart';
import '../../data/local/style_figure_config_summary.dart';
import '../../data/local/style_figure_summary.dart';

/// Local draft configuration for one selected shape in the order style sheet.
class ShapeConfigDraft {
  ShapeConfigDraft({
    required this.shapeId,
    this.selectedTextOptionId,
    this.selectedSizeOptionId,
    this.note = '',
  });

  final String shapeId;
  String? selectedTextOptionId;
  String? selectedSizeOptionId;
  String note;

  ShapeConfigDraft copy() {
    return ShapeConfigDraft(
      shapeId: shapeId,
      selectedTextOptionId: selectedTextOptionId,
      selectedSizeOptionId: selectedSizeOptionId,
      note: note,
    );
  }
}

/// Active figures for the picker, plus any inactive figures still selected on edit.
List<StyleFigureSummary> figuresForOrderSelectionGrid(
  List<StyleFigureSummary> allFigures,
  Set<String> selectedFigureIds,
) {
  final byId = {for (final f in allFigures) f.internalId: f};
  final result = <StyleFigureSummary>[];
  final seen = <String>{};

  for (final figure in allFigures) {
    if (figure.isActive) {
      result.add(figure);
      seen.add(figure.internalId);
    }
  }

  for (final id in selectedFigureIds) {
    if (seen.contains(id)) continue;
    final figure = byId[id];
    if (figure != null) {
      result.add(figure);
      seen.add(id);
    }
  }

  result.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  return result;
}

Map<String, ShapeConfigDraft> restoreShapeConfigDrafts(
  StyleOrderSelection selection,
) {
  final drafts = <String, ShapeConfigDraft>{};

  if (selection.shapeItems.isNotEmpty) {
    for (final item in selection.shapeItems) {
      drafts[item.shapeId] = ShapeConfigDraft(
        shapeId: item.shapeId,
        selectedTextOptionId:
            item.textOptions.isNotEmpty ? item.textOptions.first.id : null,
        selectedSizeOptionId:
            item.sizeOptions.isNotEmpty ? item.sizeOptions.first.id : null,
        note: item.noteSnapshot?.trim() ?? '',
      );
    }
    return drafts;
  }

  for (final id in selection.selectedFigureIds) {
    drafts[id] = ShapeConfigDraft(shapeId: id);
  }
  return drafts;
}

StyleOrderSelection buildStyleOrderSelectionFromDrafts({
  required Set<String> selectedFigureIds,
  required Map<String, ShapeConfigDraft> drafts,
  required List<StyleFigureSummary> allFigures,
  required Map<String, StyleFigureConfigSummary> configs,
}) {
  if (selectedFigureIds.isEmpty) {
    return const StyleOrderSelection.empty();
  }

  final figureById = {for (final f in allFigures) f.internalId: f};
  final sortedIds = selectedFigureIds.toList()
    ..sort((a, b) {
      final fa = figureById[a]?.sortOrder ?? 0;
      final fb = figureById[b]?.sortOrder ?? 0;
      return fa.compareTo(fb);
    });

  final items = <OrderShapeSelectionItem>[];
  for (final shapeId in sortedIds) {
    final figure = figureById[shapeId];
    final draft = drafts[shapeId] ?? ShapeConfigDraft(shapeId: shapeId);
    final config = configs[shapeId];

    final textSnapshots = <OrderShapeOptionSnapshot>[];
    final sizeSnapshots = <OrderShapeSizeSnapshot>[];

    if (config != null) {
      if (draft.selectedTextOptionId != null) {
        for (final option in config.textOptions) {
          if (option.internalId == draft.selectedTextOptionId) {
            textSnapshots.add(
              OrderShapeOptionSnapshot(
                id: option.internalId,
                labelSnapshot: option.label,
              ),
            );
            break;
          }
        }
      }

      if (draft.selectedSizeOptionId != null) {
        for (final option in config.sizeOptions) {
          if (option.internalId == draft.selectedSizeOptionId) {
            sizeSnapshots.add(
              OrderShapeSizeSnapshot(
                id: option.internalId,
                valueSnapshot: option.valueInches,
                labelSnapshot: option.label,
                unitSnapshot: orderShapeSizeUnitLabel(option.unitCode),
              ),
            );
            break;
          }
        }
      }
    }

    final shapeNameSnapshot = figure != null
        ? resolveStyleFigureSummaryDisplayName(figure)
        : '';
    final imageRefSnapshot = figure?.imageRef ?? '';
    final note = draft.note.trim();

    items.add(
      OrderShapeSelectionItem(
        shapeId: shapeId,
        shapeNameSnapshot: shapeNameSnapshot,
        imageRefSnapshot: imageRefSnapshot,
        textOptions: textSnapshots,
        sizeOptions: sizeSnapshots,
        noteSnapshot: note.isNotEmpty ? note : null,
      ),
    );
  }

  return StyleOrderSelection.withItems(shapeItems: items);
}
