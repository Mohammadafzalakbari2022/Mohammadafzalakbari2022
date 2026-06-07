import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/data/local/order_style_snapshot_view.dart';
import 'package:pride_v3/data/local/style/order_shape_selection_formatter.dart';
import 'package:pride_v3/data/local/style/order_style_snapshot_persist.dart';
import 'package:pride_v3/data/local/style/style_order_selection.dart';
import 'package:pride_v3/data/local/style_figure_summary.dart';

void main() {
  const labels = OrderShapeSelectionFormatLabels(
    mainStyle: 'Style',
    shape: 'Shape',
    detail: 'Detail',
    size: 'Size',
    note: 'Note',
  );

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

  const v2Selection = StyleOrderSelection.withItems(
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
    ],
  );

  group('formatOrderShapeSelectionDisplay', () {
    test('prefers OrderStyleSnapshotView over JSON', () {
      final snapshot = OrderStyleSnapshotView(
        orderInternalId: 'order-1',
        snapshotInternalId: 'snap-1',
        styleNameSnapshot: 'Frozen Style',
        createdAt: DateTime(2026, 1, 1),
        figures: const [
          OrderStyleSnapshotFigureView(
            styleFigureInternalId: 'fig-a',
            figureNameSnapshot: 'Frozen Collar',
            imageRefSnapshot: 'asset:shape_1',
            sortOrder: 0,
          ),
        ],
      );

      final display = formatOrderShapeSelectionDisplay(
        snapshot: snapshot,
        styleName: 'Live Style',
        styleSelectionJson: v2Selection.toJsonString(),
        styleSummary: 'ignored summary',
        labels: labels,
      );

      expect(display.mainStyleName, 'Frozen Style');
      expect(display.figures.single.shapeName, 'Frozen Collar');
      expect(display.detailedLines.first, 'Style: Frozen Style');
      expect(display.detailedLines.any((l) => l.contains('Frozen Collar')), isTrue);
    });

    test('falls back to v2 styleSelectionJson when snapshot missing', () {
      final display = formatOrderShapeSelectionDisplay(
        styleName: 'Modern Style',
        styleSelectionJson: v2Selection.toJsonString(),
        labels: labels,
      );

      expect(display.mainStyleName, 'Modern Style');
      expect(display.figures.single.shapeName, 'Classic Collar');
      expect(display.detailedLines, contains('Detail: Round front'));
      expect(display.detailedLines, contains('Size: 2.5 inch'));
      expect(display.compactPreview, contains('Classic Collar'));
    });

    test('falls back to styleSummary for empty data', () {
      final display = formatOrderShapeSelectionDisplay(
        styleSummary: 'Qasimi\nCollar A',
        labels: labels,
      );

      expect(display.summaryFallbackText, 'Qasimi\nCollar A');
      expect(display.compactPreview, contains('Qasimi'));
      expect(display.detailedLines, isNotEmpty);
    });

    test('handles multiple shapes with options', () {
      final selection = StyleOrderSelection.withItems(
        shapeItems: [
          const OrderShapeSelectionItem(
            shapeId: 'fig-a',
            shapeNameSnapshot: 'Classic Collar',
          ),
          const OrderShapeSelectionItem(
            shapeId: 'fig-b',
            shapeNameSnapshot: 'Wide Sleeve',
            textOptions: [
              OrderShapeOptionSnapshot(
                id: 'text-1',
                labelSnapshot: 'Double stitch',
              ),
            ],
          ),
        ],
      );

      final display = formatOrderShapeSelectionDisplay(
        styleName: 'Qasimi',
        styleSelectionJson: selection.toJsonString(),
        catalogFigures: [
          const StyleFigureSummary(
            internalId: 'fig-b',
            shopId: 'shop',
            partInternalId: 'part',
            name: 'Sleeve B',
            imageRef: 'asset:shape_2',
            sortOrder: 20,
            isActive: true,
          ),
          figures.first,
        ],
        labels: labels,
      );

      expect(display.figures.length, 2);
      expect(display.compactPreview, contains('Classic Collar'));
      expect(display.compactPreview, contains('Wide Sleeve'));
    });

    test('v1 catalog fallback resolves figure names', () {
      final display = formatOrderShapeSelectionDisplay(
        styleName: 'Perahan',
        styleSelectionJson: '["fig-a"]',
        catalogFigures: figures,
        labels: labels,
      );

      expect(display.figures.single.shapeName, 'Collar A');
      expect(display.detailedLines, contains('Shape: Collar A'));
    });

    test('empty input does not crash', () {
      final display = formatOrderShapeSelectionDisplay(
        styleSelectionJson: '{bad json',
        labels: labels,
      );

      expect(display.isEmpty, isTrue);
      expect(display.figures, isEmpty);
    });

    test('shows note when present in v2 JSON', () {
      final selection = StyleOrderSelection.withItems(
        shapeItems: const [
          OrderShapeSelectionItem(
            shapeId: 'fig-a',
            shapeNameSnapshot: 'Classic Collar',
            textOptions: [
              OrderShapeOptionSnapshot(
                id: 'text-1',
                labelSnapshot: 'Curved cut',
              ),
            ],
            sizeOptions: [
              OrderShapeSizeSnapshot(
                id: 'size-1',
                valueSnapshot: 5.5,
                labelSnapshot: '5.5 inch',
                unitSnapshot: 'inch',
              ),
            ],
            noteSnapshot: 'Customer wants it slightly wider',
          ),
        ],
      );

      final display = formatOrderShapeSelectionDisplay(
        styleName: 'Qasimi',
        styleSelectionJson: selection.toJsonString(),
        labels: labels,
      );

      expect(display.detailedLines, contains('Shape: Classic Collar'));
      expect(display.detailedLines, contains('Detail: Curved cut'));
      expect(display.detailedLines, contains('Size: 5.5 inch'));
      expect(
        display.detailedLines,
        contains('Note: Customer wants it slightly wider'),
      );
      expect(display.detailedLines.any((l) => l == 'Detail:'), isFalse);
      expect(display.detailedLines.any((l) => l == 'Size:'), isFalse);
      expect(display.detailedLines.any((l) => l == 'Note:'), isFalse);
    });

    test('inch display uses saved label text', () {
      final selection = StyleOrderSelection.withItems(
        shapeItems: const [
          OrderShapeSelectionItem(
            shapeId: 'fig-a',
            shapeNameSnapshot: 'Collar',
            sizeOptions: [
              OrderShapeSizeSnapshot(
                id: 'size-1',
                valueSnapshot: 0,
                labelSnapshot: '5 1/2 x 7 1/2 inch',
                unitSnapshot: 'inch',
              ),
            ],
          ),
        ],
      );

      final display = formatOrderShapeSelectionDisplay(
        styleSelectionJson: selection.toJsonString(),
        labels: labels,
      );

      expect(display.figures.single.sizeLabel, '5 1/2 x 7 1/2 inch');
      expect(display.detailedLines, contains('Size: 5 1/2 x 7 1/2 inch'));
    });

    test('inch display shows legacy numeric label', () {
      final selection = StyleOrderSelection.withItems(
        shapeItems: const [
          OrderShapeSelectionItem(
            shapeId: 'fig-a',
            shapeNameSnapshot: 'Collar',
            sizeOptions: [
              OrderShapeSizeSnapshot(
                id: 'size-1',
                valueSnapshot: 6,
                labelSnapshot: '6 inch',
                unitSnapshot: 'inch',
              ),
            ],
          ),
        ],
      );

      final display = formatOrderShapeSelectionDisplay(
        styleSelectionJson: selection.toJsonString(),
        labels: labels,
      );

      expect(display.figures.single.sizeLabel, '6 inch');
    });

    test('inch display falls back to valueSnapshot when label missing', () {
      final selection = StyleOrderSelection.withItems(
        shapeItems: const [
          OrderShapeSelectionItem(
            shapeId: 'fig-a',
            shapeNameSnapshot: 'Collar',
            sizeOptions: [
              OrderShapeSizeSnapshot(
                id: 'size-1',
                valueSnapshot: 0,
                labelSnapshot: 'Legacy size',
                unitSnapshot: '',
              ),
            ],
          ),
        ],
      );

      final display = formatOrderShapeSelectionDisplay(
        styleSelectionJson: selection.toJsonString(),
        labels: labels,
      );

      expect(display.figures.single.sizeLabel, 'Legacy size');
    });

    test('does not append styleSummary when snapshot figures exist', () {
      const selection = StyleOrderSelection.withItems(shapeItems: [v2Item]);
      final view = buildOrderStyleSnapshotView(
        orderInternalId: 'order-1',
        styleName: 'Qasimi',
        styleSelectionJson: selection.toJsonString(),
        snapshotInternalId: 'snap-1',
      );

      final display = formatOrderShapeSelectionDisplay(
        snapshot: view,
        styleName: 'Qasimi',
        styleSelectionJson: selection.toJsonString(),
        styleSummary: 'Legacy summary line that should not duplicate',
        labels: labels,
      );

      expect(display.detailedText, isNot(contains('Legacy summary')));
      expect(display.detailedText, contains('Classic Collar'));
    });
  });
}

const v2Item = OrderShapeSelectionItem(
  shapeId: 'fig-a',
  shapeNameSnapshot: 'Classic Collar',
);
