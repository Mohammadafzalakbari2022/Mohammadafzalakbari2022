import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pride_v3/core/printing/invoice_pdf.dart';
import 'package:pride_v3/core/printing/invoice_pdf_font.dart';
import 'package:pride_v3/data/local/entities/order_status.dart';
import 'package:pride_v3/data/local/order_summary.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppLocalizations l10nFa;
  late AppLocalizations l10nEn;

  setUp(() async {
    l10nFa = lookupAppLocalizations(const Locale('fa'));
    l10nEn = lookupAppLocalizations(const Locale('en'));
  });

  OrderSummary sampleOrder({String? phone, String measurements = ''}) {
    final now = DateTime(2026, 5, 17);
    return OrderSummary(
      shopId: 'shop-1',
      internalId: 'order-1',
      displayOrderNo: '00000042',
      customerInternalId: 'cust-1',
      customerName: 'Ahmad',
      customerPhone: phone,
      measurementsSnapshot: measurements,
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

  test('Vazirmatn fonts load from assets', () async {
    final fonts = await InvoicePdfFonts.load();
    expect(fonts.regular, isNotNull);
    expect(fonts.bold, isNotNull);
  });

  test('buildOrderInvoicePdf renders Persian labels (fa)', () async {
    final bytes = await buildOrderInvoicePdf(
      l10n: l10nFa,
      shop: null,
      order: sampleOrder(
        phone: '0700123456',
        measurements: 'قد: 88 cm\nسینه: 44 cm',
      ),
      payments: const [],
      deliveryDateText: '1404/02/27',
      statusText: 'در حال دوخت',
      textDirection: pw.TextDirection.rtl,
    );
    expect(bytes.length, greaterThan(8000));
  });

  test('buildOrderInvoicePdf succeeds in English LTR', () async {
    final bytes = await buildOrderInvoicePdf(
      l10n: l10nEn,
      shop: null,
      order: sampleOrder(),
      payments: const [],
      deliveryDateText: '2026-05-17',
      statusText: 'In progress',
      textDirection: pw.TextDirection.ltr,
    );
    expect(bytes, isNotEmpty);
  });

  test('buildOrderInvoicePdf succeeds without shop or phone', () async {
    final bytes = await buildOrderInvoicePdf(
      l10n: l10nFa,
      shop: null,
      order: sampleOrder(),
      payments: const [],
      deliveryDateText: '1404/02/27',
      statusText: 'In progress',
      textDirection: pw.TextDirection.rtl,
    );
    expect(bytes, isNotEmpty);
  });
}
