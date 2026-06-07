import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/data/local/style/order_style_snapshot_persist.dart';
import 'package:pride_v3/data/local/style/style_order_selection.dart';
import 'package:pride_v3/data/local/style_figure_summary.dart';

void main() {
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
    StyleFigureSummary(
      internalId: 'fig-b',
      shopId: 'shop',
      partInternalId: 'part',
      name: 'Sleeve B',
      imageRef: 'asset:shape_2',
      sortOrder: 20,
      isActive: true,
    ),
  ];

  group('prepareOrderStyleSnapshotPersistData', () {
    test('v2 selection writes main style and multiple figure rows', () {
      const selection = StyleOrderSelection.withItems(
        shapeItems: [
          OrderShapeSelectionItem(
            shapeId: 'fig-a',
            shapeNameSnapshot: 'Classic Collar',
            imageRefSnapshot: 'asset:shape_1',
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
          ),
          OrderShapeSelectionItem(
            shapeId: 'fig-b',
            shapeNameSnapshot: 'Wide Sleeve',
            imageRefSnapshot: 'asset:shape_2',
          ),
        ],
      );

      final data = prepareOrderStyleSnapshotPersistData(
        styleName: 'Qasimi',
        styleNameInternalId: 'style-1',
        styleSelectionJson: selection.toJsonString(),
        allFigures: figures,
      );

      expect(data.hasContent, isTrue);
      expect(data.styleNameSnapshot, 'Qasimi');
      expect(data.styleNameInternalIdSnapshot, 'style-1');
      expect(data.figureInputs.length, 2);

      final first = data.figureInputs.first;
      expect(first.figureNameSnapshot, 'Classic Collar');
      expect(first.imageRefSnapshot, 'asset:shape_1');
      expect(first.textOptionsSnapshotJson, contains('Round front'));
      expect(first.sizeOptionsSnapshotJson, contains('2.5'));
    });

    test('v1 JSON array resolves figures from catalog', () {
      final data = prepareOrderStyleSnapshotPersistData(
        styleName: 'Perahan',
        styleSelectionJson: jsonEncode(['fig-b', 'fig-a']),
        allFigures: figures,
      );

      expect(data.hasContent, isTrue);
      expect(data.figureInputs.length, 2);
      expect(data.figureInputs[0].styleFigureInternalId, 'fig-a');
      expect(data.figureInputs[0].figureNameSnapshot, 'Collar A');
      expect(data.figureInputs[1].styleFigureInternalId, 'fig-b');
      expect(data.figureInputs[1].textOptionsSnapshotJson, '[]');
    });

    test('empty style selection produces no content', () {
      final data = prepareOrderStyleSnapshotPersistData(
        styleName: '',
        styleSelectionJson: '',
      );

      expect(data.hasContent, isFalse);
      expect(data.figureInputs, isEmpty);
    });

    test('invalid styleSelectionJson does not crash', () {
      final data = prepareOrderStyleSnapshotPersistData(
        styleName: 'Qasimi',
        styleSelectionJson: '{not valid json',
      );

      expect(data.hasContent, isTrue);
      expect(data.styleNameSnapshot, 'Qasimi');
      expect(data.figureInputs, isEmpty);
    });

    test('note snapshot persists on figure input and view', () {
      const selection = StyleOrderSelection.withItems(
        shapeItems: [
          OrderShapeSelectionItem(
            shapeId: 'fig-a',
            shapeNameSnapshot: 'Classic Collar',
            noteSnapshot: 'Two pockets',
          ),
        ],
      );

      final data = prepareOrderStyleSnapshotPersistData(
        styleName: 'Qasimi',
        styleSelectionJson: selection.toJsonString(),
        allFigures: figures,
      );

      expect(data.figureInputs.single.noteSnapshot, 'Two pockets');

      final view = buildOrderStyleSnapshotView(
        orderInternalId: 'order-1',
        styleName: 'Qasimi',
        styleSelectionJson: selection.toJsonString(),
        snapshotInternalId: 'snap-1',
        allFigures: figures,
      );

      expect(view!.figures.single.noteSnapshot, 'Two pockets');
    });

    test('style name only persists header data without figures', () {
      final data = prepareOrderStyleSnapshotPersistData(
        styleName: 'Qasimi',
        styleSelectionJson: '',
      );

      expect(data.hasContent, isTrue);
      expect(data.styleNameSnapshot, 'Qasimi');
      expect(data.figureInputs, isEmpty);
    });
  });

  group('buildOrderStyleSnapshotView', () {
    test('removed shape is omitted on rebuild', () {
      const fullSelection = StyleOrderSelection.withItems(
        shapeItems: [
          OrderShapeSelectionItem(
            shapeId: 'fig-a',
            shapeNameSnapshot: 'Classic Collar',
          ),
          OrderShapeSelectionItem(
            shapeId: 'fig-b',
            shapeNameSnapshot: 'Wide Sleeve',
          ),
        ],
      );
      const reducedSelection = StyleOrderSelection.withItems(
        shapeItems: [
          OrderShapeSelectionItem(
            shapeId: 'fig-a',
            shapeNameSnapshot: 'Classic Collar',
          ),
        ],
      );

      final fullView = buildOrderStyleSnapshotView(
        orderInternalId: 'order-1',
        styleName: 'Qasimi',
        styleSelectionJson: fullSelection.toJsonString(),
        snapshotInternalId: 'snap-1',
        allFigures: figures,
      );
      final reducedView = buildOrderStyleSnapshotView(
        orderInternalId: 'order-1',
        styleName: 'Qasimi',
        styleSelectionJson: reducedSelection.toJsonString(),
        snapshotInternalId: 'snap-2',
        allFigures: figures,
      );

      expect(fullView!.figures.length, 2);
      expect(reducedView!.figures.length, 1);
      expect(reducedView.figures.single.figureNameSnapshot, 'Classic Collar');
    });

    test('cleared style returns null view', () {
      final view = buildOrderStyleSnapshotView(
        orderInternalId: 'order-1',
        styleName: '',
        styleSelectionJson: '',
        snapshotInternalId: 'snap-1',
      );

      expect(view, isNull);
    });
  });
}
