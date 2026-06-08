import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../../l10n/app_localizations.dart';
import '../../invoice_pdf_font.dart';
import '../../pdf_bidi_text.dart';
import '../invoice_pdf_constants.dart';
import '../invoice_pdf_shape_model.dart';
import '../invoice_pdf_text_sanitize.dart';
import 'invoice_pdf_widgets_common.dart';

/// Shape card with image, configuration rows, and notes.
pw.Widget shapeCardWidget({
  required InvoicePdfFontSet fonts,
  required AppLocalizations l10n,
  required InvoiceShapeCardData card,
  required pw.TextDirection textDirection,
}) {
  if (card.isEmpty) return pw.SizedBox();

  return pw.Inseparable(
    child: pw.Container(
      decoration: pw.BoxDecoration(
        color: InvoicePdfColors.surface,
        borderRadius: pw.BorderRadius.circular(InvoicePdfLayout.cardRadius),
        border: pw.Border.all(color: InvoicePdfColors.border, width: 0.5),
      ),
      padding: const pw.EdgeInsets.all(8),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          if (card.imageProvider != null) ...[
            pw.Container(
              width: InvoicePdfLayout.shapeImagePt,
              height: InvoicePdfLayout.shapeImagePt,
              padding: const pw.EdgeInsets.all(3),
              decoration: pw.BoxDecoration(
                color: PdfColors.white,
                borderRadius: pw.BorderRadius.circular(4),
                border: pw.Border.all(color: InvoicePdfColors.border, width: 0.4),
              ),
              child: pw.Image(card.imageProvider!, fit: pw.BoxFit.contain),
            ),
            pw.SizedBox(width: 8),
          ],
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pdfMixedTextWidget(
                  text: pdfSanitizeLabel(card.shapeName),
                  style: pw.TextStyle(
                    font: fonts.bold,
                    fontSize: InvoicePdfLayout.bodyFontSize,
                    color: InvoicePdfColors.accent,
                  ),
                  documentDirection: textDirection,
                ),
                if (card.detailRows.isNotEmpty) ...[
                  pw.SizedBox(height: 4),
                  for (final row in card.detailRows)
                    invoiceLabelValueRow(
                      fonts: fonts,
                      label: row.label,
                      value: row.value,
                      textDirection: textDirection,
                    ),
                ],
                if (card.note.isNotEmpty) ...[
                  pw.SizedBox(height: 2),
                  invoiceLabelValueRow(
                    fonts: fonts,
                    label: l10n.receiptInternalNotesHeader,
                    value: card.note,
                    textDirection: textDirection,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
