import 'package:intl/intl.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import 'digit_normalizer.dart';

/// Latin-digit number formatting for display (plan-17 display consistency).
abstract final class AppNumberFormat {
  static final NumberFormat _decimal = NumberFormat.decimalPattern('en');

  /// Formats an integer with Latin digits 0-9.
  static String formatInt(int value) {
    return normalizeWesternDigits(_decimal.format(value));
  }

  /// Formats a double with Latin digits 0-9.
  static String formatDouble(double value) {
    return normalizeWesternDigits(_decimal.format(value));
  }

  /// Money minor units with Latin digits and localized AFN suffix.
  static String formatMoney(AppLocalizations l10n, int minor) {
    return l10n.moneyAfn(formatInt(minor));
  }

  /// Signed delta for month-over-month lines (e.g. "+1,200 ؋").
  static String formatMoneyDelta(AppLocalizations l10n, int deltaMinor) {
    if (deltaMinor == 0) return formatMoney(l10n, 0);
    final sign = deltaMinor < 0 ? '−' : '+';
    return '$sign${formatMoney(l10n, deltaMinor.abs())}';
  }
}
