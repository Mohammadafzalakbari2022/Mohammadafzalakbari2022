import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/data/local/entities/garment_type.dart';
import 'package:pride_v3/data/local/entities/order_status.dart';
import 'package:pride_v3/data/local/order_item_summary.dart';
import 'package:pride_v3/data/local/order_summary.dart';
import 'package:pride_v3/features/orders/order_composer_draft.dart';
import 'package:pride_v3/features/orders/order_composer_reference.dart';

void main() {
  OrderSummary referenceOrder({
    required String id,
    List<OrderItemSummary> items = const [],
  }) {
    return OrderSummary(
      shopId: 'shop-1',
      internalId: id,
      displayOrderNo: '00000010',
      customerInternalId: 'cust-1',
      customerName: 'Ahmad',
      status: OrderLocalStatus.inProgress,
      deliveryDate: DateTime(2026, 6, 15),
      createdAt: DateTime(2026, 6, 1),
      updatedAt: DateTime(2026, 6, 1),
      totalAmountMinor: 800000,
      paidAmountMinor: 0,
      items: items,
    );
  }

  OrderItemSummary perahanItem({
    int price = 500000,
    int clothPrice = 120000,
  }) {
    return OrderItemSummary(
      internalId: 'item-p',
      orderInternalId: 'ord-ref',
      garmentType: GarmentType.perahanTunban,
      priceAmountMinor: price,
      measurementsSnapshot: 'Chest 98',
      styleName: 'Classic',
      styleSummary: 'Classic cut',
      fabricNameSnapshot: 'Wool',
      fabricColorSnapshot: 'Gray',
      clothMetersSnapshot: '3.5',
      clothPriceAmountMinor: clothPrice,
      createdAt: DateTime(2026, 6, 1),
      updatedAt: DateTime(2026, 6, 1),
    );
  }

  group('buildReferencePrefillGarmentData', () {
    test('copies included garments with cloth and price', () {
      final ref = referenceOrder(
        id: 'ord-ref',
        items: [perahanItem()],
      );
      final data = buildReferencePrefillGarmentData(
        ref,
        catalogItemExists: (_) => false,
      );
      final perahan = data[GarmentType.perahanTunban]!;
      expect(perahan.included, isTrue);
      expect(perahan.draft.priceAmountMinor, 500000);
      expect(perahan.draft.clothPriceAmountMinor, 120000);
      expect(perahan.draft.fabricName, 'Wool');
      expect(perahan.draft.measurementsSnapshot, 'Chest 98');
      expect(data[GarmentType.waistcoat]!.included, isFalse);
    });

    test('enables both garments when reference has both', () {
      final ref = referenceOrder(
        id: 'ord-ref',
        items: [
          perahanItem(price: 400000),
          OrderItemSummary(
            internalId: 'item-w',
            orderInternalId: 'ord-ref',
            garmentType: GarmentType.waistcoat,
            priceAmountMinor: 200000,
            createdAt: DateTime(2026, 6, 1),
            updatedAt: DateTime(2026, 6, 1),
          ),
        ],
      );
      final data = buildReferencePrefillGarmentData(
        ref,
        catalogItemExists: (_) => false,
      );
      expect(data[GarmentType.perahanTunban]!.included, isTrue);
      expect(data[GarmentType.waistcoat]!.included, isTrue);
      expect(garmentTypesOnReferenceOrder(ref).length, 2);
    });
  });

  group('OrderComposerDraft cloth payment gating', () {
    test('cloth price excluded when cloth block disabled', () {
      var draft = OrderComposerDraft.initial();
      draft = draft.updateItem(
        GarmentType.perahanTunban,
        draft.items[GarmentType.perahanTunban]!.copyWith(
          priceAmountMinor: 400000,
          clothPriceAmountMinor: 100000,
        ),
      );
      expect(draft.totalMinor(clothBlockEnabled: true), 500000);
      expect(draft.totalMinor(clothBlockEnabled: false), 400000);
      expect(
        draft.clothPaymentLines(clothBlockEnabled: true),
        hasLength(1),
      );
      expect(
        draft.clothPaymentLines(clothBlockEnabled: false),
        isEmpty,
      );
    });

    test('no cloth payment line without cloth price', () {
      var draft = OrderComposerDraft.initial();
      draft = draft.updateItem(
        GarmentType.perahanTunban,
        draft.items[GarmentType.perahanTunban]!.copyWith(
          priceAmountMinor: 400000,
          clothMeters: '3.5',
          clothPriceAmountMinor: 0,
        ),
      );
      expect(draft.totalMinor(clothBlockEnabled: true), 400000);
      expect(draft.clothPaymentLines(clothBlockEnabled: true), isEmpty);
    });
  });

  group('OrderComposerDraft.totalMinor cloth price', () {
    test('includes cloth price when enabled and priced', () {
      var draft = OrderComposerDraft.initial();
      draft = draft.updateItem(
        GarmentType.perahanTunban,
        draft.items[GarmentType.perahanTunban]!.copyWith(
          included: true,
          priceAmountMinor: 400000,
          clothPriceAmountMinor: 100000,
        ),
      );
      expect(draft.totalMinor(clothBlockEnabled: true), 500000);
    });

    test('sums garment and cloth across multiple items', () {
      var draft = OrderComposerDraft.initial().toggleGarment(
        GarmentType.waistcoat,
        true,
      );
      draft = draft
          .updateItem(
            GarmentType.perahanTunban,
            draft.items[GarmentType.perahanTunban]!.copyWith(
              priceAmountMinor: 300000,
              clothPriceAmountMinor: 50000,
            ),
          )
          .updateItem(
            GarmentType.waistcoat,
            draft.items[GarmentType.waistcoat]!.copyWith(
              priceAmountMinor: 200000,
              clothPriceAmountMinor: 25000,
            ),
          );
      expect(draft.totalMinor(clothBlockEnabled: true), 575000);
    });
  });
}
