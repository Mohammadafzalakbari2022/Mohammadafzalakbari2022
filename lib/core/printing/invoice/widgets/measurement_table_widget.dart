import 'package:pdf/widgets.dart' as pw;

import '../../../../l10n/app_localizations.dart';
import '../../invoice_pdf_font.dart';
import '../../invoice_pdf_measurements.dart';
import '../../pdf_bidi_text.dart';
import '../invoice_pdf_constants.dart';
import '../invoice_pdf_text_sanitize.dart';

pw.Widget measurementTableWidget({
  required InvoicePdfFontSet fonts,
  required List<InvoiceMeasurementRow> rows,
  required pw.TextDirection textDirection,
}) {
  final pad = InvoicePdfLayout.measurementCellPadding;
  return pw.Table(
    border: pw.TableBorder.all(color: InvoicePdfColors.border, width: 0.4),
    defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
    children: [
      for (final row in rows)
        pw.TableRow(
          children: [
            pw.Padding(
              padding: pw.EdgeInsets.all(pad),
              child: pdfMixedTextWidget(
                text: pdfSanitizeLabel(row.label),
                style: pw.TextStyle(
                  font: fonts.bold,
                  fontSize: InvoicePdfLayout.smallFontSize,
                ),
                documentDirection: textDirection,
              ),
            ),
            pw.Padding(
              padding: pw.EdgeInsets.all(pad),
              child: pdfMixedTextWidget(
                text: pdfSanitizeLabel(row.value),
                style: pw.TextStyle(
                  font: fonts.regular,
                  fontSize: InvoicePdfLayout.smallFontSize,
                ),
                documentDirection: textDirection,
              ),
            ),
          ],
        ),
    ],
  );
}

List<pw.Widget> measurementTableChunks({
  required InvoicePdfFontSet fonts,
  required List<InvoiceMeasurementRow> rows,
  required pw.TextDirection textDirection,
  required bool includeSectionLabel,
  required AppLocalizations l10n,
}) {
  if (rows.isEmpty) return const [];

  final widgets = <pw.Widget>[];
  if (includeSectionLabel) {
    widgets.add(
      pw.Padding(
        padding: const pw.EdgeInsets.only(
          top: InvoicePdfLayout.subsectionGap,
          bottom: InvoicePdfLayout.subsectionGap,
        ),
        child: pdfMixedTextWidget(
          text: pdfSanitizeLabel(l10n.receiptMeasurementsLabel),
          style: pw.TextStyle(
            font: fonts.bold,
            fontSize: InvoicePdfLayout.bodyFontSize,
            color: InvoicePdfColors.accent,
          ),
          documentDirection: textDirection,
        ),
      ),
    );
  }

  widgets.add(
    pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: InvoicePdfLayout.subsectionGap),
      child: measurementTableWidget(
        fonts: fonts,
        rows: rows,
        textDirection: textDirection,
      ),
    ),
  );
  return widgets;
}
