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
    preset: 'Preset',
    text: 'Text',
    size: 'Size',
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
            presetNameSnapshot: 'Frozen Preset',
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
      expect(display.figures.single.presetName, 'Frozen Preset');
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
      expect(display.detailedLines, contains('Preset: Normal Style'));
      expect(display.detailedLines, contains('Text: Round front'));
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

    test('handles multiple shapes with preset and options', () {
      final selection = StyleOrderSelection.withItems(
        shapeItems: [
          const OrderShapeSelectionItem(
            shapeId: 'fig-a',
            shapeNameSnapshot: 'Classic Collar',
            presetNameSnapshot: 'Normal Style',
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
  presetNameSnapshot: 'Normal Style',
);
