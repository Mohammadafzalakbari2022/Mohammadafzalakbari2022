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

/// Brand accent for PDF headers (matches app purple).
final PdfColor _kInvoiceAccent = PdfColor.fromInt(0xFF5B3FA6);

final PdfColor _kInvoiceSurface = PdfColor.fromInt(0xFFF7F5FB);
final PdfColor _kInvoiceBorder = PdfColors.grey400;

/// Builds a single-page A4 PDF invoice (RTL when [textDirection] is RTL).
Future<Uint8List> buildOrderInvoicePdf({
  required AppLocalizations l10n,
  required ShopProfile? shop,
  required OrderSummary order,
  required List<PaymentSummary> payments,
  required String deliveryDateText,
  required String statusText,
  required pw.TextDirection textDirection,
}) async {
  final fonts = await InvoicePdfFonts.load();
  final branding = ReceiptBranding.fromShop(
    shop: shop,
    l10n: l10n,
    wrapChars: 56,
  );

  pw.ImageProvider? logoProvider;
  final logoRaster = await loadReceiptHeaderLogoRaster(
    userLogoRelativePath: shop?.logoRelativePath,
    maxWidthPx: 240,
  );
  if (logoRaster != null) {
    final png = Uint8List.fromList(img.encodePng(logoRaster));
    logoProvider = pw.MemoryImage(png);
  }

  final total = reportFormatMoney(l10n, order.totalAmountMinor);
  final paid = reportFormatMoney(l10n, order.paidAmountMinor);
  final balance = reportFormatMoney(l10n, order.remainingAmountMinor);

  final styleText = order.styleSummary.trim().isNotEmpty
      ? order.styleSummary.trim()
      : order.styleName.trim();

  final doc = pw.Document(theme: InvoicePdfFonts.themeFor(fonts));

  doc.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.symmetric(horizontal: 40, vertical: 36),
      build: (context) {
        return pw.Directionality(
          textDirection: textDirection,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              _buildHeader(
                fonts: fonts,
                branding: branding,
                logoProvider: logoProvider,
                l10n: l10n,
                orderNo: order.displayOrderNo,
              ),
              pw.SizedBox(height: 16),
              _buildMetaRow(
                fonts: fonts,
                l10n: l10n,
                order: order,
                deliveryDateText: deliveryDateText,
                statusText: statusText,
              ),
              if (order.measurementsSnapshot.trim().isNotEmpty) ...[
                pw.SizedBox(height: 12),
                _sectionCard(
                  fonts: fonts,
                  title: l10n.receiptMeasurementsLabel,
                  child: _bodyText(fonts, order.measurementsSnapshot.trim()),
                ),
              ],
              if (styleText.isNotEmpty) ...[
                pw.SizedBox(height: 12),
                _sectionCard(
                  fonts: fonts,
                  title: l10n.receiptStyleLabel,
                  child: _bodyText(fonts, styleText),
                ),
              ],
              if (order.hasCustomerFabric) ...[
                pw.SizedBox(height: 12),
                _sectionCard(
                  fonts: fonts,
                  title: l10n.receiptFabricLabel,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      if (order.fabricNameSnapshot.trim().isNotEmpty)
                        _labelValue(
                          fonts,
                          l10n.receiptFabricNameLabel,
                          order.fabricNameSnapshot.trim(),
                        ),
                      if (order.fabricColorSnapshot.trim().isNotEmpty)
                        _labelValue(
                          fonts,
                          l10n.receiptFabricColorLabel,
                          order.fabricColorSnapshot.trim(),
                        ),
                      if (order.fabricIdSnapshot.trim().isNotEmpty)
                        _labelValue(
                          fonts,
                          l10n.receiptFabricIdLabel,
                          order.fabricIdSnapshot.trim(),
                        ),
                    ],
                  ),
                ),
              ],
              if (order.catalogDesignNameSnapshot.trim().isNotEmpty) ...[
                pw.SizedBox(height: 12),
                _sectionCard(
                  fonts: fonts,
                  title: l10n.invoiceCatalogDesignLabel,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _bodyText(fonts, order.catalogDesignNameSnapshot.trim()),
                      if (order.catalogDesignerShopNameSnapshot.trim().isNotEmpty)
                        pw.SizedBox(height: 4),
                      if (order.catalogDesignerShopNameSnapshot.trim().isNotEmpty)
                        _labelValue(
                          fonts,
                          l10n.invoiceCatalogDesignerLabel,
                          order.catalogDesignerShopNameSnapshot.trim(),
                        ),
                    ],
                  ),
                ),
              ],
              if (order.internalNotes.trim().isNotEmpty) ...[
                pw.SizedBox(height: 12),
                _sectionCard(
                  fonts: fonts,
                  title: l10n.receiptInternalNotesHeader,
                  child: _bodyText(fonts, order.internalNotes.trim()),
                ),
              ],
              pw.SizedBox(height: 16),
              _buildPaymentSummary(
                fonts: fonts,
                l10n: l10n,
                total: total,
                paid: paid,
                balance: balance,
                payments: payments,
              ),
              pw.Spacer(),
              _buildFooter(fonts: fonts, branding: branding),
            ],
          ),
        );
      },
    ),
  );

  return doc.save();
}

pw.Widget _buildHeader({
  required InvoicePdfFontSet fonts,
  required ReceiptBranding branding,
  required pw.ImageProvider? logoProvider,
  required AppLocalizations l10n,
  required String orderNo,
}) {
  return pw.Container(
    decoration: pw.BoxDecoration(
      border: pw.Border.all(color: _kInvoiceBorder, width: 0.5),
      borderRadius: pw.BorderRadius.circular(6),
    ),
    child: pw.Column(
      children: [
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: pw.BoxDecoration(
            color: _kInvoiceAccent,
            borderRadius: const pw.BorderRadius.only(
              topLeft: pw.Radius.circular(5),
              topRight: pw.Radius.circular(5),
            ),
          ),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              if (logoProvider != null)
                pw.Container(
                  width: 48,
                  height: 48,
                  padding: const pw.EdgeInsets.all(4),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.white,
                    borderRadius: pw.BorderRadius.circular(6),
                  ),
                  child: pw.Image(logoProvider, fit: pw.BoxFit.contain),
                ),
              if (logoProvider != null) pw.SizedBox(width: 12),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      branding.shopDisplayName,
                      style: pw.TextStyle(
                        font: fonts.bold,
                        fontSize: 16,
                        color: PdfColors.white,
                      ),
                    ),
                    if (branding.shopPhoneLine != null) ...[
                      pw.SizedBox(height: 2),
                      pw.Text(
                        branding.shopPhoneLine!,
                        style: pw.TextStyle(
                          font: fonts.regular,
                          fontSize: 9,
                          color: PdfColor.fromInt(0xFFE8E0F5),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              pw.Container(
                padding:
                    const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: pw.Text(
                  l10n.ordersNumberPrefix(orderNo),
                  style: pw.TextStyle(
                    font: fonts.bold,
                    fontSize: 11,
                    color: _kInvoiceAccent,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (branding.addressLines.any((l) => l.trim().isNotEmpty))
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: _kInvoiceSurface,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                for (final line in branding.addressLines)
                  if (line.trim().isNotEmpty)
                    pw.Text(
                      line.trim(),
                      style: pw.TextStyle(font: fonts.regular, fontSize: 9),
                    ),
              ],
            ),
          ),
      ],
    ),
  );
}

pw.Widget _buildMetaRow({
  required InvoicePdfFontSet fonts,
  required AppLocalizations l10n,
  required OrderSummary order,
  required String deliveryDateText,
  required String statusText,
}) {
  return pw.Row(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Expanded(
        child: _sectionCard(
          fonts: fonts,
          title: l10n.receiptCustomerLabel,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _bodyText(fonts, order.customerName, bold: true),
              if (_invoicePhoneLine(order.customerPhone) case final phone?) ...[
                pw.SizedBox(height: 4),
                _labelValue(fonts, l10n.receiptPhoneLabel, phone),
              ],
            ],
          ),
        ),
      ),
      pw.SizedBox(width: 12),
      pw.Expanded(
        child: _sectionCard(
          fonts: fonts,
          title: l10n.receiptDeliveryLabel,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _labelValue(fonts, l10n.receiptDeliveryLabel, deliveryDateText),
              pw.SizedBox(height: 4),
              _labelValue(fonts, l10n.receiptStatusLabel, statusText),
            ],
          ),
        ),
      ),
    ],
  );
}

pw.Widget _buildPaymentSummary({
  required InvoicePdfFontSet fonts,
  required AppLocalizations l10n,
  required String total,
  required String paid,
  required String balance,
  required List<PaymentSummary> payments,
}) {
  return pw.Container(
    decoration: pw.BoxDecoration(
      border: pw.Border.all(color: _kInvoiceBorder, width: 0.5),
      borderRadius: pw.BorderRadius.circular(6),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: pw.BoxDecoration(
            color: _kInvoiceSurface,
            borderRadius: const pw.BorderRadius.only(
              topLeft: pw.Radius.circular(5),
              topRight: pw.Radius.circular(5),
            ),
          ),
          child: pw.Text(
            l10n.receiptPaymentsHeader,
            style: pw.TextStyle(font: fonts.bold, fontSize: 11),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: pw.Column(
            children: [
              _moneyRow(fonts, l10n.receiptTotalLabel, total),
              pw.SizedBox(height: 6),
              _moneyRow(fonts, l10n.receiptPaidLabel, paid),
              pw.SizedBox(height: 6),
              _moneyRow(fonts, l10n.receiptBalanceLabel, balance, emphasize: true),
              if (payments.isNotEmpty) ...[
                pw.SizedBox(height: 10),
                pw.Divider(color: _kInvoiceBorder, height: 1),
                pw.SizedBox(height: 8),
                for (final p in payments)
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 4),
                    child: _moneyRow(
                      fonts,
                      p.method,
                      reportFormatMoney(l10n, p.amountMinor),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ],
    ),
  );
}

pw.Widget _buildFooter({
  required InvoicePdfFontSet fonts,
  required ReceiptBranding branding,
}) {
  final thanks = branding.thankYouLines.where((l) => l.trim().isNotEmpty);
  if (thanks.isEmpty) return pw.SizedBox();

  return pw.Column(
    children: [
      pw.Divider(color: _kInvoiceBorder, height: 1),
      pw.SizedBox(height: 10),
      for (final line in thanks)
        pw.Center(
          child: pw.Text(
            line.trim(),
            style: pw.TextStyle(
              font: fonts.regular,
              fontSize: 10,
              color: PdfColors.grey700,
            ),
            textAlign: pw.TextAlign.center,
          ),
        ),
    ],
  );
}

pw.Widget _sectionCard({
  required InvoicePdfFontSet fonts,
  required String title,
  required pw.Widget child,
}) {
  return pw.Container(
    width: double.infinity,
    padding: const pw.EdgeInsets.all(12),
    decoration: pw.BoxDecoration(
      color: _kInvoiceSurface,
      border: pw.Border.all(color: _kInvoiceBorder, width: 0.5),
      borderRadius: pw.BorderRadius.circular(6),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(font: fonts.bold, fontSize: 10, color: _kInvoiceAccent),
        ),
        pw.SizedBox(height: 6),
        child,
      ],
    ),
  );
}

pw.Widget _bodyText(InvoicePdfFontSet fonts, String text, {bool bold = false}) {
  return pw.Text(
    text,
    style: pw.TextStyle(
      font: bold ? fonts.bold : fonts.regular,
      fontSize: 10,
      lineSpacing: 2,
    ),
  );
}

pw.Widget _labelValue(InvoicePdfFontSet fonts, String label, String value) {
  return pw.RichText(
    text: pw.TextSpan(
      children: [
        pw.TextSpan(
          text: '$label: ',
          style: pw.TextStyle(font: fonts.regular, fontSize: 9, color: PdfColors.grey700),
        ),
        pw.TextSpan(
          text: value,
          style: pw.TextStyle(font: fonts.regular, fontSize: 10),
        ),
      ],
    ),
  );
}

pw.Widget _moneyRow(
  InvoicePdfFontSet fonts,
  String label,
  String amount, {
  bool emphasize = false,
}) {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    children: [
      pw.Text(
        label,
        style: pw.TextStyle(
          font: emphasize ? fonts.bold : fonts.regular,
          fontSize: emphasize ? 11 : 10,
        ),
      ),
      pw.Text(
        amount,
        style: pw.TextStyle(
          font: emphasize ? fonts.bold : fonts.regular,
          fontSize: emphasize ? 12 : 10,
          color: emphasize ? _kInvoiceAccent : PdfColors.black,
        ),
      ),
    ],
  );
}

String? _invoicePhoneLine(String? raw) {
  final phone = raw?.trim();
  if (phone == null || phone.isEmpty) return null;
  return phone;
}
