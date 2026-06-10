import 'package:pdf/widgets.dart' as pw;

import '../../../../l10n/app_localizations.dart';
import '../../invoice_pdf_font.dart';
import '../../invoice_pdf_measurements.dart';
import '../../pdf_bidi_text.dart';
import '../invoice_pdf_constants.dart';
import '../invoice_pdf_text_sanitize.dart';
import 'invoice_pdf_widgets_common.dart';
import 'measurement_table_widget.dart';

/// Measurements table (left) | style + fabric + catalog lines (right).
pw.Widget garmentTwoColumnWidget({
  required InvoicePdfFontSet fonts,
  required AppLocalizations l10n,
  required List<InvoiceMeasurementRow> measurementRows,
  required String styleName,
  required String styleSummary,
  required List<String> fabricLines,
  required List<String> catalogLines,
  required pw.TextDirection textDirection,
}) {
  return pw.Row(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Expanded(
        flex: 5,
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            _subsectionLabel(
              fonts,
              l10n.receiptMeasurementsLabel,
              textDirection,
            ),
            ...measurementTableChunks(
              fonts: fonts,
              rows: measurementRows,
              textDirection: textDirection,
              includeSectionLabel: false,
              l10n: l10n,
            ),
          ],
        ),
      ),
      pw.SizedBox(width: InvoicePdfLayout.twoColumnGap),
      pw.Expanded(
        flex: 4,
        child: garmentStyleColumnWidget(
          fonts: fonts,
          l10n: l10n,
          styleName: styleName,
          styleSummary: styleSummary,
          fabricLines: fabricLines,
          catalogLines: catalogLines,
          textDirection: textDirection,
        ),
      ),
    ],
  );
}

/// Style / fabric / catalog text column (full width when no measurements).
pw.Widget garmentStyleColumnWidget({
  required InvoicePdfFontSet fonts,
  required AppLocalizations l10n,
  required String styleName,
  required String styleSummary,
  required List<String> fabricLines,
  required List<String> catalogLines,
  required pw.TextDirection textDirection,
}) {
  final children = <pw.Widget>[];

  if (styleName.isNotEmpty) {
    children.add(
      invoiceLabelValueRow(
        fonts: fonts,
        label: l10n.invoiceStyleNameLabel,
        value: styleName,
        textDirection: textDirection,
      ),
    );
  }
  if (styleSummary.isNotEmpty) {
    children.add(
      invoiceLabelValueRow(
        fonts: fonts,
        label: l10n.invoiceDesignSectionTitle,
        value: styleSummary,
        textDirection: textDirection,
      ),
    );
  }
  if (fabricLines.isNotEmpty) {
    children.add(
      _subsectionLabel(fonts, l10n.receiptFabricLabel, textDirection),
    );
    for (final line in fabricLines) {
      children.add(
        invoiceLabelValueRow(
          fonts: fonts,
          label: '',
          value: line,
          textDirection: textDirection,
        ),
      );
    }
  }
  if (catalogLines.isNotEmpty) {
    children.add(
      _subsectionLabel(fonts, l10n.invoiceCatalogDesignLabel, textDirection),
    );
    for (final line in catalogLines) {
      children.add(
        invoiceLabelValueRow(
          fonts: fonts,
          label: '',
          value: line,
          textDirection: textDirection,
        ),
      );
    }
  }

  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.stretch,
    children: children,
  );
}

pw.Widget _subsectionLabel(
  InvoicePdfFontSet fonts,
  String label,
  pw.TextDirection textDirection,
) {
  return pw.Padding(
    padding: const pw.EdgeInsets.only(
      top: InvoicePdfLayout.subsectionGap,
      bottom: InvoicePdfLayout.subsectionGap,
    ),
    child: pdfMixedTextWidget(
      text: pdfSanitizeLabel(label),
      style: pw.TextStyle(
        font: fonts.bold,
        fontSize: InvoicePdfLayout.bodyFontSize,
        color: InvoicePdfColors.accent,
      ),
      documentDirection: textDirection,
    ),
  );
}
