import '../../../data/local/customer_display_no.dart';
import '../../../data/local/entities/garment_type.dart';
import '../../../data/local/order_item_summary.dart';
import '../../../data/local/order_measurement_snapshot_view.dart';
import '../../../data/local/order_style_snapshot_view.dart';
import '../../../data/local/order_summary.dart';
import '../../../data/local/payment_summary.dart';
import '../../../data/local/style_figure_summary.dart';
import '../../../features/reports/report_money_format.dart';
import '../../../features/settings/shop_profile.dart';
import '../../../l10n/app_localizations.dart';
import 'package:pride_v3/core/formatting/display_customer_no_format.dart';
import 'package:pride_v3/core/formatting/display_order_no_format.dart';
import '../../../features/orders/order_composer_item_card.dart';
import '../invoice_pdf_measurements.dart';
import '../receipt_branding.dart';
import 'invoice_document_model.dart';
import 'invoice_document_shapes.dart';
import 'invoice_pdf_garment_input.dart';
import 'invoice_pdf_text_sanitize.dart';

/// Builds [InvoiceDocumentModel] from order entities (shared by PDF + thermal).
Future<InvoiceDocumentModel> buildInvoiceDocument({
  required AppLocalizations l10n,
  required ShopProfile? shop,
  required OrderSummary order,
  required List<PaymentSummary> payments,
  required String deliveryDateText,
  required String statusText,
  required String createdDateText,
  required String generatedDateText,
  OrderMeasurementSnapshotView? measurementSnap,
  OrderStyleSnapshotView? styleSnap,
  List<StyleFigureSummary> catalogFigures = const [],
  List<InvoicePdfGarmentInput> garmentInputs = const [],
  String customerDisplayNo = '',
  int wrapChars = 56,
}) async {
  final branding = ReceiptBranding.fromShop(
    shop: shop,
    l10n: l10n,
    wrapChars: wrapChars,
  );

  final customerIdLabel = parseStoredDisplayCustomerNo(customerDisplayNo) > 0
      ? displayCustomerNumberLabel(l10n, customerDisplayNo)
      : null;
  final orderIdLabel = displayOrderNumberLabel(l10n, order.displayOrderNo);
  final takenDate = createdDateText.trim().isNotEmpty
      ? createdDateText.trim()
      : _fallbackDateText(order.createdAt);
  final invoiceGeneratedDate =
      generatedDateText.trim().isNotEmpty ? generatedDateText.trim() : takenDate;

  final effectiveInputs = _resolveGarmentInputs(
    order: order,
    garmentInputs: garmentInputs,
    measurementSnap: measurementSnap,
    styleSnap: styleSnap,
    catalogFigures: catalogFigures,
    l10n: l10n,
  );

  final garments = <InvoiceDocumentGarment>[];
  for (final input in effectiveInputs) {
    garments.add(_buildGarmentDocument(input: input, l10n: l10n));
  }

  final garmentTotalMinor = order.items.isNotEmpty
      ? order.itemPriceTotalAmountMinor
      : order.totalAmountMinor;

  return InvoiceDocumentModel(
    branding: branding,
    orderIdLabel: orderIdLabel,
    customerIdLabel: customerIdLabel,
    statusText: statusText,
    createdDateText: takenDate,
    deliveryDateText: deliveryDateText,
    generatedDateText: invoiceGeneratedDate,
    customer: InvoiceDocumentCustomer(
      name: order.customerName,
      phone: order.customerPhone ?? '',
      displayIdLabel: customerIdLabel,
    ),
    garments: garments,
    internalNotes: order.internalNotes.trim(),
    payment: InvoiceDocumentPayment.fromSummaries(
      garmentTotalMinor: garmentTotalMinor,
      grandTotalMinor: order.totalAmountMinor,
      paidMinor: order.paidAmountMinor,
      remainingMinor: order.remainingAmountMinor,
      payments: payments,
    ),
    logoRelativePath: shop?.logoRelativePath,
    bannerRelativePath: shop?.bannerRelativePath,
  );
}

List<InvoicePdfGarmentInput> _resolveGarmentInputs({
  required OrderSummary order,
  required List<InvoicePdfGarmentInput> garmentInputs,
  OrderMeasurementSnapshotView? measurementSnap,
  OrderStyleSnapshotView? styleSnap,
  List<StyleFigureSummary> catalogFigures = const [],
  required AppLocalizations l10n,
}) {
  if (garmentInputs.isNotEmpty) return garmentInputs;

  final legacy = order.legacyPerahanTunbanItemView();
  if (legacy != null) {
    return [
      InvoicePdfGarmentInput(
        garmentLabel: composerGarmentLabel(l10n, GarmentType.perahanTunban),
        item: legacy,
        measurementSnap: measurementSnap,
        styleSnap: styleSnap,
        catalogFigures: catalogFigures,
      ),
    ];
  }

  if (order.items.length == 1) {
    final item = order.sortedItems.first;
    return [
      InvoicePdfGarmentInput(
        garmentLabel: composerGarmentLabel(l10n, item.garmentType),
        item: item,
        measurementSnap: measurementSnap,
        styleSnap: styleSnap,
        catalogFigures: catalogFigures,
      ),
    ];
  }

  return garmentInputs;
}

InvoiceDocumentGarment _buildGarmentDocument({
  required InvoicePdfGarmentInput input,
  required AppLocalizations l10n,
}) {
  final item = input.item;
  final measurementRows = invoiceMeasurementRowsForItem(
    l10n: l10n,
    item: item,
    measurementSnap: input.measurementSnap,
  );

  final shapes = resolveInvoiceDocumentShapes(
    l10n: l10n,
    styleSnap: input.styleSnap,
    styleName: item.styleName,
    styleSelectionJson: item.styleSelectionJson,
    styleSummary: item.styleSummary,
    catalogFigures: input.catalogFigures,
  );

  return InvoiceDocumentGarment(
    title: input.garmentLabel,
    priceLabel: reportFormatMoney(l10n, item.priceAmountMinor),
    measurementRows: measurementRows,
    referenceDesign: _referenceDesignForItem(item),
    shapes: shapes,
    styleName: pdfSanitizeLabel(item.styleName.trim()),
    styleSummary: pdfSanitizeLabel(item.styleSummary.trim()),
    fabricLines: _fabricLines(l10n, item),
    catalogLines: _catalogLines(l10n, item),
    notes: '',
  );
}

InvoiceDocumentReferenceDesign _referenceDesignForItem(OrderItemSummary item) {
  final imagePath = item.catalogImagePathSnapshot?.trim();
  final thumbPath = item.catalogThumbnailPathSnapshot?.trim();
  final path = (imagePath != null && imagePath.isNotEmpty)
      ? imagePath
      : (thumbPath != null && thumbPath.isNotEmpty ? thumbPath : null);

  return InvoiceDocumentReferenceDesign(
    catalogImagePath: path,
    designName: pdfSanitizeLabel(item.catalogDesignNameSnapshot.trim()),
    designerShopName:
        pdfSanitizeLabel(item.catalogDesignerShopNameSnapshot.trim()),
  );
}

List<String> _fabricLines(AppLocalizations l10n, OrderItemSummary item) {
  final lines = <String>[];
  if (item.fabricNameSnapshot.trim().isNotEmpty) {
    lines.add(
      '${l10n.receiptFabricNameLabel}: ${pdfSanitizeLabel(item.fabricNameSnapshot.trim())}',
    );
  }
  if (item.fabricColorSnapshot.trim().isNotEmpty) {
    lines.add(
      '${l10n.receiptFabricColorLabel}: ${pdfSanitizeLabel(item.fabricColorSnapshot.trim())}',
    );
  }
  if (item.fabricIdSnapshot.trim().isNotEmpty) {
    lines.add(
      '${l10n.receiptFabricIdLabel}: ${pdfSanitizeLabel(item.fabricIdSnapshot.trim())}',
    );
  }
  return lines;
}

List<String> _catalogLines(AppLocalizations l10n, OrderItemSummary item) {
  final lines = <String>[];
  if (item.catalogDesignNameSnapshot.trim().isNotEmpty) {
    lines.add(pdfSanitizeLabel(item.catalogDesignNameSnapshot.trim()));
  }
  if (item.catalogDesignerShopNameSnapshot.trim().isNotEmpty) {
    lines.add(
      '${l10n.invoiceCatalogDesignerLabel}: ${pdfSanitizeLabel(item.catalogDesignerShopNameSnapshot.trim())}',
    );
  }
  return lines;
}

String _fallbackDateText(DateTime dt) {
  final y = dt.year.toString().padLeft(4, '0');
  final m = dt.month.toString().padLeft(2, '0');
  final d = dt.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}
