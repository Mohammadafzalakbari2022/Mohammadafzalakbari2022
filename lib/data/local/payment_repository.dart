import 'payment_summary.dart';

abstract class PaymentRepository {
  Stream<List<PaymentSummary>> watchPaymentsForOrder(String orderInternalId);

  Stream<List<PaymentSummary>> watchAllPaymentsForShop(String shopId);

  Future<void> addPayment({
    required String shopId,
    required String orderInternalId,
    required int amountMinor,
    required String method,
    required bool isAdjustment,
    String? internalId,
  });

  Future<void> updatePayment({
    required String internalId,
    required int amountMinor,
    String? method,
  });

  /// Apply one row from `GET /sync/pull` (`plan-03`).
  Future<void> mergeRemotePayment({
    required String shopId,
    required String internalId,
    required String operation,
    Object? data,
  });
}

