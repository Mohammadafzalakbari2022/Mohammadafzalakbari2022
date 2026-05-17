import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pride_v3/core/printing/invoice_pdf.dart';
import 'package:pride_v3/data/local/entities/order_status.dart';
import 'package:pride_v3/data/local/order_summary.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppLocalizations l10n;

  setUp(() async {
    l10n = lookupAppLocalizations(const Locale('fa'));
  });

  OrderSummary sampleOrder({String? phone}) {
    final now = DateTime(2026, 5, 17);
    return OrderSummary(
      shopId: 'shop-1',
      internalId: 'order-1',
      displayOrderNo: '00000042',
      customerInternalId: 'cust-1',
      customerName: 'Ahmad',
      customerPhone: phone,
      status: OrderLocalStatus.inProgress,
      deliveryDate: now,
      createdAt: now,
      updatedAt: now,
      totalAmountMinor: 500000,
      paidAmountMinor: 200000,
      fabricNameSnapshot: 'Cotton',
      fabricColorSnapshot: 'Navy',
      fabricIdSnapshot: '042817',
    );
  }

  test('buildOrderInvoicePdf succeeds without shop or phone', () async {
    final bytes = await buildOrderInvoicePdf(
      l10n: l10n,
      shop: null,
      order: sampleOrder(),
      payments: const [],
      deliveryDateText: '1404/02/27',
      statusText: 'In progress',
      textDirection: pw.TextDirection.rtl,
    );
    expect(bytes, isNotEmpty);
  });

  test('buildOrderInvoicePdf succeeds with fabric fields', () async {
    final bytes = await buildOrderInvoicePdf(
      l10n: l10n,
      shop: null,
      order: sampleOrder(),
      payments: const [],
      deliveryDateText: '1404/02/27',
      statusText: 'In progress',
      textDirection: pw.TextDirection.rtl,
    );
    expect(bytes, isNotEmpty);
  });

  test('buildOrderInvoicePdf succeeds with customer phone', () async {
    final bytes = await buildOrderInvoicePdf(
      l10n: l10n,
      shop: null,
      order: sampleOrder(phone: '0700123456'),
      payments: const [],
      deliveryDateText: '1404/02/27',
      statusText: 'In progress',
      textDirection: pw.TextDirection.rtl,
    );
    expect(bytes, isNotEmpty);
  });
}
