import '../../l10n/app_localizations.dart';

/// Localized payment method label for receipts and PDF invoices.
String formatInvoicePaymentMethod(AppLocalizations l10n, String method) {
  switch (method.trim().toLowerCase()) {
    case 'cash':
      return l10n.paymentMethodCash;
    default:
      final m = method.trim();
      return m.isEmpty ? l10n.paymentMethodCash : m;
  }
}
