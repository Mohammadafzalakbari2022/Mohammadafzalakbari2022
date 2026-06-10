import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/data/local/measurement_unit_codes.dart';
import 'package:pride_v3/data/local/style/style_order_selection.dart';
import 'package:pride_v3/data/local/style_figure_config_summary.dart';
import 'package:pride_v3/data/local/style_figure_size_option_summary.dart';
import 'package:pride_v3/data/local/style_figure_summary.dart';
import 'package:pride_v3/data/local/style_figure_text_option_summary.dart';
import 'package:pride_v3/features/orders/order_composer_shape_config_draft.dart';

void main() {
  const figure1 = StyleFigureSummary(
    internalId: 'fig-1',
    shopId: 'shop',
    partInternalId: 'part',
    name: 'Classic Collar',
    imageRef: 'asset:shape_1',
    sortOrder: 10,
    isActive: true,
  );

  const figure2 = StyleFigureSummary(
    internalId: 'fig-2',
    shopId: 'shop',
    partInternalId: 'part',
    name: 'Wide Sleeve',
    imageRef: 'asset:shape_2',
    sortOrder: 20,
    isActive: true,
  );

  const inactiveFigure = StyleFigureSummary(
    internalId: 'fig-old',
    shopId: 'shop',
    partInternalId: 'part',
    name: 'Old Shape',
    imageRef: 'asset:shape_3',
    sortOrder: 30,
    isActive: false,
  );

  test('figuresForOrderSelectionGrid includes active and selected inactive', () {
    final grid = figuresForOrderSelectionGrid(
      [figure1, inactiveFigure],
      {'fig-old'},
    );
    expect(grid.map((f) => f.internalId).toList(), ['fig-1', 'fig-old']);
  });

  test('restoreShapeConfigDrafts from v2 restores all detail/size ids and note', () {
    const selection = StyleOrderSelection.withItems(
      shapeItems: [
        OrderShapeSelectionItem(
          shapeId: 'fig-1',
          textOptions: [
            OrderShapeOptionSnapshot(id: 'text-1', labelSnapshot: 'Round front'),
            OrderShapeOptionSnapshot(id: 'text-2', labelSnapshot: 'Extra'),
          ],
          sizeOptions: [
            OrderShapeSizeSnapshot(
              id: 'size-1',
              valueSnapshot: 2.5,
              labelSnapshot: '2.5 inch',
              unitSnapshot: 'inch',
            ),
            OrderShapeSizeSnapshot(
              id: 'size-2',
              valueSnapshot: 3,
              labelSnapshot: '3 inch',
              unitSnapshot: 'inch',
            ),
          ],
          noteSnapshot: 'Slightly wider',
        ),
      ],
    );
    final drafts = restoreShapeConfigDrafts(selection);
    expect(drafts['fig-1']!.selectedTextOptionIds, {'text-1', 'text-2'});
    expect(drafts['fig-1']!.selectedSizeOptionIds, {'size-1', 'size-2'});
    expect(drafts['fig-1']!.note, 'Slightly wider');
  });

  test('restoreShapeConfigDrafts from v1 creates empty drafts per shape', () {
    const selection = StyleOrderSelection({'fig-1', 'fig-2'});
    final drafts = restoreShapeConfigDrafts(selection);
    expect(drafts.length, 2);
    expect(drafts['fig-1']!.selectedTextOptionIds, isEmpty);
    expect(drafts['fig-2']!.selectedTextOptionIds, isEmpty);
  });

  test('empty selection restores no drafts', () {
    expect(restoreShapeConfigDrafts(const StyleOrderSelection.empty()), isEmpty);
  });

  test('buildStyleOrderSelectionFromDrafts saves multiple shapes and options', () {
    final configs = <String, StyleFigureConfigSummary>{
      'fig-1': const StyleFigureConfigSummary(
        figure: figure1,
        textOptions: [
          StyleFigureTextOptionSummary(
            internalId: 'text-1',
            shopId: 'shop',
            styleFigureInternalId: 'fig-1',
            label: 'Curved cut',
            sortOrder: 10,
            isActive: true,
          ),
          StyleFigureTextOptionSummary(
            internalId: 'text-1b',
            shopId: 'shop',
            styleFigureInternalId: 'fig-1',
            label: 'Straight cut',
            sortOrder: 20,
            isActive: true,
          ),
        ],
        sizeOptions: [
          StyleFigureSizeOptionSummary(
            internalId: 'size-1',
            shopId: 'shop',
            styleFigureInternalId: 'fig-1',
            label: '5.5 inch',
            valueInches: 5.5,
            unitCode: MeasurementUnitCodes.inch,
            sortOrder: 10,
            isActive: true,
          ),
          StyleFigureSizeOptionSummary(
            internalId: 'size-2',
            shopId: 'shop',
            styleFigureInternalId: 'fig-1',
            label: '6 inch',
            valueInches: 6,
            unitCode: MeasurementUnitCodes.inch,
            sortOrder: 20,
            isActive: true,
          ),
        ],
      ),
      'fig-2': const StyleFigureConfigSummary(
        figure: figure2,
        textOptions: [
          StyleFigureTextOptionSummary(
            internalId: 'text-2',
            shopId: 'shop',
            styleFigureInternalId: 'fig-2',
            label: 'Wide',
            sortOrder: 10,
            isActive: true,
          ),
        ],
        sizeOptions: [],
      ),
    };

    final drafts = {
      'fig-1': ShapeConfigDraft(
        shapeId: 'fig-1',
        selectedTextOptionIds: {'text-1', 'text-1b'},
        selectedSizeOptionIds: {'size-1', 'size-2'},
        note: 'Collar note',
      ),
      'fig-2': ShapeConfigDraft(
        shapeId: 'fig-2',
        selectedTextOptionIds: {'text-2'},
      ),
    };

    final selection = buildStyleOrderSelectionFromDrafts(
      selectedFigureIds: {'fig-1', 'fig-2'},
      drafts: drafts,
      allFigures: const [figure1, figure2],
      configs: configs,
    );

    expect(selection.shapeItems.length, 2);
    final collar = selection.shapeItems.first;
    final sleeve = selection.shapeItems.last;
    expect(collar.shapeId, 'fig-1');
    expect(collar.textOptions.map((o) => o.labelSnapshot).toList(),
        ['Curved cut', 'Straight cut']);
    expect(collar.sizeOptions.map((o) => o.labelSnapshot).toList(),
        ['5.5 inch', '6 inch']);
    expect(collar.noteSnapshot, 'Collar note');
    expect(sleeve.shapeId, 'fig-2');
    expect(sleeve.textOptions.single.labelSnapshot, 'Wide');
    expect(sleeve.sizeOptions, isEmpty);
    expect(sleeve.noteSnapshot, isNull);
  });

  test('empty selected shapes returns empty selection', () {
    final selection = buildStyleOrderSelectionFromDrafts(
      selectedFigureIds: {},
      drafts: {},
      allFigures: const [figure1],
      configs: const {},
    );
    expect(selection.isEmpty, isTrue);
  });

  test('omits empty note from JSON', () {
    final selection = buildStyleOrderSelectionFromDrafts(
      selectedFigureIds: {'fig-1'},
      drafts: {'fig-1': ShapeConfigDraft(shapeId: 'fig-1')},
      allFigures: const [figure1],
      configs: const {},
    );
    expect(selection.toJsonString().contains('note_snapshot'), isFalse);
  });
}
