import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:pdf/widgets.dart' as pw;

import '../../../data/local/customer_display_no.dart';
import '../../../data/local/entities/garment_type.dart';
import '../../../data/local/order_item_summary.dart';
import '../../../data/local/order_measurement_snapshot_view.dart';
import '../../../data/local/order_style_snapshot_view.dart';
import '../../../data/local/order_summary.dart';
import '../../../data/local/payment_summary.dart';
import '../../../data/local/style/order_shape_selection_formatter.dart';
import '../../../data/local/style_figure_summary.dart';
import '../../../features/reports/report_money_format.dart';
import '../../../features/settings/shop_profile.dart';
import '../../../l10n/app_localizations.dart';
import 'package:pride_v3/core/formatting/display_customer_no_format.dart';
import 'package:pride_v3/core/formatting/display_order_no_format.dart';
import '../../../features/orders/order_composer_item_card.dart';
import '../invoice_pdf_font.dart';
import '../invoice_pdf_measurements.dart';
import '../pdf_bidi_text.dart';
import '../receipt_branding.dart';
import '../shop_logo_raster.dart';
import 'invoice_pdf_constants.dart';
import 'invoice_pdf_debug_dump.dart';
import 'invoice_pdf_garment_assets.dart';
import 'invoice_pdf_garment_input.dart';
import 'invoice_pdf_shape_model.dart';
import 'invoice_pdf_text_sanitize.dart';
import 'widgets/customer_card_widget.dart';
import 'widgets/garment_section_widget.dart';
import 'widgets/invoice_footer_widget.dart';
import 'widgets/invoice_header_widget.dart';
import 'widgets/invoice_pdf_widgets_common.dart';
import 'widgets/payment_summary_widget.dart';

/// Builds an A4 portrait invoice PDF (v2 layout).
Future<Uint8List> buildOrderInvoicePdfV2({
  required AppLocalizations l10n,
  required ShopProfile? shop,
  required OrderSummary order,
  required List<PaymentSummary> payments,
  required String deliveryDateText,
  required String statusText,
  required pw.TextDirection textDirection,
  String? createdDateText,
  String? generatedDateText,
  String Function(DateTime dateTime)? formatPaymentDate,
  OrderMeasurementSnapshotView? measurementSnap,
  OrderStyleSnapshotView? styleSnap,
  List<StyleFigureSummary> catalogFigures = const [],
  List<InvoicePdfGarmentInput> garmentInputs = const [],
  String customerDisplayNo = '',
  bool writeDebugDump = false,
}) async {
  if (writeDebugDump) {
    final payload = buildInvoicePdfDebugPayload(
      order: order,
      payments: payments,
      garmentInputs: garmentInputs,
      styleSnap: styleSnap,
      measurementSnap: measurementSnap,
      catalogFigures: catalogFigures,
      customerDisplayNo: customerDisplayNo,
      shop: shop,
    );
    await writeInvoicePdfDebugDump(payload);
  }

  final fonts = await InvoicePdfFonts.load();
  final branding = ReceiptBranding.fromShop(
    shop: shop,
    l10n: l10n,
    wrapChars: 56,
  );

  final customerIdLabel = parseStoredDisplayCustomerNo(customerDisplayNo) > 0
      ? displayCustomerNumberLabel(l10n, customerDisplayNo)
      : null;
  final orderIdLabel = displayOrderNumberLabel(l10n, order.displayOrderNo);
  final takenDate = (createdDateText ?? '').trim().isNotEmpty
      ? createdDateText!.trim()
      : _fallbackDateText(order.createdAt);
  final invoiceGeneratedDate =
      (generatedDateText ?? takenDate).trim();

  pw.ImageProvider? logoProvider;
  final logoRaster = await loadReceiptHeaderLogoRaster(
    userLogoRelativePath: shop?.logoRelativePath,
    maxWidthPx: InvoicePdfLayout.headerLogoMaxPx,
  );
  if (logoRaster != null) {
    logoProvider = pw.MemoryImage(
      Uint8List.fromList(img.encodePng(logoRaster)),
    );
  }

  pw.ImageProvider? bannerProvider;
  final bannerRaster = await loadShopBannerRasterIfPresent(
    relativePath: shop?.bannerRelativePath,
    maxWidthPx: 480,
  );
  if (bannerRaster != null) {
    bannerProvider = pw.MemoryImage(
      Uint8List.fromList(img.encodePng(bannerRaster)),
    );
  }

  final effectiveInputs = await _resolveGarmentInputs(
    order: order,
    garmentInputs: garmentInputs,
    measurementSnap: measurementSnap,
    styleSnap: styleSnap,
    catalogFigures: catalogFigures,
    l10n: l10n,
  );

  final garmentBlocks = <InvoiceGarmentBlockData>[];
  for (final input in effectiveInputs) {
    garmentBlocks.add(await _buildGarmentBlock(input: input, l10n: l10n));
  }

  _logInvoiceBuildMetrics(
    orderIdLabel: orderIdLabel,
    customerIdLabel: customerIdLabel,
    garmentBlocks: garmentBlocks,
    paymentCount: payments.length,
  );

  final garmentTotalMinor = order.items.isNotEmpty
      ? order.itemPriceTotalAmountMinor
      : order.totalAmountMinor;

  final doc = pw.Document(theme: InvoicePdfFonts.themeFor(fonts));

  doc.addPage(
    pw.MultiPage(
      pageFormat: InvoicePdfLayout.pageFormat,
      margin: const pw.EdgeInsets.fromLTRB(
        InvoicePdfLayout.pageMarginL,
        InvoicePdfLayout.pageMarginT,
        InvoicePdfLayout.pageMarginR,
        InvoicePdfLayout.pageMarginB,
      ),
      textDirection: textDirection,
      header: (context) => pw.Directionality(
        textDirection: textDirection,
        child: _continuationHeader(
          pageNumber: context.pageNumber,
          fonts: fonts,
          l10n: l10n,
          orderIdLabel: orderIdLabel,
          branding: branding,
          textDirection: textDirection,
        ),
      ),
      build: (context) {
        final widgets = <pw.Widget>[
          pw.Directionality(
            textDirection: textDirection,
            child: invoiceHeaderWidget(
              fonts: fonts,
              branding: branding,
              logoProvider: logoProvider,
              uploadedBannerProvider: bannerProvider,
              l10n: l10n,
              orderIdLabel: orderIdLabel,
              statusText: statusText,
              createdDateText: takenDate,
              deliveryDateText: deliveryDateText,
              textDirection: textDirection,
            ),
          ),
          pw.SizedBox(height: InvoicePdfLayout.sectionGap),
          pw.Directionality(
            textDirection: textDirection,
            child: customerCardWidget(
              fonts: fonts,
              l10n: l10n,
              customerName: order.customerName,
              phone: order.customerPhone ?? '',
              customerIdLabel: customerIdLabel,
              textDirection: textDirection,
            ),
          ),
        ];

        for (final block in garmentBlocks) {
          widgets.add(pw.SizedBox(height: InvoicePdfLayout.sectionGap));
          for (final section in garmentSectionWidgets(
            fonts: fonts,
            l10n: l10n,
            garment: block,
            textDirection: textDirection,
          )) {
            widgets.add(
              pw.Directionality(
                textDirection: textDirection,
                child: section,
              ),
            );
          }
        }

        if (order.internalNotes.trim().isNotEmpty) {
          widgets.add(pw.SizedBox(height: InvoicePdfLayout.sectionGap));
          widgets.add(
            pw.Directionality(
              textDirection: textDirection,
              child: pw.Inseparable(
                child: invoiceCardShell(
                  fonts: fonts,
                  title: l10n.receiptInternalNotesHeader,
                  textDirection: textDirection,
                  child: pdfMixedTextWidget(
                    text: pdfSanitizeLabel(order.internalNotes.trim()),
                    style: pw.TextStyle(
                      font: fonts.regular,
                      fontSize: InvoicePdfLayout.bodyFontSize,
                    ),
                    documentDirection: textDirection,
                    maxLines: 8,
                  ),
                ),
              ),
            ),
          );
        }

        widgets.add(pw.SizedBox(height: InvoicePdfLayout.sectionGap));
        widgets.add(
          pw.Directionality(
            textDirection: textDirection,
            child: paymentSummaryWidget(
              fonts: fonts,
              l10n: l10n,
              garmentTotalMinor: garmentTotalMinor,
              grandTotalMinor: order.totalAmountMinor,
              paidMinor: order.paidAmountMinor,
              remainingMinor: order.remainingAmountMinor,
              payments: payments,
              textDirection: textDirection,
              formatPaymentDate: formatPaymentDate,
            ),
          ),
        );

        widgets.add(pw.SizedBox(height: InvoicePdfLayout.sectionGap));
        widgets.add(
          pw.Directionality(
            textDirection: textDirection,
            child: invoiceFooterWidget(
              fonts: fonts,
              l10n: l10n,
              branding: branding,
              generatedDateText: invoiceGeneratedDate,
              textDirection: textDirection,
            ),
          ),
        );

        return widgets;
      },
    ),
  );

  return doc.save();
}

void _logInvoiceBuildMetrics({
  required String orderIdLabel,
  required String? customerIdLabel,
  required List<InvoiceGarmentBlockData> garmentBlocks,
  required int paymentCount,
}) {
  if (!kDebugMode) return;

  var measurementCount = 0;
  var shapeCount = 0;
  var designImageCount = 0;
  for (final block in garmentBlocks) {
    measurementCount += block.measurementRows.length;
    shapeCount += block.shapeCards.length;
    if (block.designImages.catalogProvider != null) designImageCount++;
    designImageCount += block.designImages.referenceProviders.length;
  }

  debugPrint(
    'Invoice PDF build: orderId=$orderIdLabel customerId=${customerIdLabel ?? '—'} '
    'garments=${garmentBlocks.length} measurements=$measurementCount '
    'shapes=$shapeCount designImages=$designImageCount payments=$paymentCount',
  );
}

Future<List<InvoicePdfGarmentInput>> _resolveGarmentInputs({
  required OrderSummary order,
  required List<InvoicePdfGarmentInput> garmentInputs,
  OrderMeasurementSnapshotView? measurementSnap,
  OrderStyleSnapshotView? styleSnap,
  List<StyleFigureSummary> catalogFigures = const [],
  required AppLocalizations l10n,
}) async {
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

Future<InvoiceGarmentBlockData> _buildGarmentBlock({
  required InvoicePdfGarmentInput input,
  required AppLocalizations l10n,
}) async {
  final item = input.item;
  final measurementRows = invoiceMeasurementRowsForItem(
    l10n: l10n,
    item: item,
    measurementSnap: input.measurementSnap,
  );

  var shapeCards = List<InvoiceShapeCardData>.from(
    await invoiceShapeCardsFromSnapshot(
      snapshot: input.styleSnap,
      l10n: l10n,
      loadImage: loadInvoiceShapeImageProvider,
    ),
  );

  if (shapeCards.isEmpty) {
    final display = formatOrderShapeSelectionDisplay(
      snapshot: input.styleSnap,
      styleName: item.styleName,
      styleSelectionJson: item.styleSelectionJson,
      styleSummary: item.styleSummary,
      catalogFigures: input.catalogFigures,
    );
    final imageById = <String, pw.ImageProvider?>{};
    for (final figure in display.figures) {
      if (figure.imageRef.trim().isEmpty) continue;
      imageById[figure.shapeId] =
          await loadInvoiceShapeImageProvider(figure.imageRef);
    }
    shapeCards.addAll(
      invoiceShapeCardsFromDisplay(
        display: display,
        l10n: l10n,
        imageByShapeId: imageById,
      ),
    );
  }

  final designImages = await loadGarmentDesignImages(
    item: item,
    styleSnap: input.styleSnap,
    catalogFigures: input.catalogFigures,
  );

  return InvoiceGarmentBlockData(
    title: input.garmentLabel,
    priceLabel: reportFormatMoney(l10n, item.priceAmountMinor),
    measurementRows: measurementRows,
    designImages: designImages,
    shapeCards: shapeCards,
    styleName: pdfSanitizeLabel(item.styleName.trim()),
    styleSummary: pdfSanitizeLabel(item.styleSummary.trim()),
    fabricLines: _fabricLines(l10n, item),
    catalogLines: _catalogLines(l10n, item),
    notes: '',
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

pw.Widget _continuationHeader({
  required int pageNumber,
  required InvoicePdfFontSet fonts,
  required AppLocalizations l10n,
  required String orderIdLabel,
  required ReceiptBranding branding,
  required pw.TextDirection textDirection,
}) {
  if (pageNumber <= 1) return pw.SizedBox();

  return pw.Container(
    margin: const pw.EdgeInsets.only(bottom: 6),
    padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 5),
    decoration: pw.BoxDecoration(
      color: InvoicePdfColors.accentLight,
      borderRadius: pw.BorderRadius.circular(InvoicePdfLayout.cardRadius),
      border: pw.Border.all(color: InvoicePdfColors.border, width: 0.5),
    ),
    child: pw.Row(
      children: [
        pw.Expanded(
          child: pdfMixedTextWidget(
            text:
                '${pdfSanitizeLabel(l10n.invoiceContinuedLabel)} — ${pdfSanitizeLabel(branding.shopDisplayName)}',
            style: pw.TextStyle(
              font: fonts.bold,
              fontSize: InvoicePdfLayout.smallFontSize,
              color: InvoicePdfColors.accent,
            ),
            documentDirection: textDirection,
          ),
        ),
        pdfMixedTextWidget(
          text: pdfSanitizeLabel(orderIdLabel),
          style: pw.TextStyle(
            font: fonts.regular,
            fontSize: InvoicePdfLayout.smallFontSize,
          ),
          documentDirection: pw.TextDirection.ltr,
        ),
      ],
    ),
  );
}

String _fallbackDateText(DateTime dt) {
  final y = dt.year.toString().padLeft(4, '0');
  final m = dt.month.toString().padLeft(2, '0');
  final d = dt.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}
