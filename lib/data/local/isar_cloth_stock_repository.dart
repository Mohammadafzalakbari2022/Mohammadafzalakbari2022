import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

import 'cloth_stock_models.dart';
import 'cloth_stock_repository.dart';
import 'entities/cloth_purchase_entity.dart';
import 'entities/cloth_purchase_line_entity.dart';
import 'entities/cloth_purchase_payment_entity.dart';
import 'entities/cloth_stock_movement_entity.dart';
import 'entities/cloth_stock_movement_type.dart';
import 'entities/cloth_stock_sku_entity.dart';
import 'entities/cloth_supplier_entity.dart';
import 'sync_pull_payload.dart';

class IsarClothStockRepository implements ClothStockRepository {
  IsarClothStockRepository(this._isar);

  final Isar _isar;
  final _uuid = const Uuid();

  ClothStockSkuSummary _mapSku(ClothStockSkuEntity e) => ClothStockSkuSummary(
        internalId: e.internalId,
        shopId: e.shopId,
        skuCode: e.skuCode,
        name: e.name,
        color: e.color,
        fabricNamePresetInternalId: e.fabricNamePresetInternalId,
        fabricColorPresetInternalId: e.fabricColorPresetInternalId,
        qtyOnHandMilli: e.qtyOnHandMilli,
        updatedAt: e.updatedAt,
      );

  ClothSupplierSummary _mapSupplier(ClothSupplierEntity e) =>
      ClothSupplierSummary(
        internalId: e.internalId,
        shopId: e.shopId,
        name: e.name,
        phone: e.phone,
        notes: e.notes,
        updatedAt: e.updatedAt,
      );

  ClothPurchaseSummary _mapPurchase(ClothPurchaseEntity e) =>
      ClothPurchaseSummary(
        internalId: e.internalId,
        shopId: e.shopId,
        supplierInternalId: e.supplierInternalId,
        purchaseDate: DateTime(
          e.purchaseDate.year,
          e.purchaseDate.month,
          e.purchaseDate.day,
        ),
        totalAmountMinor: e.totalAmountMinor,
        note: e.note,
        updatedAt: e.updatedAt,
      );

  ClothPurchaseLineSummary _mapLine(ClothPurchaseLineEntity e) =>
      ClothPurchaseLineSummary(
        internalId: e.internalId,
        shopId: e.shopId,
        purchaseInternalId: e.purchaseInternalId,
        skuInternalId: e.skuInternalId,
        qtyMilli: e.qtyMilli,
        unitCostAmountMinor: e.unitCostAmountMinor,
        lineTotalMinor: e.lineTotalMinor,
      );

  ClothPurchasePaymentSummary _mapPayment(ClothPurchasePaymentEntity e) =>
      ClothPurchasePaymentSummary(
        internalId: e.internalId,
        shopId: e.shopId,
        purchaseInternalId: e.purchaseInternalId,
        amountMinor: e.amountMinor,
        paidAt: e.paidAt,
        note: e.note,
      );

  ClothStockMovementSummary _mapMovement(ClothStockMovementEntity e) =>
      ClothStockMovementSummary(
        internalId: e.internalId,
        shopId: e.shopId,
        skuInternalId: e.skuInternalId,
        movementType: ClothStockMovementType.fromCode(e.movementTypeIndex),
        qtyMilliDelta: e.qtyMilliDelta,
        orderItemInternalId: e.orderItemInternalId,
        purchaseLineInternalId: e.purchaseLineInternalId,
        note: e.note,
        createdAt: e.createdAt,
      );

  @override
  Stream<List<ClothStockSkuSummary>> watchSkus(String shopId) {
    return _isar.clothStockSkuEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .deletedAtIsNull()
        .sortByName()
        .watch(fireImmediately: true)
        .map((rows) => rows.map(_mapSku).toList());
  }

  @override
  Stream<List<ClothSupplierSummary>> watchSuppliers(String shopId) {
    return _isar.clothSupplierEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .deletedAtIsNull()
        .sortByName()
        .watch(fireImmediately: true)
        .map((rows) => rows.map(_mapSupplier).toList());
  }

  @override
  Stream<List<ClothPurchaseSummary>> watchPurchases(String shopId) {
    return _isar.clothPurchaseEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .deletedAtIsNull()
        .sortByPurchaseDateDesc()
        .watch(fireImmediately: true)
        .map((rows) => rows.map(_mapPurchase).toList());
  }

  @override
  Stream<List<ClothPurchaseLineSummary>> watchPurchaseLines(String shopId) {
    return _isar.clothPurchaseLineEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .watch(fireImmediately: true)
        .map((rows) => rows.map(_mapLine).toList());
  }

  @override
  Stream<List<ClothPurchasePaymentSummary>> watchPurchasePayments(
    String shopId,
  ) {
    return _isar.clothPurchasePaymentEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .sortByPaidAtDesc()
        .watch(fireImmediately: true)
        .map((rows) => rows.map(_mapPayment).toList());
  }

  @override
  Stream<List<ClothStockMovementSummary>> watchMovements(String shopId) {
    return _isar.clothStockMovementEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .sortByCreatedAtDesc()
        .watch(fireImmediately: true)
        .map((rows) => rows.map(_mapMovement).toList());
  }

  @override
  Future<ClothStockSkuSummary?> getSku(String internalId) async {
    final e = await _isar.clothStockSkuEntitys.getByInternalId(internalId);
    if (e == null || e.deletedAt != null) return null;
    return _mapSku(e);
  }

  @override
  Future<String> upsertSku({
    required String shopId,
    required String internalId,
    required String skuCode,
    required String name,
    String color = '',
    String? fabricNamePresetInternalId,
    String? fabricColorPresetInternalId,
  }) async {
    final now = DateTime.now();
    await _isar.writeTxn(() async {
      final existing =
          await _isar.clothStockSkuEntitys.getByInternalId(internalId);
      final e = existing ?? ClothStockSkuEntity()
        ..internalId = internalId
        ..shopId = shopId
        ..qtyOnHandMilli = existing?.qtyOnHandMilli ?? 0
        ..createdAt = existing?.createdAt ?? now;
      e
        ..skuCode = skuCode.trim()
        ..name = name.trim()
        ..color = color.trim()
        ..fabricNamePresetInternalId = fabricNamePresetInternalId
        ..fabricColorPresetInternalId = fabricColorPresetInternalId
        ..updatedAt = now
        ..deletedAt = null;
      await _isar.clothStockSkuEntitys.putByInternalId(e);
    });
    return internalId;
  }

  @override
  Future<void> softDeleteSku(String internalId) async {
    await _isar.writeTxn(() async {
      final e = await _isar.clothStockSkuEntitys.getByInternalId(internalId);
      if (e == null || e.deletedAt != null) return;
      e
        ..deletedAt = DateTime.now()
        ..updatedAt = DateTime.now();
      await _isar.clothStockSkuEntitys.putByInternalId(e);
    });
  }

  @override
  Future<String> upsertSupplier({
    required String shopId,
    required String internalId,
    required String name,
    String phone = '',
    String notes = '',
  }) async {
    final now = DateTime.now();
    await _isar.writeTxn(() async {
      final existing =
          await _isar.clothSupplierEntitys.getByInternalId(internalId);
      final e = existing ?? ClothSupplierEntity()
        ..internalId = internalId
        ..shopId = shopId
        ..createdAt = existing?.createdAt ?? now;
      e
        ..name = name.trim()
        ..phone = phone.trim()
        ..notes = notes.trim()
        ..updatedAt = now
        ..deletedAt = null;
      await _isar.clothSupplierEntitys.putByInternalId(e);
    });
    return internalId;
  }

  @override
  Future<void> softDeleteSupplier(String internalId) async {
    await _isar.writeTxn(() async {
      final e = await _isar.clothSupplierEntitys.getByInternalId(internalId);
      if (e == null || e.deletedAt != null) return;
      e
        ..deletedAt = DateTime.now()
        ..updatedAt = DateTime.now();
      await _isar.clothSupplierEntitys.putByInternalId(e);
    });
  }

  @override
  Future<void> upsertPurchase({
    required String shopId,
    required ClothPurchaseUpsertInput input,
  }) async {
    final now = DateTime.now();
    final purchaseDate = DateTime(
      input.purchaseDate.year,
      input.purchaseDate.month,
      input.purchaseDate.day,
    );
    var totalMinor = 0;
    for (final line in input.lines) {
      totalMinor += line.lineTotalMinor;
    }

    await _isar.writeTxn(() async {
      final existing =
          await _isar.clothPurchaseEntitys.getByInternalId(input.internalId);
      final purchase = existing ?? ClothPurchaseEntity()
        ..internalId = input.internalId
        ..shopId = shopId
        ..createdAt = existing?.createdAt ?? now;
      purchase
        ..supplierInternalId = input.supplierInternalId
        ..purchaseDate = purchaseDate
        ..totalAmountMinor = totalMinor
        ..note = input.note.trim()
        ..updatedAt = now
        ..deletedAt = null;
      await _isar.clothPurchaseEntitys.putByInternalId(purchase);

      final oldLines = await _isar.clothPurchaseLineEntitys
          .filter()
          .purchaseInternalIdEqualTo(input.internalId)
          .findAll();
      for (final old in oldLines) {
        await _voidPurchaseLineMovement(old);
        await _isar.clothPurchaseLineEntitys.delete(old.id);
      }

      for (final lineInput in input.lines) {
        if (lineInput.qtyMilli <= 0) continue;
        final lineId = lineInput.internalId ?? _uuid.v4();
        final lineTotal = lineInput.lineTotalMinor;
        final line = ClothPurchaseLineEntity()
          ..internalId = lineId
          ..shopId = shopId
          ..purchaseInternalId = input.internalId
          ..skuInternalId = lineInput.skuInternalId
          ..qtyMilli = lineInput.qtyMilli
          ..unitCostAmountMinor = lineInput.unitCostAmountMinor
          ..lineTotalMinor = lineTotal
          ..createdAt = now;
        await _isar.clothPurchaseLineEntitys.putByInternalId(line);

        final movement = ClothStockMovementEntity()
          ..internalId = _uuid.v4()
          ..shopId = shopId
          ..skuInternalId = lineInput.skuInternalId
          ..movementTypeIndex = ClothStockMovementType.purchase.code
          ..qtyMilliDelta = lineInput.qtyMilli
          ..purchaseLineInternalId = lineId
          ..createdAt = now;
        await _isar.clothStockMovementEntitys.putByInternalId(movement);
        await _applyQtyDelta(lineInput.skuInternalId, lineInput.qtyMilli);
      }
    });
  }

  Future<void> _voidPurchaseLineMovement(ClothPurchaseLineEntity line) async {
    final movements = await _isar.clothStockMovementEntitys
        .filter()
        .purchaseLineInternalIdEqualTo(line.internalId)
        .findAll();
    for (final m in movements) {
      if (m.movementTypeIndex == ClothStockMovementType.purchase.code) {
        await _applyQtyDelta(m.skuInternalId, -m.qtyMilliDelta);
      }
      await _isar.clothStockMovementEntitys.delete(m.id);
    }
  }

  @override
  Future<void> appendPurchasePayment({
    required String shopId,
    required String purchaseInternalId,
    required int amountMinor,
    required DateTime paidAt,
    String note = '',
    String? internalId,
  }) async {
    final id = internalId ?? _uuid.v4();
    final e = ClothPurchasePaymentEntity()
      ..internalId = id
      ..shopId = shopId
      ..purchaseInternalId = purchaseInternalId
      ..amountMinor = amountMinor
      ..paidAt = paidAt
      ..note = note.trim()
      ..createdAt = DateTime.now();
    await _isar.writeTxn(() async {
      await _isar.clothPurchasePaymentEntitys.putByInternalId(e);
    });
  }

  @override
  Future<void> appendMovement({
    required String shopId,
    required String internalId,
    required String skuInternalId,
    required ClothStockMovementType movementType,
    required int qtyMilliDelta,
    String? orderItemInternalId,
    String? purchaseLineInternalId,
    String note = '',
  }) async {
    final now = DateTime.now();
    await _isar.writeTxn(() async {
      final e = ClothStockMovementEntity()
        ..internalId = internalId
        ..shopId = shopId
        ..skuInternalId = skuInternalId
        ..movementTypeIndex = movementType.code
        ..qtyMilliDelta = qtyMilliDelta
        ..orderItemInternalId = orderItemInternalId
        ..purchaseLineInternalId = purchaseLineInternalId
        ..note = note.trim()
        ..createdAt = now;
      await _isar.clothStockMovementEntitys.putByInternalId(e);
      await _applyQtyDelta(skuInternalId, qtyMilliDelta);
    });
  }

  Future<void> _applyQtyDelta(String skuInternalId, int delta) async {
    final sku = await _isar.clothStockSkuEntitys.getByInternalId(skuInternalId);
    if (sku == null || sku.deletedAt != null) return;
    sku
      ..qtyOnHandMilli = sku.qtyOnHandMilli + delta
      ..updatedAt = DateTime.now();
    await _isar.clothStockSkuEntitys.putByInternalId(sku);
  }

  @override
  Future<void> recacheSkuQty(String skuInternalId) async {
    final movements = await _isar.clothStockMovementEntitys
        .filter()
        .skuInternalIdEqualTo(skuInternalId)
        .findAll();
    var sum = 0;
    for (final m in movements) {
      sum += m.qtyMilliDelta;
    }
    await _isar.writeTxn(() async {
      final sku = await _isar.clothStockSkuEntitys.getByInternalId(skuInternalId);
      if (sku == null || sku.deletedAt != null) return;
      sku
        ..qtyOnHandMilli = sum
        ..updatedAt = DateTime.now();
      await _isar.clothStockSkuEntitys.putByInternalId(sku);
    });
  }

  @override
  Future<List<ClothStockMovementSummary>> movementsForOrderItem(
    String orderItemInternalId,
  ) async {
    final rows = await _isar.clothStockMovementEntitys
        .filter()
        .orderItemInternalIdEqualTo(orderItemInternalId)
        .findAll();
    return rows.map(_mapMovement).toList();
  }

  @override
  Future<void> mergeRemoteSku({
    required String shopId,
    required String internalId,
    required String operation,
    Object? data,
  }) async {
    if (operation == 'delete') {
      await softDeleteSku(internalId);
      return;
    }
    final m = syncPullDataMap(data);
    final skuCode = syncPullString(m, const ['sku_code', 'skuCode']) ?? '';
    final name = syncPullString(m, const ['name']) ?? '';
    if (name.trim().isEmpty) return;
    final color = syncPullString(m, const ['color']) ?? '';
    final qty = syncPullInt(m, const ['qty_on_hand_milli', 'qtyOnHandMilli']);
    await upsertSku(
      shopId: shopId,
      internalId: internalId,
      skuCode: skuCode,
      name: name,
      color: color,
    );
    if (qty != null) {
      await _isar.writeTxn(() async {
        final e = await _isar.clothStockSkuEntitys.getByInternalId(internalId);
        if (e == null) return;
        e.qtyOnHandMilli = qty;
        await _isar.clothStockSkuEntitys.putByInternalId(e);
      });
    }
  }

  @override
  Future<void> mergeRemoteSupplier({
    required String shopId,
    required String internalId,
    required String operation,
    Object? data,
  }) async {
    if (operation == 'delete') {
      await softDeleteSupplier(internalId);
      return;
    }
    final m = syncPullDataMap(data);
    final name = syncPullString(m, const ['name']) ?? '';
    if (name.trim().isEmpty) return;
    await upsertSupplier(
      shopId: shopId,
      internalId: internalId,
      name: name,
      phone: syncPullString(m, const ['phone']) ?? '',
      notes: syncPullString(m, const ['notes']) ?? '',
    );
  }

  @override
  Future<void> mergeRemotePurchase({
    required String shopId,
    required String internalId,
    required String operation,
    Object? data,
  }) async {
    if (operation == 'delete') return;
    final m = syncPullDataMap(data);
    final supplierId = syncPullString(
      m,
      const ['supplier_internal_id', 'supplierInternalId'],
    );
    if (supplierId == null || supplierId.isEmpty) return;
    final purchaseDate = syncPullDateTime(
          m,
          const ['purchase_date', 'purchaseDate'],
        ) ??
        DateTime.now();
    final note = syncPullString(m, const ['note']) ?? '';
    final linesRaw = m['lines'];
    final lines = <ClothPurchaseLineInput>[];
    if (linesRaw is List) {
      for (final entry in linesRaw) {
        if (entry is! Map) continue;
        final lm = Map<String, dynamic>.from(entry);
        final skuId = syncPullString(
          lm,
          const ['sku_internal_id', 'skuInternalId'],
        );
        final qty = syncPullInt(lm, const ['qty_milli', 'qtyMilli']);
        final unitCost = syncPullInt(
          lm,
          const ['unit_cost_amount_minor', 'unitCostAmountMinor'],
        );
        if (skuId == null || qty == null || unitCost == null) continue;
        lines.add(
          ClothPurchaseLineInput(
            internalId: syncPullString(lm, const ['internal_id', 'internalId']),
            skuInternalId: skuId,
            qtyMilli: qty,
            unitCostAmountMinor: unitCost,
          ),
        );
      }
    }
    await upsertPurchase(
      shopId: shopId,
      input: ClothPurchaseUpsertInput(
        internalId: internalId,
        supplierInternalId: supplierId,
        purchaseDate: purchaseDate,
        note: note,
        lines: lines,
      ),
    );
  }

  @override
  Future<void> mergeRemotePurchasePayment({
    required String shopId,
    required String internalId,
    required String operation,
    Object? data,
  }) async {
    if (operation == 'delete') return;
    final m = syncPullDataMap(data);
    final purchaseId = syncPullString(
      m,
      const ['purchase_internal_id', 'purchaseInternalId'],
    );
    final amount = syncPullInt(m, const ['amount_minor', 'amountMinor']);
    final paidAt = syncPullDateTime(m, const ['paid_at', 'paidAt']);
    if (purchaseId == null || amount == null || paidAt == null) return;
    await appendPurchasePayment(
      shopId: shopId,
      purchaseInternalId: purchaseId,
      amountMinor: amount,
      paidAt: paidAt,
      note: syncPullString(m, const ['note']) ?? '',
      internalId: internalId,
    );
  }

  @override
  Future<void> mergeRemoteMovement({
    required String shopId,
    required String internalId,
    required String operation,
    Object? data,
  }) async {
    if (operation == 'delete') return;
    final m = syncPullDataMap(data);
    final skuId = syncPullString(m, const ['sku_internal_id', 'skuInternalId']);
    final typeCode = syncPullInt(
      m,
      const ['movement_type_index', 'movementTypeIndex'],
    );
    final delta = syncPullInt(m, const ['qty_milli_delta', 'qtyMilliDelta']);
    if (skuId == null || typeCode == null || delta == null) return;
    final existing =
        await _isar.clothStockMovementEntitys.getByInternalId(internalId);
    if (existing != null) return;
    await appendMovement(
      shopId: shopId,
      internalId: internalId,
      skuInternalId: skuId,
      movementType: ClothStockMovementType.fromCode(typeCode),
      qtyMilliDelta: delta,
      orderItemInternalId: syncPullString(
        m,
        const ['order_item_internal_id', 'orderItemInternalId'],
      ),
      purchaseLineInternalId: syncPullString(
        m,
        const ['purchase_line_internal_id', 'purchaseLineInternalId'],
      ),
      note: syncPullString(m, const ['note']) ?? '',
    );
  }
}
