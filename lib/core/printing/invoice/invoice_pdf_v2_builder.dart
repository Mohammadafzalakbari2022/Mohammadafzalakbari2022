import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:pdf/widgets.dart' as pw;

import '../../../data/local/order_measurement_snapshot_view.dart';
import '../../../data/local/order_style_snapshot_view.dart';
import '../../../data/local/order_summary.dart';
import '../../../data/local/payment_summary.dart';
import '../../../data/local/style_figure_summary.dart';
import '../../../features/settings/shop_profile.dart';
import '../../../l10n/app_localizations.dart';
import '../invoice_pdf_font.dart';
import '../pdf_bidi_text.dart';
import '../receipt_branding.dart';
import '../shop_logo_raster.dart';
import 'invoice_document_builder.dart';
import 'invoice_document_model.dart';
import 'invoice_pdf_constants.dart';
import 'invoice_pdf_debug_dump.dart';
import 'invoice_pdf_garment_assets.dart';
import 'invoice_pdf_garment_input.dart';
import 'invoice_pdf_text_sanitize.dart';
import 'widgets/customer_card_widget.dart';
import 'widgets/garment_section_widget.dart';
import 'widgets/invoice_footer_widget.dart';
import 'widgets/invoice_header_widget.dart';
import 'widgets/invoice_pdf_widgets_common.dart';
import 'widgets/payment_summary_widget.dart';
import 'widgets/shape_grid_widget.dart';

/// Builds an A4 portrait invoice PDF (v2 compact layout).
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

  final document = await buildInvoiceDocument(
    l10n: l10n,
    shop: shop,
    order: order,
    payments: payments,
    deliveryDateText: deliveryDateText,
    statusText: statusText,
    createdDateText: createdDateText ?? '',
    generatedDateText: generatedDateText ?? createdDateText ?? '',
    measurementSnap: measurementSnap,
    styleSnap: styleSnap,
    catalogFigures: catalogFigures,
    garmentInputs: garmentInputs,
    customerDisplayNo: customerDisplayNo,
  );

  return buildOrderInvoicePdfFromDocument(
    l10n: l10n,
    shop: shop,
    order: order,
    payments: payments,
    document: document,
    textDirection: textDirection,
    formatPaymentDate: formatPaymentDate,
  );
}

/// Renders a pre-built [InvoiceDocumentModel] to PDF bytes.
Future<Uint8List> buildOrderInvoicePdfFromDocument({
  required AppLocalizations l10n,
  required ShopProfile? shop,
  required OrderSummary order,
  required List<PaymentSummary> payments,
  required InvoiceDocumentModel document,
  required pw.TextDirection textDirection,
  String Function(DateTime dateTime)? formatPaymentDate,
}) async {
  final fonts = await InvoicePdfFonts.load();

  pw.ImageProvider? logoProvider;
  final logoRaster = await loadReceiptHeaderLogoRaster(
    userLogoRelativePath: document.logoRelativePath,
    maxWidthPx: InvoicePdfLayout.headerLogoMaxPx,
  );
  if (logoRaster != null) {
    logoProvider = pw.MemoryImage(
      Uint8List.fromList(img.encodePng(logoRaster)),
    );
  }

  pw.ImageProvider? bannerProvider;
  final bannerRaster = await loadShopBannerRasterIfPresent(
    relativePath: document.bannerRelativePath,
    maxWidthPx: 480,
  );
  if (bannerRaster != null) {
    bannerProvider = pw.MemoryImage(
      Uint8List.fromList(img.encodePng(bannerRaster)),
    );
  }

  final garmentBlocks = <InvoiceGarmentBlockData>[];
  for (final garment in document.garments) {
    garmentBlocks.add(await _renderGarmentBlock(garment: garment));
  }

  _logInvoiceBuildMetrics(
    orderIdLabel: document.orderIdLabel,
    customerIdLabel: document.customerIdLabel,
    garmentBlocks: garmentBlocks,
    paymentCount: payments.length,
  );

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
          orderIdLabel: document.orderIdLabel,
          branding: document.branding,
          textDirection: textDirection,
        ),
      ),
      build: (context) {
        final widgets = <pw.Widget>[
          pw.Directionality(
            textDirection: textDirection,
            child: invoiceHeaderWidget(
              fonts: fonts,
              branding: document.branding,
              logoProvider: logoProvider,
              uploadedBannerProvider: bannerProvider,
              l10n: l10n,
              orderIdLabel: document.orderIdLabel,
              statusText: document.statusText,
              createdDateText: document.createdDateText,
              deliveryDateText: document.deliveryDateText,
              textDirection: textDirection,
            ),
          ),
          pw.SizedBox(height: InvoicePdfLayout.sectionGap),
          pw.Directionality(
            textDirection: textDirection,
            child: customerCardWidget(
              fonts: fonts,
              l10n: l10n,
              customerName: document.customer.name,
              phone: document.customer.phone,
              customerIdLabel: document.customerIdLabel,
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

        if (document.internalNotes.isNotEmpty) {
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
                    text: pdfSanitizeLabel(document.internalNotes),
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
              garmentTotalMinor: document.payment.garmentTotalMinor,
              grandTotalMinor: document.payment.grandTotalMinor,
              paidMinor: document.payment.paidMinor,
              remainingMinor: document.payment.remainingMinor,
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
              branding: document.branding,
              generatedDateText: document.generatedDateText,
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

Future<InvoiceGarmentBlockData> _renderGarmentBlock({
  required InvoiceDocumentGarment garment,
}) async {
  pw.ImageProvider? referenceProvider;
  if (garment.referenceDesign.hasImage) {
    referenceProvider = await loadCatalogReferenceImageProvider(
      garment.referenceDesign.catalogImagePath,
    );
  }

  final shapeRenders = <InvoicePdfShapeRenderData>[];
  for (final shape in garment.shapes) {
    pw.ImageProvider? image;
    if (shape.imageRef.isNotEmpty) {
      image = await loadInvoiceShapeImageProvider(shape.imageRef);
    }
    shapeRenders.add(
      InvoicePdfShapeRenderData(shape: shape, imageProvider: image),
    );
  }

  return InvoiceGarmentBlockData(
    title: garment.title,
    priceLabel: garment.priceLabel,
    measurementRows: garment.measurementRows,
    referenceDesign: garment.referenceDesign,
    referenceImageProvider: referenceProvider,
    shapes: shapeRenders,
    styleName: garment.styleName,
    styleSummary: garment.styleSummary,
    fabricLines: garment.fabricLines,
    catalogLines: garment.catalogLines,
    notes: garment.notes,
  );
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
  var referenceCount = 0;
  for (final block in garmentBlocks) {
    measurementCount += block.measurementRows.length;
    shapeCount += block.shapes.length;
    if (block.referenceDesign.hasImage) referenceCount++;
  }

  debugPrint(
    'Invoice PDF build: orderId=$orderIdLabel customerId=${customerIdLabel ?? '—'} '
    'garments=${garmentBlocks.length} measurements=$measurementCount '
    'shapes=$shapeCount referenceDesigns=$referenceCount payments=$paymentCount',
  );
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
          documentDirection: textDirection,
        ),
      ],
    ),
  );
}
