import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../invoice_document_model.dart';
import '../invoice_pdf_constants.dart';
import '../invoice_pdf_text_sanitize.dart';
import '../../invoice_pdf_font.dart';
import '../../invoice_pdf_measurements.dart';
import '../../pdf_bidi_text.dart';
import 'shape_grid_widget.dart';

/// Resolved garment block for PDF rendering.
class InvoiceGarmentBlockData {
  const InvoiceGarmentBlockData({
    required this.title,
    required this.priceLabel,
    required this.measurementRows,
    required this.referenceDesign,
    required this.shapes,
    this.referenceImageProvider,
    this.styleName = '',
    this.styleSummary = '',
    this.fabricLines = const [],
    this.catalogLines = const [],
    this.notes = '',
  });

  final String title;
  final String priceLabel;
  final List<InvoiceMeasurementRow> measurementRows;
  final InvoiceDocumentReferenceDesign referenceDesign;
  final pw.ImageProvider? referenceImageProvider;
  final List<InvoicePdfShapeRenderData> shapes;
  final String styleName;
  final String styleSummary;
  final List<String> fabricLines;
  final List<String> catalogLines;
  final String notes;
}

/// Shared card shell for invoice sections.
pw.Widget invoiceCardShell({
  required InvoicePdfFontSet fonts,
  required String title,
  required pw.Widget child,
  required pw.TextDirection textDirection,
  PdfColor? titleBackground,
  PdfColor? titleTextColor,
}) {
  return pw.Container(
    decoration: pw.BoxDecoration(
      border: pw.Border.all(
        color: InvoicePdfColors.border,
        width: InvoicePdfLayout.cardBorderWidth,
      ),
      borderRadius: pw.BorderRadius.circular(InvoicePdfLayout.cardRadius),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: pw.BoxDecoration(
            color: titleBackground ?? InvoicePdfColors.accentLight,
            borderRadius: pw.BorderRadius.only(
              topLeft: pw.Radius.circular(InvoicePdfLayout.cardRadius),
              topRight: pw.Radius.circular(InvoicePdfLayout.cardRadius),
            ),
          ),
          child: pdfMixedTextWidget(
            text: pdfSanitizeLabel(title),
            style: pw.TextStyle(
              font: fonts.bold,
              fontSize: InvoicePdfLayout.sectionTitleFontSize,
              color: titleTextColor ?? InvoicePdfColors.accent,
            ),
            documentDirection: textDirection,
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(InvoicePdfLayout.cardBodyPadding),
          child: child,
        ),
      ],
    ),
  );
}

pw.Widget invoiceLabelValueRow({
  required InvoicePdfFontSet fonts,
  required String label,
  required String value,
  required pw.TextDirection textDirection,
  bool emphasize = false,
}) {
  if (label.trim().isEmpty) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 3),
      child: pdfMixedTextWidget(
        text: pdfSanitizeLabel(value),
        style: pw.TextStyle(
          font: emphasize ? fonts.bold : fonts.regular,
          fontSize: InvoicePdfLayout.bodyFontSize,
        ),
        documentDirection: textDirection,
      ),
    );
  }

  return pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 3),
    child: pdfCompactLabelValue(
      fonts: fonts,
      label: pdfSanitizeLabel(label),
      value: pdfSanitizeLabel(value),
      documentDirection: textDirection,
      labelWidth: 72,
      valueFontSize: InvoicePdfLayout.bodyFontSize,
      valueFont: emphasize ? fonts.bold : fonts.regular,
    ),
  );
}
