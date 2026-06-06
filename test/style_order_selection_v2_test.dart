import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/data/local/style/style_order_selection.dart';
import 'package:pride_v3/data/local/style_figure_summary.dart';

void main() {
  group('StyleOrderSelection v1', () {
    test('parses JSON array of figure ids', () {
      final selection = StyleOrderSelection.fromJsonString(
        '["fig-b","fig-a"]',
      );
      expect(selection.selectedFigureIds, {'fig-b', 'fig-a'});
      expect(selection.shapeItems, isEmpty);
    });

    test('parses legacy map format', () {
      final selection = StyleOrderSelection.fromJsonString(
        '{"part-1":"fig-a","part-2":"fig-b"}',
      );
      expect(selection.selectedFigureIds, {'fig-a', 'fig-b'});
      expect(selection.shapeItems, isEmpty);
    });

    test('serializes v1 array when no shape items', () {
      const selection = StyleOrderSelection({'fig-b', 'fig-a'});
      expect(selection.toJsonString(), jsonEncode(['fig-a', 'fig-b']));
    });

    test('buildSummary uses catalog names for v1 selections', () {
      const figures = [
        StyleFigureSummary(
          internalId: 'fig-a',
          shopId: 'shop',
          partInternalId: 'part',
          name: 'Collar A',
          imageRef: 'asset:shape_1',
          sortOrder: 10,
          isActive: true,
        ),
      ];
      const selection = StyleOrderSelection({'fig-a'});
      final summary = StyleOrderSelection.buildSummary(
        mainStyleName: 'Qasimi',
        selection: selection,
        figures: figures,
      );
      expect(summary, 'Qasimi\nCollar A');
    });
  });

  group('StyleOrderSelection v2', () {
    test('round trip preserves shape items and snapshots', () {
      const item = OrderShapeSelectionItem(
        shapeId: 'fig-a',
        shapeNameSnapshot: 'Classic Collar',
        imageRefSnapshot: 'asset:shape_1',
        presetId: 'preset-1',
        presetNameSnapshot: 'Normal Style',
        textOptions: [
          OrderShapeOptionSnapshot(
            id: 'text-1',
            labelSnapshot: 'Round front',
          ),
        ],
        sizeOptions: [
          OrderShapeSizeSnapshot(
            id: 'size-1',
            valueSnapshot: 2.5,
            labelSnapshot: '2.5 inch',
            unitSnapshot: 'inch',
          ),
        ],
      );
      const selection = StyleOrderSelection.withItems(shapeItems: [item]);
      final json = selection.toJsonString();
      final restored = StyleOrderSelection.fromJsonString(json);

      expect(restored.selectedFigureIds, {'fig-a'});
      expect(restored.shapeItems.length, 1);
      expect(restored.shapeItems.first.shapeNameSnapshot, 'Classic Collar');
      expect(restored.shapeItems.first.presetNameSnapshot, 'Normal Style');
      expect(restored.shapeItems.first.textOptions.single.labelSnapshot,
          'Round front');
      expect(restored.shapeItems.first.sizeOptions.single.valueSnapshot, 2.5);
    });

    test('buildSummary uses snapshots from shape items', () {
      const selection = StyleOrderSelection.withItems(
        shapeItems: [
          OrderShapeSelectionItem(
            shapeId: 'fig-a',
            shapeNameSnapshot: 'Classic Collar',
            presetNameSnapshot: 'Normal Style',
            textOptions: [
              OrderShapeOptionSnapshot(
                id: 'text-1',
                labelSnapshot: 'Double stitch',
              ),
            ],
            sizeOptions: [
              OrderShapeSizeSnapshot(
                id: 'size-1',
                valueSnapshot: 3,
                labelSnapshot: '3 inch',
                unitSnapshot: 'inch',
              ),
            ],
          ),
        ],
      );
      final summary = StyleOrderSelection.buildSummary(
        mainStyleName: 'Qasimi',
        selection: selection,
        figures: const [],
      );
      expect(summary, contains('Classic Collar'));
      expect(summary, contains('Normal Style'));
      expect(summary, contains('Double stitch'));
      expect(summary, contains('3 inch'));
    });

    test('empty options and presets do not crash summary', () {
      const selection = StyleOrderSelection.withItems(
        shapeItems: [
          OrderShapeSelectionItem(
            shapeId: 'fig-a',
            shapeNameSnapshot: 'Shape 1',
            imageRefSnapshot: 'asset:shape_1',
          ),
        ],
      );
      final summary = StyleOrderSelection.buildSummary(
        mainStyleName: '',
        selection: selection,
        figures: const [],
      );
      expect(summary, 'Shape 1');
    });
  });
}
