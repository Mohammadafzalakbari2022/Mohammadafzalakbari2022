import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pride_v3/core/printing/invoice_pdf.dart';
import 'package:pride_v3/core/printing/invoice_pdf_font.dart';
import 'package:pride_v3/core/printing/receipt_branding.dart';
import 'package:pride_v3/data/local/entities/order_status.dart';
import 'package:pride_v3/data/local/order_summary.dart';
import 'package:pride_v3/data/local/payment_summary.dart';
import 'package:pride_v3/features/settings/shop_profile.dart';
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
      styleSummary: 'Qasimi — coat',
    );
  }

  ShopProfile fullShopProfile() {
    return const ShopProfile(
      name: 'Karzai Tailoring',
      address: 'Karte Char, District 4, Kabul',
      phone: '0700123456',
      receiptThankYouMessage: 'Thank you for trusting our craft!',
    );
  }

  test('Invoice PDF fonts load from assets', () async {
    final fonts = await InvoicePdfFonts.load();
    expect(fonts.regular, isNotNull);
    expect(fonts.bold, isNotNull);
  });

  test('ReceiptBranding includes shop phone and thank-you from profile', () {
    final branding = ReceiptBranding.fromShop(
      shop: fullShopProfile(),
      l10n: l10nEn,
      wrapChars: 56,
    );
    expect(branding.shopPhoneRaw, '0700123456');
    expect(branding.shopDisplayName, 'Karzai Tailoring');
    expect(branding.thankYouLines.join(' '), contains('Thank you for trusting'));
    expect(branding.addressLines, isNotEmpty);
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

  test('buildOrderInvoicePdf with full shop profile and payments', () async {
    final bytes = await buildOrderInvoicePdf(
      l10n: l10nEn,
      shop: fullShopProfile(),
      order: sampleOrder(phone: '0700999888'),
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
      textDirection: pw.TextDirection.ltr,
    );
    expect(bytes.length, greaterThan(12000));
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
