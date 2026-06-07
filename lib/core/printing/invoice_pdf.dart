import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../data/local/order_measurement_snapshot_view.dart';
import '../../data/local/order_style_snapshot_view.dart';
import '../../data/local/order_summary.dart';
import '../../data/local/payment_summary.dart';
import '../../data/local/style/order_shape_format_labels.dart';
import '../../data/local/style/order_shape_selection_formatter.dart';
import '../../data/local/style_figure_summary.dart';
import '../../features/reports/report_money_format.dart';
import '../../features/settings/shop_profile.dart';
import '../../l10n/app_localizations.dart';
import 'invoice_pdf_font.dart';
import 'invoice_pdf_icons.dart';
import 'invoice_pdf_images.dart';
import 'invoice_pdf_measurements.dart';
import 'invoice_payment_labels.dart';
import 'receipt_branding.dart';
import 'shop_logo_raster.dart';

/// Brand accent for PDF headers (matches app purple).
final PdfColor kInvoicePdfAccent = PdfColor.fromInt(0xFF5B3FA6);

final PdfColor kInvoicePdfAccentLight = PdfColor.fromInt(0xFFEDE8F5);
final PdfColor kInvoicePdfSurface = PdfColor.fromInt(0xFFF7F5FB);
final PdfColor kInvoicePdfSurfaceAlt = PdfColor.fromInt(0xFFEFECF4);
final PdfColor kInvoicePdfBorder = PdfColors.grey400;

const double kInvoicePdfSectionGap = 6;
const double kInvoicePdfOuterBorderWidth = 1;
const double kInvoicePdfSectionRadius = 4;

/// Builds an A4 PDF invoice/receipt (RTL when [textDirection] is RTL).
Future<Uint8List> buildOrderInvoicePdf({
  required AppLocalizations l10n,
  required ShopProfile? shop,
  required OrderSummary order,
  required List<PaymentSummary> payments,
  required String deliveryDateText,
  required String statusText,
  required pw.TextDirection textDirection,
  InvoicePdfDesignRail? designRail,
  OrderMeasurementSnapshotView? measurementSnap,
  OrderStyleSnapshotView? styleSnap,
  List<StyleFigureSummary> catalogFigures = const [],
}) async {
  final fonts = await InvoicePdfFonts.load();
  final branding = ReceiptBranding.fromShop(
    shop: shop,
    l10n: l10n,
    wrapChars: 56,
  );
  final rail = designRail ?? const InvoicePdfDesignRail();

  pw.ImageProvider? logoProvider;
  final logoRaster = await loadReceiptHeaderLogoRaster(
    userLogoRelativePath: shop?.logoRelativePath,
    maxWidthPx: 180,
  );
  if (logoRaster != null) {
    final png = Uint8List.fromList(img.encodePng(logoRaster));
    logoProvider = pw.MemoryImage(png);
  }

  final total = reportFormatMoney(l10n, order.totalAmountMinor);
  final paid = reportFormatMoney(l10n, order.paidAmountMinor);
  final balance = reportFormatMoney(l10n, order.remainingAmountMinor);

  final styleDisplay = formatOrderShapeSelectionDisplay(
    snapshot: styleSnap,
    styleName: order.styleName,
    styleSelectionJson: order.styleSelectionJson,
    styleSummary: order.styleSummary,
    catalogFigures: catalogFigures,
    labels: orderShapeFormatLabels(l10n),
  );
  final styleText = styleDisplay.detailedText.trim().isNotEmpty
      ? styleDisplay.detailedText.trim()
      : styleDisplay.summaryFallbackText.trim();

  final measurementsBody = formatInvoiceMeasurementsBody(
    l10n: l10n,
    order: order,
    measurementSnap: measurementSnap,
  );

  final doc = pw.Document(theme: InvoicePdfFonts.themeFor(fonts));

  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.fromLTRB(24, 22, 24, 24),
      textDirection: textDirection,
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
            padding: const pw.EdgeInsets.all(8),
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
                pw.SizedBox(height: 8),
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
                if (_hasDesignSectionContent(
                  order: order,
                  styleDisplay: styleDisplay,
                  rail: rail,
                )) ...[
                  pw.SizedBox(height: kInvoicePdfSectionGap),
                  _buildDesignAndStyleSection(
                    fonts: fonts,
                    l10n: l10n,
                    order: order,
                    styleText: styleText,
                    rail: rail,
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
                pw.SizedBox(height: 8),
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
          pw.Directionality(
            textDirection: textDirection,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: [
                pw.SizedBox(height: 8),
                _buildThankYouFooter(fonts: fonts, branding: branding),
                _buildPridePromoFooter(
                  fonts: fonts,
                  l10n: l10n,
                ),
              ],
            ),
          ),
        ];
      },
    ),
  );

  return doc.save();
}

bool _hasDesignSectionContent({
  required OrderSummary order,
  required OrderShapeSelectionDisplay styleDisplay,
  required InvoicePdfDesignRail rail,
}) {
  return !styleDisplay.isEmpty ||
      order.hasCustomerFabric ||
      order.catalogDesignNameSnapshot.trim().isNotEmpty ||
      order.catalogDesignerShopNameSnapshot.trim().isNotEmpty ||
      rail.catalogProvider != null ||
      rail.figureProviders.isNotEmpty;
}

/// Design/style text in one column; catalog + style shapes in the other (like customer meta row).
pw.Widget _buildDesignAndStyleSection({
  required InvoicePdfFontSet fonts,
  required AppLocalizations l10n,
  required OrderSummary order,
  required String styleText,
  required InvoicePdfDesignRail rail,
}) {
  final hasImages =
      rail.catalogProvider != null || rail.figureProviders.isNotEmpty;

  return _sectionCard(
    fonts: fonts,
    title: l10n.invoiceDesignSectionTitle,
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: _buildDesignInfoColumn(
            fonts: fonts,
            l10n: l10n,
            order: order,
            styleText: styleText,
          ),
        ),
        if (hasImages) ...[
          pw.SizedBox(width: 6),
          pw.Expanded(
            child: _buildDesignImagesColumn(
              fonts: fonts,
              l10n: l10n,
              rail: rail,
            ),
          ),
        ],
      ],
    ),
  );
}

pw.Widget _buildDesignInfoColumn({
  required InvoicePdfFontSet fonts,
  required AppLocalizations l10n,
  required OrderSummary order,
  required String styleText,
}) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      if (styleText.isNotEmpty) ...[
        _subsectionLabel(fonts, l10n.receiptStyleLabel),
        pw.SizedBox(height: 2),
        _bodyText(fonts, styleText),
        pw.SizedBox(height: 6),
      ],
      if (order.hasCustomerFabric) ...[
        _subsectionLabel(fonts, l10n.receiptFabricLabel),
        pw.SizedBox(height: 2),
        if (order.fabricNameSnapshot.trim().isNotEmpty)
          _labelValue(
            fonts,
            l10n.receiptFabricNameLabel,
            order.fabricNameSnapshot.trim(),
          ),
        if (order.fabricColorSnapshot.trim().isNotEmpty) ...[
          pw.SizedBox(height: 2),
          _labelValue(
            fonts,
            l10n.receiptFabricColorLabel,
            order.fabricColorSnapshot.trim(),
          ),
        ],
        if (order.fabricIdSnapshot.trim().isNotEmpty) ...[
          pw.SizedBox(height: 2),
          _labelValue(
            fonts,
            l10n.receiptFabricIdLabel,
            order.fabricIdSnapshot.trim(),
          ),
        ],
        pw.SizedBox(height: 6),
      ],
      if (order.catalogDesignNameSnapshot.trim().isNotEmpty ||
          order.catalogDesignerShopNameSnapshot.trim().isNotEmpty) ...[
        _subsectionLabel(fonts, l10n.invoiceCatalogDesignLabel),
        pw.SizedBox(height: 2),
        if (order.catalogDesignNameSnapshot.trim().isNotEmpty)
          _bodyText(
            fonts,
            order.catalogDesignNameSnapshot.trim(),
            bold: true,
          ),
        if (order.catalogDesignerShopNameSnapshot.trim().isNotEmpty) ...[
          pw.SizedBox(height: 2),
          _labelValue(
            fonts,
            l10n.invoiceCatalogDesignerLabel,
            order.catalogDesignerShopNameSnapshot.trim(),
          ),
        ],
      ],
    ],
  );
}

pw.Widget _buildDesignImagesColumn({
  required InvoicePdfFontSet fonts,
  required AppLocalizations l10n,
  required InvoicePdfDesignRail rail,
}) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.stretch,
    children: [
      if (rail.catalogProvider != null) ...[
        _subsectionLabel(fonts, l10n.invoiceCatalogDesignLabel),
        pw.SizedBox(height: 2),
        pw.Container(
          padding: const pw.EdgeInsets.all(4),
          decoration: pw.BoxDecoration(
            color: kInvoicePdfSurface,
            borderRadius: pw.BorderRadius.circular(4),
            border: pw.Border.all(color: kInvoicePdfBorder, width: 0.5),
          ),
          child: pw.SizedBox(
            height: kInvoicePdfCatalogDisplayHeightPt,
            width: double.infinity,
            child: pw.Image(
              rail.catalogProvider!,
              fit: pw.BoxFit.contain,
            ),
          ),
        ),
        pw.SizedBox(height: 6),
      ],
      if (rail.figureProviders.isNotEmpty) ...[
        _subsectionLabel(fonts, l10n.invoiceStyleFiguresLabel),
        pw.SizedBox(height: 2),
        _buildStyleFigureGrid(rail: rail),
      ],
    ],
  );
}

pw.Widget _subsectionLabel(InvoicePdfFontSet fonts, String text) {
  return pw.Text(
    text,
    style: pw.TextStyle(
      font: fonts.bold,
      fontSize: 8.5,
      color: kInvoicePdfAccent,
    ),
  );
}

pw.Widget _buildStyleFigureGrid({required InvoicePdfDesignRail rail}) {
  return pw.Wrap(
    spacing: 4,
    runSpacing: 4,
    children: [
      for (final provider in rail.figureProviders)
        pw.Container(
          width: kInvoicePdfStyleFigureDisplayPt,
          height: kInvoicePdfStyleFigureDisplayPt,
          padding: const pw.EdgeInsets.all(2),
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
}) {
  return pw.Padding(
    padding: const pw.EdgeInsets.only(top: 6),
    child: pw.Text(
      l10n.invoicePridePromoLine,
      style: pw.TextStyle(
        font: fonts.regular,
        fontSize: 8.5,
        color: PdfColors.grey700,
      ),
      textAlign: pw.TextAlign.center,
    ),
  );
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
    padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 8),
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
            width: 40,
            height: 40,
            padding: const pw.EdgeInsets.all(3),
            decoration: pw.BoxDecoration(
              color: PdfColors.white,
              borderRadius: pw.BorderRadius.circular(4),
              border: pw.Border.all(color: PdfColors.white, width: 0.5),
            ),
            child: pw.Image(logoProvider, fit: pw.BoxFit.contain),
          ),
        if (logoProvider != null) pw.SizedBox(width: 8),
        pw.Expanded(
          child: pw.Text(
            branding.shopDisplayName,
            style: pw.TextStyle(
              font: fonts.bold,
              fontSize: 14,
              color: PdfColors.white,
            ),
          ),
        ),
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: pw.BoxDecoration(
            color: PdfColors.white,
            borderRadius: pw.BorderRadius.circular(4),
          ),
          child: pw.Text(
            l10n.ordersNumberPrefix(orderNo),
            style: pw.TextStyle(
              font: fonts.bold,
              fontSize: 10,
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
    padding: const pw.EdgeInsets.only(top: 6),
    child: pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(6),
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
          if (hasPhone && hasAddress) pw.SizedBox(height: 4),
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
                          fontSize: 8,
                          color: PdfColors.grey700,
                        ),
                      ),
                      for (final line in branding.addressLines)
                        if (line.trim().isNotEmpty)
                          pw.Padding(
                            padding: const pw.EdgeInsets.only(top: 1),
                            child: pw.Text(
                              line.trim(),
                              style: pw.TextStyle(
                                font: fonts.regular,
                                fontSize: 9,
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
                pw.SizedBox(height: 4),
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
      pw.SizedBox(width: 6),
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
      border: pw.Border.all(color: kInvoicePdfBorder, width: 0.9),
      borderRadius: pw.BorderRadius.circular(kInvoicePdfSectionRadius),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 5),
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
              fontSize: 10,
              color: PdfColors.white,
            ),
          ),
        ),
        pw.Container(
          padding: const pw.EdgeInsets.fromLTRB(6, 6, 6, 6),
          color: kInvoicePdfSurface,
          child: pw.Column(
            children: [
              _moneyRowTile(fonts, l10n.receiptTotalLabel, total),
              pw.SizedBox(height: 4),
              _moneyRowTile(fonts, l10n.receiptPaidLabel, paid),
              pw.SizedBox(height: 4),
              _moneyRowTile(
                fonts,
                l10n.receiptBalanceLabel,
                balance,
                emphasize: true,
              ),
              if (payments.isNotEmpty) ...[
                pw.SizedBox(height: 6),
                pw.Divider(color: kInvoicePdfBorder, height: 0.5),
                pw.SizedBox(height: 4),
                for (var i = 0; i < payments.length; i++) ...[
                  if (i > 0) pw.SizedBox(height: 2),
                  _moneyRowTile(
                    fonts,
                    formatInvoicePaymentMethod(l10n, payments[i].method),
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
    margin: const pw.EdgeInsets.only(top: 2),
    padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: pw.BoxDecoration(
      color: kInvoicePdfSurface,
      borderRadius: pw.BorderRadius.circular(kInvoicePdfSectionRadius),
      border: pw.Border.all(color: kInvoicePdfBorder, width: 0.6),
    ),
    child: pw.Column(
      children: [
        for (final line in thanks)
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 1),
            child: pw.Center(
              child: pw.Text(
                line.trim(),
                style: pw.TextStyle(
                  font: fonts.bold,
                  fontSize: 9.5,
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
          padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
              fontSize: 9,
              color: kInvoicePdfAccent,
            ),
          ),
        ),
        pw.Divider(color: kInvoicePdfBorder, height: 0.5),
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(6),
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
      pw.SizedBox(width: 6),
      pw.Expanded(
        child: pw.RichText(
          text: pw.TextSpan(
            children: [
              pw.TextSpan(
                text: '$label: ',
                style: pw.TextStyle(
                  font: fonts.regular,
                  fontSize: 8,
                  color: PdfColors.grey700,
                ),
              ),
              pw.TextSpan(
                text: value,
                style: pw.TextStyle(font: fonts.regular, fontSize: 9.5),
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
      fontSize: 9.5,
      lineSpacing: 1,
    ),
    maxLines: maxLines,
  );
}

pw.Widget _labelValue(InvoicePdfFontSet fonts, String label, String value) {
  return pw.Container(
    width: double.infinity,
    padding: const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 3),
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
              fontSize: 8.5,
              color: PdfColors.grey700,
            ),
          ),
          pw.TextSpan(
            text: value,
            style: pw.TextStyle(font: fonts.regular, fontSize: 9.5),
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
    padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
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
            fontSize: emphasize ? 10 : 9.5,
          ),
        ),
        pw.Text(
          amount,
          style: pw.TextStyle(
            font: emphasize ? fonts.bold : fonts.regular,
            fontSize: emphasize ? 11 : 9.5,
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
