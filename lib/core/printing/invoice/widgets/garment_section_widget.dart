import 'package:pdf/widgets.dart' as pw;

import '../../../../l10n/app_localizations.dart';
import '../../invoice_pdf_font.dart';
import '../invoice_pdf_constants.dart';
import 'garment_two_column_widget.dart';
import 'invoice_pdf_widgets_common.dart';
import 'measurement_table_widget.dart';
import 'reference_design_widget.dart';
import 'shape_grid_widget.dart';

/// Span-able garment widgets for [pw.MultiPage] (compact multi-column layout).
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
    pw.SizedBox(height: InvoicePdfLayout.subsectionGap),
  ];

  final rows = garment.measurementRows;
  final chunkSize = InvoicePdfLayout.measurementRowsPerChunk;
  final hasStyleColumn = garment.styleName.isNotEmpty ||
      garment.styleSummary.isNotEmpty ||
      garment.fabricLines.isNotEmpty ||
      garment.catalogLines.isNotEmpty;

  if (rows.isNotEmpty) {
    final firstEnd = rows.length < chunkSize ? rows.length : chunkSize;
    final firstChunk = rows.sublist(0, firstEnd);

    if (hasStyleColumn) {
      widgets.add(
        garmentTwoColumnWidget(
          fonts: fonts,
          l10n: l10n,
          measurementRows: firstChunk,
          styleName: garment.styleName,
          styleSummary: garment.styleSummary,
          fabricLines: garment.fabricLines,
          catalogLines: garment.catalogLines,
          textDirection: textDirection,
        ),
      );
    } else {
      widgets.addAll(
        measurementTableChunks(
          fonts: fonts,
          rows: firstChunk,
          textDirection: textDirection,
          includeSectionLabel: true,
          l10n: l10n,
        ),
      );
    }

    for (var i = chunkSize; i < rows.length; i += chunkSize) {
      final end = (i + chunkSize < rows.length) ? i + chunkSize : rows.length;
      widgets.addAll(
        measurementTableChunks(
          fonts: fonts,
          rows: rows.sublist(i, end),
          textDirection: textDirection,
          includeSectionLabel: false,
          l10n: l10n,
        ),
      );
    }
  } else if (hasStyleColumn) {
    widgets.add(
      garmentStyleColumnWidget(
        fonts: fonts,
        l10n: l10n,
        styleName: garment.styleName,
        styleSummary: garment.styleSummary,
        fabricLines: garment.fabricLines,
        catalogLines: garment.catalogLines,
        textDirection: textDirection,
      ),
    );
  }

  widgets.add(
    referenceDesignWidget(
      fonts: fonts,
      l10n: l10n,
      design: garment.referenceDesign,
      imageProvider: garment.referenceImageProvider,
      textDirection: textDirection,
    ),
  );
  widgets.addAll(
    shapeGridWidgets(
      fonts: fonts,
      l10n: l10n,
      shapes: garment.shapes,
      textDirection: textDirection,
    ),
  );

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
