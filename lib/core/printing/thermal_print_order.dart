import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/order_summary.dart';
import '../../data/local/payment_summary.dart';
import '../../features/reports/report_money_format.dart';
import '../../features/settings/shop_profile_provider.dart';
import '../../l10n/app_localizations.dart';
import '../persistence/shared_preferences_provider.dart';
import 'thermal_printer_prefs.dart';
import 'thermal_printer_socket.dart';
import 'thermal_receipt_escpos.dart';

Future<void> printThermalOrderReceipt({
  required BuildContext context,
  required WidgetRef ref,
  required AppLocalizations l10n,
  required OrderSummary order,
  required List<PaymentSummary> payments,
  required String deliveryDateText,
  required String statusText,
}) async {
  if (kIsWeb) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.settingsPrinterWebUnavailable)),
    );
    return;
  }

  final prefs = ref.read(sharedPreferencesProvider);
  final host = ThermalPrinterPrefs.readHost(prefs);
  if (host.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.orderPrintReceiptNeedPrinter)),
    );
    return;
  }

  final port = ThermalPrinterPrefs.readPort(prefs);
  final paperMm = ThermalPrinterPrefs.readPaperMm(prefs);
  final paper = paperSizeFromMm(paperMm);

  final shop = ref.read(shopProfileProvider).valueOrNull;
  final shopName = (shop?.name ?? '').trim();
  final shopLine = shopName.isNotEmpty ? shopName : 'Pride';

  final total = reportFormatMoney(l10n, order.totalAmountMinor);
  final paid = reportFormatMoney(l10n, order.paidAmountMinor);
  final balance = reportFormatMoney(l10n, order.remainingAmountMinor);

  final paymentRows = <String>[];
  for (final p in payments) {
    final amt = reportFormatMoney(l10n, p.amountMinor);
    paymentRows.add('${p.method}  $amt');
  }

  final phone = order.customerPhone?.trim();
  final content = OrderReceiptEscPosContent(
    shopLine: shopLine,
    orderLine: l10n.ordersNumberPrefix(order.displayOrderNo),
    customerLine: '${l10n.receiptCustomerLabel}: ${order.customerName}',
    phoneLine: (phone != null && phone.isNotEmpty)
        ? '${l10n.receiptPhoneLabel}: $phone'
        : null,
    deliveryLine: '${l10n.receiptDeliveryLabel}: $deliveryDateText',
    statusLine: '${l10n.receiptStatusLabel}: $statusText',
    measurementsLine: order.measurementsSnapshot.trim().isEmpty
        ? null
        : '${l10n.receiptMeasurementsLabel}: ${order.measurementsSnapshot.trim()}',
    styleNotesLine: order.styleNotes.trim().isEmpty
        ? null
        : '${l10n.receiptStyleLabel}: ${order.styleNotes.trim()}',
    internalNotesLine: order.internalNotes.trim().isEmpty
        ? null
        : '${l10n.receiptInternalNotesHeader}:\n${order.internalNotes.trim()}',
    totalLine: '${l10n.receiptTotalLabel}: $total',
    paidLine: '${l10n.receiptPaidLabel}: $paid',
    balanceLine: '${l10n.receiptBalanceLabel}: $balance',
    paymentHeader: l10n.receiptPaymentsHeader,
    paymentRows: paymentRows,
    footerLine: l10n.receiptFooterThanks,
  );

  if (!context.mounted) return;
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => const PopScope(
      canPop: false,
      child: Center(child: CircularProgressIndicator()),
    ),
  );

  try {
    final bytes = await buildThermalOrderReceipt(paper: paper, c: content);
    await sendThermalReceiptBytes(host: host, port: port, bytes: bytes);
    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.orderPrintReceiptOk)),
      );
    }
  } catch (e) {
    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.orderPrintReceiptFail(e.toString()))),
      );
    }
  }
}
