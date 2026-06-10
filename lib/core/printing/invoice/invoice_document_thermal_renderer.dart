import 'package:image/image.dart' as img;

import '../../../features/reports/report_money_format.dart';
import '../../../l10n/app_localizations.dart';
import '../invoice_payment_labels.dart';
import '../receipt_safe_text.dart';
import '../style_figure_raster.dart';
import 'invoice_document_model.dart';
import '../thermal_receipt_escpos.dart';

/// Maps [InvoiceDocumentModel] to thermal ESC/POS content (data parity with PDF).
Future<OrderReceiptEscPosContent> renderThermalReceiptContent({
  required AppLocalizations l10n,
  required InvoiceDocumentModel document,
  required String deliveryDateText,
  required String statusText,
  required int paperWidthPx,
  img.Image? headerLogo,
  String Function(DateTime dateTime)? formatPaymentDate,
}) async {
  final branding = document.branding;
  final phone = document.customer.phone.trim();
  final figureThumbWidth = (paperWidthPx * 0.42).round().clamp(80, paperWidthPx);

  final paymentRows = <String>[];
  for (final row in document.payment.ledger) {
    final amt = reportFormatMoney(l10n, row.amountMinor);
    final method = formatInvoicePaymentMethod(l10n, row.method);
    final dateText = formatPaymentDate?.call(row.createdAt) ??
        _fallbackPaymentDate(row.createdAt);
    paymentRows.add(receiptLatin1Safe('$dateText  $method  $amt'));
  }

  final garmentSections = <ThermalGarmentSection>[];
  String? measurementsLine;
  String? styleLine;
  String? catalogDesignLine;
  String? fabricLine;
  List<ReceiptStyleFigure> styleFigures = const [];

  if (document.garments.length > 1) {
    for (final garment in document.garments) {
      garmentSections.add(
        await _thermalGarmentSection(
          l10n: l10n,
          garment: garment,
          figureThumbWidth: figureThumbWidth,
        ),
      );
    }
  } else if (document.garments.isNotEmpty) {
    final garment = document.garments.first;
    measurementsLine = _measurementsLine(l10n, garment);
    styleLine = _styleLine(l10n, garment);
    catalogDesignLine = _catalogDesignLine(l10n, garment);
    fabricLine = _fabricLine(l10n, garment);
    styleFigures = await _thermalStyleFigures(
      garment: garment,
      figureThumbWidth: figureThumbWidth,
    );
  }

  final total = reportFormatMoney(l10n, document.payment.grandTotalMinor);
  final paid = reportFormatMoney(l10n, document.payment.paidMinor);
  final balance = reportFormatMoney(l10n, document.payment.remainingMinor);

  return OrderReceiptEscPosContent(
    headerLogo: headerLogo,
    shopLine: branding.shopDisplayName,
    shopPhoneLine: branding.shopPhoneLine,
    shopAddressLines: branding.addressLines,
    customerIdLine: document.customerIdLabel,
    customerLine: '${l10n.receiptCustomerLabel}: ${document.customer.name}',
    orderLine: document.orderIdLabel,
    phoneLine: phone.isNotEmpty ? '${l10n.receiptPhoneLabel}: $phone' : null,
    deliveryLine: '${l10n.receiptDeliveryLabel}: $deliveryDateText',
    statusLine: '${l10n.receiptStatusLabel}: $statusText',
    measurementsLine: measurementsLine,
    styleLine: styleLine,
    catalogDesignLine: catalogDesignLine,
    fabricLine: fabricLine,
    styleFigures: styleFigures,
    garmentSections: garmentSections,
    internalNotesLine: document.internalNotes.isEmpty
        ? null
        : '${l10n.receiptInternalNotesHeader}:\n${document.internalNotes}',
    totalLine: '${l10n.receiptTotalLabel}: $total',
    paidLine: '${l10n.receiptPaidLabel}: $paid',
    balanceLine: '${l10n.receiptBalanceLabel}: $balance',
    paymentHeader: l10n.receiptPaymentsHeader,
    paymentRows: paymentRows,
    footerAddressLines: branding.addressLines,
    footerThankYouLines: branding.thankYouLines,
  );
}

Future<ThermalGarmentSection> _thermalGarmentSection({
  required AppLocalizations l10n,
  required InvoiceDocumentGarment garment,
  required int figureThumbWidth,
}) async {
  return ThermalGarmentSection(
    garmentLabel: garment.title,
    priceLine: garment.priceLabel.isEmpty
        ? null
        : '${l10n.ordersComposerItemPriceLabel}: ${garment.priceLabel}',
    measurementsLine: _measurementsLine(l10n, garment),
    styleLine: _styleLine(l10n, garment),
    catalogDesignLine: _catalogDesignLine(l10n, garment),
    fabricLine: _fabricLine(l10n, garment),
    styleFigures: await _thermalStyleFigures(
      garment: garment,
      figureThumbWidth: figureThumbWidth,
    ),
  );
}

String? _measurementsLine(AppLocalizations l10n, InvoiceDocumentGarment garment) {
  if (garment.measurementRows.isEmpty) return null;
  final body = garment.measurementRows
      .map((r) => '${r.label}: ${r.value}')
      .join('\n');
  return '${l10n.receiptMeasurementsLabel}:\n$body';
}

String? _styleLine(AppLocalizations l10n, InvoiceDocumentGarment garment) {
  final parts = <String>[];
  if (garment.styleName.isNotEmpty) {
    parts.add('${l10n.invoiceStyleNameLabel}: ${garment.styleName}');
  }
  if (garment.styleSummary.isNotEmpty) {
    parts.add(garment.styleSummary);
  }
  if (parts.isEmpty) return null;
  final body = parts.join('\n');
  return body.contains('\n')
      ? '${l10n.receiptStyleLabel}:\n$body'
      : '${l10n.receiptStyleLabel}: $body';
}

String? _catalogDesignLine(AppLocalizations l10n, InvoiceDocumentGarment garment) {
  final name = garment.referenceDesign.designName.isNotEmpty
      ? garment.referenceDesign.designName
      : (garment.catalogLines.isNotEmpty ? garment.catalogLines.first : '');
  if (name.isEmpty) return null;
  return '${l10n.receiptCatalogDesignLabel}: $name';
}

String? _fabricLine(AppLocalizations l10n, InvoiceDocumentGarment garment) {
  if (garment.fabricLines.isEmpty) return null;
  return '${l10n.receiptFabricLabel}:\n${garment.fabricLines.join('\n')}';
}

Future<List<ReceiptStyleFigure>> _thermalStyleFigures({
  required InvoiceDocumentGarment garment,
  required int figureThumbWidth,
}) async {
  final figures = <ReceiptStyleFigure>[];
  for (final shape in garment.shapes) {
    img.Image? image;
    if (shape.imageRef.isNotEmpty) {
      image = await loadStyleFigureRaster(
        imageRef: shape.imageRef,
        maxWidthPx: figureThumbWidth,
      );
    }
    final detailText = shape.detailRows
        .map((r) => '${r.label}: ${r.value}')
        .join(' · ');
    final nameParts = <String>[shape.shapeName];
    if (detailText.isNotEmpty) nameParts.add(detailText);
    if (shape.note.isNotEmpty) nameParts.add(shape.note);
    figures.add(
      ReceiptStyleFigure(
        image: image,
        name: nameParts.where((p) => p.trim().isNotEmpty).join('\n'),
      ),
    );
  }
  return figures;
}

String _fallbackPaymentDate(DateTime dt) {
  final y = dt.year.toString().padLeft(4, '0');
  final m = dt.month.toString().padLeft(2, '0');
  final d = dt.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}
