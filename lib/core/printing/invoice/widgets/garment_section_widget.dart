import 'package:pdf/widgets.dart' as pw;

import '../../../../l10n/app_localizations.dart';
import '../../invoice_pdf_font.dart';
import '../../invoice_pdf_measurements.dart';
import '../../pdf_bidi_text.dart';
import '../invoice_pdf_constants.dart';
import '../invoice_pdf_garment_assets.dart';
import '../invoice_pdf_text_sanitize.dart';
import 'invoice_pdf_widgets_common.dart';
import 'shape_card_widget.dart';

/// Span-able garment widgets for [pw.MultiPage] (no single block taller than a page).
List<pw.Widget> garmentSectionWidgets({
  required InvoicePdfFontSet fonts,
  required AppLocalizations l10n,
  required InvoiceGarmentBlockData garment,
  required pw.TextDirection textDirection,
}) {
  final widgets = <pw.Widget>[
    invoiceCardShell(
      fonts: fonts,
      title: garment.title,
      textDirection: textDirection,
      titleBackground: InvoicePdfColors.surfaceAlt,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          if (garment.priceLabel.isNotEmpty)
            invoiceLabelValueRow(
              fonts: fonts,
              label: l10n.ordersComposerItemPriceLabel,
              value: garment.priceLabel,
              textDirection: textDirection,
              emphasize: true,
            ),
        ],
      ),
    ),
  ];

  if (garment.measurementRows.isNotEmpty) {
    widgets.add(
      _garmentSubsectionLabel(
        fonts,
        l10n.receiptMeasurementsLabel,
        textDirection,
      ),
    );
    widgets.addAll(
      _measurementTableChunks(
        fonts: fonts,
        rows: garment.measurementRows,
        textDirection: textDirection,
      ),
    );
  }

  widgets.addAll(
    designGalleryWidgets(
      fonts: fonts,
      l10n: l10n,
      images: garment.designImages,
      textDirection: textDirection,
    ),
  );

  if (garment.styleName.isNotEmpty) {
    widgets.add(
      invoiceLabelValueRow(
        fonts: fonts,
        label: l10n.invoiceStyleNameLabel,
        value: garment.styleName,
        textDirection: textDirection,
      ),
    );
  }
  if (garment.styleSummary.isNotEmpty) {
    widgets.add(
      invoiceLabelValueRow(
        fonts: fonts,
        label: l10n.invoiceDesignSectionTitle,
        value: garment.styleSummary,
        textDirection: textDirection,
      ),
    );
  }

  if (garment.shapeCards.isNotEmpty) {
    widgets.add(
      _garmentSubsectionLabel(
        fonts,
        l10n.invoiceStyleFiguresLabel,
        textDirection,
      ),
    );
    for (final card in garment.shapeCards) {
      widgets.add(
        pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 6),
          child: shapeCardWidget(
            fonts: fonts,
            l10n: l10n,
            card: card,
            textDirection: textDirection,
          ),
        ),
      );
    }
  }

  if (garment.fabricLines.isNotEmpty) {
    widgets.add(
      _garmentSubsectionLabel(
        fonts,
        l10n.receiptFabricLabel,
        textDirection,
      ),
    );
    for (final line in garment.fabricLines) {
      widgets.add(
        invoiceLabelValueRow(
          fonts: fonts,
          label: '',
          value: line,
          textDirection: textDirection,
        ),
      );
    }
  }

  if (garment.catalogLines.isNotEmpty) {
    widgets.add(
      _garmentSubsectionLabel(
        fonts,
        l10n.invoiceCatalogDesignLabel,
        textDirection,
      ),
    );
    for (final line in garment.catalogLines) {
      widgets.add(
        invoiceLabelValueRow(
          fonts: fonts,
          label: '',
          value: line,
          textDirection: textDirection,
        ),
      );
    }
  }

  if (garment.notes.isNotEmpty) {
    widgets.add(
      invoiceLabelValueRow(
        fonts: fonts,
        label: l10n.receiptInternalNotesHeader,
        value: garment.notes,
        textDirection: textDirection,
      ),
    );
  }

  return widgets;
}

pw.Widget _garmentSubsectionLabel(
  InvoicePdfFontSet fonts,
  String label,
  pw.TextDirection textDirection,
) {
  return pw.Padding(
    padding: const pw.EdgeInsets.only(top: 4, bottom: 4),
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

List<pw.Widget> _measurementTableChunks({
  required InvoicePdfFontSet fonts,
  required List<InvoiceMeasurementRow> rows,
  required pw.TextDirection textDirection,
}) {
  if (rows.isEmpty) return const [];

  final chunkSize = InvoicePdfLayout.measurementRowsPerChunk;
  final chunks = <pw.Widget>[];
  for (var i = 0; i < rows.length; i += chunkSize) {
    final end = (i + chunkSize < rows.length) ? i + chunkSize : rows.length;
    chunks.add(
      pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 4),
        child: measurementTableWidget(
          fonts: fonts,
          rows: rows.sublist(i, end),
          textDirection: textDirection,
        ),
      ),
    );
  }
  return chunks;
}

pw.Widget measurementTableWidget({
  required InvoicePdfFontSet fonts,
  required List<InvoiceMeasurementRow> rows,
  required pw.TextDirection textDirection,
}) {
  return pw.Table(
    border: pw.TableBorder.all(color: InvoicePdfColors.border, width: 0.4),
    defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
    children: [
      for (final row in rows)
        pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
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
              padding: const pw.EdgeInsets.all(5),
              child: pdfMixedTextWidget(
                text: pdfSanitizeLabel(row.value),
                style: pw.TextStyle(
                  font: fonts.regular,
                  fontSize: InvoicePdfLayout.smallFontSize,
                ),
                documentDirection:
                    pdfValueShouldRenderLtr(row.value)
                        ? pw.TextDirection.ltr
                        : textDirection,
              ),
            ),
          ],
        ),
    ],
  );
}

/// Catalog + reference design images — one tile per MultiPage widget.
List<pw.Widget> designGalleryWidgets({
  required InvoicePdfFontSet fonts,
  required AppLocalizations l10n,
  required InvoiceGarmentDesignImages images,
  required pw.TextDirection textDirection,
}) {
  if (!images.hasContent) return const [];

  final widgets = <pw.Widget>[
    _garmentSubsectionLabel(
      fonts,
      l10n.invoiceDesignSectionTitle,
      textDirection,
    ),
  ];

  if (images.catalogProvider != null) {
    widgets.add(
      _designImageTile(
        label: l10n.invoiceCatalogDesignLabel,
        provider: images.catalogProvider!,
        fonts: fonts,
        textDirection: textDirection,
        large: true,
      ),
    );
  }

  for (var i = 0; i < images.referenceProviders.length; i++) {
    widgets.add(
      _designImageTile(
        label: images.referenceProviders.length > 1
            ? '${l10n.invoiceReferenceDesignLabel} ${i + 1}'
            : l10n.invoiceReferenceDesignLabel,
        provider: images.referenceProviders[i],
        fonts: fonts,
        textDirection: textDirection,
        large: false,
      ),
    );
  }

  return widgets;
}

pw.Widget _designImageTile({
  required String label,
  required pw.ImageProvider provider,
  required InvoicePdfFontSet fonts,
  required pw.TextDirection textDirection,
  required bool large,
}) {
  final height = large
      ? InvoicePdfLayout.catalogDisplayHeightPt
      : InvoicePdfLayout.shapeImagePt * 1.4;

  return pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 6),
    child: pw.Container(
      decoration: pw.BoxDecoration(
        color: InvoicePdfColors.surface,
        borderRadius: pw.BorderRadius.circular(InvoicePdfLayout.cardRadius),
        border: pw.Border.all(color: InvoicePdfColors.border, width: 0.5),
      ),
      padding: const pw.EdgeInsets.all(6),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pdfMixedTextWidget(
            text: pdfSanitizeLabel(label),
            style: pw.TextStyle(
              font: fonts.bold,
              fontSize: InvoicePdfLayout.smallFontSize,
              color: InvoicePdfColors.accent,
            ),
            documentDirection: textDirection,
          ),
          pw.SizedBox(height: 4),
          pw.SizedBox(
            height: height,
            width: double.infinity,
            child: pw.Image(provider, fit: pw.BoxFit.contain),
          ),
        ],
      ),
    ),
  );
}
