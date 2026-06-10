import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../../l10n/app_localizations.dart';
import '../../invoice_pdf_font.dart';
import '../../pdf_bidi_text.dart';
import '../../receipt_branding.dart';
import '../invoice_pdf_constants.dart';
import '../invoice_pdf_text_sanitize.dart';

/// Full-width banner header: shop (left), order meta (center), contact (right).
pw.Widget invoiceHeaderWidget({
  required InvoicePdfFontSet fonts,
  required ReceiptBranding branding,
  required pw.ImageProvider? logoProvider,
  required pw.ImageProvider? uploadedBannerProvider,
  required AppLocalizations l10n,
  required String orderIdLabel,
  required String statusText,
  required String createdDateText,
  required String deliveryDateText,
  required pw.TextDirection textDirection,
}) {
  final phone = branding.shopPhoneRaw?.trim() ?? '';
  final addressLines = branding.addressLines
      .map((l) => pdfSanitizeLabel(l.trim()))
      .where((l) => l.isNotEmpty)
      .toList();

  pw.Widget bannerContent = pw.Container(
    height: InvoicePdfLayout.bannerHeightPt,
    padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: pw.BoxDecoration(
      gradient: pw.LinearGradient(
        begin: pw.Alignment.centerLeft,
        end: pw.Alignment.centerRight,
        colors: [
          InvoicePdfColors.accent,
          InvoicePdfColors.accentMid,
          InvoicePdfColors.accentTeal,
        ],
      ),
      borderRadius: pw.BorderRadius.circular(InvoicePdfLayout.cardRadius),
      border: pw.Border.all(color: InvoicePdfColors.accentDark, width: 0.5),
    ),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Expanded(
          flex: 3,
          child: _shopColumn(
            fonts: fonts,
            branding: branding,
            logoProvider: logoProvider,
            textDirection: textDirection,
          ),
        ),
        pw.SizedBox(width: 8),
        pw.Expanded(
          flex: 4,
          child: _orderMetaColumn(
            fonts: fonts,
            l10n: l10n,
            orderIdLabel: orderIdLabel,
            statusText: statusText,
            createdDateText: createdDateText,
            deliveryDateText: deliveryDateText,
            textDirection: textDirection,
          ),
        ),
        pw.SizedBox(width: 8),
        pw.Expanded(
          flex: 3,
          child: _contactColumn(
            fonts: fonts,
            l10n: l10n,
            phone: phone,
            addressLines: addressLines,
            textDirection: textDirection,
          ),
        ),
      ],
    ),
  );

  if (uploadedBannerProvider != null) {
    bannerContent = pw.Stack(
      children: [
        pw.ClipRRect(
          horizontalRadius: InvoicePdfLayout.cardRadius,
          verticalRadius: InvoicePdfLayout.cardRadius,
          child: pw.Image(
            uploadedBannerProvider,
            height: InvoicePdfLayout.bannerHeightPt,
            width: double.infinity,
            fit: pw.BoxFit.cover,
          ),
        ),
        pw.Container(
          height: InvoicePdfLayout.bannerHeightPt,
          padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: pw.BoxDecoration(
            color: InvoicePdfColors.bannerOverlay,
            borderRadius:
                pw.BorderRadius.circular(InvoicePdfLayout.cardRadius),
          ),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Expanded(
                flex: 3,
                child: _shopColumn(
                  fonts: fonts,
                  branding: branding,
                  logoProvider: logoProvider,
                  textDirection: textDirection,
                  onDark: true,
                ),
              ),
              pw.SizedBox(width: 8),
              pw.Expanded(
                flex: 4,
                child: _orderMetaColumn(
                  fonts: fonts,
                  l10n: l10n,
                  orderIdLabel: orderIdLabel,
                  statusText: statusText,
                  createdDateText: createdDateText,
                  deliveryDateText: deliveryDateText,
                  textDirection: textDirection,
                  onDark: true,
                ),
              ),
              pw.SizedBox(width: 8),
              pw.Expanded(
                flex: 3,
                child: _contactColumn(
                  fonts: fonts,
                  l10n: l10n,
                  phone: phone,
                  addressLines: addressLines,
                  textDirection: textDirection,
                  onDark: true,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  return bannerContent;
}

pw.Widget _shopColumn({
  required InvoicePdfFontSet fonts,
  required ReceiptBranding branding,
  required pw.ImageProvider? logoProvider,
  required pw.TextDirection textDirection,
  bool onDark = false,
}) {
  final color = onDark ? InvoicePdfColors.onBanner : InvoicePdfColors.onBanner;
  return pw.Row(
    children: [
      if (logoProvider != null) ...[
        pw.Container(
          width: InvoicePdfLayout.logoBoxPt,
          height: InvoicePdfLayout.logoBoxPt,
          padding: const pw.EdgeInsets.all(4),
          decoration: pw.BoxDecoration(
            color: PdfColors.white,
            borderRadius: pw.BorderRadius.circular(4),
          ),
          child: pw.Image(logoProvider, fit: pw.BoxFit.contain),
        ),
        pw.SizedBox(width: 8),
      ],
      pw.Expanded(
        child: pdfMixedTextWidget(
          text: pdfSanitizeLabel(branding.shopDisplayName),
          style: pw.TextStyle(
            font: fonts.bold,
            fontSize: 12,
            color: color,
          ),
          documentDirection: textDirection,
          maxLines: 3,
        ),
      ),
    ],
  );
}

pw.Widget _orderMetaColumn({
  required InvoicePdfFontSet fonts,
  required AppLocalizations l10n,
  required String orderIdLabel,
  required String statusText,
  required String createdDateText,
  required String deliveryDateText,
  required pw.TextDirection textDirection,
  bool onDark = false,
}) {
  final color = onDark ? InvoicePdfColors.onBanner : InvoicePdfColors.onBanner;
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pdfMixedTextWidget(
        text: pdfSanitizeLabel(orderIdLabel),
        style: pw.TextStyle(font: fonts.bold, fontSize: 10, color: color),
        documentDirection: textDirection,
      ),
      pw.SizedBox(height: 3),
      _bannerMetaLine(fonts, l10n.receiptStatusLabel, statusText, color, textDirection),
      _bannerMetaLine(fonts, l10n.invoiceTakenDateLabel, createdDateText, color, textDirection),
      _bannerMetaLine(fonts, l10n.receiptDeliveryLabel, deliveryDateText, color, textDirection),
    ],
  );
}

pw.Widget _contactColumn({
  required InvoicePdfFontSet fonts,
  required AppLocalizations l10n,
  required String phone,
  required List<String> addressLines,
  required pw.TextDirection textDirection,
  bool onDark = false,
}) {
  final color = onDark ? InvoicePdfColors.onBanner : InvoicePdfColors.onBanner;
  final children = <pw.Widget>[];
  if (phone.isNotEmpty) {
    children.add(
      _bannerMetaLine(fonts, l10n.receiptShopPhoneLabel, phone, color, textDirection),
    );
  }
  for (final line in addressLines.take(3)) {
    children.add(
      pdfMixedTextWidget(
        text: line,
        style: pw.TextStyle(font: fonts.regular, fontSize: 8, color: color),
        documentDirection: textDirection,
        maxLines: 2,
      ),
    );
  }
  if (children.isEmpty) {
    return pw.SizedBox();
  }
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: children,
  );
}

pw.Widget _bannerMetaLine(
  InvoicePdfFontSet fonts,
  String label,
  String value,
  PdfColor color,
  pw.TextDirection textDirection,
) {
  return pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 2),
    child: pdfMixedTextWidget(
      text: '${pdfSanitizeLabel(label)}: ${pdfSanitizeLabel(value)}',
      style: pw.TextStyle(font: fonts.regular, fontSize: 8, color: color),
      documentDirection: textDirection,
      maxLines: 2,
    ),
  );
}
