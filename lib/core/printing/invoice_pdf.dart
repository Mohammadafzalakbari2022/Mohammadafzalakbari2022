import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../data/local/order_measurement_snapshot_view.dart';
import '../../data/local/order_summary.dart';
import '../../data/local/payment_summary.dart';
import '../../features/reports/report_money_format.dart';
import '../../features/settings/shop_profile.dart';
import '../../l10n/app_localizations.dart';
import 'invoice_pdf_font.dart';
import 'invoice_pdf_icons.dart';
import 'invoice_pdf_images.dart';
import 'invoice_pdf_measurements.dart';
import 'invoice_pdf_promo_assets.dart';
import 'receipt_branding.dart';
import 'shop_logo_raster.dart';

/// Brand accent for PDF headers (matches app purple).
final PdfColor kInvoicePdfAccent = PdfColor.fromInt(0xFF5B3FA6);

final PdfColor kInvoicePdfAccentLight = PdfColor.fromInt(0xFFEDE8F5);
final PdfColor kInvoicePdfSurface = PdfColor.fromInt(0xFFF7F5FB);
final PdfColor kInvoicePdfSurfaceAlt = PdfColor.fromInt(0xFFEFECF4);
final PdfColor kInvoicePdfBorder = PdfColors.grey400;

const double kInvoicePdfSectionGap = 10;
const double kInvoicePdfOuterBorderWidth = 1.2;
const double kInvoicePdfSectionRadius = 6;

/// Builds a single-page A4 PDF invoice (RTL when [textDirection] is RTL).
Future<Uint8List> buildOrderInvoicePdf({
  required AppLocalizations l10n,
  required ShopProfile? shop,
  required OrderSummary order,
  required List<PaymentSummary> payments,
  required String deliveryDateText,
  required String statusText,
  required pw.TextDirection textDirection,
  InvoicePdfDesignRail? designRail,
  InvoicePdfPromoAssets? promoAssets,
  OrderMeasurementSnapshotView? measurementSnap,
}) async {
  final fonts = await InvoicePdfFonts.load();
  final branding = ReceiptBranding.fromShop(
    shop: shop,
    l10n: l10n,
    wrapChars: 56,
  );
  final rail = designRail ?? const InvoicePdfDesignRail();
  final promo = promoAssets ?? await loadInvoicePdfPromoAssets();

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

  final measurementsBody = formatInvoiceMeasurementsBody(
    l10n: l10n,
    order: order,
    measurementSnap: measurementSnap,
  );

  final doc = pw.Document(theme: InvoicePdfFonts.themeFor(fonts));

  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.fromLTRB(32, 28, 32, 88),
      textDirection: textDirection,
      footer: (context) => pw.Directionality(
        textDirection: textDirection,
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            _buildThankYouFooter(fonts: fonts, branding: branding),
            _buildPridePromoFooter(
              fonts: fonts,
              l10n: l10n,
              promo: promo,
            ),
          ],
        ),
      ),
      build: (context) {
        return [
          pw.Directionality(
          textDirection: textDirection,
          child: pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(
                color: kInvoicePdfBorder,
                width: kInvoicePdfOuterBorderWidth,
              ),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            padding: const pw.EdgeInsets.all(12),
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
                _buildShopInfoCard(fonts: fonts, l10n: l10n, branding: branding),
                pw.SizedBox(height: 12),
                _buildMetaRow(
                  fonts: fonts,
                  l10n: l10n,
                  order: order,
                  deliveryDateText: deliveryDateText,
                  statusText: statusText,
                ),
                if (measurementsBody != null && measurementsBody.isNotEmpty) ...[
                  pw.SizedBox(height: kInvoicePdfSectionGap),
                  _sectionCard(
                    fonts: fonts,
                    title: l10n.receiptMeasurementsLabel,
                    child: _bodyText(fonts, measurementsBody),
                  ),
                ],
                if (styleText.isNotEmpty) ...[
                  pw.SizedBox(height: kInvoicePdfSectionGap),
                  _sectionCard(
                    fonts: fonts,
                    title: l10n.receiptStyleLabel,
                    child: _bodyText(fonts, styleText),
                  ),
                ],
                if (rail.figureProviders.isNotEmpty) ...[
                  pw.SizedBox(height: 6),
                  _buildStyleFigureImages(fonts: fonts, rail: rail),
                ],
                if (order.hasCustomerFabric) ...[
                  pw.SizedBox(height: kInvoicePdfSectionGap),
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
                if (order.catalogDesignNameSnapshot.trim().isNotEmpty ||
                    rail.catalogProvider != null) ...[
                  pw.SizedBox(height: kInvoicePdfSectionGap),
                  _sectionCard(
                    fonts: fonts,
                    title: l10n.invoiceCatalogDesignLabel,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                      children: [
                        if (rail.catalogProvider != null) ...[
                          pw.Center(
                            child: pw.Container(
                              padding: const pw.EdgeInsets.all(8),
                              decoration: pw.BoxDecoration(
                                color: kInvoicePdfSurface,
                                borderRadius: pw.BorderRadius.circular(4),
                                border: pw.Border.all(
                                  color: kInvoicePdfBorder,
                                  width: 0.5,
                                ),
                              ),
                              child: pw.SizedBox(
                                width: kInvoicePdfCatalogMaxWidthPx.toDouble(),
                                height: kInvoicePdfCatalogMaxHeightPx.toDouble(),
                                child: pw.Image(
                                  rail.catalogProvider!,
                                  fit: pw.BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          pw.SizedBox(height: 8),
                        ],
                        if (order.catalogDesignNameSnapshot.trim().isNotEmpty)
                          _bodyText(
                            fonts,
                            order.catalogDesignNameSnapshot.trim(),
                            bold: true,
                          ),
                        if (order.catalogDesignerShopNameSnapshot
                            .trim()
                            .isNotEmpty) ...[
                          pw.SizedBox(height: 4),
                          _labelValue(
                            fonts,
                            l10n.invoiceCatalogDesignerLabel,
                            order.catalogDesignerShopNameSnapshot.trim(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
                if (order.internalNotes.trim().isNotEmpty) ...[
                  pw.SizedBox(height: kInvoicePdfSectionGap),
                  _sectionCard(
                    fonts: fonts,
                    title: l10n.receiptInternalNotesHeader,
                    child: _bodyText(
                      fonts,
                      order.internalNotes.trim(),
                      maxLines: 5,
                    ),
                  ),
                ],
                pw.SizedBox(height: 12),
                _buildPaymentSummary(
                  fonts: fonts,
                  l10n: l10n,
                  total: total,
                  paid: paid,
                  balance: balance,
                  payments: payments,
                ),
              ],
            ),
          ),
        ),
        ];
      },
    ),
  );

  return doc.save();
}

pw.Widget _buildStyleFigureImages({
  required InvoicePdfFontSet fonts,
  required InvoicePdfDesignRail rail,
}) {
  return pw.Wrap(
    spacing: 6,
    runSpacing: 6,
    children: [
      for (final provider in rail.figureProviders)
        pw.Container(
          width: kInvoicePdfStyleFigurePx.toDouble(),
          height: kInvoicePdfStyleFigurePx.toDouble(),
          padding: const pw.EdgeInsets.all(4),
          decoration: pw.BoxDecoration(
            color: kInvoicePdfSurface,
            borderRadius: pw.BorderRadius.circular(4),
            border: pw.Border.all(color: kInvoicePdfBorder, width: 0.5),
          ),
          child: pw.Image(provider, fit: pw.BoxFit.contain),
        ),
    ],
  );
}

pw.Widget _buildPridePromoFooter({
  required InvoicePdfFontSet fonts,
  required AppLocalizations l10n,
  required InvoicePdfPromoAssets promo,
}) {
  return pw.Container(
    margin: const pw.EdgeInsets.only(top: 6),
    padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: pw.BoxDecoration(
      color: kInvoicePdfAccentLight,
      borderRadius: pw.BorderRadius.circular(kInvoicePdfSectionRadius),
      border: pw.Border.all(color: kInvoicePdfBorder, width: 0.6),
    ),
    child: pw.Column(
      children: [
        pw.Center(
          child: pw.Wrap(
            crossAxisAlignment: pw.WrapCrossAlignment.center,
            alignment: pw.WrapAlignment.center,
            spacing: 8,
            runSpacing: 6,
            children: [
              if (promo.prideIconProvider != null)
                pw.SizedBox(
                  width: 20,
                  height: 20,
                  child: pw.Image(
                    promo.prideIconProvider!,
                    fit: pw.BoxFit.contain,
                  ),
                ),
              pw.Text(
                l10n.invoicePridePromoLine,
                style: pw.TextStyle(
                  font: fonts.regular,
                  fontSize: 8,
                  color: PdfColors.grey800,
                ),
                textAlign: pw.TextAlign.center,
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Center(
          child: pw.Wrap(
            spacing: 10,
            runSpacing: 4,
            alignment: pw.WrapAlignment.center,
            children: [
              _storeBadgeWidget(promo.googlePlayProvider, isGooglePlay: true),
              _storeBadgeWidget(promo.appStoreProvider, isGooglePlay: false),
            ],
          ),
        ),
      ],
    ),
  );
}

pw.Widget _storeBadgeWidget(
  pw.ImageProvider? provider, {
  required bool isGooglePlay,
}) {
  if (provider != null) {
    return pw.SizedBox(
      height: 20,
      child: pw.Image(provider, fit: pw.BoxFit.contain),
    );
  }
  return buildInvoiceStoreBadgeFallback(isGooglePlay: isGooglePlay, size: 20);
}

pw.Widget _buildHeader({
  required InvoicePdfFontSet fonts,
  required ReceiptBranding branding,
  required pw.ImageProvider? logoProvider,
  required AppLocalizations l10n,
  required String orderNo,
}) {
  return pw.Container(
    width: double.infinity,
    padding: const pw.EdgeInsets.symmetric(vertical: 10, horizontal: 12),
    decoration: pw.BoxDecoration(
      color: kInvoicePdfAccent,
      borderRadius: pw.BorderRadius.circular(kInvoicePdfSectionRadius),
      border: pw.Border.all(color: PdfColor.fromInt(0xFF4A3288), width: 0.5),
    ),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        if (logoProvider != null)
          pw.Container(
            width: 52,
            height: 52,
            padding: const pw.EdgeInsets.all(4),
            decoration: pw.BoxDecoration(
              color: PdfColors.white,
              borderRadius: pw.BorderRadius.circular(6),
              border: pw.Border.all(color: PdfColors.white, width: 0.5),
            ),
            child: pw.Image(logoProvider, fit: pw.BoxFit.contain),
          ),
        if (logoProvider != null) pw.SizedBox(width: 12),
        pw.Expanded(
          child: pw.Text(
            branding.shopDisplayName,
            style: pw.TextStyle(
              font: fonts.bold,
              fontSize: 17,
              color: PdfColors.white,
            ),
          ),
        ),
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: pw.BoxDecoration(
            color: PdfColors.white,
            borderRadius: pw.BorderRadius.circular(4),
          ),
          child: pw.Text(
            l10n.ordersNumberPrefix(orderNo),
            style: pw.TextStyle(
              font: fonts.bold,
              fontSize: 11,
              color: kInvoicePdfAccent,
            ),
          ),
        ),
      ],
    ),
  );
}

/// Shop phone + address from Settings → Shop profile.
pw.Widget _buildShopInfoCard({
  required InvoicePdfFontSet fonts,
  required AppLocalizations l10n,
  required ReceiptBranding branding,
}) {
  final phoneRaw = branding.shopPhoneRaw?.trim();
  final hasPhone = phoneRaw != null && phoneRaw.isNotEmpty;
  final hasAddress = branding.addressLines.any((l) => l.trim().isNotEmpty);
  if (!hasPhone && !hasAddress) return pw.SizedBox();

  return pw.Padding(
    padding: const pw.EdgeInsets.only(top: 10),
    child: pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: kInvoicePdfSurface,
        borderRadius: pw.BorderRadius.circular(kInvoicePdfSectionRadius),
        border: pw.Border.all(color: kInvoicePdfBorder, width: 0.8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          if (hasPhone)
            _iconTextRow(
              fonts: fonts,
              icon: InvoicePdfIcons.phone(color: kInvoicePdfAccent),
              label: l10n.receiptShopPhoneLabel,
              value: phoneRaw,
            ),
          if (hasPhone && hasAddress) pw.SizedBox(height: 6),
          if (hasAddress)
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                InvoicePdfIcons.location(color: kInvoicePdfAccent),
                pw.SizedBox(width: 8),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        l10n.receiptShopAddressLabel,
                        style: pw.TextStyle(
                          font: fonts.bold,
                          fontSize: 8.5,
                          color: PdfColors.grey700,
                        ),
                      ),
                      for (final line in branding.addressLines)
                        if (line.trim().isNotEmpty)
                          pw.Padding(
                            padding: const pw.EdgeInsets.only(top: 2),
                            child: pw.Text(
                              line.trim(),
                              style: pw.TextStyle(
                                font: fonts.regular,
                                fontSize: 9.5,
                              ),
                            ),
                          ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
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
                pw.SizedBox(height: 6),
                _iconTextRow(
                  fonts: fonts,
                  icon: InvoicePdfIcons.person(color: kInvoicePdfAccent),
                  label: l10n.receiptPhoneLabel,
                  value: phone,
                ),
              ],
            ],
          ),
        ),
      ),
      pw.SizedBox(width: 10),
      pw.Expanded(
        child: _sectionCard(
          fonts: fonts,
          title: l10n.receiptDeliveryLabel,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _labelValue(fonts, l10n.receiptDeliveryLabel, deliveryDateText),
              pw.SizedBox(height: 6),
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
      border: pw.Border.all(color: kInvoicePdfBorder, width: 0.9),
      borderRadius: pw.BorderRadius.circular(kInvoicePdfSectionRadius),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: pw.BoxDecoration(
            color: kInvoicePdfAccent,
            borderRadius: const pw.BorderRadius.only(
              topLeft: pw.Radius.circular(kInvoicePdfSectionRadius),
              topRight: pw.Radius.circular(kInvoicePdfSectionRadius),
            ),
          ),
          child: pw.Text(
            l10n.receiptPaymentsHeader,
            style: pw.TextStyle(
              font: fonts.bold,
              fontSize: 11,
              color: PdfColors.white,
            ),
          ),
        ),
        pw.Container(
          padding: const pw.EdgeInsets.fromLTRB(10, 10, 10, 10),
          color: kInvoicePdfSurface,
          child: pw.Column(
            children: [
              _moneyRowTile(fonts, l10n.receiptTotalLabel, total),
              pw.SizedBox(height: 6),
              _moneyRowTile(fonts, l10n.receiptPaidLabel, paid),
              pw.SizedBox(height: 6),
              _moneyRowTile(
                fonts,
                l10n.receiptBalanceLabel,
                balance,
                emphasize: true,
              ),
              if (payments.isNotEmpty) ...[
                pw.SizedBox(height: 10),
                pw.Divider(color: kInvoicePdfBorder, height: 0.5),
                pw.SizedBox(height: 8),
                for (var i = 0; i < payments.length; i++) ...[
                  if (i > 0) pw.SizedBox(height: 4),
                  _moneyRowTile(
                    fonts,
                    payments[i].method,
                    reportFormatMoney(l10n, payments[i].amountMinor),
                    altBackground: i.isOdd,
                  ),
                ],
              ],
            ],
          ),
        ),
      ],
    ),
  );
}

pw.Widget _buildThankYouFooter({
  required InvoicePdfFontSet fonts,
  required ReceiptBranding branding,
}) {
  final thanks = branding.thankYouLines.where((l) => l.trim().isNotEmpty);
  if (thanks.isEmpty) return pw.SizedBox();

  return pw.Container(
    margin: const pw.EdgeInsets.only(top: 4),
    padding: const pw.EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: pw.BoxDecoration(
      color: kInvoicePdfSurface,
      borderRadius: pw.BorderRadius.circular(kInvoicePdfSectionRadius),
      border: pw.Border.all(color: kInvoicePdfBorder, width: 0.8),
    ),
    child: pw.Column(
      children: [
        for (final line in thanks)
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 2),
            child: pw.Center(
              child: pw.Text(
                line.trim(),
                style: pw.TextStyle(
                  font: fonts.bold,
                  fontSize: 10.5,
                  color: kInvoicePdfAccent,
                ),
                textAlign: pw.TextAlign.center,
              ),
            ),
          ),
      ],
    ),
  );
}

pw.Widget _sectionCard({
  required InvoicePdfFontSet fonts,
  required String title,
  required pw.Widget child,
}) {
  return pw.Container(
    decoration: pw.BoxDecoration(
      border: pw.Border.all(color: kInvoicePdfBorder, width: 0.8),
      borderRadius: pw.BorderRadius.circular(kInvoicePdfSectionRadius),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: pw.BoxDecoration(
            color: kInvoicePdfAccentLight,
            borderRadius: const pw.BorderRadius.only(
              topLeft: pw.Radius.circular(kInvoicePdfSectionRadius),
              topRight: pw.Radius.circular(kInvoicePdfSectionRadius),
            ),
          ),
          child: pw.Text(
            title,
            style: pw.TextStyle(
              font: fonts.bold,
              fontSize: 10,
              color: kInvoicePdfAccent,
            ),
          ),
        ),
        pw.Divider(color: kInvoicePdfBorder, height: 0.5),
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(10),
          color: PdfColors.white,
          child: child,
        ),
      ],
    ),
  );
}

pw.Widget _iconTextRow({
  required InvoicePdfFontSet fonts,
  required pw.Widget icon,
  required String label,
  required String value,
}) {
  return pw.Row(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      icon,
      pw.SizedBox(width: 8),
      pw.Expanded(
        child: pw.RichText(
          text: pw.TextSpan(
            children: [
              pw.TextSpan(
                text: '$label: ',
                style: pw.TextStyle(
                  font: fonts.regular,
                  fontSize: 8.5,
                  color: PdfColors.grey700,
                ),
              ),
              pw.TextSpan(
                text: value,
                style: pw.TextStyle(font: fonts.regular, fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

pw.Widget _bodyText(
  InvoicePdfFontSet fonts,
  String text, {
  bool bold = false,
  int? maxLines,
}) {
  return pw.Text(
    text,
    style: pw.TextStyle(
      font: bold ? fonts.bold : fonts.regular,
      fontSize: 10,
      lineSpacing: 2,
    ),
    maxLines: maxLines,
  );
}

pw.Widget _labelValue(InvoicePdfFontSet fonts, String label, String value) {
  return pw.Container(
    width: double.infinity,
    padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
    decoration: pw.BoxDecoration(
      color: kInvoicePdfSurfaceAlt,
      borderRadius: pw.BorderRadius.circular(3),
    ),
    child: pw.RichText(
      text: pw.TextSpan(
        children: [
          pw.TextSpan(
            text: '$label: ',
            style: pw.TextStyle(
              font: fonts.regular,
              fontSize: 9,
              color: PdfColors.grey700,
            ),
          ),
          pw.TextSpan(
            text: value,
            style: pw.TextStyle(font: fonts.regular, fontSize: 10),
          ),
        ],
      ),
    ),
  );
}

pw.Widget _moneyRowTile(
  InvoicePdfFontSet fonts,
  String label,
  String amount, {
  bool emphasize = false,
  bool altBackground = false,
}) {
  return pw.Container(
    padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    decoration: pw.BoxDecoration(
      color: emphasize
          ? kInvoicePdfAccentLight
          : (altBackground ? kInvoicePdfSurfaceAlt : PdfColors.white),
      borderRadius: pw.BorderRadius.circular(4),
      border: emphasize
          ? pw.Border.all(color: kInvoicePdfBorder, width: 0.5)
          : null,
    ),
    child: pw.Row(
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
            color: emphasize ? kInvoicePdfAccent : PdfColors.black,
          ),
        ),
      ],
    ),
  );
}

String? _invoicePhoneLine(String? raw) {
  final phone = raw?.trim();
  if (phone == null || phone.isEmpty) return null;
  return phone;
}
