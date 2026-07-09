import 'package:uuid/uuid.dart';

import 'cloth_stock_models.dart';
import 'cloth_stock_repository.dart';
import 'entities/cloth_source.dart';
import 'entities/cloth_stock_movement_type.dart';
import 'entities/garment_type.dart';
import 'order_item_input.dart';
import 'order_item_summary.dart';

/// Stock movement engine: sale on order save, void on edit, purchase via repo.
class ClothStockService {
  ClothStockService(this._repo);

  final ClothStockRepository _repo;
  final _uuid = const Uuid();

  /// After order item upsert, reconcile stock movements for shop-stock cloth.
  /// Returns movements written this call (voids + sale) for sync outbox.
  Future<List<ClothStockMovementSummary>> reconcileOrderItemStock({
    required String shopId,
    required OrderItemSummary savedItem,
    OrderItemSummary? previousItem,
  }) async {
    final written = <ClothStockMovementSummary>[];
    written.addAll(
      await _voidExistingSaleMovements(
        shopId: shopId,
        orderItemInternalId: savedItem.internalId,
      ),
    );

    if (!ClothSource.fromCode(savedItem.clothSourceIndex).isShopStock) {
      return written;
    }

    final skuId = savedItem.clothStockSkuInternalId;
    if (skuId == null || skuId.isEmpty) return written;

    final qtyMilli = parseMetersToMilli(savedItem.clothMetersSnapshot);
    if (qtyMilli <= 0) return written;

    final movementId = _uuid.v4();
    await _repo.appendMovement(
      shopId: shopId,
      internalId: movementId,
      skuInternalId: skuId,
      movementType: ClothStockMovementType.sale,
      qtyMilliDelta: -qtyMilli,
      orderItemInternalId: savedItem.internalId,
    );
    written.add(
      ClothStockMovementSummary(
        internalId: movementId,
        shopId: shopId,
        skuInternalId: skuId,
        movementType: ClothStockMovementType.sale,
        qtyMilliDelta: -qtyMilli,
        orderItemInternalId: savedItem.internalId,
        purchaseLineInternalId: null,
        note: '',
        createdAt: DateTime.now(),
      ),
    );
    return written;
  }

  /// Reconcile from create input after upsert returns summary.
  Future<void> reconcileFromCreateInput({
    required String shopId,
    required String orderItemInternalId,
    required OrderItemCreateInput input,
    OrderItemSummary? previousItem,
  }) async {
    final saved = OrderItemSummary(
      internalId: orderItemInternalId,
      orderInternalId: previousItem?.orderInternalId ?? '',
      garmentType: input.garmentType,
      sortOrder: input.sortOrder ?? input.garmentType.defaultSortOrder,
      priceAmountMinor: input.priceAmountMinor,
      clothMetersSnapshot: input.clothMetersSnapshot,
      clothSourceIndex: input.clothSourceIndex,
      clothStockSkuInternalId: input.clothStockSkuInternalId,
      clothSaleCostAmountMinor: input.clothSaleCostAmountMinor,
      createdAt: previousItem?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await reconcileOrderItemStock(
      shopId: shopId,
      savedItem: saved,
      previousItem: previousItem,
    );
  }

  Future<List<ClothStockMovementSummary>> _voidExistingSaleMovements({
    required String shopId,
    required String orderItemInternalId,
  }) async {
    final written = <ClothStockMovementSummary>[];
    final existing =
        await _repo.movementsForOrderItem(orderItemInternalId);
    for (final m in existing) {
      if (m.movementType != ClothStockMovementType.sale) continue;
      final voidId = _uuid.v4();
      await _repo.appendMovement(
        shopId: shopId,
        internalId: voidId,
        skuInternalId: m.skuInternalId,
        movementType: ClothStockMovementType.saleVoid,
        qtyMilliDelta: -m.qtyMilliDelta,
        orderItemInternalId: orderItemInternalId,
        note: 'void:${m.internalId}',
      );
      written.add(
        ClothStockMovementSummary(
          internalId: voidId,
          shopId: shopId,
          skuInternalId: m.skuInternalId,
          movementType: ClothStockMovementType.saleVoid,
          qtyMilliDelta: -m.qtyMilliDelta,
          orderItemInternalId: orderItemInternalId,
          purchaseLineInternalId: null,
          note: 'void:${m.internalId}',
          createdAt: DateTime.now(),
        ),
      );
    }
    return written;
  }

  /// Whether SKU would go negative after deducting [qtyMilli].
  Future<bool> wouldBeShortStock({
    required String skuInternalId,
    required int qtyMilli,
  }) async {
    final sku = await _repo.getSku(skuInternalId);
    if (sku == null) return false;
    return sku.qtyOnHandMilli - qtyMilli < 0;
  }

  Future<ClothStockSkuSummary?> skuSummary(String internalId) =>
      _repo.getSku(internalId);
}
