import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/customer_name_rules.dart';
import '../../data/local/order_summary.dart';
import '../../data/local/payment_summary.dart';
import '../../features/settings/shop_profile_provider.dart';
import '../../l10n/app_localizations.dart';
import '../persistence/shared_preferences_provider.dart';
import 'invoice/invoice_document_thermal_renderer.dart';
import 'invoice/order_invoice_loader.dart';
import 'receipt_line_wrap.dart';
import 'shop_logo_raster.dart';
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
  if (!isValidCustomerName(order.customerName)) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.customerNameRequired)),
    );
    return;
  }

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
  final wrapChars = receiptWrapCharsForPaperMm(paperMm);

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
    final shop = ref.read(shopProfileProvider).valueOrNull;
    final request = await prepareOrderInvoicePdfRequest(
      context: context,
      ref: ref,
      l10n: l10n,
      order: order,
      payments: payments,
      deliveryDateText: deliveryDateText,
      statusText: statusText,
    );

    final document = await loadInvoiceDocumentFromRef(
      ref: ref,
      request: request,
      wrapChars: wrapChars,
    );

    final headerLogo = await loadReceiptHeaderLogoRaster(
      userLogoRelativePath: shop?.logoRelativePath,
      maxWidthPx: paper.width,
    );

    final content = await renderThermalReceiptContent(
      l10n: l10n,
      document: document,
      deliveryDateText: deliveryDateText,
      statusText: statusText,
      paperWidthPx: paper.width,
      headerLogo: headerLogo,
      formatPaymentDate: request.formatPaymentDate,
    );

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
