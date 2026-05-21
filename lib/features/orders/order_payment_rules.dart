import 'package:pride_v3/core/formatting/digit_normalizer.dart';

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

  static bool canRecordNextPayment({
    required int totalMinor,
    required int paidMinor,
    required int nextPaymentMinor,
  }) =>
      nextPaymentMinor > 0 &&
      paidMinor + nextPaymentMinor <= totalMinor;

  /// Legacy append/adjustment check (reports/tests).
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
    return projected >= 0 && projected <= totalMinor;
  }
}
