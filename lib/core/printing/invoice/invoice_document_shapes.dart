import '../../../data/local/order_style_snapshot_view.dart';
import '../../../data/local/style/order_shape_format_labels.dart';
import '../../../data/local/style/order_shape_selection_formatter.dart';
import '../../../data/local/style/style_figure_inch_display.dart';
import '../../../data/local/style_figure_summary.dart';
import '../../../l10n/app_localizations.dart';
import 'invoice_document_model.dart';
import 'invoice_pdf_text_sanitize.dart';

List<InvoiceDocumentShape> invoiceDocumentShapesFromSnapshot({
  required OrderStyleSnapshotView? snapshot,
  required AppLocalizations l10n,
}) {
  if (snapshot == null || snapshot.figures.isEmpty) return const [];

  final labels = orderShapeFormatLabels(l10n);
  final sorted = List<OrderStyleSnapshotFigureView>.from(snapshot.figures)
    ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

  final shapes = <InvoiceDocumentShape>[];
  for (final figure in sorted) {
    final rows = <InvoiceDocumentShapeDetailRow>[];

    for (final opt in figure.textOptions) {
      final value = pdfSanitizeLabel(opt.labelSnapshot);
      if (value.isEmpty) continue;
      rows.add(
        InvoiceDocumentShapeDetailRow(
          label: pdfSanitizeLabel(labels.detail),
          value: value,
        ),
      );
    }

    for (final opt in figure.sizeOptions) {
      final value = pdfSanitizeLabel(
        displayInchOptionLabel(
          valueInches: opt.valueSnapshot,
          label: opt.labelSnapshot,
        ),
      );
      if (value.isEmpty) continue;
      rows.add(
        InvoiceDocumentShapeDetailRow(
          label: pdfSanitizeLabel(labels.size),
          value: value,
        ),
      );
    }

    final name = pdfSanitizeLabel(figure.figureNameSnapshot);
    final note = pdfSanitizeLabel(figure.noteSnapshot);
    final hasSelection = rows.isNotEmpty || note.isNotEmpty;
    if (!hasSelection) continue;

    shapes.add(
      InvoiceDocumentShape(
        shapeName: name.isNotEmpty ? name : pdfSanitizeLabel(labels.shape),
        imageRef: figure.imageRefSnapshot.trim(),
        detailRows: rows,
        note: note,
      ),
    );
  }
  return shapes.where((s) => !s.isEmpty).toList(growable: false);
}

List<InvoiceDocumentShape> invoiceDocumentShapesFromDisplay({
  required OrderShapeSelectionDisplay display,
  required AppLocalizations l10n,
}) {
  final labels = orderShapeFormatLabels(l10n);
  final shapes = <InvoiceDocumentShape>[];

  for (final figure in display.figures) {
    final name = pdfSanitizeLabel(figure.shapeName);
    final detail = pdfSanitizeLabel(figure.detailLabel);
    final size = pdfSanitizeLabel(figure.sizeLabel);
    final note = pdfSanitizeLabel(figure.note);
    final hasSelection =
        detail.isNotEmpty || size.isNotEmpty || note.isNotEmpty;
    if (!hasSelection && name.isEmpty && figure.imageRef.isEmpty) continue;

    final rows = <InvoiceDocumentShapeDetailRow>[];
    if (detail.isNotEmpty) {
      rows.add(
        InvoiceDocumentShapeDetailRow(
          label: pdfSanitizeLabel(labels.detail),
          value: detail,
        ),
      );
    }
    if (size.isNotEmpty) {
      rows.add(
        InvoiceDocumentShapeDetailRow(
          label: pdfSanitizeLabel(labels.size),
          value: size,
        ),
      );
    }

    shapes.add(
      InvoiceDocumentShape(
        shapeName: name.isNotEmpty ? name : pdfSanitizeLabel(labels.shape),
        imageRef: figure.imageRef.trim(),
        detailRows: rows,
        note: note,
      ),
    );
  }
  return shapes.where((s) => !s.isEmpty).toList(growable: false);
}

List<InvoiceDocumentShape> resolveInvoiceDocumentShapes({
  required AppLocalizations l10n,
  required OrderStyleSnapshotView? styleSnap,
  required String styleName,
  required String styleSelectionJson,
  required String styleSummary,
  required List<StyleFigureSummary> catalogFigures,
}) {
  var shapes = invoiceDocumentShapesFromSnapshot(
    snapshot: styleSnap,
    l10n: l10n,
  );
  if (shapes.isNotEmpty) return shapes;

  final display = formatOrderShapeSelectionDisplay(
    snapshot: styleSnap,
    styleName: styleName,
    styleSelectionJson: styleSelectionJson,
    styleSummary: styleSummary,
    catalogFigures: catalogFigures,
  );
  return invoiceDocumentShapesFromDisplay(display: display, l10n: l10n)
      .where((s) => !s.isEmpty)
      .toList(growable: false);
}
