import 'package:pride_v3/core/formatting/app_number_format.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

String reportFormatMoney(AppLocalizations l10n, int minor) {
  return AppNumberFormat.formatMoney(l10n, minor);
}

/// Signed delta for month-over-month lines (e.g. "+1,200 ؋").
String reportFormatMoneyDelta(AppLocalizations l10n, int deltaMinor) {
  return AppNumberFormat.formatMoneyDelta(l10n, deltaMinor);
}
