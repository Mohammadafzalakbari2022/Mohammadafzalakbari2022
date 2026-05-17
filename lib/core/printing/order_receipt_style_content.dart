import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/measurement_profile_formatting.dart';
import '../../data/local/order_measurement_snapshot_view.dart';
import '../../data/local/order_style_snapshot_view.dart';
import '../../data/local/order_summary.dart';
import '../../data/local/style/order_style_figures_resolver.dart';
import '../../data/local/style_figure_summary.dart';
import '../../data/providers/local_data_providers.dart';
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

String? formatReceiptStyleBody({
  required OrderSummary order,
  OrderStyleSnapshotView? styleSnap,
  List<StyleFigureSummary> catalogFigures = const [],
}) {
  final content = resolveOrderReceiptStyleContent(
    order: order,
    styleSnap: styleSnap,
    catalogFigures: catalogFigures,
    styleLabel: '',
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
}) {
  final buf = StringBuffer();
  final name = (styleSnap?.styleNameSnapshot ?? order.styleName).trim();
  if (name.isNotEmpty) {
    buf.writeln(name);
  }

  final receiptFigures = <ReceiptStyleFigure>[];
  final snapFigures = styleSnap?.figures ?? [];
  if (snapFigures.isNotEmpty) {
    for (final f in snapFigures) {
      final label = f.figureNameSnapshot.trim();
      if (label.isNotEmpty) buf.writeln(label);
      receiptFigures.add(ReceiptStyleFigure(name: label));
    }
  } else {
    final selected = resolveOrderStyleFigures(
      styleSelectionJson: order.styleSelectionJson,
      allFigures: catalogFigures,
    );
    for (final f in selected) {
      final label = f.name.trim();
      if (label.isNotEmpty) buf.writeln(label);
      receiptFigures.add(ReceiptStyleFigure(name: label));
    }
    if (receiptFigures.isEmpty && order.styleSummary.trim().isNotEmpty) {
      buf.write(order.styleSummary.trim());
    }
  }

  final text = buf.toString().trim();
  return OrderReceiptStyleContent(
    styleLine: text.isEmpty
        ? null
        : (text.contains('\n') ? '$styleLabel:\n$text' : '$styleLabel: $text'),
    figures: receiptFigures,
  );
}

OrderReceiptStyleContent watchOrderReceiptStyleContent(
  WidgetRef ref,
  OrderSummary order,
  String styleLabel,
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
  );
}
