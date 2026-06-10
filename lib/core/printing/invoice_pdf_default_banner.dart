import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'invoice_pdf_font.dart';
import 'pdf_bidi_text.dart';
import 'receipt_branding.dart';

/// Default PDF banner height (~3:1 feel at A4 width).
const double kPdfDefaultBannerHeightPt = 56;

/// Uploaded banner image or branded default banner for invoice PDF headers.
pw.Widget buildPdfShopBannerSection({
  required pw.ImageProvider? uploadedBannerProvider,
  required InvoicePdfFontSet fonts,
  required ReceiptBranding branding,
  required pw.ImageProvider? logoProvider,
  required pw.TextDirection textDirection,
  bool compactBottomGap = false,
}) {
  final bottomGap = compactBottomGap ? 4.0 : 6.0;
  if (uploadedBannerProvider != null) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pw.ClipRRect(
          horizontalRadius: 4,
          verticalRadius: 4,
          child: pw.Image(
            uploadedBannerProvider,
            fit: pw.BoxFit.cover,
            height: kPdfDefaultBannerHeightPt,
            width: double.infinity,
          ),
        ),
        pw.SizedBox(height: bottomGap),
      ],
    );
  }

  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.stretch,
    children: [
      pw.Container(
        height: kPdfDefaultBannerHeightPt,
        decoration: pw.BoxDecoration(
          gradient: pw.LinearGradient(
            begin: pw.Alignment.centerLeft,
            end: pw.Alignment.centerRight,
            colors: [
              PdfColor.fromInt(0xFF5B3FA6),
              PdfColor.fromInt(0xFF6D28D9),
              PdfColor.fromInt(0xFF0D9488),
            ],
          ),
          borderRadius: const pw.BorderRadius.only(
            topLeft: pw.Radius.circular(4),
            topRight: pw.Radius.circular(4),
          ),
          border: pw.Border.all(color: PdfColor.fromInt(0xFF4A3288), width: 0.5),
        ),
        padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            if (logoProvider != null) ...[
              pw.Container(
                width: 40,
                height: 40,
                padding: const pw.EdgeInsets.all(3),
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: pw.Image(logoProvider, fit: pw.BoxFit.contain),
              ),
              pw.SizedBox(width: 10),
            ],
            pw.Expanded(
              child: pdfMixedTextWidget(
                text: branding.shopDisplayName,
                style: pw.TextStyle(
                  font: fonts.bold,
                  fontSize: 14,
                  color: PdfColors.white,
                ),
                documentDirection: textDirection,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
      pw.SizedBox(height: bottomGap),
    ],
  );
}
