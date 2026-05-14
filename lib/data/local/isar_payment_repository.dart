import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

import 'entities/payment_entity.dart';
import 'payment_repository.dart';
import 'payment_summary.dart';
import 'sync_pull_payload.dart';

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
    String? internalId,
  }) async {
    await _isar.writeTxn(() async {
      final id = (internalId != null && internalId.isNotEmpty)
          ? internalId
          : _uuid.v4();
      final e = PaymentEntity()
        ..internalId = id
        ..shopId = shopId
        ..orderInternalId = orderInternalId
        ..amountMinor = amountMinor
        ..method = method
        ..isAdjustment = isAdjustment
        ..createdAt = DateTime.now();
      await _isar.paymentEntitys.putByInternalId(e);
    });
  }

  @override
  Future<void> mergeRemotePayment({
    required String shopId,
    required String internalId,
    required String operation,
    Object? data,
  }) async {
    if (operation == 'delete') {
      await _isar.writeTxn(() async {
        await _isar.paymentEntitys.deleteByInternalId(internalId);
      });
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

    await _isar.writeTxn(() async {
      final e = await _isar.paymentEntitys.getByInternalId(internalId) ??
          (PaymentEntity()..internalId = internalId);
      e
        ..shopId = shopId
        ..orderInternalId = orderId
        ..amountMinor = amount
        ..method = method
        ..isAdjustment = isAdj
        ..createdAt = createdAt;
      await _isar.paymentEntitys.putByInternalId(e);
    });
  }
}

