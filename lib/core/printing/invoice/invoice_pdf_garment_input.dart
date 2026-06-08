import '../../../data/local/order_item_summary.dart';
import '../../../data/local/order_measurement_snapshot_view.dart';
import '../../../data/local/order_style_snapshot_view.dart';
import '../../../data/local/style_figure_summary.dart';

/// One garment block for multi-item PDF invoices.
class InvoicePdfGarmentInput {
  const InvoicePdfGarmentInput({
    required this.garmentLabel,
    required this.item,
    this.measurementSnap,
    this.styleSnap,
    this.catalogFigures = const [],
  });

  final String garmentLabel;
  final OrderItemSummary item;
  final OrderMeasurementSnapshotView? measurementSnap;
  final OrderStyleSnapshotView? styleSnap;
  final List<StyleFigureSummary> catalogFigures;
}
