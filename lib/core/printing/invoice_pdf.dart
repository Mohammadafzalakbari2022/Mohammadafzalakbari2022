import 'package:flutter/foundation.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../data/local/order_measurement_snapshot_view.dart';
import '../../data/local/order_style_snapshot_view.dart';
import '../../data/local/order_summary.dart';
import '../../data/local/payment_summary.dart';
import '../../data/local/style_figure_summary.dart';
import '../../features/settings/shop_profile.dart';
import '../../l10n/app_localizations.dart';
import 'invoice/invoice_pdf_constants.dart';
import 'invoice/invoice_pdf_garment_input.dart';
import 'invoice/invoice_pdf_v2_builder.dart';
import 'invoice_pdf_images.dart';

export 'invoice/invoice_pdf_constants.dart' show InvoicePdfColors, InvoicePdfLayout;
export 'invoice/invoice_pdf_garment_input.dart';

/// Brand accent for PDF headers (matches app purple).
@Deprecated('Use InvoicePdfColors.accent')
final kInvoicePdfAccent = InvoicePdfColors.accent;

/// Thrown when invoice PDF layout or asset loading fails.
class InvoicePdfGenerationException implements Exception {
  InvoicePdfGenerationException(this.cause, [this.stackTrace]);

  final Object cause;
  final StackTrace? stackTrace;

  @override
  String toString() => 'InvoicePdfGenerationException: $cause';
}

/// Builds an A4 PDF invoice/receipt (RTL when [textDirection] is RTL).
Future<Uint8List> buildOrderInvoicePdf({
  required AppLocalizations l10n,
  required ShopProfile? shop,
  required OrderSummary order,
  required List<PaymentSummary> payments,
  required String deliveryDateText,
  required String statusText,
  required pw.TextDirection textDirection,
  String? createdDateText,
  String Function(DateTime dateTime)? formatPaymentDate,
  InvoicePdfDesignRail? designRail,
  OrderMeasurementSnapshotView? measurementSnap,
  OrderStyleSnapshotView? styleSnap,
  List<StyleFigureSummary> catalogFigures = const [],
  List<InvoicePdfGarmentInput> garmentInputs = const [],
  String customerDisplayNo = '',
  bool writeDebugDump = false,
}) async {
  try {
    return await buildOrderInvoicePdfV2(
      l10n: l10n,
      shop: shop,
      order: order,
      payments: payments,
      deliveryDateText: deliveryDateText,
      statusText: statusText,
      textDirection: textDirection,
      createdDateText: createdDateText,
      generatedDateText: createdDateText,
      formatPaymentDate: formatPaymentDate,
      measurementSnap: measurementSnap,
      styleSnap: styleSnap,
      catalogFigures: catalogFigures,
      garmentInputs: garmentInputs,
      customerDisplayNo: customerDisplayNo,
      writeDebugDump: writeDebugDump,
    );
  } catch (e, st) {
    debugPrint('Invoice PDF generation failed: $e\n$st');
    throw InvoicePdfGenerationException(e, st);
  }
}
