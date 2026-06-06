import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/data/local/dev_shop_constants.dart';
import 'package:pride_v3/data/local/memory_order_repository.dart';
import 'package:pride_v3/data/local/memory_style_catalog_repository.dart';
import 'package:pride_v3/data/local/order_style_snapshot_view.dart';
import 'package:pride_v3/data/local/seed_data.dart';
import 'package:pride_v3/data/local/style/order_shape_selection_formatter.dart';
import 'package:pride_v3/data/local/style/order_style_snapshot_persist.dart';
import 'package:pride_v3/data/local/style/style_figure_image_ref.dart';
import 'package:pride_v3/data/local/style/style_order_selection.dart';
import 'package:pride_v3/data/local/style_figure_summary.dart';
import 'package:pride_v3/features/orders/order_composer_shape_config_draft.dart';

void main() {
  const labels = OrderShapeSelectionFormatLabels(
    mainStyle: 'Style',
    shape: 'Shape',
    preset: 'Preset',
    text: 'Text',
    size: 'Size',
  );

  const v2Item = OrderShapeSelectionItem(
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
      OrderShapeOptionSnapshot(
        id: 'text-2',
        labelSnapshot: 'Double stitch',
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

  const catalogFigures = [
    StyleFigureSummary(
      internalId: 'fig-a',
      shopId: kDevShopId,
      partInternalId: 'part',
      name: 'Renamed Collar',
      imageRef: 'asset:shape_1',
      sortOrder: 10,
      isActive: true,
    ),
  ];

  group('snapshot freeze end-to-end', () {
    test('persist then format keeps original labels after catalog rename', () {
      const selection = StyleOrderSelection.withItems(shapeItems: [v2Item]);
      final persistData = prepareOrderStyleSnapshotPersistData(
        styleName: 'Qasimi',
        styleSelectionJson: selection.toJsonString(),
        allFigures: catalogFigures,
      );
      final view = buildOrderStyleSnapshotView(
        orderInternalId: 'order-1',
        styleName: persistData.styleNameSnapshot,
        styleSelectionJson: selection.toJsonString(),
        snapshotInternalId: 'snap-1',
        allFigures: catalogFigures,
      );

      final display = formatOrderShapeSelectionDisplay(
        snapshot: view,
        styleName: 'Qasimi',
        styleSelectionJson: selection.toJsonString(),
        styleSummary: 'Qasimi\nClassic Collar',
        catalogFigures: catalogFigures,
        labels: labels,
      );

      expect(display.figures.single.shapeName, 'Classic Collar');
      expect(display.figures.single.presetName, 'Normal Style');
      expect(display.detailedLines, contains('Text: Round front, Double stitch'));
      expect(display.detailedLines, contains('Size: 2.5 inch'));
      expect(display.detailedLines.any((l) => l.contains('Renamed Collar')),
          isFalse);
    });

    test('v2 JSON fallback preserves embedded labels without snapshot rows', () {
      const selection = StyleOrderSelection.withItems(shapeItems: [v2Item]);
      final display = formatOrderShapeSelectionDisplay(
        styleName: 'Qasimi',
        styleSelectionJson: selection.toJsonString(),
        catalogFigures: catalogFigures,
        labels: labels,
      );

      expect(display.figures.single.shapeName, 'Classic Collar');
      expect(display.detailedLines, contains('Preset: Normal Style'));
      expect(display.detailedLines.any((l) => l.contains('Renamed Collar')),
          isFalse);
    });

    test('invalid JSON falls back to styleSummary without crashing', () {
      final display = formatOrderShapeSelectionDisplay(
        styleName: 'Qasimi',
        styleSelectionJson: '{bad json',
        styleSummary: 'Qasimi\nClassic Collar\nNormal Style',
        labels: labels,
      );

      expect(display.compactPreview, contains('Qasimi'));
      expect(display.detailedLines, isNotEmpty);
    });
  });

  group('MemoryOrderRepository style snapshots', () {
    late MemoryOrderRepository repo;

    setUp(() {
      repo = MemoryOrderRepository();
    });

    Future<String> createStyledOrder({
      required String styleSelectionJson,
      String styleSummary = '',
    }) {
      return repo.createOrder(
        shopId: kDevShopId,
        customerInternalId: DevSeedIds.customer1,
        deliveryDate: DateTime(2026, 6, 1),
        totalAmountMinor: 10000,
        measurementsSnapshot: '',
        styleName: 'Qasimi',
        styleSelectionJson: styleSelectionJson,
        styleSummary: styleSummary,
      );
    }

    test('create order stores style snapshot view', () async {
      const selection = StyleOrderSelection.withItems(shapeItems: [v2Item]);
      final orderId = await createStyledOrder(
        styleSelectionJson: selection.toJsonString(),
        styleSummary: 'Qasimi\nClassic Collar',
      );

      final snap = await repo.watchOrderStyleSnapshot(orderId).first;
      expect(snap, isNotNull);
      expect(snap!.styleNameSnapshot, 'Qasimi');
      expect(snap.figures.single.figureNameSnapshot, 'Classic Collar');
      expect(snap.figures.single.presetNameSnapshot, 'Normal Style');
    });

    test('update order replaces snapshot figure rows', () async {
      const fullSelection = StyleOrderSelection.withItems(
        shapeItems: [
          v2Item,
          const OrderShapeSelectionItem(
            shapeId: 'fig-b',
            shapeNameSnapshot: 'Wide Sleeve',
            imageRefSnapshot: 'asset:shape_2',
          ),
        ],
      );
      const reducedSelection = StyleOrderSelection.withItems(shapeItems: [v2Item]);

      final orderId = await createStyledOrder(
        styleSelectionJson: fullSelection.toJsonString(),
      );
      final firstSnap = await repo.watchOrderStyleSnapshot(orderId).first;
      expect(firstSnap!.figures.length, 2);

      await repo.updateOrderDetails(
        orderInternalId: orderId,
        styleSelectionJson: reducedSelection.toJsonString(),
      );

      final secondSnap = await repo.watchOrderStyleSnapshot(orderId).first;
      expect(secondSnap!.figures.length, 1);
      expect(secondSnap.figures.single.figureNameSnapshot, 'Classic Collar');
      expect(
        secondSnap.snapshotInternalId,
        isNot(equals(firstSnap.snapshotInternalId)),
      );
    });

    test('cleared style removes snapshot view', () async {
      const selection = StyleOrderSelection.withItems(shapeItems: [v2Item]);
      final orderId = await createStyledOrder(
        styleSelectionJson: selection.toJsonString(),
      );
      expect(await repo.watchOrderStyleSnapshot(orderId).first, isNotNull);

      await repo.updateOrderDetails(
        orderInternalId: orderId,
        styleName: '',
        styleSelectionJson: '',
        styleSummary: '',
      );

      expect(await repo.watchOrderStyleSnapshot(orderId).first, isNull);
    });

    test('remote merge order with v2 styleSelectionJson rebuilds snapshot rows',
        () async {
      const selection = StyleOrderSelection.withItems(shapeItems: [v2Item]);
      const orderId = 'remote-order-v2-1';

      await repo.mergeRemoteOrder(
        shopId: kDevShopId,
        internalId: orderId,
        operation: 'upsert',
        data: {
          'customer_internal_id': DevSeedIds.customer1,
          'delivery_date': DateTime(2026, 6, 10).toIso8601String(),
          'total_amount_minor': 12000,
          'status_index': 0,
          'style_name': 'Qasimi',
          'style_selection_json': selection.toJsonString(),
          'style_summary': 'Qasimi\nClassic Collar',
        },
      );

      final snap = await repo.watchOrderStyleSnapshot(orderId).first;
      expect(snap, isNotNull);
      expect(snap!.figures.single.figureNameSnapshot, 'Classic Collar');
      expect(snap.figures.single.presetNameSnapshot, 'Normal Style');

      final display = formatOrderShapeSelectionDisplay(
        snapshot: snap,
        styleName: 'Qasimi',
        styleSelectionJson: selection.toJsonString(),
        labels: labels,
      );
      expect(display.detailedLines, contains('Text: Round front, Double stitch'));
      expect(display.detailedLines, contains('Size: 2.5 inch'));
    });

    test('remote v2 order displays from snapshot even without local catalog options',
        () async {
      const selection = StyleOrderSelection.withItems(shapeItems: [v2Item]);
      const orderId = 'remote-order-v2-2';

      await repo.mergeRemoteOrder(
        shopId: kDevShopId,
        internalId: orderId,
        operation: 'upsert',
        data: {
          'customer_internal_id': DevSeedIds.customer1,
          'delivery_date': DateTime(2026, 6, 11).toIso8601String(),
          'style_name': 'Qasimi',
          'style_selection_json': selection.toJsonString(),
        },
      );

      final snap = await repo.watchOrderStyleSnapshot(orderId).first;
      final display = formatOrderShapeSelectionDisplay(
        snapshot: snap,
        styleName: 'Qasimi',
        styleSelectionJson: selection.toJsonString(),
        catalogFigures: const [],
        labels: labels,
      );

      expect(display.figures.single.shapeName, 'Classic Collar');
      expect(display.detailedLines, contains('Preset: Normal Style'));
    });

    test('remote order with invalid styleSelectionJson falls back safely', () async {
      const orderId = 'remote-order-bad-json';

      await repo.mergeRemoteOrder(
        shopId: kDevShopId,
        internalId: orderId,
        operation: 'upsert',
        data: {
          'customer_internal_id': DevSeedIds.customer1,
          'delivery_date': DateTime(2026, 6, 12).toIso8601String(),
          'style_name': 'Qasimi',
          'style_selection_json': '{bad json',
          'style_summary': 'Qasimi\nFallback summary',
        },
      );

      final snap = await repo.watchOrderStyleSnapshot(orderId).first;
      expect(snap, isNotNull);
      expect(snap!.styleNameSnapshot, 'Qasimi');
      expect(snap.figures, isEmpty);

      final display = formatOrderShapeSelectionDisplay(
        snapshot: snap,
        styleName: 'Qasimi',
        styleSelectionJson: '{bad json',
        styleSummary: 'Qasimi\nFallback summary',
        labels: labels,
      );
      expect(display.compactPreview, contains('Qasimi'));
    });
  });

  group('inactive and bundled shape safety', () {
    test('inactive selected shape stays in order picker grid', () {
      const active = StyleFigureSummary(
        internalId: 'fig-active',
        shopId: kDevShopId,
        partInternalId: 'part',
        name: 'Active',
        imageRef: 'asset:shape_2',
        sortOrder: 20,
        isActive: true,
      );
      const inactiveSelected = StyleFigureSummary(
        internalId: 'fig-inactive',
        shopId: kDevShopId,
        partInternalId: 'part',
        name: 'Inactive Selected',
        imageRef: 'asset:shape_1',
        sortOrder: 10,
        isActive: false,
      );

      final grid = figuresForOrderSelectionGrid(
        [inactiveSelected, active],
        {'fig-inactive'},
      );

      expect(grid.map((f) => f.internalId), contains('fig-inactive'));
      expect(grid.map((f) => f.internalId), contains('fig-active'));
    });

    test('bundled shapes cannot be hard-deleted from memory catalog', () async {
      final catalog = MemoryStyleCatalogRepository();
      await catalog.seedIfEmpty(kDevShopId);
      final figures = await catalog.watchAllFigures(kDevShopId).first;
      final bundled = figures.firstWhere(
        (f) => StyleFigureImageRef.isBundledAssetRef(f.imageRef),
      );
      final beforeCount = figures.length;

      await catalog.softDeleteStyleFigure(bundled.internalId);
      final after = await catalog.watchAllFigures(kDevShopId).first;

      expect(after.length, beforeCount);
      expect(after.any((f) => f.internalId == bundled.internalId), isTrue);
    });

    test('deactivated shape snapshot still formats from saved view', () {
      final view = OrderStyleSnapshotView(
        orderInternalId: 'order-1',
        snapshotInternalId: 'snap-1',
        styleNameSnapshot: 'Qasimi',
        createdAt: DateTime(2026, 1, 1),
        figures: const [
          OrderStyleSnapshotFigureView(
            styleFigureInternalId: 'fig-inactive',
            figureNameSnapshot: 'Classic Collar',
            imageRefSnapshot: 'asset:shape_1',
            sortOrder: 0,
            presetNameSnapshot: 'Normal Style',
          ),
        ],
      );

      final display = formatOrderShapeSelectionDisplay(
        snapshot: view,
        catalogFigures: const [
          StyleFigureSummary(
            internalId: 'fig-inactive',
            shopId: kDevShopId,
            partInternalId: 'part',
            name: 'Deactivated in catalog',
            imageRef: 'asset:shape_1',
            sortOrder: 10,
            isActive: false,
          ),
        ],
        labels: labels,
      );

      expect(display.figures.single.shapeName, 'Classic Collar');
      expect(display.detailedLines, contains('Preset: Normal Style'));
    });
  });
}
