/// Pure payment validation for orders (minor units, e.g. AFN).
abstract final class OrderPaymentRules {
  static int remainingMinor(int totalMinor, int paidMinor) {
    final r = totalMinor - paidMinor;
    return r < 0 ? 0 : r;
  }

  static bool isValidInitialPay(int totalMinor, int initialPaidMinor) =>
      totalMinor > 0 && initialPaidMinor >= 0 && initialPaidMinor <= totalMinor;

  static bool canSetOrderTotal(int newTotalMinor, int paidMinor) =>
      newTotalMinor > 0 && newTotalMinor >= paidMinor;

  /// Normal payment: amount > 0 and does not exceed remaining.
  /// Adjustment: signed; net paid after append must not exceed [totalMinor].
  static bool canAppendPayment({
    required int totalMinor,
    required int paidMinor,
    required int amountMinor,
    required bool isAdjustment,
  }) {
    if (totalMinor <= 0) return false;
    if (!isAdjustment) {
      return amountMinor > 0 && paidMinor + amountMinor <= totalMinor;
    }
    final projected = paidMinor + amountMinor;
    return projected <= totalMinor;
  }
}
