import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:pride_v3/core/persistence/pride_path_provider_io.dart';

import '../../../data/local/order_measurement_snapshot_view.dart';
import '../../../data/local/order_style_snapshot_view.dart';
import '../../../data/local/order_summary.dart';
import '../../../data/local/payment_summary.dart';
import '../../../data/local/style/order_shape_selection_formatter.dart';
import '../../../data/local/style_figure_summary.dart';
import '../../../features/settings/shop_profile.dart';
import 'invoice_pdf_garment_input.dart';

/// Debug payload sent to the PDF generator — inspect when shapes/designs are missing.
class InvoicePdfDebugPayload {
  const InvoicePdfDebugPayload({
    required this.generatedAt,
    required this.order,
    required this.payments,
    required this.garmentInputs,
    required this.singleGarmentStyleSnap,
    required this.singleGarmentMeasurementSnap,
    required this.catalogFigureCount,
    required this.customerDisplayNo,
    required this.shopName,
  });

  final DateTime generatedAt;
  final Map<String, dynamic> order;
  final List<Map<String, dynamic>> payments;
  final List<Map<String, dynamic>> garmentInputs;
  final Map<String, dynamic>? singleGarmentStyleSnap;
  final Map<String, dynamic>? singleGarmentMeasurementSnap;
  final int catalogFigureCount;
  final String customerDisplayNo;
  final String shopName;

  Map<String, dynamic> toJson() => {
        'generated_at': generatedAt.toUtc().toIso8601String(),
        'shop_name': shopName,
        'customer_display_no': customerDisplayNo,
        'catalog_figure_count': catalogFigureCount,
        'order': order,
        'payments': payments,
        'garment_inputs': garmentInputs,
        'single_garment_style_snapshot': singleGarmentStyleSnap,
        'single_garment_measurement_snapshot': singleGarmentMeasurementSnap,
      };
}

InvoicePdfDebugPayload buildInvoicePdfDebugPayload({
  required OrderSummary order,
  required List<PaymentSummary> payments,
  required List<InvoicePdfGarmentInput> garmentInputs,
  OrderStyleSnapshotView? styleSnap,
  OrderMeasurementSnapshotView? measurementSnap,
  List<StyleFigureSummary> catalogFigures = const [],
  String customerDisplayNo = '',
  ShopProfile? shop,
}) {
  return InvoicePdfDebugPayload(
    generatedAt: DateTime.now(),
    shopName: shop?.name ?? '',
    customerDisplayNo: customerDisplayNo,
    catalogFigureCount: catalogFigures.length,
    order: _orderToJson(order),
    payments: payments.map(_paymentToJson).toList(),
    garmentInputs: garmentInputs.map(_garmentInputToJson).toList(),
    singleGarmentStyleSnap:
        garmentInputs.isEmpty ? _styleSnapToJson(styleSnap) : null,
    singleGarmentMeasurementSnap: garmentInputs.isEmpty
        ? _measurementSnapToJson(measurementSnap)
        : null,
  );
}

/// Writes debug JSON when [kDebugMode]; returns file path or null.
Future<String?> writeInvoicePdfDebugDump(InvoicePdfDebugPayload payload) async {
  if (!kDebugMode || kIsWeb) return null;
  try {
    final dir = await prideTemporaryDirectory();
    final id = payload.order['internal_id'] ?? 'order';
    final path = '${dir.path}/invoice_pdf_debug_$id.json';
    final encoder = const JsonEncoder.withIndent('  ');
    await File(path).writeAsString(encoder.convert(payload.toJson()));
    debugPrint('Invoice PDF debug dump: $path');
    return path;
  } on Object catch (e) {
    debugPrint('Invoice PDF debug dump failed: $e');
    return null;
  }
}

Map<String, dynamic> _orderToJson(OrderSummary o) => {
      'internal_id': o.internalId,
      'display_order_no': o.displayOrderNo,
      'customer_internal_id': o.customerInternalId,
      'customer_name': o.customerName,
      'customer_phone': o.customerPhone,
      'status': o.status.name,
      'total_amount_minor': o.totalAmountMinor,
      'paid_amount_minor': o.paidAmountMinor,
      'items_count': o.items.length,
      'style_selection_json_len': o.styleSelectionJson.length,
      'style_summary': o.styleSummary,
      'catalog_image': o.catalogImagePathSnapshot,
      'catalog_design': o.catalogDesignNameSnapshot,
    };

Map<String, dynamic> _paymentToJson(PaymentSummary p) => {
      'order_internal_id': p.orderInternalId,
      'amount_minor': p.amountMinor,
      'method': p.method,
      'created_at': p.createdAt.toUtc().toIso8601String(),
    };

Map<String, dynamic> _garmentInputToJson(InvoicePdfGarmentInput g) {
  final display = formatOrderShapeSelectionDisplay(
    snapshot: g.styleSnap,
    styleName: g.item.styleName,
    styleSelectionJson: g.item.styleSelectionJson,
    styleSummary: g.item.styleSummary,
    catalogFigures: g.catalogFigures,
  );
  return {
    'garment_label': g.garmentLabel,
    'garment_type': g.item.garmentType.name,
    'item_internal_id': g.item.internalId,
    'price_minor': g.item.priceAmountMinor,
    'style_name': g.item.styleName,
    'style_selection_json': g.item.styleSelectionJson,
    'catalog_figures_count': g.catalogFigures.length,
    'style_snap_figure_count': g.styleSnap?.figures.length ?? 0,
    'measurement_snap_item_count': g.measurementSnap?.items.length ?? 0,
    'resolved_shape_count': display.figures.length,
    'resolved_shapes': display.figures
        .map(
          (f) => {
            'shape_id': f.shapeId,
            'name': f.shapeName,
            'image_ref': f.imageRef,
            'detail': f.detailLabel,
            'size': f.sizeLabel,
            'note': f.note,
          },
        )
        .toList(),
    'catalog_design': g.item.catalogDesignNameSnapshot,
    'catalog_image': g.item.catalogImagePathSnapshot,
  };
}

Map<String, dynamic>? _styleSnapToJson(OrderStyleSnapshotView? snap) {
  if (snap == null) return null;
  return {
    'style_name': snap.styleNameSnapshot,
    'figures': snap.figures
        .map(
          (f) => {
            'id': f.styleFigureInternalId,
            'name': f.figureNameSnapshot,
            'image_ref': f.imageRefSnapshot,
            'text_options': f.textOptions.map((o) => o.labelSnapshot).toList(),
            'size_options': f.sizeOptions
                .map((o) => {'label': o.labelSnapshot, 'value': o.valueSnapshot})
                .toList(),
            'note': f.noteSnapshot,
          },
        )
        .toList(),
  };
}

Map<String, dynamic>? _measurementSnapToJson(
  OrderMeasurementSnapshotView? snap,
) {
  if (snap == null) return null;
  return {
    'items': snap.items
        .map((i) => {'type': i.typeName, 'value': i.value, 'unit': i.unitCode})
        .toList(),
  };
}
