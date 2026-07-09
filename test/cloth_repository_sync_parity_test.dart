import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/data/local/cloth_stock_models.dart';
import 'package:pride_v3/data/local/entities/cloth_stock_movement_type.dart';
import 'package:pride_v3/data/local/memory_cloth_stock_repository.dart';

/// Web (memory) and mobile (Isar) share mergeRemote* contracts for sync pull.
void main() {
  group('MemoryClothStockRepository sync pull parity', () {
    late MemoryClothStockRepository repo;
    const shopId = 'shop-1';

    setUp(() {
      repo = MemoryClothStockRepository();
    });

    test('mergeRemoteSku upsert applies qty on hand', () async {
      await repo.mergeRemoteSku(
        shopId: shopId,
        internalId: 'sku-remote',
        operation: 'upsert',
        data: {
          'sku_code': 'R1',
          'name': 'Silk',
          'color': 'Blue',
          'qty_on_hand_milli': 4500,
        },
      );
      final sku = await repo.getSku('sku-remote');
      expect(sku!.name, 'Silk');
      expect(sku.qtyOnHandMilli, 4500);
    });

    test('mergeRemotePurchase creates stock via purchase lines', () async {
      await repo.upsertSku(
        shopId: shopId,
        internalId: 'sku-1',
        skuCode: 'A1',
        name: 'Wool',
      );
      await repo.mergeRemotePurchase(
        shopId: shopId,
        internalId: 'purchase-remote',
        operation: 'upsert',
        data: {
          'supplier_internal_id': 'sup-1',
          'purchase_date': DateTime(2026, 3, 1).toUtc().toIso8601String(),
          'lines': [
            {
              'internal_id': 'line-1',
              'sku_internal_id': 'sku-1',
              'qty_milli': 3000,
              'unit_cost_amount_minor': 5000,
            },
          ],
        },
      );
      final sku = await repo.getSku('sku-1');
      expect(sku!.qtyOnHandMilli, 3000);
      final purchases = await repo.watchPurchases(shopId).first;
      expect(purchases, hasLength(1));
      expect(purchases.single.totalAmountMinor, 15000);
    });

    test('mergeRemoteMovement appends sale movement once', () async {
      await repo.upsertSku(
        shopId: shopId,
        internalId: 'sku-1',
        skuCode: 'A1',
        name: 'Wool',
      );
      await repo.appendMovement(
        shopId: shopId,
        internalId: 'm-in',
        skuInternalId: 'sku-1',
        movementType: ClothStockMovementType.purchase,
        qtyMilliDelta: 5000,
      );
      await repo.mergeRemoteMovement(
        shopId: shopId,
        internalId: 'm-sale-remote',
        operation: 'upsert',
        data: {
          'sku_internal_id': 'sku-1',
          'movement_type_index': ClothStockMovementType.sale.code,
          'qty_milli_delta': -2000,
          'order_item_internal_id': 'item-1',
        },
      );
      final sku = await repo.getSku('sku-1');
      expect(sku!.qtyOnHandMilli, 3000);
      final movements = await repo.movementsForOrderItem('item-1');
      expect(movements, hasLength(1));
    });
  });
}
