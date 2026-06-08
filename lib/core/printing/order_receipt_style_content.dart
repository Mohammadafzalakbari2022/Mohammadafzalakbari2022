import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/measurement_profile_formatting.dart';
import '../../data/local/order_item_summary.dart';
import '../../data/local/order_measurement_snapshot_view.dart';
import '../../data/local/order_style_snapshot_view.dart';
import '../../data/local/order_summary.dart';
import '../../data/local/style/order_shape_selection_formatter.dart';
import '../../data/local/style_figure_summary.dart';
import '../../data/providers/local_data_providers.dart';
import 'style_figure_raster.dart';
import 'thermal_receipt_escpos.dart';

/// Style label + figure rows for receipts (DB snapshot first, then order fields).
class OrderReceiptStyleContent {
  const OrderReceiptStyleContent({
    required this.styleLine,
    required this.figures,
  });

  final String? styleLine;
  final List<ReceiptStyleFigure> figures;
}

String? formatReceiptMeasurementsBody({
  required OrderSummary order,
  OrderMeasurementSnapshotView? measurementSnap,
}) {
  final items = measurementSnap?.items ?? [];
  if (items.isNotEmpty) {
    return items
        .map(
          (it) =>
              '${it.typeName}: ${it.value.trim()}'
              '${MeasurementProfileFormatting.unitSuffix(it.unitCode)}',
        )
        .join('\n');
  }
  final text = order.measurementsSnapshot.trim();
  return text.isEmpty ? null : text;
}

String? formatReceiptMeasurementsLine({
  required OrderSummary order,
  OrderMeasurementSnapshotView? measurementSnap,
  required String label,
}) {
  final body = formatReceiptMeasurementsBody(
    order: order,
    measurementSnap: measurementSnap,
  );
  if (body == null) return null;
  return body.contains('\n') ? '$label:\n$body' : '$label: $body';
}

String? formatReceiptMeasurementsBodyForItem({
  required OrderItemSummary item,
  OrderMeasurementSnapshotView? measurementSnap,
}) {
  final items = measurementSnap?.items ?? [];
  if (items.isNotEmpty) {
    return items
        .map(
          (it) =>
              '${it.typeName}: ${it.value.trim()}'
              '${MeasurementProfileFormatting.unitSuffix(it.unitCode)}',
        )
        .join('\n');
  }
  final text = item.measurementsSnapshot.trim();
  return text.isEmpty ? null : text;
}

String? formatReceiptMeasurementsLineForItem({
  required OrderItemSummary item,
  OrderMeasurementSnapshotView? measurementSnap,
  required String label,
}) {
  final body = formatReceiptMeasurementsBodyForItem(
    item: item,
    measurementSnap: measurementSnap,
  );
  if (body == null) return null;
  return body.contains('\n') ? '$label:\n$body' : '$label: $body';
}

OrderReceiptStyleContent resolveOrderReceiptStyleContentForItem({
  required OrderItemSummary item,
  OrderStyleSnapshotView? styleSnap,
  List<StyleFigureSummary> catalogFigures = const [],
  required String styleLabel,
  OrderShapeSelectionFormatLabels formatLabels =
      OrderShapeSelectionFormatLabels.defaults,
}) {
  final display = formatOrderShapeSelectionDisplay(
    snapshot: styleSnap,
    styleName: item.styleName,
    styleSelectionJson: item.styleSelectionJson,
    styleSummary: item.styleSummary,
    catalogFigures: catalogFigures,
    labels: formatLabels,
  );

  if (display.isEmpty) {
    return const OrderReceiptStyleContent(styleLine: null, figures: []);
  }

  final body = display.detailedText.trim().isNotEmpty
      ? display.detailedText.trim()
      : display.summaryFallbackText.trim();

  final receiptFigures = display.figures
      .map((figure) => ReceiptStyleFigure(name: figure.shapeName))
      .toList(growable: false);

  return OrderReceiptStyleContent(
    styleLine: body.isEmpty
        ? null
        : (body.contains('\n') ? '$styleLabel:\n$body' : '$styleLabel: $body'),
    figures: receiptFigures,
  );
}

String? formatReceiptStyleBody({
  required OrderSummary order,
  OrderStyleSnapshotView? styleSnap,
  List<StyleFigureSummary> catalogFigures = const [],
  OrderShapeSelectionFormatLabels labels =
      OrderShapeSelectionFormatLabels.defaults,
}) {
  final content = resolveOrderReceiptStyleContent(
    order: order,
    styleSnap: styleSnap,
    catalogFigures: catalogFigures,
    styleLabel: '',
    formatLabels: labels,
  );
  final line = content.styleLine?.trim();
  if (line == null || line.isEmpty) return null;
  return line.startsWith(':') ? line.substring(1).trim() : line;
}

OrderReceiptStyleContent resolveOrderReceiptStyleContent({
  required OrderSummary order,
  OrderStyleSnapshotView? styleSnap,
  List<StyleFigureSummary> catalogFigures = const [],
  required String styleLabel,
  OrderShapeSelectionFormatLabels formatLabels =
      OrderShapeSelectionFormatLabels.defaults,
}) {
  final display = formatOrderShapeSelectionDisplay(
    snapshot: styleSnap,
    styleName: order.styleName,
    styleSelectionJson: order.styleSelectionJson,
    styleSummary: order.styleSummary,
    catalogFigures: catalogFigures,
    labels: formatLabels,
  );

  if (display.isEmpty) {
    return const OrderReceiptStyleContent(styleLine: null, figures: []);
  }

  final body = display.detailedText.trim().isNotEmpty
      ? display.detailedText.trim()
      : display.summaryFallbackText.trim();

  final receiptFigures = display.figures
      .map((figure) => ReceiptStyleFigure(name: figure.shapeName))
      .toList(growable: false);

  return OrderReceiptStyleContent(
    styleLine: body.isEmpty
        ? null
        : (body.contains('\n') ? '$styleLabel:\n$body' : '$styleLabel: $body'),
    figures: receiptFigures,
  );
}

OrderReceiptStyleContent watchOrderReceiptStyleContent(
  WidgetRef ref,
  OrderSummary order,
  String styleLabel,
  OrderShapeSelectionFormatLabels formatLabels,
) {
  final styleSnap =
      ref.read(orderStyleSnapshotProvider(order.internalId)).valueOrNull;
  final catalogFigures =
      ref.read(styleAllFiguresStreamProvider).valueOrNull ?? const [];
  return resolveOrderReceiptStyleContent(
    order: order,
    styleSnap: styleSnap,
    catalogFigures: catalogFigures,
    styleLabel: styleLabel,
    formatLabels: formatLabels,
  );
}

/// Loads figure images for thermal output without repeating names in text.
Future<List<ReceiptStyleFigure>> loadReceiptStyleFigureImages({
  required OrderShapeSelectionDisplay display,
  required int maxWidthPx,
}) async {
  final out = <ReceiptStyleFigure>[];
  for (final figure in display.figures) {
    if (figure.imageRef.trim().isEmpty) continue;
    final image = await loadStyleFigureRaster(
      imageRef: figure.imageRef,
      maxWidthPx: maxWidthPx,
    );
    if (image != null) {
      out.add(ReceiptStyleFigure(image: image));
    }
  }
  return out;
}
