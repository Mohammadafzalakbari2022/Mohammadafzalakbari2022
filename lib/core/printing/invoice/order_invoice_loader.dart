import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pride_v3/core/calendar/app_calendar_format.dart';
import 'package:pride_v3/core/calendar/date_calendar_notifier.dart';
import 'package:pride_v3/core/printing/invoice/invoice_document_builder.dart';
import 'package:pride_v3/core/printing/invoice/invoice_document_model.dart';
import 'package:pride_v3/core/printing/invoice_pdf.dart';
import 'package:pride_v3/core/printing/order_receipt_customer_lookup.dart';
import 'package:pride_v3/data/local/order_item_snapshot_key.dart';
import 'package:pride_v3/data/local/order_summary.dart';
import 'package:pride_v3/data/local/payment_summary.dart';
import 'package:pride_v3/data/providers/local_data_providers.dart';
import 'package:pride_v3/features/orders/order_composer_item_card.dart';
import 'package:pride_v3/features/settings/shop_profile.dart';
import 'package:pride_v3/features/settings/shop_profile_provider.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

/// Shared inputs for generating an order invoice PDF.
class OrderInvoicePdfRequest {
  const OrderInvoicePdfRequest({
    required this.l10n,
    required this.order,
    required this.payments,
    required this.deliveryDateText,
    required this.statusText,
    required this.textDirection,
    required this.createdDateText,
    required this.formatPaymentDate,
    this.shop,
    this.garmentInputs = const [],
    this.customerDisplayNo = '',
  });

  final AppLocalizations l10n;
  final OrderSummary order;
  final List<PaymentSummary> payments;
  final String deliveryDateText;
  final String statusText;
  final pw.TextDirection textDirection;
  final String createdDateText;
  final String Function(DateTime dateTime) formatPaymentDate;
  final ShopProfile? shop;
  final List<InvoicePdfGarmentInput> garmentInputs;
  final String customerDisplayNo;
}

/// Loads garment inputs and metadata for share/view/print flows.
Future<OrderInvoicePdfRequest> prepareOrderInvoicePdfRequest({
  required BuildContext context,
  required WidgetRef ref,
  required AppLocalizations l10n,
  required OrderSummary order,
  required List<PaymentSummary> payments,
  required String deliveryDateText,
  required String statusText,
}) async {
  final shop = ref.read(shopProfileProvider).valueOrNull;
  final locale = Localizations.localeOf(context).toString();
  final calendar = ref.read(dateCalendarSystemProvider);
  final localeObj = Localizations.localeOf(context);
  final isRtl =
      localeObj.languageCode == 'fa' || localeObj.languageCode == 'ps';
  final textDirection =
      isRtl ? pw.TextDirection.rtl : pw.TextDirection.ltr;
  final createdDateText = AppCalendarFormat.dateTimeMedium(
    l10n,
    calendar,
    order.createdAt,
    locale,
  );

  final garmentInputs = <InvoicePdfGarmentInput>[];
  if (order.items.length > 1) {
    for (final item in order.sortedItems) {
      final snapKey = OrderItemSnapshotKey(
        orderInternalId: order.internalId,
        orderItemInternalId: item.internalId,
      );
      final mSnap = ref
          .read(orderItemMeasurementSnapshotProvider(snapKey))
          .valueOrNull;
      final sSnap =
          ref.read(orderItemStyleSnapshotProvider(snapKey)).valueOrNull;
      final figures = ref
              .read(styleFiguresForGarmentProvider(item.garmentType))
              .valueOrNull ??
          const [];
      garmentInputs.add(
        InvoicePdfGarmentInput(
          garmentLabel: composerGarmentLabel(l10n, item.garmentType),
          item: item,
          measurementSnap: mSnap,
          styleSnap: sSnap,
          catalogFigures: figures,
        ),
      );
    }
  }

  final customerDisplayNo =
      customerDisplayNoForOrder(ref, order.customerInternalId);

  return OrderInvoicePdfRequest(
    l10n: l10n,
    order: order,
    payments: payments,
    deliveryDateText: deliveryDateText,
    statusText: statusText,
    textDirection: textDirection,
    createdDateText: createdDateText,
    shop: shop,
    garmentInputs: garmentInputs,
    customerDisplayNo: customerDisplayNo,
    formatPaymentDate: (dt) =>
        AppCalendarFormat.mediumDate(l10n, calendar, dt, locale),
  );
}

/// Builds PDF bytes with full snapshot resolution (share/view).
Future<Uint8List> loadOrderInvoicePdfBytesFromRef({
  required WidgetRef ref,
  required OrderInvoicePdfRequest request,
}) async {
  final styleSnap =
      ref.read(orderStyleSnapshotProvider(request.order.internalId)).valueOrNull;
  final measurementSnap = ref
      .read(orderMeasurementSnapshotProvider(request.order.internalId))
      .valueOrNull;
  final catalogFigures =
      ref.read(styleAllFiguresStreamProvider).valueOrNull ?? const [];

  return buildOrderInvoicePdf(
    l10n: request.l10n,
    shop: request.shop,
    order: request.order,
    payments: request.payments,
    deliveryDateText: request.deliveryDateText,
    statusText: request.statusText,
    textDirection: request.textDirection,
    createdDateText: request.createdDateText,
    formatPaymentDate: request.formatPaymentDate,
    measurementSnap: measurementSnap,
    styleSnap: styleSnap,
    catalogFigures: catalogFigures,
    garmentInputs: request.garmentInputs,
    customerDisplayNo: request.customerDisplayNo,
  );
}

/// Builds [InvoiceDocumentModel] for thermal printing (shared data layer).
Future<InvoiceDocumentModel> loadInvoiceDocumentFromRef({
  required WidgetRef ref,
  required OrderInvoicePdfRequest request,
  int wrapChars = 56,
}) async {
  final styleSnap =
      ref.read(orderStyleSnapshotProvider(request.order.internalId)).valueOrNull;
  final measurementSnap = ref
      .read(orderMeasurementSnapshotProvider(request.order.internalId))
      .valueOrNull;
  final catalogFigures =
      ref.read(styleAllFiguresStreamProvider).valueOrNull ?? const [];

  return buildInvoiceDocument(
    l10n: request.l10n,
    shop: request.shop,
    order: request.order,
    payments: request.payments,
    deliveryDateText: request.deliveryDateText,
    statusText: request.statusText,
    createdDateText: request.createdDateText,
    generatedDateText: request.createdDateText,
    measurementSnap: measurementSnap,
    styleSnap: styleSnap,
    catalogFigures: catalogFigures,
    garmentInputs: request.garmentInputs,
    customerDisplayNo: request.customerDisplayNo,
    wrapChars: wrapChars,
  );
}
