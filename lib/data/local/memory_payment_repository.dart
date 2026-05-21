import 'dart:async';

import 'package:uuid/uuid.dart';

import 'memory_order_repository.dart';
import 'payment_repository.dart';
import 'payment_summary.dart';
import 'sync_pull_payload.dart';

class MemoryPaymentRepository implements PaymentRepository {
  MemoryPaymentRepository(this._orders);

  final MemoryOrderRepository _orders;
  final _uuid = const Uuid();

  final List<PaymentSummary> _payments = [];
  final _controller = StreamController<List<PaymentSummary>>.broadcast();

  @override
  Stream<List<PaymentSummary>> watchPaymentsForOrder(String orderInternalId) async* {
    yield _forOrder(orderInternalId);
    yield* _controller.stream.map((_) => _forOrder(orderInternalId));
  }

  @override
  Stream<List<PaymentSummary>> watchAllPaymentsForShop(String shopId) async* {
    yield _forShop(shopId);
    yield* _controller.stream.map((_) => _forShop(shopId));
  }

  @override
  Future<void> addPayment({
    required String shopId,
    required String orderInternalId,
    required int amountMinor,
    required String method,
    required bool isAdjustment,
    String? internalId,
  }) async {
    final id = (internalId != null && internalId.isNotEmpty)
        ? internalId
        : _uuid.v4();
    _payments.add(
      PaymentSummary(
        internalId: id,
        orderInternalId: orderInternalId,
        amountMinor: amountMinor,
        method: method,
        isAdjustment: isAdjustment,
        createdAt: DateTime.now(),
      ),
    );
    // Update order paid total in memory so list chips change.
    _orders.applyPaymentDelta(orderInternalId, amountMinor);
    _controller.add(const []);
  }

  @override
  Future<void> updatePayment({
    required String internalId,
    required int amountMinor,
    String? method,
  }) async {
    if (amountMinor < 0) {
      throw StateError('payment_amount_negative');
    }
    final idx = _payments.indexWhere((p) => p.internalId == internalId);
    if (idx == -1) throw StateError('payment_not_found');
    final prev = _payments[idx];
    _orders.applyPaymentDelta(prev.orderInternalId, -prev.amountMinor);
    _payments[idx] = PaymentSummary(
      internalId: prev.internalId,
      orderInternalId: prev.orderInternalId,
      amountMinor: amountMinor,
      method: method ?? prev.method,
      isAdjustment: prev.isAdjustment,
      createdAt: prev.createdAt,
    );
    _orders.applyPaymentDelta(prev.orderInternalId, amountMinor);
    _controller.add(const []);
  }

  @override
  Future<void> mergeRemotePayment({
    required String shopId,
    required String internalId,
    required String operation,
    Object? data,
  }) async {
    if (shopId.isEmpty) return;
    if (operation == 'delete') {
      final idx = _payments.indexWhere((p) => p.internalId == internalId);
      if (idx == -1) return;
      final prev = _payments[idx];
      _orders.applyPaymentDelta(prev.orderInternalId, -prev.amountMinor);
      _payments.removeAt(idx);
      _controller.add(const []);
      return;
    }
    final m = syncPullDataMap(data);
    final orderId = syncPullString(
      m,
      const ['order_internal_id', 'orderInternalId'],
    );
    final amount = syncPullInt(m, const ['amount_minor', 'amountMinor']);
    final method = syncPullString(m, const ['method']) ?? 'cash';
    final isAdj =
        syncPullBool(m, const ['is_adjustment', 'isAdjustment']) ?? false;
    if (orderId == null || amount == null) return;
    final createdAt =
        syncPullDateTime(m, const ['created_at', 'createdAt']) ?? DateTime.now();

    final idx = _payments.indexWhere((p) => p.internalId == internalId);
    if (idx != -1) {
      final prev = _payments[idx];
      _orders.applyPaymentDelta(prev.orderInternalId, -prev.amountMinor);
      _payments[idx] = PaymentSummary(
        internalId: internalId,
        orderInternalId: orderId,
        amountMinor: amount,
        method: method,
        isAdjustment: isAdj,
        createdAt: createdAt,
      );
      _orders.applyPaymentDelta(orderId, amount);
      _controller.add(const []);
      return;
    }

    _payments.add(
      PaymentSummary(
        internalId: internalId,
        orderInternalId: orderId,
        amountMinor: amount,
        method: method,
        isAdjustment: isAdj,
        createdAt: createdAt,
      ),
    );
    _orders.applyPaymentDelta(orderId, amount);
    _controller.add(const []);
  }

  List<PaymentSummary> _forOrder(String orderInternalId) {
    final list = _payments.where((p) => p.orderInternalId == orderInternalId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  List<PaymentSummary> _forShop(String shopId) {
    // Payments only exist for the dev shop in web preview.
    if (shopId.isEmpty) return const [];
    final list = [..._payments]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }
}

