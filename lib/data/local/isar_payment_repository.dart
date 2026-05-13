import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

import 'entities/payment_entity.dart';
import 'payment_repository.dart';
import 'payment_summary.dart';

class IsarPaymentRepository implements PaymentRepository {
  IsarPaymentRepository(this._isar);

  final Isar _isar;
  final _uuid = const Uuid();

  @override
  Stream<List<PaymentSummary>> watchPaymentsForOrder(String orderInternalId) {
    return _isar.paymentEntitys
        .filter()
        .orderInternalIdEqualTo(orderInternalId)
        .sortByCreatedAtDesc()
        .watch(fireImmediately: true)
        .map(
          (rows) => rows
              .map(
                (p) => PaymentSummary(
                  internalId: p.internalId,
                  orderInternalId: p.orderInternalId,
                  amountMinor: p.amountMinor,
                  method: p.method,
                  isAdjustment: p.isAdjustment,
                  createdAt: p.createdAt,
                ),
              )
              .toList(),
        );
  }

  @override
  Stream<List<PaymentSummary>> watchAllPaymentsForShop(String shopId) {
    return _isar.paymentEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .sortByCreatedAtDesc()
        .watch(fireImmediately: true)
        .map(
          (rows) => rows
              .map(
                (p) => PaymentSummary(
                  internalId: p.internalId,
                  orderInternalId: p.orderInternalId,
                  amountMinor: p.amountMinor,
                  method: p.method,
                  isAdjustment: p.isAdjustment,
                  createdAt: p.createdAt,
                ),
              )
              .toList(),
        );
  }

  @override
  Future<void> addPayment({
    required String shopId,
    required String orderInternalId,
    required int amountMinor,
    required String method,
    required bool isAdjustment,
  }) async {
    await _isar.writeTxn(() async {
      final e = PaymentEntity()
        ..internalId = _uuid.v4()
        ..shopId = shopId
        ..orderInternalId = orderInternalId
        ..amountMinor = amountMinor
        ..method = method
        ..isAdjustment = isAdjustment
        ..createdAt = DateTime.now();
      await _isar.paymentEntitys.putByInternalId(e);
    });
  }
}

