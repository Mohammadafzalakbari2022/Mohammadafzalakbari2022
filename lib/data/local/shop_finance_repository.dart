import 'shop_finance_models.dart';

abstract class ShopFinanceRepository {
  Stream<List<ShopRentSummary>> watchRents(String shopId);

  Stream<List<ShopRentPaymentSummary>> watchRentPayments(String shopId);

  Stream<List<ShopExpenseSummary>> watchExpenses(String shopId);

  Future<void> upsertRent({
    required String shopId,
    required String internalId,
    required int amountMinor,
    required DateTime dueDate,
    required int periodMonths,
  });

  Future<void> appendRentPayment({
    required String shopId,
    required String rentInternalId,
    required int amountMinor,
    required DateTime paidAt,
    String note = '',
    String? internalId,
  });

  /// Advances rent due date by [periodMonths] after payment.
  Future<void> renewRentAfterPayment(String rentInternalId);

  Future<void> upsertExpense({
    required String shopId,
    required String internalId,
    required ShopExpenseCategory category,
    required int amountMinor,
    required DateTime expenseDate,
    String note = '',
  });

  Future<void> deleteExpense(String internalId);

  Future<void> mergeRemoteRent({
    required String shopId,
    required String internalId,
    required String operation,
    Object? data,
  });

  Future<void> mergeRemoteRentPayment({
    required String shopId,
    required String internalId,
    required String operation,
    Object? data,
  });

  Future<void> mergeRemoteExpense({
    required String shopId,
    required String internalId,
    required String operation,
    Object? data,
  });

  /// Soft-clear expenses before [before] (exclusive) for the shop.
  Future<void> clearExpensesBefore(String shopId, DateTime before);

  int totalPaidForRent(String rentInternalId, List<ShopRentPaymentSummary> payments);
}
