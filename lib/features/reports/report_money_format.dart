import 'package:intl/intl.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

String reportFormatMoney(AppLocalizations l10n, int minor) {
  final fmt = NumberFormat.decimalPattern();
  return l10n.moneyAfn(fmt.format(minor));
}

/// Signed delta for month-over-month lines (e.g. "+1,200 ؋").
String reportFormatMoneyDelta(AppLocalizations l10n, int deltaMinor) {
  if (deltaMinor == 0) return reportFormatMoney(l10n, 0);
  final sign = deltaMinor < 0 ? '−' : '+';
  return '$sign${reportFormatMoney(l10n, deltaMinor.abs())}';
}
