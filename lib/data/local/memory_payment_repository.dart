import 'dart:async';

import 'package:uuid/uuid.dart';

import 'memory_order_repository.dart';
import 'payment_repository.dart';
import 'payment_summary.dart';

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
  }) async {
    _payments.add(
      PaymentSummary(
        internalId: _uuid.v4(),
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

