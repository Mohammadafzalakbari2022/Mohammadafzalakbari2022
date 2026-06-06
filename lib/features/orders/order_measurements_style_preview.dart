import '../../data/local/order_measurement_snapshot_view.dart';
import '../../data/local/order_style_snapshot_view.dart';
import '../../data/local/order_summary.dart';
import '../../data/local/style/order_shape_selection_formatter.dart';

/// One-line preview for order lists (customer history, etc.).
String orderMeasurementsStylePreview({
  required OrderSummary order,
  OrderMeasurementSnapshotView? measurementSnap,
  OrderStyleSnapshotView? styleSnap,
  OrderShapeSelectionFormatLabels labels =
      OrderShapeSelectionFormatLabels.defaults,
}) {
  final parts = <String>[];

  final items = measurementSnap?.items ?? [];
  if (items.isNotEmpty) {
    parts.add(
      items
          .map(
            (it) => '${it.typeName}: ${it.value.trim()}',
          )
          .join(' · '),
    );
  } else if (order.measurementsSnapshot.trim().isNotEmpty) {
    final line = order.measurementsSnapshot.trim().replaceAll('\n', ' · ');
    parts.add(line);
  }

  final styleDisplay = formatOrderShapeSelectionDisplay(
    snapshot: styleSnap,
    styleName: order.styleName,
    styleSelectionJson: order.styleSelectionJson,
    styleSummary: order.styleSummary,
    labels: labels,
  );
  final stylePreview = styleDisplay.compactPreview.trim();
  if (stylePreview.isNotEmpty) {
    parts.add(stylePreview);
  }

  if (parts.isEmpty) return '';
  return parts.join(' | ');
}
