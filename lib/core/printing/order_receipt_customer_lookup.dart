import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/customer_display_no.dart';
import '../../data/local/customer_summary.dart';
import '../../data/providers/local_data_providers.dart';
import '../formatting/display_customer_no_format.dart';
import '../formatting/display_order_no_format.dart';
import '../../l10n/app_localizations.dart';

/// Resolves stored customer display number for receipt/PDF output.
String customerDisplayNoForOrder(WidgetRef ref, String customerInternalId) {
  final customers =
      ref.read(customersListStreamProvider).valueOrNull ??
      const <CustomerSummary>[];
  for (final c in customers) {
    if (c.internalId == customerInternalId) {
      return c.displayCustomerNo;
    }
  }
  return '';
}

/// Localized customer ID line for receipts (null when not assigned).
String? receiptCustomerIdLine(AppLocalizations l10n, String storedCustomerNo) {
  if (parseStoredDisplayCustomerNo(storedCustomerNo) <= 0) return null;
  return displayCustomerNumberLabel(l10n, storedCustomerNo);
}

/// Localized order ID line for receipts.
String receiptOrderIdLine(AppLocalizations l10n, String storedOrderNo) {
  return displayOrderNumberLabel(l10n, storedOrderNo);
}
