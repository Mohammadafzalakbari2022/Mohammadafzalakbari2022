import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/data/local/entities/order_status.dart';
import 'package:pride_v3/data/local/entities/garment_type.dart';
import 'package:pride_v3/data/local/order_item_summary.dart';
import 'package:pride_v3/data/local/order_measurement_snapshot_view.dart';
import 'package:pride_v3/data/local/order_summary.dart';
import 'package:pride_v3/features/orders/order_composer_reference.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

void main() {
  late AppLocalizations l10nEn;

  setUp(() {
    l10nEn = lookupAppLocalizations(const Locale('en'));
  });

  OrderSummary sampleOrder({
    required String internalId,
    required DateTime createdAt,
    String customerId = 'cust-1',
    String measurements = '',
    String styleName = '',
    String styleSummary = '',
    String fabricName = '',
    String fabricColor = '',
    String fabricId = '',
    String catalogDesign = '',
    int totalAmountMinor = 500000,
    int paidAmountMinor = 200000,
  }) {
    return OrderSummary(
      shopId: 'shop-1',
      internalId: internalId,
      displayOrderNo: '00000010',
      customerInternalId: customerId,
      customerName: 'Ahmad Khan',
      customerPhone: '0700123456',
      measurementsSnapshot: measurements,
      styleName: styleName,
      styleSummary: styleSummary,
      catalogDesignNameSnapshot: catalogDesign,
      fabricNameSnapshot: fabricName,
      fabricColorSnapshot: fabricColor,
      fabricIdSnapshot: fabricId,
      status: OrderLocalStatus.inProgress,
      deliveryDate: DateTime(2026, 6, 15),
      createdAt: createdAt,
      updatedAt: createdAt,
      totalAmountMinor: totalAmountMinor,
      paidAmountMinor: paidAmountMinor,
    );
  }

  group('customerOrdersForReference', () {
    test('filters by customer and sorts newest first', () {
      final orders = [
        sampleOrder(
          internalId: 'o-old',
          createdAt: DateTime(2026, 1, 1),
        ),
        sampleOrder(
          internalId: 'o-new',
          createdAt: DateTime(2026, 6, 1),
        ),
        sampleOrder(
          internalId: 'o-other',
          createdAt: DateTime(2026, 6, 2),
          customerId: 'cust-2',
        ),
      ];
      final result = customerOrdersForReference(orders, 'cust-1');
      expect(result.map((o) => o.internalId).toList(), ['o-new', 'o-old']);
    });

    test('returns empty for unknown customer', () {
      expect(
        customerOrdersForReference(
          [sampleOrder(internalId: 'o1', createdAt: DateTime(2026, 1, 1))],
          'missing',
        ),
        isEmpty,
      );
    });
  });

  group('resolveReferenceOrder', () {
    test('defaults to newest order', () {
      final orders = [
        sampleOrder(internalId: 'o-new', createdAt: DateTime(2026, 6, 1)),
        sampleOrder(internalId: 'o-old', createdAt: DateTime(2026, 1, 1)),
      ];
      final ref = resolveReferenceOrder(orders, null);
      expect(ref?.internalId, 'o-new');
    });

    test('uses explicit override when valid', () {
      final orders = [
        sampleOrder(internalId: 'o-new', createdAt: DateTime(2026, 6, 1)),
        sampleOrder(internalId: 'o-old', createdAt: DateTime(2026, 1, 1)),
      ];
      final ref = resolveReferenceOrder(orders, 'o-old');
      expect(ref?.internalId, 'o-old');
    });

    test('returns null when no orders', () {
      expect(resolveReferenceOrder(const [], null), isNull);
    });
  });

  group('buildMeasurementsCopy', () {
    test('copies snapshot text and structured items', () {
      final snap = OrderMeasurementSnapshotView(
        orderInternalId: 'o1',
        snapshotInternalId: 'snap-1',
        createdAt: DateTime(2026, 1, 1),
        items: const [
          OrderMeasurementSnapshotItemView(
            measurementTypeInternalId: 't1',
            typeName: 'Chest',
            value: '40',
            unitCode: 0,
            sortOrder: 0,
          ),
        ],
      );
      final order = sampleOrder(
        internalId: 'o1',
        createdAt: DateTime(2026, 1, 1),
        measurements: '',
      );
      final copy = buildMeasurementsCopy(order, snap);
      expect(copy, isNotNull);
      expect(copy!.items, hasLength(1));
      expect(copy.items.first.typeName, 'Chest');
      expect(copy.snapshotText, contains('Chest'));
    });

    test('returns null when no measurement data', () {
      final order = sampleOrder(
        internalId: 'o1',
        createdAt: DateTime(2026, 1, 1),
      );
      expect(buildMeasurementsCopy(order, null), isNull);
    });
  });

  group('buildStyleCopy / buildFabricCopy / buildDesignCopy', () {
    test('style copy from order summary', () {
      final order = sampleOrder(
        internalId: 'o1',
        createdAt: DateTime(2026, 1, 1),
        styleName: 'Perahan',
        styleSummary: 'Classic cut',
      );
      final copy = buildStyleCopy(order);
      expect(copy?.styleName, 'Perahan');
      expect(copy?.styleSummary, 'Classic cut');
    });

    test('fabric copy payload has no fabric id field', () {
      final order = sampleOrder(
        internalId: 'o1',
        createdAt: DateTime(2026, 1, 1),
        fabricName: 'Silk',
        fabricColor: 'Blue',
        fabricId: 'FAB-OLD',
      );
      final copy = buildFabricCopy(order);
      expect(copy?.fabricName, 'Silk');
      expect(copy?.fabricColor, 'Blue');
    });

    test('design copy clears catalog id when item missing', () {
      final order = sampleOrder(
        internalId: 'o1',
        createdAt: DateTime(2026, 1, 1),
        catalogDesign: 'Floral A',
      );
      final copy = buildDesignCopy(order, catalogItemExists: false);
      expect(copy?.catalogDesignName, 'Floral A');
      expect(copy?.catalogItemInternalId, isNull);
    });

    test('design snapshot-only copy avoids catalog link', () {
      final order = sampleOrder(
        internalId: 'o1',
        createdAt: DateTime(2026, 1, 1),
        catalogDesign: 'Floral B',
      );
      final copy = buildDesignCopySnapshotOnly(order);
      expect(copy?.catalogDesignName, 'Floral B');
      expect(copy?.catalogItemInternalId, isNull);
    });
  });

  group('composerReferenceShouldShowDiff', () {
    test('detects trimmed differences when current is meaningful', () {
      expect(
        composerReferenceShouldShowDiff(
          current: 'abc',
          previous: 'abc',
          currentIsMeaningful: true,
        ),
        isFalse,
      );
      expect(
        composerReferenceShouldShowDiff(
          current: 'abc',
          previous: 'xyz',
          currentIsMeaningful: true,
        ),
        isTrue,
      );
    });

    test('hides diff when current is empty or placeholder', () {
      expect(
        composerReferenceShouldShowDiff(
          current: 'Add style (required)',
          previous: 'Perahan',
          currentIsMeaningful: false,
        ),
        isFalse,
      );
      expect(
        composerReferenceShouldShowDiff(
          current: '',
          previous: 'Perahan',
          currentIsMeaningful: false,
        ),
        isFalse,
      );
    });
  });

  group('referenceOrderPaymentTotals', () {
    test('uses ledger paid when loaded', () {
      final order = sampleOrder(
        internalId: 'o1',
        createdAt: DateTime(2026, 1, 1),
        paidAmountMinor: 100000,
      );
      final totals = referenceOrderPaymentTotals(
        order: order,
        paidByOrderId: const {'o1': 250000},
        paymentsLedgerLoaded: true,
      );
      expect(totals.paidMinor, 250000);
      expect(totals.remainingMinor, 250000);
    });

    test('falls back to summary paid when ledger not loaded', () {
      final order = sampleOrder(
        internalId: 'o1',
        createdAt: DateTime(2026, 1, 1),
        paidAmountMinor: 150000,
      );
      final totals = referenceOrderPaymentTotals(
        order: order,
        paidByOrderId: const {'o1': 250000},
        paymentsLedgerLoaded: false,
      );
      expect(totals.paidMinor, 150000);
    });

    test('formatReferenceOrderPaymentSummary matches ledger totals', () {
      final order = sampleOrder(
        internalId: 'o1',
        createdAt: DateTime(2026, 1, 1),
        totalAmountMinor: 500000,
        paidAmountMinor: 0,
      );
      final paidByOrderId = referencePaidByOrderIdFromPayments([
        (orderInternalId: 'o1', amountMinor: 200000),
      ]);
      final text = formatReferenceOrderPaymentSummary(
        l10nEn,
        order,
        paidByOrderId,
        true,
        (_, minor) => '$minor',
      );
      expect(text, contains('200000'));
      expect(text, contains('300000'));
    });
  });

  group('buildItemFabricCopy', () {
    test('includes cloth meters and price from item summary', () {
      final item = OrderItemSummary(
        internalId: 'item-1',
        orderInternalId: 'o1',
        garmentType: GarmentType.perahanTunban,
        fabricNameSnapshot: 'Wool',
        fabricColorSnapshot: 'Gray',
        clothMetersSnapshot: '3.5',
        clothPriceAmountMinor: 120000,
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
      );
      final copy = buildItemFabricCopy(item);
      expect(copy?.fabricName, 'Wool');
      expect(copy?.clothMeters, '3.5');
      expect(copy?.clothPriceAmountMinor, 120000);
    });
  });

  group('previousFabricDisplayText', () {
    test('formats fabric summary for display', () {
      final order = sampleOrder(
        internalId: 'o1',
        createdAt: DateTime(2026, 1, 1),
        fabricName: 'Wool',
        fabricColor: 'Gray',
        fabricId: 'F123',
      );
      final text = previousFabricDisplayText(order, l10nEn);
      expect(text, contains('Wool'));
      expect(text, contains('Gray'));
      expect(text, contains('F123'));
    });
  });
}
