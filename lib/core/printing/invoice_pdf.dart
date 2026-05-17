import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../data/local/order_summary.dart';
import '../../data/local/payment_summary.dart';
import '../../features/reports/report_money_format.dart';
import '../../features/settings/shop_profile.dart';
import '../../l10n/app_localizations.dart';
import 'invoice_pdf_font.dart';
import 'receipt_branding.dart';
import 'shop_logo_raster.dart';

/// Builds a single-page PDF invoice (RTL when [textDirection] is RTL).
Future<Uint8List> buildOrderInvoicePdf({
  required AppLocalizations l10n,
  required ShopProfile? shop,
  required OrderSummary order,
  required List<PaymentSummary> payments,
  required String deliveryDateText,
  required String statusText,
  required pw.TextDirection textDirection,
  bool forceHelvetica = false,
}) async {
  final font = forceHelvetica
      ? InvoicePdfFonts.helvetica()
      : await InvoicePdfFonts.primary();
  final branding = ReceiptBranding.fromShop(
    shop: shop,
    l10n: l10n,
    wrapChars: 48,
  );

  pw.ImageProvider? logoProvider;
  final logoRaster = await loadReceiptHeaderLogoRaster(
    userLogoRelativePath: shop?.logoRelativePath,
    maxWidthPx: 200,
  );
  if (logoRaster != null) {
    final png = Uint8List.fromList(img.encodePng(logoRaster));
    logoProvider = pw.MemoryImage(png);
  }

  final total = reportFormatMoney(l10n, order.totalAmountMinor);
  final paid = reportFormatMoney(l10n, order.paidAmountMinor);
  final balance = reportFormatMoney(l10n, order.remainingAmountMinor);

  final paymentRows = <String>[];
  for (final p in payments) {
    final amt = reportFormatMoney(l10n, p.amountMinor);
    paymentRows.add('${p.method}  $amt');
  }

  final styleText = order.styleSummary.trim().isNotEmpty
      ? order.styleSummary.trim()
      : order.styleName.trim();

  pw.Widget sectionTitle(String text) => pw.Padding(
        padding: const pw.EdgeInsets.only(top: 6, bottom: 2),
        child: pw.Text(
          text,
          style: pw.TextStyle(font: font, fontSize: 11, fontWeight: pw.FontWeight.bold),
        ),
      );

  pw.Widget bodyLine(String text) => pw.Text(
        text,
        style: pw.TextStyle(font: font, fontSize: 10),
      );

  pw.Widget divider() => pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 6),
        child: pw.Divider(color: PdfColors.grey400, thickness: 0.5),
      );

  final doc = pw.Document(
    theme: forceHelvetica
        ? pw.ThemeData.withFont(base: font, bold: font)
        : InvoicePdfFonts.themeFor(font),
  );

  doc.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      build: (context) {
        return pw.Directionality(
          textDirection: textDirection,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              if (logoProvider != null)
                pw.Center(
                  child: pw.Image(logoProvider, height: 56, fit: pw.BoxFit.contain),
                ),
              pw.SizedBox(height: logoProvider != null ? 8 : 0),
              pw.Center(
                child: pw.Text(
                  branding.shopDisplayName,
                  style: pw.TextStyle(font: font, fontSize: 16, fontWeight: pw.FontWeight.bold),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              if (branding.shopPhoneLine != null) ...[
                pw.SizedBox(height: 4),
                pw.Center(child: bodyLine(branding.shopPhoneLine!)),
              ],
              for (final line in branding.addressLines)
                if (line.trim().isNotEmpty)
                  pw.Center(child: bodyLine(line.trim())),
              divider(),
              pw.Center(
                child: pw.Text(
                  l10n.ordersNumberPrefix(order.displayOrderNo),
                  style: pw.TextStyle(font: font, fontSize: 13, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.SizedBox(height: 8),
              bodyLine('${l10n.receiptCustomerLabel}: ${order.customerName}'),
              if (_invoicePhoneLine(order.customerPhone)
                  case final phoneLine?)
                bodyLine('${l10n.receiptPhoneLabel}: $phoneLine'),
              bodyLine('${l10n.receiptDeliveryLabel}: $deliveryDateText'),
              bodyLine('${l10n.receiptStatusLabel}: $statusText'),
              if (order.measurementsSnapshot.trim().isNotEmpty) ...[
                sectionTitle(l10n.receiptMeasurementsLabel),
                bodyLine(order.measurementsSnapshot.trim()),
              ],
              if (styleText.isNotEmpty) ...[
                sectionTitle(l10n.receiptStyleLabel),
                bodyLine(styleText),
              ],
              if (order.hasCustomerFabric) ...[
                sectionTitle(l10n.receiptFabricLabel),
                if (order.fabricNameSnapshot.trim().isNotEmpty)
                  bodyLine(
                    '${l10n.receiptFabricNameLabel}: ${order.fabricNameSnapshot.trim()}',
                  ),
                if (order.fabricColorSnapshot.trim().isNotEmpty)
                  bodyLine(
                    '${l10n.receiptFabricColorLabel}: ${order.fabricColorSnapshot.trim()}',
                  ),
                if (order.fabricIdSnapshot.trim().isNotEmpty)
                  bodyLine(
                    '${l10n.receiptFabricIdLabel}: ${order.fabricIdSnapshot.trim()}',
                  ),
              ],
              if (order.catalogDesignNameSnapshot.trim().isNotEmpty) ...[
                sectionTitle(l10n.invoiceCatalogDesignLabel),
                bodyLine(order.catalogDesignNameSnapshot.trim()),
                if (order.catalogDesignerShopNameSnapshot.trim().isNotEmpty)
                  bodyLine(
                    '${l10n.invoiceCatalogDesignerLabel}: ${order.catalogDesignerShopNameSnapshot.trim()}',
                  ),
              ],
              if (order.internalNotes.trim().isNotEmpty) ...[
                sectionTitle(l10n.receiptInternalNotesHeader),
                bodyLine(order.internalNotes.trim()),
              ],
              divider(),
              bodyLine('${l10n.receiptTotalLabel}: $total'),
              bodyLine('${l10n.receiptPaidLabel}: $paid'),
              bodyLine('${l10n.receiptBalanceLabel}: $balance'),
              sectionTitle(l10n.receiptPaymentsHeader),
              for (final row in paymentRows) bodyLine(row),
              pw.Spacer(),
              divider(),
              for (final line in branding.thankYouLines)
                if (line.trim().isNotEmpty)
                  pw.Center(child: bodyLine(line.trim())),
            ],
          ),
        );
      },
    ),
  );

  try {
    return await doc.save();
  } on Object {
    if (forceHelvetica) rethrow;
    return buildOrderInvoicePdf(
      l10n: l10n,
      shop: shop,
      order: order,
      payments: payments,
      deliveryDateText: deliveryDateText,
      statusText: statusText,
      textDirection: textDirection,
      forceHelvetica: true,
    );
  }
}

String? _invoicePhoneLine(String? raw) {
  final phone = raw?.trim();
  if (phone == null || phone.isEmpty) return null;
  return phone;
}
