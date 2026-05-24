import 'package:pride_v3/core/formatting/digit_normalizer.dart';

/// Pure payment validation for orders (minor units, e.g. AFN).
abstract final class OrderPaymentRules {
  static int remainingMinor(int totalMinor, int paidMinor) {
    final r = totalMinor - paidMinor;
    return r < 0 ? 0 : r;
  }

  /// Sum of payment rows when the ledger stream has emitted; otherwise order summary.
  static int effectivePaidMinor({
    required int orderSummaryPaidMinor,
    List<int>? paymentAmountsMinor,
  }) {
    if (paymentAmountsMinor == null) return orderSummaryPaidMinor;
    return paymentAmountsMinor.fold<int>(0, (sum, a) => sum + a);
  }

  /// Per-order paid totals from shop payment rows (for list tiles).
  static Map<String, int> sumPaidMinorByOrderId(
    Iterable<({String orderInternalId, int amountMinor})> payments,
  ) {
    final map = <String, int>{};
    for (final p in payments) {
      map[p.orderInternalId] =
          (map[p.orderInternalId] ?? 0) + p.amountMinor;
    }
    return map;
  }

  static int paidMinorForOrder({
    required int orderSummaryPaidMinor,
    required Map<String, int> paidByOrderId,
    required String orderInternalId,
    required bool paymentsLedgerLoaded,
  }) {
    if (!paymentsLedgerLoaded) return orderSummaryPaidMinor;
    return paidByOrderId[orderInternalId] ?? 0;
  }

  static bool isValidInitialPay(int totalMinor, int initialPaidMinor) =>
      totalMinor > 0 && initialPaidMinor >= 0 && initialPaidMinor <= totalMinor;

  static bool canSetOrderTotal(int newTotalMinor, int paidMinor) =>
      newTotalMinor > 0 && newTotalMinor >= paidMinor;

  /// Positive [raw] sets the field to that amount; negative subtracts from [currentMinor].
  static int? resolveFieldAmount({
    required int currentMinor,
    required String raw,
    bool allowEmpty = false,
  }) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      return allowEmpty ? null : currentMinor;
    }
    final parsed = tryParseSignedMoneyAmount(trimmed);
    if (parsed == null) return null;
    if (parsed < 0) {
      final next = currentMinor + parsed;
      return next < 0 ? null : next;
    }
    return parsed;
  }

  static bool validatePaymentState({
    required int totalMinor,
    required List<int> depositAmountsMinor,
  }) {
    if (totalMinor <= 0) return false;
    var paid = 0;
    for (final a in depositAmountsMinor) {
      if (a < 0) return false;
      paid += a;
    }
    return paid >= 0 && paid <= totalMinor;
  }

  static int sumDepositAmountsMinor(Iterable<int> amounts) =>
      amounts.fold<int>(0, (sum, a) => sum + a);

  static bool canRecordNextPayment({
    required int totalMinor,
    required int paidMinor,
    required int nextPaymentMinor,
  }) =>
      nextPaymentMinor > 0 &&
      paidMinor + nextPaymentMinor <= totalMinor;
}
