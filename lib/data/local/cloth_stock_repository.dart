import 'entities/cloth_stock_movement_type.dart';
import 'cloth_stock_models.dart';

abstract class ClothStockRepository {
  Stream<List<ClothStockSkuSummary>> watchSkus(String shopId);

  Stream<List<ClothSupplierSummary>> watchSuppliers(String shopId);

  Stream<List<ClothPurchaseSummary>> watchPurchases(String shopId);

  Stream<List<ClothPurchaseLineSummary>> watchPurchaseLines(String shopId);

  Stream<List<ClothPurchasePaymentSummary>> watchPurchasePayments(String shopId);

  Stream<List<ClothStockMovementSummary>> watchMovements(String shopId);

  Future<ClothStockSkuSummary?> getSku(String internalId);

  Future<String> upsertSku({
    required String shopId,
    required String internalId,
    required String skuCode,
    required String name,
    String color = '',
    String? fabricNamePresetInternalId,
    String? fabricColorPresetInternalId,
  });

  Future<void> softDeleteSku(String internalId);

  Future<String> upsertSupplier({
    required String shopId,
    required String internalId,
    required String name,
    String phone = '',
    String notes = '',
  });

  Future<void> softDeleteSupplier(String internalId);

  Future<void> upsertPurchase({
    required String shopId,
    required ClothPurchaseUpsertInput input,
  });

  Future<void> appendPurchasePayment({
    required String shopId,
    required String purchaseInternalId,
    required int amountMinor,
    required DateTime paidAt,
    String note = '',
    String? internalId,
  });

  Future<void> appendMovement({
    required String shopId,
    required String internalId,
    required String skuInternalId,
    required ClothStockMovementType movementType,
    required int qtyMilliDelta,
    String? orderItemInternalId,
    String? purchaseLineInternalId,
    String note = '',
  });

  Future<void> recacheSkuQty(String skuInternalId);

  Future<List<ClothStockMovementSummary>> movementsForOrderItem(
    String orderItemInternalId,
  );

  Future<void> mergeRemoteSku({
    required String shopId,
    required String internalId,
    required String operation,
    Object? data,
  });

  Future<void> mergeRemoteSupplier({
    required String shopId,
    required String internalId,
    required String operation,
    Object? data,
  });

  Future<void> mergeRemotePurchase({
    required String shopId,
    required String internalId,
    required String operation,
    Object? data,
  });

  Future<void> mergeRemotePurchasePayment({
    required String shopId,
    required String internalId,
    required String operation,
    Object? data,
  });

  Future<void> mergeRemoteMovement({
    required String shopId,
    required String internalId,
    required String operation,
    Object? data,
  });
}
