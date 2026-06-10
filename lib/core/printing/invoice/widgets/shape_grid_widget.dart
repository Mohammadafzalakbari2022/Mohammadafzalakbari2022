import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../../l10n/app_localizations.dart';
import '../../invoice_pdf_font.dart';
import '../../pdf_bidi_text.dart';
import '../invoice_document_model.dart';
import '../invoice_pdf_constants.dart';
import '../invoice_pdf_text_sanitize.dart';

/// Resolved shape with loaded image for PDF rendering.
class InvoicePdfShapeRenderData {
  const InvoicePdfShapeRenderData({
    required this.shape,
    this.imageProvider,
  });

  final InvoiceDocumentShape shape;
  final pw.ImageProvider? imageProvider;
}

/// 3-column shape grid with image, name, inch/text rows, and notes.
List<pw.Widget> shapeGridWidgets({
  required InvoicePdfFontSet fonts,
  required AppLocalizations l10n,
  required List<InvoicePdfShapeRenderData> shapes,
  required pw.TextDirection textDirection,
}) {
  if (shapes.isEmpty) return const [];

  final widgets = <pw.Widget>[
    pw.Padding(
      padding: const pw.EdgeInsets.only(
        top: InvoicePdfLayout.subsectionGap,
        bottom: InvoicePdfLayout.subsectionGap,
      ),
      child: pdfMixedTextWidget(
        text: pdfSanitizeLabel(l10n.invoiceStyleFiguresLabel),
        style: pw.TextStyle(
          font: fonts.bold,
          fontSize: InvoicePdfLayout.bodyFontSize,
          color: InvoicePdfColors.accent,
        ),
        documentDirection: textDirection,
      ),
    ),
  ];

  final columns = InvoicePdfLayout.shapeGridColumns;
  for (var i = 0; i < shapes.length; i += columns) {
    final end = (i + columns < shapes.length) ? i + columns : shapes.length;
    final rowItems = shapes.sublist(i, end);
    widgets.add(
      pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: InvoicePdfLayout.shapeGridCellGap),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            for (var c = 0; c < columns; c++)
              pw.Expanded(
                child: c < rowItems.length
                    ? _shapeGridCell(
                        fonts: fonts,
                        l10n: l10n,
                        data: rowItems[c],
                        textDirection: textDirection,
                      )
                    : pw.SizedBox(),
              ),
          ],
        ),
      ),
    );
  }

  return widgets;
}

pw.Widget _shapeGridCell({
  required InvoicePdfFontSet fonts,
  required AppLocalizations l10n,
  required InvoicePdfShapeRenderData data,
  required pw.TextDirection textDirection,
}) {
  final shape = data.shape;
  if (shape.isEmpty) return pw.SizedBox();

  return pw.Container(
    margin: const pw.EdgeInsets.symmetric(
      horizontal: InvoicePdfLayout.shapeGridCellGap / 2,
    ),
    padding: const pw.EdgeInsets.all(InvoicePdfLayout.shapeGridCellGap),
    decoration: pw.BoxDecoration(
      color: InvoicePdfColors.surface,
      borderRadius: pw.BorderRadius.circular(InvoicePdfLayout.cardRadius),
      border: pw.Border.all(color: InvoicePdfColors.border, width: 0.4),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        if (data.imageProvider != null)
          pw.Center(
            child: pw.Container(
              width: InvoicePdfLayout.shapeGridImagePt,
              height: InvoicePdfLayout.shapeGridImagePt,
              padding: const pw.EdgeInsets.all(2),
              decoration: pw.BoxDecoration(
                color: PdfColors.white,
                borderRadius: pw.BorderRadius.circular(3),
                border: pw.Border.all(
                  color: InvoicePdfColors.border,
                  width: 0.3,
                ),
              ),
              child: pw.Image(data.imageProvider!, fit: pw.BoxFit.contain),
            ),
          ),
        if (shape.shapeName.isNotEmpty) ...[
          pw.SizedBox(height: 2),
          pdfMixedTextWidget(
            text: pdfSanitizeLabel(shape.shapeName),
            style: pw.TextStyle(
              font: fonts.bold,
              fontSize: InvoicePdfLayout.smallFontSize,
              color: InvoicePdfColors.accent,
            ),
            documentDirection: textDirection,
            maxLines: 2,
          ),
        ],
        for (final row in shape.detailRows)
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 1),
            child: pdfCompactLabelValue(
              fonts: fonts,
              label: row.label,
              value: row.value,
              documentDirection: textDirection,
              labelWidth: 36,
              valueFontSize: InvoicePdfLayout.smallFontSize,
            ),
          ),
        if (shape.note.isNotEmpty)
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 2),
            child: pdfCompactLabelValue(
              fonts: fonts,
              label: l10n.receiptInternalNotesHeader,
              value: shape.note,
              documentDirection: textDirection,
              labelWidth: 36,
              valueFontSize: InvoicePdfLayout.smallFontSize,
            ),
          ),
      ],
    ),
  );
}
