import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/data/local/entities/garment_type.dart';
import 'package:pride_v3/data/local/entities/order_status.dart';
import 'package:pride_v3/data/local/order_item_draft.dart';
import 'package:pride_v3/data/local/order_item_summary.dart';
import 'package:pride_v3/data/local/order_summary.dart';

OrderSummary _minimalOrder({List<OrderItemSummary> items = const []}) {
  final now = DateTime(2026, 6, 1);
  return OrderSummary(
    shopId: 'shop-1',
    internalId: 'order-1',
    displayOrderNo: '00000001',
    customerInternalId: 'cust-1',
    customerName: 'Test Customer',
    items: items,
    status: OrderLocalStatus.newOrder,
    deliveryDate: now,
    createdAt: now,
    updatedAt: now,
    totalAmountMinor: 2000,
    paidAmountMinor: 500,
  );
}

OrderItemSummary _item({
  required GarmentType type,
  int price = 1000,
  int sortOrder = 0,
}) {
  final now = DateTime(2026, 6, 1);
  return OrderItemSummary(
    internalId: 'item-${type.apiKey}',
    orderInternalId: 'order-1',
    garmentType: type,
    sortOrder: sortOrder,
    priceAmountMinor: price,
    createdAt: now,
    updatedAt: now,
  );
}

void main() {
  group('OrderItemSummary', () {
    test('type and content helpers', () {
      final perahan = _item(type: GarmentType.perahanTunban, price: 1200)
          .copyWith(styleName: 'Qasimi');
      expect(perahan.isPerahanTunban, isTrue);
      expect(perahan.isWaistcoat, isFalse);
      expect(perahan.hasPrice, isTrue);
      expect(perahan.hasStyle, isTrue);
      expect(perahan.hasFabric, isFalse);
      expect(perahan.hasCatalogDesign, isFalse);
    });

    test('sorted places Perahan/Tunban before Waistcoat', () {
      final waistcoat = _item(
        type: GarmentType.waistcoat,
        sortOrder: 0,
        price: 800,
      );
      final perahan = _item(
        type: GarmentType.perahanTunban,
        sortOrder: 0,
        price: 1200,
      );
      final sorted = OrderItemSummary.sorted([waistcoat, perahan]);
      expect(sorted.first.garmentType, GarmentType.perahanTunban);
      expect(sorted.last.garmentType, GarmentType.waistcoat);
    });
  });

  group('OrderItemDraft', () {
    test('empty factory defaults Perahan/Tunban included', () {
      final perahan = OrderItemDraft.empty(GarmentType.perahanTunban);
      expect(perahan.included, isTrue);
      expect(perahan.canSaveBasic, isFalse);

      final waistcoat = OrderItemDraft.empty(GarmentType.waistcoat);
      expect(waistcoat.included, isFalse);
      expect(waistcoat.canSaveBasic, isTrue);
    });

    test('hasAnyContent and canSaveBasic', () {
      final draft = OrderItemDraft.empty(GarmentType.waistcoat)
          .copyWith(included: true, priceAmountMinor: 800, styleName: 'Vest');
      expect(draft.hasAnyContent, isTrue);
      expect(draft.hasRequiredPrice, isTrue);
      expect(draft.canSaveBasic, isTrue);
    });
  });

  group('OrderSummary item helpers', () {
    test('itemOf and garment flags', () {
      final order = _minimalOrder(items: [
        _item(type: GarmentType.perahanTunban, price: 1200),
        _item(type: GarmentType.waistcoat, price: 800),
      ]);
      expect(order.hasPerahanTunban, isTrue);
      expect(order.hasWaistcoat, isTrue);
      expect(order.hasMultipleGarments, isTrue);
      expect(
        order.itemOf(GarmentType.waistcoat)?.priceAmountMinor,
        800,
      );
      expect(order.itemPriceTotalAmountMinor, 2000);
      expect(order.garmentSummaryKey, 'perahan_tunban+waistcoat');
    });

    test('legacyPerahanTunbanItemView from flat fields', () {
      final now = DateTime(2026, 6, 1);
      final order = OrderSummary(
        shopId: 'shop-1',
        internalId: 'order-legacy',
        displayOrderNo: '00000002',
        customerInternalId: 'cust-1',
        customerName: 'Legacy',
        styleName: 'Classic',
        measurementsSnapshot: 'Chest: 40',
        totalAmountMinor: 1500,
        status: OrderLocalStatus.newOrder,
        deliveryDate: now,
        createdAt: now,
        updatedAt: now,
        paidAmountMinor: 0,
      );
      expect(order.items, isEmpty);
      expect(order.hasPerahanTunban, isFalse);
      final view = order.legacyPerahanTunbanItemView();
      expect(view, isNotNull);
      expect(view!.garmentType, GarmentType.perahanTunban);
      expect(view.styleName, 'Classic');
      expect(view.priceAmountMinor, 1500);
    });

    test('empty items defaults garmentSummaryKey to perahan_tunban', () {
      expect(_minimalOrder().garmentSummaryKey, kGarmentTypePerahanTunbanApiKey);
    });
  });
}
