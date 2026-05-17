import '../../data/local/order_measurement_snapshot_view.dart';
import '../../data/local/order_style_snapshot_view.dart';
import '../../data/local/order_summary.dart';

/// One-line preview for order lists (customer history, etc.).
String orderMeasurementsStylePreview({
  required OrderSummary order,
  OrderMeasurementSnapshotView? measurementSnap,
  OrderStyleSnapshotView? styleSnap,
}) {
  final parts = <String>[];

  final items = measurementSnap?.items ?? [];
  if (items.isNotEmpty) {
    parts.add(
      items
          .map(
            (it) =>
                '${it.typeName}: ${it.value.trim()}',
          )
          .join(' · '),
    );
  } else if (order.measurementsSnapshot.trim().isNotEmpty) {
    final line = order.measurementsSnapshot.trim().replaceAll('\n', ' · ');
    parts.add(line);
  }

  final styleName =
      (styleSnap?.styleNameSnapshot ?? order.styleName).trim();
  if (styleName.isNotEmpty) {
    parts.add(styleName);
  }

  final figureNames = styleSnap?.figures
          .map((f) => f.figureNameSnapshot.trim())
          .where((n) => n.isNotEmpty)
          .toList() ??
      [];
  if (figureNames.isNotEmpty) {
    parts.add(figureNames.join(' · '));
  } else if (order.styleSummary.trim().isNotEmpty) {
    parts.add(order.styleSummary.trim().replaceAll('\n', ' · '));
  }

  if (parts.isEmpty) return '';
  return parts.join(' | ');
}
