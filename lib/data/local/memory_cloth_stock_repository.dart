import 'dart:async';

import 'package:uuid/uuid.dart';

import 'cloth_stock_models.dart';
import 'cloth_stock_repository.dart';
import 'entities/cloth_stock_movement_type.dart';
import 'sync_pull_payload.dart';

class MemoryClothStockRepository implements ClothStockRepository {
  final List<ClothStockSkuSummary> _skus = [];
  final List<ClothSupplierSummary> _suppliers = [];
  final List<ClothPurchaseSummary> _purchases = [];
  final List<ClothPurchaseLineSummary> _lines = [];
  final List<ClothPurchasePaymentSummary> _payments = [];
  final List<ClothStockMovementSummary> _movements = [];
  final _controller = StreamController<void>.broadcast();
  final _uuid = const Uuid();

  void _emit() => _controller.add(null);

  @override
  Stream<List<ClothStockSkuSummary>> watchSkus(String shopId) async* {
    yield _skus.where((s) => s.shopId == shopId).toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    yield* _controller.stream.map((_) {
      final list = _skus.where((s) => s.shopId == shopId).toList();
      list.sort((a, b) => a.name.compareTo(b.name));
      return list;
    });
  }

  @override
  Stream<List<ClothSupplierSummary>> watchSuppliers(String shopId) async* {
    yield _suppliers.where((s) => s.shopId == shopId).toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    yield* _controller.stream.map((_) {
      final list = _suppliers.where((s) => s.shopId == shopId).toList();
      list.sort((a, b) => a.name.compareTo(b.name));
      return list;
    });
  }

  @override
  Stream<List<ClothPurchaseSummary>> watchPurchases(String shopId) async* {
    yield _sortedPurchases(shopId);
    yield* _controller.stream.map((_) => _sortedPurchases(shopId));
  }

  List<ClothPurchaseSummary> _sortedPurchases(String shopId) {
    final list = _purchases.where((p) => p.shopId == shopId).toList();
    list.sort((a, b) => b.purchaseDate.compareTo(a.purchaseDate));
    return list;
  }

  @override
  Stream<List<ClothPurchaseLineSummary>> watchPurchaseLines(
    String shopId,
  ) async* {
    yield _lines.where((l) => l.shopId == shopId).toList();
    yield* _controller.stream
        .map((_) => _lines.where((l) => l.shopId == shopId).toList());
  }

  @override
  Stream<List<ClothPurchasePaymentSummary>> watchPurchasePayments(
    String shopId,
  ) async* {
    yield _sortedPayments(shopId);
    yield* _controller.stream.map((_) => _sortedPayments(shopId));
  }

  List<ClothPurchasePaymentSummary> _sortedPayments(String shopId) {
    final list = _payments.where((p) => p.shopId == shopId).toList();
    list.sort((a, b) => b.paidAt.compareTo(a.paidAt));
    return list;
  }

  @override
  Stream<List<ClothStockMovementSummary>> watchMovements(String shopId) async* {
    yield _sortedMovements(shopId);
    yield* _controller.stream.map((_) => _sortedMovements(shopId));
  }

  List<ClothStockMovementSummary> _sortedMovements(String shopId) {
    final list = _movements.where((m) => m.shopId == shopId).toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  @override
  Future<ClothStockSkuSummary?> getSku(String internalId) async {
    try {
      return _skus.firstWhere((s) => s.internalId == internalId);
    } catch (_) {
      return null;
    }
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
    final idx = _skus.indexWhere((s) => s.internalId == internalId);
    final existing = idx >= 0 ? _skus[idx] : null;
    final row = ClothStockSkuSummary(
      internalId: internalId,
      shopId: shopId,
      skuCode: skuCode.trim(),
      name: name.trim(),
      color: color.trim(),
      fabricNamePresetInternalId: fabricNamePresetInternalId,
      fabricColorPresetInternalId: fabricColorPresetInternalId,
      qtyOnHandMilli: existing?.qtyOnHandMilli ?? 0,
      updatedAt: now,
    );
    if (idx >= 0) {
      _skus[idx] = row;
    } else {
      _skus.add(row);
    }
    _emit();
    return internalId;
  }

  @override
  Future<void> softDeleteSku(String internalId) async {
    _skus.removeWhere((s) => s.internalId == internalId);
    _emit();
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
    final idx = _suppliers.indexWhere((s) => s.internalId == internalId);
    final row = ClothSupplierSummary(
      internalId: internalId,
      shopId: shopId,
      name: name.trim(),
      phone: phone.trim(),
      notes: notes.trim(),
      updatedAt: now,
    );
    if (idx >= 0) {
      _suppliers[idx] = row;
    } else {
      _suppliers.add(row);
    }
    _emit();
    return internalId;
  }

  @override
  Future<void> softDeleteSupplier(String internalId) async {
    _suppliers.removeWhere((s) => s.internalId == internalId);
    _emit();
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

    final oldLines =
        _lines.where((l) => l.purchaseInternalId == input.internalId).toList();
    for (final old in oldLines) {
      await _voidPurchaseLineMovement(old);
    }
    _lines.removeWhere((l) => l.purchaseInternalId == input.internalId);

    final pIdx = _purchases.indexWhere((p) => p.internalId == input.internalId);
    final purchase = ClothPurchaseSummary(
      internalId: input.internalId,
      shopId: shopId,
      supplierInternalId: input.supplierInternalId,
      purchaseDate: purchaseDate,
      totalAmountMinor: totalMinor,
      note: input.note.trim(),
      updatedAt: now,
    );
    if (pIdx >= 0) {
      _purchases[pIdx] = purchase;
    } else {
      _purchases.add(purchase);
    }

    for (final lineInput in input.lines) {
      if (lineInput.qtyMilli <= 0) continue;
      final lineId = lineInput.internalId ?? _uuid.v4();
      _lines.add(
        ClothPurchaseLineSummary(
          internalId: lineId,
          shopId: shopId,
          purchaseInternalId: input.internalId,
          skuInternalId: lineInput.skuInternalId,
          qtyMilli: lineInput.qtyMilli,
          unitCostAmountMinor: lineInput.unitCostAmountMinor,
          lineTotalMinor: lineInput.lineTotalMinor,
        ),
      );
      await appendMovement(
        shopId: shopId,
        internalId: _uuid.v4(),
        skuInternalId: lineInput.skuInternalId,
        movementType: ClothStockMovementType.purchase,
        qtyMilliDelta: lineInput.qtyMilli,
        purchaseLineInternalId: lineId,
      );
    }
    _emit();
  }

  Future<void> _voidPurchaseLineMovement(ClothPurchaseLineSummary line) async {
    final movements = _movements
        .where((m) => m.purchaseLineInternalId == line.internalId)
        .toList();
    for (final m in movements) {
      if (m.movementType == ClothStockMovementType.purchase) {
        await _applyQtyDelta(m.skuInternalId, -m.qtyMilliDelta);
      }
      _movements.removeWhere((x) => x.internalId == m.internalId);
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
    _payments.add(
      ClothPurchasePaymentSummary(
        internalId: internalId ?? _uuid.v4(),
        shopId: shopId,
        purchaseInternalId: purchaseInternalId,
        amountMinor: amountMinor,
        paidAt: paidAt,
        note: note.trim(),
      ),
    );
    _emit();
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
    _movements.add(
      ClothStockMovementSummary(
        internalId: internalId,
        shopId: shopId,
        skuInternalId: skuInternalId,
        movementType: movementType,
        qtyMilliDelta: qtyMilliDelta,
        orderItemInternalId: orderItemInternalId,
        purchaseLineInternalId: purchaseLineInternalId,
        note: note.trim(),
        createdAt: DateTime.now(),
      ),
    );
    await _applyQtyDelta(skuInternalId, qtyMilliDelta);
    _emit();
  }

  Future<void> _applyQtyDelta(String skuInternalId, int delta) async {
    final idx = _skus.indexWhere((s) => s.internalId == skuInternalId);
    if (idx < 0) return;
    final s = _skus[idx];
    _skus[idx] = ClothStockSkuSummary(
      internalId: s.internalId,
      shopId: s.shopId,
      skuCode: s.skuCode,
      name: s.name,
      color: s.color,
      fabricNamePresetInternalId: s.fabricNamePresetInternalId,
      fabricColorPresetInternalId: s.fabricColorPresetInternalId,
      qtyOnHandMilli: s.qtyOnHandMilli + delta,
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<void> recacheSkuQty(String skuInternalId) async {
    var sum = 0;
    for (final m in _movements.where((m) => m.skuInternalId == skuInternalId)) {
      sum += m.qtyMilliDelta;
    }
    final idx = _skus.indexWhere((s) => s.internalId == skuInternalId);
    if (idx < 0) return;
    final s = _skus[idx];
    _skus[idx] = ClothStockSkuSummary(
      internalId: s.internalId,
      shopId: s.shopId,
      skuCode: s.skuCode,
      name: s.name,
      color: s.color,
      fabricNamePresetInternalId: s.fabricNamePresetInternalId,
      fabricColorPresetInternalId: s.fabricColorPresetInternalId,
      qtyOnHandMilli: sum,
      updatedAt: DateTime.now(),
    );
    _emit();
  }

  @override
  Future<List<ClothStockMovementSummary>> movementsForOrderItem(
    String orderItemInternalId,
  ) async =>
      _movements
          .where((m) => m.orderItemInternalId == orderItemInternalId)
          .toList();

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
      final idx = _skus.indexWhere((s) => s.internalId == internalId);
      if (idx >= 0) {
        final s = _skus[idx];
        _skus[idx] = ClothStockSkuSummary(
          internalId: s.internalId,
          shopId: s.shopId,
          skuCode: s.skuCode,
          name: s.name,
          color: s.color,
          fabricNamePresetInternalId: s.fabricNamePresetInternalId,
          fabricColorPresetInternalId: s.fabricColorPresetInternalId,
          qtyOnHandMilli: qty,
          updatedAt: DateTime.now(),
        );
        _emit();
      }
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
    if (_movements.any((m) => m.internalId == internalId)) return;
    final m = syncPullDataMap(data);
    final skuId = syncPullString(m, const ['sku_internal_id', 'skuInternalId']);
    final typeCode = syncPullInt(
      m,
      const ['movement_type_index', 'movementTypeIndex'],
    );
    final delta = syncPullInt(m, const ['qty_milli_delta', 'qtyMilliDelta']);
    if (skuId == null || typeCode == null || delta == null) return;
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
