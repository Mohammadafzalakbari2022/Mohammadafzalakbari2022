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
  });
}

