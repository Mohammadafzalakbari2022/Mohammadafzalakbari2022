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
import 'package:pride_v3/core/formatting/display_order_no_format.dart';
import 'invoice_pdf_default_banner.dart';
import 'invoice_pdf_font.dart';
import 'invoice_pdf_icons.dart';
import 'invoice_pdf_images.dart';
import 'invoice_pdf_measurements.dart';
import 'invoice_payment_labels.dart';
import 'pdf_bidi_text.dart';
import 'receipt_branding.dart';
import 'shop_logo_raster.dart';

/// Brand accent for PDF headers (matches app purple).
final PdfColor kInvoicePdfAccent = PdfColor.fromInt(0xFF5B3FA6);

final PdfColor kInvoicePdfAccentLight = PdfColor.fromInt(0xFFEDE8F5);
final PdfColor kInvoicePdfSurface = PdfColor.fromInt(0xFFF7F5FB);
final PdfColor kInvoicePdfSurfaceAlt = PdfColor.fromInt(0xFFEFECF4);
final PdfColor kInvoicePdfBorder = PdfColors.grey400;

const double kInvoicePdfSectionGap = 4;
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
  String? createdDateText,
  String Function(DateTime dateTime)? formatPaymentDate,
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
  final displayOrderNo = formatDisplayOrderNo(order.displayOrderNo);
  final takenDate = (createdDateText ?? '').trim().isNotEmpty
      ? createdDateText!.trim()
      : _fallbackDateText(order.createdAt);

  pw.ImageProvider? logoProvider;
  final logoRaster = await loadReceiptHeaderLogoRaster(
    userLogoRelativePath: shop?.logoRelativePath,
    maxWidthPx: 180,
  );
  if (logoRaster != null) {
    logoProvider = pw.MemoryImage(
      Uint8List.fromList(img.encodePng(logoRaster)),
    );
  }

  pw.ImageProvider? bannerProvider;
  final bannerRaster = await loadShopBannerRasterIfPresent(
    relativePath: shop?.bannerRelativePath,
    maxWidthPx: 480,
  );
  if (bannerRaster != null) {
    bannerProvider = pw.MemoryImage(
      Uint8List.fromList(img.encodePng(bannerRaster)),
    );
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

  final measurementRows = invoiceMeasurementRows(
    l10n: l10n,
    order: order,
    measurementSnap: measurementSnap,
  );

  final doc = pw.Document(theme: InvoicePdfFonts.themeFor(fonts));

  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.fromLTRB(20, 12, 20, 14),
      textDirection: textDirection,
      header: (context) => pw.Directionality(
        textDirection: textDirection,
        child: _buildContinuationHeader(
          pageNumber: context.pageNumber,
          fonts: fonts,
          l10n: l10n,
          orderNo: displayOrderNo,
          branding: branding,
          textDirection: textDirection,
        ),
      ),
      build: (context) {
        final bodySections = <pw.Widget>[
          _buildCustomerSection(
            fonts: fonts,
            l10n: l10n,
            order: order,
            textDirection: textDirection,
          ),
          if (measurementRows.isNotEmpty)
            _buildMeasurementsSection(
              fonts: fonts,
              l10n: l10n,
              rows: measurementRows,
              profileLabel: order.sourceMeasurementProfileLabel.trim(),
              textDirection: textDirection,
            ),
          if (_hasStyleTextContent(order: order, styleDisplay: styleDisplay))
            _buildStyleSection(
              fonts: fonts,
              l10n: l10n,
              order: order,
              styleText: styleText,
              textDirection: textDirection,
            ),
          if (order.hasCustomerFabric)
            _buildFabricSection(
              fonts: fonts,
              l10n: l10n,
              order: order,
              textDirection: textDirection,
            ),
          if (_hasCatalogTextContent(order: order))
            _buildCatalogTextSection(
              fonts: fonts,
              l10n: l10n,
              order: order,
              textDirection: textDirection,
            ),
          if (order.internalNotes.trim().isNotEmpty)
            _sectionCard(
              fonts: fonts,
              title: l10n.receiptInternalNotesHeader,
              child: _bodyText(
                fonts,
                order.internalNotes.trim(),
                textDirection: textDirection,
                maxLines: 6,
              ),
            ),
          _buildPaymentSummary(
            fonts: fonts,
            l10n: l10n,
            total: total,
            paid: paid,
            balance: balance,
            payments: payments,
            formatPaymentDate: formatPaymentDate,
            textDirection: textDirection,
          ),
        ];

        return [
          pw.Directionality(
            textDirection: textDirection,
            child: _buildPdfHeader(
              uploadedBannerProvider: bannerProvider,
              fonts: fonts,
              branding: branding,
              logoProvider: logoProvider,
              l10n: l10n,
              orderNo: displayOrderNo,
              statusText: statusText,
              takenDateText: takenDate,
              deliveryDateText: deliveryDateText,
              textDirection: textDirection,
            ),
          ),
          pw.SizedBox(height: kInvoicePdfSectionGap),
          _buildTwoColumnSections(bodySections),
          if (rail.catalogProvider != null || rail.figureProviders.isNotEmpty) ...[
            pw.SizedBox(height: kInvoicePdfSectionGap),
            _buildDesignImagesSection(
              fonts: fonts,
              l10n: l10n,
              rail: rail,
              textDirection: textDirection,
            ),
          ],
          pw.SizedBox(height: kInvoicePdfSectionGap),
          _buildThankYouFooter(
            fonts: fonts,
            branding: branding,
            textDirection: textDirection,
          ),
          _buildPridePromoFooter(
            fonts: fonts,
            l10n: l10n,
            textDirection: textDirection,
          ),
        ];
      },
    ),
  );

  return doc.save();
}

String _fallbackDateText(DateTime dt) {
  final y = dt.year.toString().padLeft(4, '0');
  final m = dt.month.toString().padLeft(2, '0');
  final d = dt.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

String _fallbackPaymentDateText(DateTime dt) => _fallbackDateText(dt);

bool _hasStyleTextContent({
  required OrderSummary order,
  required OrderShapeSelectionDisplay styleDisplay,
}) {
  return order.styleName.trim().isNotEmpty ||
      order.styleSummary.trim().isNotEmpty ||
      !styleDisplay.isEmpty;
}

bool _hasCatalogTextContent({required OrderSummary order}) {
  return order.catalogDesignNameSnapshot.trim().isNotEmpty ||
      order.catalogDesignerShopNameSnapshot.trim().isNotEmpty;
}

pw.Widget _buildPdfHeader({
  required pw.ImageProvider? uploadedBannerProvider,
  required InvoicePdfFontSet fonts,
  required ReceiptBranding branding,
  required pw.ImageProvider? logoProvider,
  required AppLocalizations l10n,
  required String orderNo,
  required String statusText,
  required String takenDateText,
  required String deliveryDateText,
  required pw.TextDirection textDirection,
}) {
  final phoneRaw = branding.shopPhoneRaw?.trim();
  final hasPhone = phoneRaw != null && phoneRaw.isNotEmpty;
  final hasAddress = branding.addressLines.any((l) => l.trim().isNotEmpty);
  final hasUploadedBanner = uploadedBannerProvider != null;
  final showShopNameInInfo = hasUploadedBanner;

  return pw.Container(
    decoration: pw.BoxDecoration(
      color: kInvoicePdfSurface,
      borderRadius: pw.BorderRadius.circular(kInvoicePdfSectionRadius),
      border: pw.Border.all(color: kInvoicePdfBorder, width: 0.6),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        buildPdfShopBannerSection(
          uploadedBannerProvider: uploadedBannerProvider,
          fonts: fonts,
          branding: branding,
          logoProvider: logoProvider,
          textDirection: textDirection,
          compactBottomGap: true,
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.fromLTRB(6, 0, 6, 6),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    if (showShopNameInInfo)
                      pdfMixedTextWidget(
                        text: branding.shopDisplayName,
                        style: pw.TextStyle(
                          font: fonts.bold,
                          fontSize: 10.5,
                          color: kInvoicePdfAccent,
                        ),
                        documentDirection:
                            pdfValueShouldRenderLtr(branding.shopDisplayName)
                                ? pw.TextDirection.ltr
                                : textDirection,
                        maxLines: 2,
                      ),
                    if (showShopNameInInfo && (hasPhone || hasAddress))
                      pw.SizedBox(height: 3),
                    if (hasPhone)
                      pdfMixedIconTextRow(
                        fonts: fonts,
                        icon: InvoicePdfIcons.phone(color: kInvoicePdfAccent),
                        label: l10n.receiptShopPhoneLabel,
                        value: phoneRaw,
                        documentDirection: textDirection,
                      ),
                    if (hasPhone && hasAddress) pw.SizedBox(height: 2),
                    if (hasAddress)
                      for (final line in branding.addressLines)
                        if (line.trim().isNotEmpty)
                          pdfMixedTextWidget(
                            text: line.trim(),
                            style:
                                pw.TextStyle(font: fonts.regular, fontSize: 8),
                            documentDirection:
                                pdfValueShouldRenderLtr(line.trim())
                                    ? pw.TextDirection.ltr
                                    : textDirection,
                          ),
                  ],
                ),
              ),
              pw.SizedBox(width: 8),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pdfMixedTextWidget(
                      text: l10n.ordersNumberPrefix(orderNo),
                      style: pw.TextStyle(
                        font: fonts.bold,
                        fontSize: 10,
                        color: kInvoicePdfAccent,
                      ),
                      documentDirection: pw.TextDirection.ltr,
                    ),
                    pw.SizedBox(height: 3),
                    _metaChip(fonts, statusText, textDirection: textDirection),
                    pw.SizedBox(height: 2),
                    _metaChip(
                      fonts,
                      '${l10n.invoiceTakenDateLabel}: $takenDateText',
                      textDirection: textDirection,
                    ),
                    pw.SizedBox(height: 2),
                    _metaChip(
                      fonts,
                      '${l10n.receiptDeliveryLabel}: $deliveryDateText',
                      textDirection: textDirection,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

pw.Widget _buildTwoColumnSections(List<pw.Widget> sections) {
  if (sections.isEmpty) return pw.SizedBox();
  if (sections.length == 1) return sections.first;

  final splitAt = (sections.length / 2).ceil();
  final left = sections.sublist(0, splitAt);
  final right = sections.sublist(splitAt);

  pw.Widget column(List<pw.Widget> items) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) pw.SizedBox(height: kInvoicePdfSectionGap),
          items[i],
        ],
      ],
    );
  }

  return pw.Row(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Expanded(child: column(left)),
      pw.SizedBox(width: 6),
      pw.Expanded(child: column(right)),
    ],
  );
}

pw.Widget _buildContinuationHeader({
  required int pageNumber,
  required InvoicePdfFontSet fonts,
  required AppLocalizations l10n,
  required String orderNo,
  required ReceiptBranding branding,
  required pw.TextDirection textDirection,
}) {
  if (pageNumber <= 1) return pw.SizedBox();

  return pw.Container(
    margin: const pw.EdgeInsets.only(bottom: 6),
    padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 5),
    decoration: pw.BoxDecoration(
      color: kInvoicePdfAccentLight,
      borderRadius: pw.BorderRadius.circular(kInvoicePdfSectionRadius),
      border: pw.Border.all(color: kInvoicePdfBorder, width: 0.6),
    ),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Expanded(
          child: pdfMixedTextWidget(
            text: '${l10n.invoiceContinuedLabel} — ${branding.shopDisplayName}',
            style: pw.TextStyle(
              font: fonts.bold,
              fontSize: 9,
              color: kInvoicePdfAccent,
            ),
            documentDirection: textDirection,
            maxLines: 1,
          ),
        ),
        pw.SizedBox(width: 6),
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: pw.BoxDecoration(
            color: PdfColors.white,
            borderRadius: pw.BorderRadius.circular(3),
            border: pw.Border.all(color: kInvoicePdfBorder, width: 0.5),
          ),
          child: pdfMixedTextWidget(
            text: l10n.ordersNumberPrefix(orderNo),
            style: pw.TextStyle(font: fonts.bold, fontSize: 8.5),
            documentDirection: pw.TextDirection.ltr,
          ),
        ),
      ],
    ),
  );
}

pw.Widget _metaChip(
  InvoicePdfFontSet fonts,
  String text, {
  bool emphasize = false,
  required pw.TextDirection textDirection,
}) {
  return pw.Container(
    padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 3),
    decoration: pw.BoxDecoration(
      color: emphasize ? kInvoicePdfAccentLight : kInvoicePdfSurface,
      borderRadius: pw.BorderRadius.circular(3),
      border: pw.Border.all(
        color: emphasize ? kInvoicePdfAccent : kInvoicePdfBorder,
        width: 0.5,
      ),
    ),
    child: pdfMixedTextWidget(
      text: text,
      style: pw.TextStyle(
        font: emphasize ? fonts.bold : fonts.regular,
        fontSize: 8.5,
        color: emphasize ? kInvoicePdfAccent : PdfColors.black,
      ),
      documentDirection: textDirection,
    ),
  );
}

pw.Widget _buildCustomerSection({
  required InvoicePdfFontSet fonts,
  required AppLocalizations l10n,
  required OrderSummary order,
  required pw.TextDirection textDirection,
}) {
  return _sectionCard(
    fonts: fonts,
    title: l10n.receiptCustomerLabel,
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _bodyText(
          fonts,
          order.customerName,
          textDirection: textDirection,
          bold: true,
        ),
        if (_invoicePhoneLine(order.customerPhone) case final phone?) ...[
          pw.SizedBox(height: 3),
          pdfMixedIconTextRow(
            fonts: fonts,
            icon: InvoicePdfIcons.person(color: kInvoicePdfAccent),
            label: l10n.receiptPhoneLabel,
            value: phone,
            documentDirection: textDirection,
          ),
        ],
      ],
    ),
  );
}

pw.Widget _buildMeasurementsSection({
  required InvoicePdfFontSet fonts,
  required AppLocalizations l10n,
  required List<InvoiceMeasurementRow> rows,
  required String profileLabel,
  required pw.TextDirection textDirection,
}) {
  return _sectionCard(
    fonts: fonts,
    title: l10n.receiptMeasurementsLabel,
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        if (profileLabel.isNotEmpty) ...[
          _labelValue(
            fonts,
            l10n.invoiceMeasurementProfileLabel,
            profileLabel,
            textDirection: textDirection,
          ),
          pw.SizedBox(height: 4),
        ],
        pw.Wrap(
          spacing: 3,
          runSpacing: 3,
          children: [
            for (final row in rows)
              pw.SizedBox(
                width: 248,
                child: _labelValue(
                  fonts,
                  row.label,
                  row.value,
                  textDirection: textDirection,
                ),
              ),
          ],
        ),
      ],
    ),
  );
}

pw.Widget _buildStyleSection({
  required InvoicePdfFontSet fonts,
  required AppLocalizations l10n,
  required OrderSummary order,
  required String styleText,
  required pw.TextDirection textDirection,
}) {
  return _sectionCard(
    fonts: fonts,
    title: l10n.invoiceDesignSectionTitle,
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        if (order.styleName.trim().isNotEmpty) ...[
          _labelValue(
            fonts,
            l10n.invoiceStyleNameLabel,
            order.styleName.trim(),
            textDirection: textDirection,
          ),
          pw.SizedBox(height: 3),
        ],
        if (styleText.isNotEmpty) ...[
          _subsectionLabel(fonts, l10n.receiptStyleLabel, textDirection),
          pw.SizedBox(height: 2),
          _bodyText(fonts, styleText, textDirection: textDirection),
        ],
      ],
    ),
  );
}

pw.Widget _buildFabricSection({
  required InvoicePdfFontSet fonts,
  required AppLocalizations l10n,
  required OrderSummary order,
  required pw.TextDirection textDirection,
}) {
  return _sectionCard(
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
            textDirection: textDirection,
          ),
        if (order.fabricColorSnapshot.trim().isNotEmpty) ...[
          pw.SizedBox(height: 2),
          _labelValue(
            fonts,
            l10n.receiptFabricColorLabel,
            order.fabricColorSnapshot.trim(),
            textDirection: textDirection,
          ),
        ],
        if (order.fabricIdSnapshot.trim().isNotEmpty) ...[
          pw.SizedBox(height: 2),
          _labelValue(
            fonts,
            l10n.receiptFabricIdLabel,
            order.fabricIdSnapshot.trim(),
            textDirection: textDirection,
          ),
        ],
      ],
    ),
  );
}

pw.Widget _buildCatalogTextSection({
  required InvoicePdfFontSet fonts,
  required AppLocalizations l10n,
  required OrderSummary order,
  required pw.TextDirection textDirection,
}) {
  return _sectionCard(
    fonts: fonts,
    title: l10n.invoiceCatalogDesignLabel,
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        if (order.catalogDesignNameSnapshot.trim().isNotEmpty)
          _bodyText(
            fonts,
            order.catalogDesignNameSnapshot.trim(),
            textDirection: textDirection,
            bold: true,
          ),
        if (order.catalogDesignerShopNameSnapshot.trim().isNotEmpty) ...[
          pw.SizedBox(height: 2),
          _labelValue(
            fonts,
            l10n.invoiceCatalogDesignerLabel,
            order.catalogDesignerShopNameSnapshot.trim(),
            textDirection: textDirection,
          ),
        ],
      ],
    ),
  );
}

/// Full-width design image below two-column body sections.
pw.Widget _buildDesignImagesSection({
  required InvoicePdfFontSet fonts,
  required AppLocalizations l10n,
  required InvoicePdfDesignRail rail,
  required pw.TextDirection textDirection,
}) {
  return _sectionCard(
    fonts: fonts,
    title: l10n.invoiceStyleFiguresLabel,
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        if (rail.catalogProvider != null) ...[
          pw.Container(
            padding: const pw.EdgeInsets.all(3),
            decoration: pw.BoxDecoration(
              color: kInvoicePdfSurface,
              borderRadius: pw.BorderRadius.circular(4),
              border: pw.Border.all(color: kInvoicePdfBorder, width: 0.5),
            ),
            child: pw.SizedBox(
              height: kInvoicePdfCatalogDisplayHeightPt,
              width: double.infinity,
              child: pw.Image(rail.catalogProvider!, fit: pw.BoxFit.contain),
            ),
          ),
          if (rail.figureProviders.isNotEmpty) pw.SizedBox(height: 4),
        ],
        if (rail.figureProviders.isNotEmpty)
          _buildStyleFigureGrid(rail: rail),
      ],
    ),
  );
}

pw.Widget _buildStyleFigureGrid({required InvoicePdfDesignRail rail}) {
  return pw.Wrap(
    spacing: 3,
    runSpacing: 3,
    children: [
      for (final provider in rail.figureProviders)
        pw.Container(
          width: kInvoicePdfStyleFigureDisplayPt,
          height: kInvoicePdfStyleFigureDisplayPt,
          padding: const pw.EdgeInsets.all(2),
          decoration: pw.BoxDecoration(
            color: kInvoicePdfSurface,
            borderRadius: pw.BorderRadius.circular(3),
            border: pw.Border.all(color: kInvoicePdfBorder, width: 0.5),
          ),
          child: pw.Image(provider, fit: pw.BoxFit.contain),
        ),
    ],
  );
}

pw.Widget _subsectionLabel(
  InvoicePdfFontSet fonts,
  String text,
  pw.TextDirection textDirection,
) {
  return pw.Text(
    text,
    style: pw.TextStyle(
      font: fonts.bold,
      fontSize: 8,
      color: kInvoicePdfAccent,
    ),
    textDirection: textDirection,
  );
}

pw.Widget _buildPridePromoFooter({
  required InvoicePdfFontSet fonts,
  required AppLocalizations l10n,
  required pw.TextDirection textDirection,
}) {
  return pw.Padding(
    padding: const pw.EdgeInsets.only(top: 4),
    child: pdfMixedTextWidget(
      text: l10n.invoicePridePromoLine,
      style: pw.TextStyle(
        font: fonts.regular,
        fontSize: 8,
        color: PdfColors.grey700,
      ),
      textAlign: pw.TextAlign.center,
      documentDirection: textDirection,
    ),
  );
}

pw.Widget _buildPaymentSummary({
  required InvoicePdfFontSet fonts,
  required AppLocalizations l10n,
  required String total,
  required String paid,
  required String balance,
  required List<PaymentSummary> payments,
  String Function(DateTime dateTime)? formatPaymentDate,
  required pw.TextDirection textDirection,
}) {
  return pw.Container(
    decoration: pw.BoxDecoration(
      border: pw.Border.all(color: kInvoicePdfBorder, width: 0.7),
      borderRadius: pw.BorderRadius.circular(kInvoicePdfSectionRadius),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
              fontSize: 9.5,
              color: PdfColors.white,
            ),
            textDirection: textDirection,
          ),
        ),
        pw.Container(
          padding: const pw.EdgeInsets.fromLTRB(6, 5, 6, 5),
          color: kInvoicePdfSurface,
          child: pw.Column(
            children: [
              _moneyRowTile(
                fonts,
                l10n.receiptTotalLabel,
                total,
                textDirection: textDirection,
              ),
              pw.SizedBox(height: 3),
              _moneyRowTile(
                fonts,
                l10n.receiptPaidLabel,
                paid,
                textDirection: textDirection,
              ),
              pw.SizedBox(height: 3),
              _moneyRowTile(
                fonts,
                l10n.receiptBalanceLabel,
                balance,
                textDirection: textDirection,
                emphasize: true,
              ),
              if (payments.isNotEmpty) ...[
                pw.SizedBox(height: 4),
                pw.Divider(color: kInvoicePdfBorder, height: 0.5),
                pw.SizedBox(height: 3),
                for (var i = 0; i < payments.length; i++) ...[
                  if (i > 0) pw.SizedBox(height: 2),
                  _paymentLedgerRow(
                    fonts: fonts,
                    l10n: l10n,
                    payment: payments[i],
                    formatPaymentDate: formatPaymentDate,
                    textDirection: textDirection,
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

pw.Widget _paymentLedgerRow({
  required InvoicePdfFontSet fonts,
  required AppLocalizations l10n,
  required PaymentSummary payment,
  String Function(DateTime dateTime)? formatPaymentDate,
  required pw.TextDirection textDirection,
}) {
  final method = formatInvoicePaymentMethod(l10n, payment.method);
  final amount = reportFormatMoney(l10n, payment.amountMinor);
  final dateText = formatPaymentDate?.call(payment.createdAt) ??
      _fallbackPaymentDateText(payment.createdAt);

  return pw.Container(
    padding: const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 3),
    decoration: pw.BoxDecoration(
      color: PdfColors.white,
      borderRadius: pw.BorderRadius.circular(3),
      border: pw.Border.all(color: kInvoicePdfBorder, width: 0.4),
    ),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: 3,
          child: pw.Text(
            method,
            style: pw.TextStyle(font: fonts.regular, fontSize: 8.5),
            textDirection: textDirection,
          ),
        ),
        pw.Expanded(
          flex: 2,
          child: pdfMixedTextWidget(
            text: '${l10n.invoicePaymentDateLabel}: $dateText',
            style: pw.TextStyle(font: fonts.regular, fontSize: 8),
            documentDirection: pw.TextDirection.ltr,
          ),
        ),
        pdfMoneyWidget(
          formattedMoney: amount,
          style: pw.TextStyle(font: fonts.bold, fontSize: 8.5),
          documentDirection: textDirection,
        ),
      ],
    ),
  );
}

pw.Widget _buildThankYouFooter({
  required InvoicePdfFontSet fonts,
  required ReceiptBranding branding,
  required pw.TextDirection textDirection,
}) {
  final thanks = branding.thankYouLines.where((l) => l.trim().isNotEmpty);
  if (thanks.isEmpty) return pw.SizedBox();

  return pw.Container(
    padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 5),
    decoration: pw.BoxDecoration(
      color: kInvoicePdfSurface,
      borderRadius: pw.BorderRadius.circular(kInvoicePdfSectionRadius),
      border: pw.Border.all(color: kInvoicePdfBorder, width: 0.5),
    ),
    child: pw.Column(
      children: [
        for (final line in thanks)
          pdfMixedTextWidget(
            text: line.trim(),
            style: pw.TextStyle(
              font: fonts.bold,
              fontSize: 9,
              color: kInvoicePdfAccent,
            ),
            textAlign: pw.TextAlign.center,
            documentDirection: pdfValueShouldRenderLtr(line.trim())
                ? pw.TextDirection.ltr
                : textDirection,
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
      border: pw.Border.all(color: kInvoicePdfBorder, width: 0.7),
      borderRadius: pw.BorderRadius.circular(kInvoicePdfSectionRadius),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
              fontSize: 8.5,
              color: kInvoicePdfAccent,
            ),
          ),
        ),
        pw.Divider(color: kInvoicePdfBorder, height: 0.5),
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(5),
          color: PdfColors.white,
          child: child,
        ),
      ],
    ),
  );
}

pw.Widget _bodyText(
  InvoicePdfFontSet fonts,
  String text, {
  required pw.TextDirection textDirection,
  bool bold = false,
  int? maxLines,
}) {
  return pdfMixedTextWidget(
    text: text,
    style: pw.TextStyle(
      font: bold ? fonts.bold : fonts.regular,
      fontSize: 9,
      lineSpacing: 0.8,
    ),
    documentDirection: textDirection,
    maxLines: maxLines,
  );
}

pw.Widget _labelValue(
  InvoicePdfFontSet fonts,
  String label,
  String value, {
  required pw.TextDirection textDirection,
}) {
  return pw.Container(
    padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2),
    decoration: pw.BoxDecoration(
      color: kInvoicePdfSurfaceAlt,
      borderRadius: pw.BorderRadius.circular(3),
    ),
    child: pdfCompactLabelValue(
      fonts: fonts,
      label: label,
      value: value,
      documentDirection: textDirection,
      labelFontSize: 8,
      valueFontSize: 9,
      labelWidth: 68,
    ),
  );
}

pw.Widget _moneyRowTile(
  InvoicePdfFontSet fonts,
  String label,
  String amount, {
  required pw.TextDirection textDirection,
  bool emphasize = false,
}) {
  return pw.Container(
    padding: const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 3),
    decoration: pw.BoxDecoration(
      color: emphasize ? kInvoicePdfAccentLight : PdfColors.white,
      borderRadius: pw.BorderRadius.circular(3),
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
            fontSize: emphasize ? 9.5 : 9,
          ),
          textDirection: textDirection,
        ),
        pdfMoneyWidget(
          formattedMoney: amount,
          style: pw.TextStyle(
            font: emphasize ? fonts.bold : fonts.regular,
            fontSize: emphasize ? 10 : 9,
            color: emphasize ? kInvoicePdfAccent : PdfColors.black,
          ),
          documentDirection: textDirection,
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
