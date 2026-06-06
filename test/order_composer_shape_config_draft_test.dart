import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/data/local/measurement_unit_codes.dart';
import 'package:pride_v3/data/local/style/style_order_selection.dart';
import 'package:pride_v3/data/local/style_figure_config_summary.dart';
import 'package:pride_v3/data/local/style_figure_preset_summary.dart';
import 'package:pride_v3/data/local/style_figure_size_option_summary.dart';
import 'package:pride_v3/data/local/style_figure_summary.dart';
import 'package:pride_v3/data/local/style_figure_text_option_summary.dart';
import 'package:pride_v3/features/orders/order_composer_shape_config_draft.dart';

void main() {
  const figure = StyleFigureSummary(
    internalId: 'fig-1',
    shopId: 'shop',
    partInternalId: 'part',
    name: 'Classic Collar',
    imageRef: 'asset:shape_1',
    sortOrder: 10,
    isActive: true,
  );

  const inactiveFigure = StyleFigureSummary(
    internalId: 'fig-old',
    shopId: 'shop',
    partInternalId: 'part',
    name: 'Old Shape',
    imageRef: 'asset:shape_2',
    sortOrder: 20,
    isActive: false,
  );

  test('figuresForOrderSelectionGrid includes active and selected inactive', () {
    final grid = figuresForOrderSelectionGrid(
      [figure, inactiveFigure],
      {'fig-old'},
    );
    expect(grid.map((f) => f.internalId).toList(), ['fig-1', 'fig-old']);
  });

  test('restoreShapeConfigDrafts from v2 selection', () {
    const selection = StyleOrderSelection.withItems(
      shapeItems: [
        OrderShapeSelectionItem(
          shapeId: 'fig-1',
          presetId: 'preset-1',
          textOptions: [
            OrderShapeOptionSnapshot(id: 'text-1', labelSnapshot: 'Round front'),
          ],
          sizeOptions: [
            OrderShapeSizeSnapshot(
              id: 'size-1',
              valueSnapshot: 2.5,
              labelSnapshot: '2.5 inch',
              unitSnapshot: 'inch',
            ),
          ],
        ),
      ],
    );
    final drafts = restoreShapeConfigDrafts(selection);
    expect(drafts['fig-1']!.selectedPresetId, 'preset-1');
    expect(drafts['fig-1']!.selectedTextOptionIds, {'text-1'});
    expect(drafts['fig-1']!.selectedSizeOptionIds, {'size-1'});
  });

  test('restoreShapeConfigDrafts from v1 selection is empty', () {
    const selection = StyleOrderSelection({'fig-1'});
    expect(restoreShapeConfigDrafts(selection), isEmpty);
  });

  test('applyPresetToDraft selects linked option ids', () {
    final draft = ShapeConfigDraft(shapeId: 'fig-1');
    applyPresetToDraft(
      draft: draft,
      preset: const StyleFigurePresetSummary(
        internalId: 'preset-1',
        shopId: 'shop',
        styleFigureInternalId: 'fig-1',
        name: 'Normal',
        textOptionInternalIds: ['text-1', 'text-2'],
        sizeOptionInternalIds: ['size-1'],
        sortOrder: 10,
        isActive: true,
      ),
    );
    expect(draft.selectedPresetId, 'preset-1');
    expect(draft.selectedTextOptionIds, {'text-1', 'text-2'});
    expect(draft.selectedSizeOptionIds, {'size-1'});
  });

  test('buildStyleOrderSelectionFromDrafts creates v2 snapshots', () {
    final configs = {
      'fig-1': StyleFigureConfigSummary(
        figure: figure,
        textOptions: const [
          StyleFigureTextOptionSummary(
            internalId: 'text-1',
            shopId: 'shop',
            styleFigureInternalId: 'fig-1',
            label: 'Round front',
            sortOrder: 10,
            isActive: true,
          ),
        ],
        sizeOptions: const [
          StyleFigureSizeOptionSummary(
            internalId: 'size-1',
            shopId: 'shop',
            styleFigureInternalId: 'fig-1',
            label: '2.5 inch',
            valueInches: 2.5,
            unitCode: MeasurementUnitCodes.inch,
            sortOrder: 10,
            isActive: true,
          ),
        ],
        presets: const [
          StyleFigurePresetSummary(
            internalId: 'preset-1',
            shopId: 'shop',
            styleFigureInternalId: 'fig-1',
            name: 'Normal Style',
            textOptionInternalIds: ['text-1'],
            sizeOptionInternalIds: ['size-1'],
            sortOrder: 10,
            isActive: true,
          ),
        ],
      ),
    };

    final drafts = {
      'fig-1': ShapeConfigDraft(
        shapeId: 'fig-1',
        selectedPresetId: 'preset-1',
        selectedTextOptionIds: {'text-1'},
        selectedSizeOptionIds: {'size-1'},
      ),
    };

    final selection = buildStyleOrderSelectionFromDrafts(
      selectedFigureIds: {'fig-1'},
      drafts: drafts,
      allFigures: const [figure],
      configs: configs,
    );

    expect(selection.shapeItems.length, 1);
    final item = selection.shapeItems.first;
    expect(item.shapeId, 'fig-1');
    expect(item.shapeNameSnapshot, 'Classic Collar');
    expect(item.imageRefSnapshot, 'asset:shape_1');
    expect(item.presetId, 'preset-1');
    expect(item.presetNameSnapshot, 'Normal Style');
    expect(item.textOptions.single.labelSnapshot, 'Round front');
    expect(item.sizeOptions.single.valueSnapshot, 2.5);

    final json = selection.toJsonString();
    expect(json.contains('"version":2'), isTrue);
    final restored = StyleOrderSelection.fromJsonString(json);
    expect(restored.selectedFigureIds, {'fig-1'});
    expect(restored.shapeItems.first.presetId, 'preset-1');
  });
}
