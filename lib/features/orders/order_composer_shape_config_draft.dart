import '../../data/local/style/style_figure_display_name.dart';
import '../../data/local/style/style_order_selection.dart';
import '../../data/local/style_figure_config_summary.dart';
import '../../data/local/style_figure_preset_summary.dart';
import '../../data/local/style_figure_summary.dart';

/// Local draft configuration for one selected shape in the order style sheet.
class ShapeConfigDraft {
  ShapeConfigDraft({
    required this.shapeId,
    this.selectedPresetId,
    Set<String>? selectedTextOptionIds,
    Set<String>? selectedSizeOptionIds,
  })  : selectedTextOptionIds = selectedTextOptionIds ?? {},
        selectedSizeOptionIds = selectedSizeOptionIds ?? {};

  final String shapeId;
  String? selectedPresetId;
  Set<String> selectedTextOptionIds;
  Set<String> selectedSizeOptionIds;

  ShapeConfigDraft copy() {
    return ShapeConfigDraft(
      shapeId: shapeId,
      selectedPresetId: selectedPresetId,
      selectedTextOptionIds: Set<String>.from(selectedTextOptionIds),
      selectedSizeOptionIds: Set<String>.from(selectedSizeOptionIds),
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
  if (selection.shapeItems.isEmpty) return {};
  final drafts = <String, ShapeConfigDraft>{};
  for (final item in selection.shapeItems) {
    drafts[item.shapeId] = ShapeConfigDraft(
      shapeId: item.shapeId,
      selectedPresetId: item.presetId,
      selectedTextOptionIds: item.textOptions.map((e) => e.id).toSet(),
      selectedSizeOptionIds: item.sizeOptions.map((e) => e.id).toSet(),
    );
  }
  return drafts;
}

void applyPresetToDraft({
  required ShapeConfigDraft draft,
  required StyleFigurePresetSummary preset,
}) {
  draft.selectedPresetId = preset.internalId;
  draft.selectedTextOptionIds = preset.textOptionInternalIds.toSet();
  draft.selectedSizeOptionIds = preset.sizeOptionInternalIds.toSet();
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

    String? presetNameSnapshot;
    if (draft.selectedPresetId != null && config != null) {
      for (final preset in config.presets) {
        if (preset.internalId == draft.selectedPresetId) {
          presetNameSnapshot = preset.name;
          break;
        }
      }
    }

    final textSnapshots = <OrderShapeOptionSnapshot>[];
    final sizeSnapshots = <OrderShapeSizeSnapshot>[];

    if (config != null) {
      final textById = {
        for (final o in config.textOptions) o.internalId: o,
      };
      for (final id in draft.selectedTextOptionIds) {
        final option = textById[id];
        if (option == null) continue;
        textSnapshots.add(
          OrderShapeOptionSnapshot(
            id: option.internalId,
            labelSnapshot: option.label,
          ),
        );
      }

      final sizeById = {
        for (final o in config.sizeOptions) o.internalId: o,
      };
      for (final id in draft.selectedSizeOptionIds) {
        final option = sizeById[id];
        if (option == null) continue;
        sizeSnapshots.add(
          OrderShapeSizeSnapshot(
            id: option.internalId,
            valueSnapshot: option.valueInches,
            labelSnapshot: option.label,
            unitSnapshot: orderShapeSizeUnitLabel(option.unitCode),
          ),
        );
      }
    }

    final shapeNameSnapshot = figure != null
        ? resolveStyleFigureSummaryDisplayName(figure)
        : '';
    final imageRefSnapshot = figure?.imageRef ?? '';

    items.add(
      OrderShapeSelectionItem(
        shapeId: shapeId,
        shapeNameSnapshot: shapeNameSnapshot,
        imageRefSnapshot: imageRefSnapshot,
        presetId: draft.selectedPresetId,
        presetNameSnapshot: presetNameSnapshot,
        textOptions: textSnapshots,
        sizeOptions: sizeSnapshots,
      ),
    );
  }

  return StyleOrderSelection.withItems(shapeItems: items);
}
