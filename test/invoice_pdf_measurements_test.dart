import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import 'package:pride_v3/core/printing/invoice_pdf_measurements.dart';
import 'package:pride_v3/data/local/entities/order_status.dart';
import 'package:pride_v3/data/local/order_summary.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

void main() {
  late AppLocalizations l10nEn;

  setUp(() {
    l10nEn = lookupAppLocalizations(const Locale('en'));
  });

  test('invoiceMeasurementRows parses snapshot lines', () {
    final order = OrderSummary(
      shopId: 's',
      internalId: 'o',
      displayOrderNo: '00000001',
      customerInternalId: 'c',
      customerName: 'Test',
      measurementsSnapshot: 'Chest: 44 cm\nLength: 88 cm',
      status: OrderLocalStatus.inProgress,
      deliveryDate: DateTime(2026, 1, 1),
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
      totalAmountMinor: 0,
      paidAmountMinor: 0,
    );

    final rows = invoiceMeasurementRows(l10n: l10nEn, order: order);
    expect(rows.length, 2);
    expect(rows.first.label, 'Chest');
    expect(rows.first.value, contains('44'));
  });
}
