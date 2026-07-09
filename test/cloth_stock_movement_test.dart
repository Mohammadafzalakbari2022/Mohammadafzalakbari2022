import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/data/local/cloth_stock_models.dart';
import 'package:pride_v3/data/local/cloth_stock_service.dart';
import 'package:pride_v3/data/local/entities/cloth_source.dart';
import 'package:pride_v3/data/local/entities/cloth_stock_movement_type.dart';
import 'package:pride_v3/data/local/entities/garment_type.dart';
import 'package:pride_v3/data/local/memory_cloth_stock_repository.dart';
import 'package:pride_v3/data/local/order_item_summary.dart';

void main() {
  group('ClothStockService movements', () {
    late MemoryClothStockRepository repo;
    late ClothStockService service;
    const shopId = 'shop-1';
    const skuId = 'sku-1';

    setUp(() async {
      repo = MemoryClothStockRepository();
      service = ClothStockService(repo);
      await repo.upsertSku(
        shopId: shopId,
        internalId: skuId,
        skuCode: 'A1',
        name: 'Wool',
      );
      await repo.appendMovement(
        shopId: shopId,
        internalId: 'm-purchase',
        skuInternalId: skuId,
        movementType: ClothStockMovementType.purchase,
        qtyMilliDelta: 5000,
      );
    });

    OrderItemSummary shopStockItem({
      required String itemId,
      String meters = '2',
      int cogs = 1000,
    }) {
      return OrderItemSummary(
        internalId: itemId,
        orderInternalId: 'order-1',
        garmentType: GarmentType.perahanTunban,
        clothMetersSnapshot: meters,
        clothSourceIndex: ClothSource.shopStock.code,
        clothStockSkuInternalId: skuId,
        clothSaleCostAmountMinor: cogs,
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
      );
    }

    test('deducts stock on shop-stock order save', () async {
      await service.reconcileOrderItemStock(
        shopId: shopId,
        savedItem: shopStockItem(itemId: 'item-1'),
      );
      final sku = await repo.getSku(skuId);
      expect(sku!.qtyOnHandMilli, 3000);
    });

    test('allows short stock without throwing', () async {
      await service.reconcileOrderItemStock(
        shopId: shopId,
        savedItem: shopStockItem(itemId: 'item-2', meters: '10'),
      );
      final sku = await repo.getSku(skuId);
      expect(sku!.qtyOnHandMilli, -5000);
      expect(sku.isShortStock, isTrue);
    });

    test('voids prior sale on edit and applies new qty', () async {
      final item = shopStockItem(itemId: 'item-3', meters: '1');
      await service.reconcileOrderItemStock(
        shopId: shopId,
        savedItem: item,
      );
      await service.reconcileOrderItemStock(
        shopId: shopId,
        savedItem: item.copyWith(clothMetersSnapshot: '3'),
        previousItem: item,
      );
      final sku = await repo.getSku(skuId);
      expect(sku!.qtyOnHandMilli, 2000);
    });

    test('customer supplied cloth has no stock impact', () async {
      await service.reconcileOrderItemStock(
        shopId: shopId,
        savedItem: OrderItemSummary(
          internalId: 'item-4',
          orderInternalId: 'order-1',
          garmentType: GarmentType.perahanTunban,
          clothMetersSnapshot: '5',
          clothSourceIndex: ClothSource.customerSupplied.code,
          createdAt: DateTime(2026, 1, 1),
          updatedAt: DateTime(2026, 1, 1),
        ),
      );
      final sku = await repo.getSku(skuId);
      expect(sku!.qtyOnHandMilli, 5000);
    });
  });

  group('parseMetersToMilli', () {
    test('parses decimal meters', () {
      expect(parseMetersToMilli('3.5'), 3500);
      expect(parseMetersToMilli(''), 0);
    });
  });
}
