import 'package:pride_v3/l10n/app_localizations.dart';

import 'display_order_no_format.dart';

/// Display-only formatter for canonical stored customer numbers (8-digit storage).
String formatDisplayCustomerNo(String stored) => formatDisplayOrderNo(stored);

/// Localized customer ID label for list/profile surfaces.
String displayCustomerNumberLabel(AppLocalizations l10n, String storedCustomerNo) {
  return l10n.customersIdPrefix(formatDisplayCustomerNo(storedCustomerNo));
}
