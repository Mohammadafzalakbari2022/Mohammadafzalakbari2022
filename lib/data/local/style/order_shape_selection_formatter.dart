import '../order_style_snapshot_view.dart';
import '../style_figure_summary.dart';
import 'style_figure_display_name.dart';
import 'style_figure_inch_display.dart';
import 'style_order_selection.dart';

/// Localized labels for formatted style/shape lines (pass from UI/print layers).
class OrderShapeSelectionFormatLabels {
  const OrderShapeSelectionFormatLabels({
    required this.mainStyle,
    required this.shape,
    required this.detail,
    required this.size,
    required this.note,
  });

  final String mainStyle;
  final String shape;
  final String detail;
  final String size;
  final String note;

  static const defaults = OrderShapeSelectionFormatLabels(
    mainStyle: 'Style',
    shape: 'Shape',
    detail: 'Detail',
    size: 'Size',
    note: 'Note',
  );
}

/// One shape row for UI, PDF, and receipt output.
class OrderShapeDisplayItem {
  const OrderShapeDisplayItem({
    required this.shapeId,
    required this.shapeName,
    this.imageRef = '',
    this.detailLabel = '',
    this.sizeLabel = '',
    this.note = '',
  });

  final String shapeId;
  final String shapeName;
  final String imageRef;
  final String detailLabel;
  final String sizeLabel;
  final String note;
}

/// Snapshot-first display bundle for order style/shape details.
class OrderShapeSelectionDisplay {
  const OrderShapeSelectionDisplay({
    this.mainStyleName = '',
    this.figures = const [],
    this.detailedLines = const [],
    this.compactPreview = '',
    this.summaryFallbackText = '',
  });

  final String mainStyleName;
  final List<OrderShapeDisplayItem> figures;
  final List<String> detailedLines;
  final String compactPreview;
  final String summaryFallbackText;

  bool get isEmpty =>
      mainStyleName.isEmpty &&
      figures.isEmpty &&
      summaryFallbackText.isEmpty;

  String get detailedText => detailedLines.join('\n');
}

/// Builds snapshot-first style/shape display data.
///
/// Priority: [snapshot] → v2 [styleSelectionJson] → v1 catalog → [styleSummary].
OrderShapeSelectionDisplay formatOrderShapeSelectionDisplay({
  OrderStyleSnapshotView? snapshot,
  String styleName = '',
  String styleSelectionJson = '',
  String styleSummary = '',
  List<StyleFigureSummary> catalogFigures = const [],
  OrderShapeSelectionFormatLabels labels =
      OrderShapeSelectionFormatLabels.defaults,
}) {
  final summaryFallback = styleSummary.trim();
  final mainStyleName = (snapshot?.styleNameSnapshot ?? styleName).trim();

  final figures = _resolveFigureItems(
    snapshot: snapshot,
    styleSelectionJson: styleSelectionJson,
    catalogFigures: catalogFigures,
  );

  if (mainStyleName.isEmpty && figures.isEmpty) {
    if (summaryFallback.isEmpty) {
      return const OrderShapeSelectionDisplay();
    }
    return OrderShapeSelectionDisplay(
      summaryFallbackText: summaryFallback,
      detailedLines: _splitNonEmptyLines(summaryFallback),
      compactPreview: summaryFallback.replaceAll('\n', ' · '),
    );
  }

  final detailedLines = _buildDetailedLines(
    mainStyleName: mainStyleName,
    figures: figures,
    labels: labels,
    summaryFallback: summaryFallback,
  );
  final compactPreview = _buildCompactPreview(
    mainStyleName: mainStyleName,
    figures: figures,
    summaryFallback: summaryFallback,
  );

  return OrderShapeSelectionDisplay(
    mainStyleName: mainStyleName,
    figures: figures,
    detailedLines: detailedLines,
    compactPreview: compactPreview,
    summaryFallbackText:
        figures.isEmpty && mainStyleName.isEmpty ? summaryFallback : '',
  );
}

List<OrderShapeDisplayItem> _resolveFigureItems({
  OrderStyleSnapshotView? snapshot,
  required String styleSelectionJson,
  required List<StyleFigureSummary> catalogFigures,
}) {
  final snapFigures = snapshot?.figures ?? [];
  if (snapFigures.isNotEmpty) {
    return snapFigures.map(_fromSnapshotFigure).toList(growable: false);
  }

  final selection = StyleOrderSelection.fromJsonString(styleSelectionJson);
  if (selection.shapeItems.isNotEmpty) {
    return _fromShapeItems(selection.shapeItems, catalogFigures);
  }

  if (selection.selectedFigureIds.isNotEmpty) {
    return _fromCatalogFigures(selection, catalogFigures);
  }

  return const [];
}

String _firstTextLabel(List<OrderShapeOptionSnapshotView> options) {
  for (final o in options) {
    final label = o.labelSnapshot.trim();
    if (label.isNotEmpty) return label;
  }
  return '';
}

String _firstSizeLabel(List<OrderShapeSizeSnapshotView> options) {
  for (final o in options) {
    final label = _sizeOptionLabel(o);
    if (label.isNotEmpty) return label;
  }
  return '';
}

OrderShapeDisplayItem _fromSnapshotFigure(OrderStyleSnapshotFigureView figure) {
  return OrderShapeDisplayItem(
    shapeId: figure.styleFigureInternalId,
    shapeName: figure.figureNameSnapshot.trim(),
    imageRef: figure.imageRefSnapshot.trim(),
    detailLabel: _firstTextLabel(figure.textOptions),
    sizeLabel: _firstSizeLabel(figure.sizeOptions),
    note: figure.noteSnapshot.trim(),
  );
}

List<OrderShapeDisplayItem> _fromShapeItems(
  List<OrderShapeSelectionItem> items,
  List<StyleFigureSummary> catalogFigures,
) {
  final figureById = {for (final f in catalogFigures) f.internalId: f};
  final sortedItems = List<OrderShapeSelectionItem>.from(items)
    ..sort((a, b) {
      final fa = figureById[a.shapeId]?.sortOrder ?? 0;
      final fb = figureById[b.shapeId]?.sortOrder ?? 0;
      return fa.compareTo(fb);
    });

  return sortedItems.map((item) {
    final figure = figureById[item.shapeId];
    final shapeName = item.shapeNameSnapshot.trim().isNotEmpty
        ? item.shapeNameSnapshot.trim()
        : resolveStyleFigureSummaryDisplayName(
            figure ??
                StyleFigureSummary(
                  internalId: item.shapeId,
                  shopId: '',
                  partInternalId: '',
                  name: '',
                  imageRef: item.imageRefSnapshot,
                  sortOrder: 0,
                  isActive: true,
                ),
          );
    final imageRef = item.imageRefSnapshot.trim().isNotEmpty
        ? item.imageRefSnapshot.trim()
        : (figure?.imageRef ?? '');

    String detailLabel = '';
    for (final o in item.textOptions) {
      final label = o.labelSnapshot.trim();
      if (label.isNotEmpty) {
        detailLabel = label;
        break;
      }
    }

    String sizeLabel = '';
    for (final o in item.sizeOptions) {
      final label = _sizeOptionLabelFromSnapshot(o);
      if (label.isNotEmpty) {
        sizeLabel = label;
        break;
      }
    }

    return OrderShapeDisplayItem(
      shapeId: item.shapeId,
      shapeName: shapeName,
      imageRef: imageRef,
      detailLabel: detailLabel,
      sizeLabel: sizeLabel,
      note: item.noteSnapshot?.trim() ?? '',
    );
  }).toList(growable: false);
}

List<OrderShapeDisplayItem> _fromCatalogFigures(
  StyleOrderSelection selection,
  List<StyleFigureSummary> catalogFigures,
) {
  final figureById = {for (final f in catalogFigures) f.internalId: f};
  final sortedIds = selection.selectedFigureIds.toList()
    ..sort((a, b) {
      final fa = figureById[a]?.sortOrder ?? 0;
      final fb = figureById[b]?.sortOrder ?? 0;
      return fa.compareTo(fb);
    });

  final out = <OrderShapeDisplayItem>[];
  for (final id in sortedIds) {
    final figure = figureById[id];
    if (figure == null) continue;
    out.add(
      OrderShapeDisplayItem(
        shapeId: figure.internalId,
        shapeName: resolveStyleFigureSummaryDisplayName(figure),
        imageRef: figure.imageRef,
      ),
    );
  }
  return out;
}

String _sizeOptionLabel(OrderShapeSizeSnapshotView option) {
  return displayInchOptionLabel(
    valueInches: option.valueSnapshot,
    label: option.labelSnapshot,
  );
}

String _sizeOptionLabelFromSnapshot(OrderShapeSizeSnapshot option) {
  return displayInchOptionLabel(
    valueInches: option.valueSnapshot,
    label: option.labelSnapshot,
  );
}

List<String> _buildDetailedLines({
  required String mainStyleName,
  required List<OrderShapeDisplayItem> figures,
  required OrderShapeSelectionFormatLabels labels,
  required String summaryFallback,
}) {
  final lines = <String>[];

  void add(String line) {
    final trimmed = line.trim();
    if (trimmed.isEmpty) return;
    if (!lines.contains(trimmed)) lines.add(trimmed);
  }

  if (figures.isEmpty && mainStyleName.isEmpty) {
    return _splitNonEmptyLines(summaryFallback);
  }

  if (mainStyleName.isNotEmpty) {
    add('${labels.mainStyle}: $mainStyleName');
  }

  for (final figure in figures) {
    if (figure.shapeName.isNotEmpty) {
      add('${labels.shape}: ${figure.shapeName}');
    }
    if (figure.detailLabel.isNotEmpty) {
      add('${labels.detail}: ${figure.detailLabel}');
    }
    if (figure.sizeLabel.isNotEmpty) {
      add('${labels.size}: ${figure.sizeLabel}');
    }
    if (figure.note.isNotEmpty) {
      add('${labels.note}: ${figure.note}');
    }
  }

  if (lines.isEmpty && summaryFallback.isNotEmpty) {
    return _splitNonEmptyLines(summaryFallback);
  }

  return lines;
}

String _buildCompactPreview({
  required String mainStyleName,
  required List<OrderShapeDisplayItem> figures,
  required String summaryFallback,
}) {
  if (figures.isEmpty && mainStyleName.isEmpty) {
    return summaryFallback.replaceAll('\n', ' · ');
  }

  final parts = <String>[];
  if (mainStyleName.isNotEmpty) parts.add(mainStyleName);

  for (final figure in figures) {
    final detailParts = <String>[];
    if (figure.detailLabel.isNotEmpty) detailParts.add(figure.detailLabel);
    if (figure.sizeLabel.isNotEmpty) detailParts.add(figure.sizeLabel);
    if (figure.note.isNotEmpty) detailParts.add(figure.note);

    if (figure.shapeName.isEmpty) continue;
    if (detailParts.isEmpty) {
      parts.add(figure.shapeName);
    } else {
      parts.add('${figure.shapeName}: ${detailParts.join(', ')}');
    }
  }

  if (parts.isEmpty) {
    return summaryFallback.replaceAll('\n', ' · ');
  }
  return parts.join(' • ');
}

List<String> _splitNonEmptyLines(String text) {
  return text
      .split('\n')
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty)
      .toList(growable: false);
}
