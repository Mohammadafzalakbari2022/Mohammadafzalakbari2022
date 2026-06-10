import '../../../data/local/payment_summary.dart';
import '../invoice_pdf_measurements.dart';
import '../receipt_branding.dart';

/// One label/value row on a shape (text option, inch option, etc.).
class InvoiceDocumentShapeDetailRow {
  const InvoiceDocumentShapeDetailRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;
}

/// Style figure for invoice output (image loaded at render time via [imageRef]).
class InvoiceDocumentShape {
  const InvoiceDocumentShape({
    required this.shapeName,
    this.imageRef = '',
    this.detailRows = const [],
    this.note = '',
  });

  final String shapeName;
  final String imageRef;
  final List<InvoiceDocumentShapeDetailRow> detailRows;
  final String note;

  bool get isEmpty =>
      shapeName.isEmpty && imageRef.isEmpty && detailRows.isEmpty && note.isEmpty;
}

/// Catalog design photo shown large in the reference-design section.
class InvoiceDocumentReferenceDesign {
  const InvoiceDocumentReferenceDesign({
    this.catalogImagePath,
    this.designName = '',
    this.designerShopName = '',
  });

  final String? catalogImagePath;
  final String designName;
  final String designerShopName;

  bool get hasImage =>
      catalogImagePath != null && catalogImagePath!.trim().isNotEmpty;

  bool get hasContent =>
      hasImage || designName.isNotEmpty || designerShopName.isNotEmpty;
}

/// One garment block on the invoice.
class InvoiceDocumentGarment {
  const InvoiceDocumentGarment({
    required this.title,
    required this.priceLabel,
    required this.measurementRows,
    required this.referenceDesign,
    required this.shapes,
    this.styleName = '',
    this.styleSummary = '',
    this.fabricLines = const [],
    this.catalogLines = const [],
    this.notes = '',
  });

  final String title;
  final String priceLabel;
  final List<InvoiceMeasurementRow> measurementRows;
  final InvoiceDocumentReferenceDesign referenceDesign;
  final List<InvoiceDocumentShape> shapes;
  final String styleName;
  final String styleSummary;
  final List<String> fabricLines;
  final List<String> catalogLines;
  final String notes;
}

class InvoiceDocumentCustomer {
  const InvoiceDocumentCustomer({
    required this.name,
    this.phone = '',
    this.displayIdLabel,
  });

  final String name;
  final String phone;
  final String? displayIdLabel;
}

class InvoiceDocumentPaymentLedgerRow {
  const InvoiceDocumentPaymentLedgerRow({
    required this.createdAt,
    required this.method,
    required this.amountMinor,
  });

  final DateTime createdAt;
  final String method;
  final int amountMinor;
}

class InvoiceDocumentPayment {
  const InvoiceDocumentPayment({
    required this.garmentTotalMinor,
    required this.grandTotalMinor,
    required this.paidMinor,
    required this.remainingMinor,
    required this.ledger,
  });

  final int garmentTotalMinor;
  final int grandTotalMinor;
  final int paidMinor;
  final int remainingMinor;
  final List<InvoiceDocumentPaymentLedgerRow> ledger;

  factory InvoiceDocumentPayment.fromSummaries({
    required int garmentTotalMinor,
    required int grandTotalMinor,
    required int paidMinor,
    required int remainingMinor,
    required List<PaymentSummary> payments,
  }) {
    return InvoiceDocumentPayment(
      garmentTotalMinor: garmentTotalMinor,
      grandTotalMinor: grandTotalMinor,
      paidMinor: paidMinor,
      remainingMinor: remainingMinor,
      ledger: [
        for (final p in payments)
          InvoiceDocumentPaymentLedgerRow(
            createdAt: p.createdAt,
            method: p.method,
            amountMinor: p.amountMinor,
          ),
      ],
    );
  }
}

/// Shared invoice document — single source for PDF and thermal renderers.
class InvoiceDocumentModel {
  const InvoiceDocumentModel({
    required this.branding,
    required this.orderIdLabel,
    required this.statusText,
    required this.createdDateText,
    required this.deliveryDateText,
    required this.generatedDateText,
    required this.customer,
    required this.garments,
    required this.payment,
    this.customerIdLabel,
    this.internalNotes = '',
    this.logoRelativePath,
    this.bannerRelativePath,
  });

  final ReceiptBranding branding;
  final String orderIdLabel;
  final String? customerIdLabel;
  final String statusText;
  final String createdDateText;
  final String deliveryDateText;
  final String generatedDateText;
  final InvoiceDocumentCustomer customer;
  final List<InvoiceDocumentGarment> garments;
  final InvoiceDocumentPayment payment;
  final String internalNotes;
  final String? logoRelativePath;
  final String? bannerRelativePath;
}
