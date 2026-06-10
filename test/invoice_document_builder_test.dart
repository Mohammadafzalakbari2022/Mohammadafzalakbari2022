import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/core/printing/invoice/invoice_document_builder.dart';
import 'package:pride_v3/data/local/entities/order_status.dart';
import 'package:pride_v3/data/local/order_summary.dart';
import 'package:pride_v3/data/local/payment_summary.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

void main() {
  late AppLocalizations l10nEn;

  setUp(() async {
    l10nEn = lookupAppLocalizations(const Locale('en'));
  });

  test('buildInvoiceDocument resolves customer, garments, and payment ledger', () async {
    final order = OrderSummary(
      shopId: 'shop-1',
      internalId: 'order-1',
      displayOrderNo: '00000042',
      customerInternalId: 'cust-1',
      customerName: 'Ahmad',
      customerPhone: '0700123456',
      measurementsSnapshot: 'Chest: 102 cm\nShoulder: 58 cm',
      status: OrderLocalStatus.inProgress,
      deliveryDate: DateTime(2026, 5, 20),
      createdAt: DateTime(2026, 5, 17),
      updatedAt: DateTime(2026, 5, 17),
      totalAmountMinor: 500000,
      paidAmountMinor: 200000,
      styleSummary: 'Qasimi coat',
      catalogDesignNameSnapshot: 'Royal coat',
    );

    final document = await buildInvoiceDocument(
      l10n: l10nEn,
      shop: null,
      order: order,
      payments: [
        PaymentSummary(
          internalId: 'pay-1',
          orderInternalId: 'order-1',
          amountMinor: 200000,
          method: 'Cash',
          isAdjustment: false,
          createdAt: DateTime(2026, 5, 17),
        ),
      ],
      deliveryDateText: '2026-05-20',
      statusText: 'In progress',
      createdDateText: '2026-05-17',
      generatedDateText: '2026-05-17',
      customerDisplayNo: '00000007',
    );

    expect(document.customer.name, 'Ahmad');
    expect(document.customerIdLabel, isNotNull);
    expect(document.garments, isNotEmpty);
    expect(document.garments.first.measurementRows.length, greaterThan(0));
    expect(document.payment.ledger, hasLength(1));
    expect(document.payment.ledger.first.method, 'Cash');
  });

  test('reference design uses catalog snapshot only on garment block', () async {
    final order = OrderSummary(
      shopId: 'shop-1',
      internalId: 'order-2',
      displayOrderNo: '00000043',
      customerInternalId: 'cust-1',
      customerName: 'Sara',
      measurementsSnapshot: '',
      status: OrderLocalStatus.inProgress,
      deliveryDate: DateTime(2026, 5, 20),
      createdAt: DateTime(2026, 5, 17),
      updatedAt: DateTime(2026, 5, 17),
      totalAmountMinor: 100000,
      paidAmountMinor: 0,
      catalogDesignNameSnapshot: 'Evening dress',
      catalogImagePathSnapshot: '/tmp/design.jpg',
    );

    final document = await buildInvoiceDocument(
      l10n: l10nEn,
      shop: null,
      order: order,
      payments: const [],
      deliveryDateText: '2026-05-20',
      statusText: 'In progress',
      createdDateText: '2026-05-17',
      generatedDateText: '2026-05-17',
    );

    final ref = document.garments.first.referenceDesign;
    expect(ref.designName, 'Evening dress');
    expect(ref.catalogImagePath, '/tmp/design.jpg');
  });
}
