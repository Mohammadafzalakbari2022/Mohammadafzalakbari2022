import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../../l10n/app_localizations.dart';
import '../../invoice_pdf_font.dart';
import '../../pdf_bidi_text.dart';
import '../../receipt_branding.dart';
import '../invoice_pdf_constants.dart';
import '../invoice_pdf_text_sanitize.dart';

/// Minimal invoice footer: thank-you, generated-by line, generation date.
pw.Widget invoiceFooterWidget({
  required InvoicePdfFontSet fonts,
  required AppLocalizations l10n,
  required ReceiptBranding branding,
  required String generatedDateText,
  required pw.TextDirection textDirection,
}) {
  final thanks = branding.thankYouLines
      .map((l) => pdfSanitizeLabel(l.trim()))
      .where((l) => l.isNotEmpty)
      .toList();

  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.stretch,
    children: [
      if (thanks.isNotEmpty) ...[
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: pw.BoxDecoration(
            color: InvoicePdfColors.surface,
            borderRadius: pw.BorderRadius.circular(InvoicePdfLayout.cardRadius),
            border: pw.Border.all(color: InvoicePdfColors.border, width: 0.5),
          ),
          child: pw.Column(
            children: [
              for (final line in thanks)
                pdfMixedTextWidget(
                  text: line,
                  style: pw.TextStyle(
                    font: fonts.bold,
                    fontSize: InvoicePdfLayout.bodyFontSize,
                    color: InvoicePdfColors.accent,
                  ),
                  textAlign: pw.TextAlign.center,
                  documentDirection: pdfValueShouldRenderLtr(line)
                      ? pw.TextDirection.ltr
                      : textDirection,
                ),
            ],
          ),
        ),
        pw.SizedBox(height: InvoicePdfLayout.sectionGap),
      ],
      pdfMixedTextWidget(
        text: pdfSanitizeLabel(l10n.invoiceGeneratedByKhayat),
        style: pw.TextStyle(
          font: fonts.regular,
          fontSize: InvoicePdfLayout.smallFontSize,
          color: PdfColors.grey700,
        ),
        textAlign: pw.TextAlign.center,
        documentDirection: textDirection,
      ),
      if (generatedDateText.trim().isNotEmpty) ...[
        pw.SizedBox(height: 2),
        pdfMixedTextWidget(
          text:
              '${pdfSanitizeLabel(l10n.invoiceGeneratedDateLabel)}: ${pdfSanitizeLabel(generatedDateText.trim())}',
          style: pw.TextStyle(
            font: fonts.regular,
            fontSize: InvoicePdfLayout.smallFontSize,
            color: PdfColors.grey600,
          ),
          textAlign: pw.TextAlign.center,
          documentDirection: textDirection,
        ),
      ],
    ],
  );
}
