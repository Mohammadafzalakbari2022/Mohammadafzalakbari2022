import 'package:pdf/widgets.dart' as pw;

import '../../../data/local/order_style_snapshot_view.dart';
import '../../../data/local/style/order_shape_format_labels.dart';
import '../../../data/local/style/order_shape_selection_formatter.dart';
import '../../../data/local/style/style_figure_inch_display.dart';
import '../../../l10n/app_localizations.dart';
import 'invoice_pdf_text_sanitize.dart';

/// One configuration row on a shape card (type, height, width, etc.).
class InvoiceShapeDetailRow {
  const InvoiceShapeDetailRow({required this.label, required this.value});

  final String label;
  final String value;
}

/// Rich shape card for PDF — all options from snapshot, not just the first.
class InvoiceShapeCardData {
  const InvoiceShapeCardData({
    required this.shapeName,
    this.imageProvider,
    this.detailRows = const [],
    this.note = '',
  });

  final String shapeName;
  final pw.ImageProvider? imageProvider;
  final List<InvoiceShapeDetailRow> detailRows;
  final String note;

  bool get isEmpty =>
      shapeName.isEmpty && imageProvider == null && detailRows.isEmpty;
}

List<InvoiceShapeCardData> invoiceShapeCardsFromDisplay({
  required OrderShapeSelectionDisplay display,
  required AppLocalizations l10n,
  required Map<String, pw.ImageProvider?> imageByShapeId,
}) {
  final labels = orderShapeFormatLabels(l10n);
  final cards = <InvoiceShapeCardData>[];

  for (final figure in display.figures) {
    final name = pdfSanitizeLabel(figure.shapeName);
    if (name.isEmpty && figure.imageRef.isEmpty) continue;

    final rows = <InvoiceShapeDetailRow>[];
    if (figure.detailLabel.isNotEmpty) {
      rows.add(
        InvoiceShapeDetailRow(
          label: pdfSanitizeLabel(labels.detail),
          value: pdfSanitizeLabel(figure.detailLabel),
        ),
      );
    }
    if (figure.sizeLabel.isNotEmpty) {
      rows.add(
        InvoiceShapeDetailRow(
          label: pdfSanitizeLabel(labels.size),
          value: pdfSanitizeLabel(figure.sizeLabel),
        ),
      );
    }
    final note = pdfSanitizeLabel(figure.note);
    cards.add(
      InvoiceShapeCardData(
        shapeName: name.isNotEmpty ? name : pdfSanitizeLabel(labels.shape),
        imageProvider: imageByShapeId[figure.shapeId],
        detailRows: rows,
        note: note,
      ),
    );
  }
  return cards;
}

/// Builds shape cards directly from snapshot figures (all text/size options).
Future<List<InvoiceShapeCardData>> invoiceShapeCardsFromSnapshot({
  required OrderStyleSnapshotView? snapshot,
  required AppLocalizations l10n,
  required Future<pw.ImageProvider?> Function(String imageRef) loadImage,
}) async {
  if (snapshot == null || snapshot.figures.isEmpty) return const [];

  final labels = orderShapeFormatLabels(l10n);
  final sorted = List<OrderStyleSnapshotFigureView>.from(snapshot.figures)
    ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

  final cards = <InvoiceShapeCardData>[];
  for (final figure in sorted) {
    final rows = <InvoiceShapeDetailRow>[];

    for (final opt in figure.textOptions) {
      final value = pdfSanitizeLabel(opt.labelSnapshot);
      if (value.isEmpty) continue;
      rows.add(
        InvoiceShapeDetailRow(
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
        InvoiceShapeDetailRow(
          label: pdfSanitizeLabel(labels.size),
          value: value,
        ),
      );
    }

    pw.ImageProvider? image;
    final ref = figure.imageRefSnapshot.trim();
    if (ref.isNotEmpty) {
      image = await loadImage(ref);
    }

    final name = pdfSanitizeLabel(figure.figureNameSnapshot);
    cards.add(
      InvoiceShapeCardData(
        shapeName: name.isNotEmpty ? name : pdfSanitizeLabel(labels.shape),
        imageProvider: image,
        detailRows: rows,
        note: pdfSanitizeLabel(figure.noteSnapshot),
      ),
    );
  }
  return cards;
}
