import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/data/local/entities/garment_type.dart';
import 'package:pride_v3/data/local/entities/order_status.dart';
import 'package:pride_v3/data/local/order_item_summary.dart';
import 'package:pride_v3/data/local/order_summary.dart';
import 'package:pride_v3/features/orders/order_composer_reference.dart';
import 'package:pride_v3/features/orders/order_garment_summary.dart';
import 'package:pride_v3/l10n/app_localizations_en.dart';

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
    totalAmountMinor: 3000,
    paidAmountMinor: 0,
  );
}

OrderItemSummary _item({
  required GarmentType type,
  int price = 1000,
  String styleName = '',
}) {
  final now = DateTime(2026, 6, 1);
  return OrderItemSummary(
    internalId: 'item-${type.apiKey}',
    orderInternalId: 'order-1',
    garmentType: type,
    sortOrder: type.defaultSortOrder,
    priceAmountMinor: price,
    styleName: styleName,
    createdAt: now,
    updatedAt: now,
  );
}

void main() {
  test('paymentBreakdownFromOrder sums item prices', () {
    final order = _minimalOrder(
      items: [
        _item(type: GarmentType.perahanTunban, price: 2000),
        _item(type: GarmentType.waistcoat, price: 1000),
      ],
    );
    final breakdown = paymentBreakdownFromOrder(order);
    expect(breakdown.length, 2);
    expect(breakdown[0].amountMinor, 2000);
    expect(breakdown[1].amountMinor, 1000);
  });

  test('orderGarmentSummaryLabel maps combined key', () {
    final l10n = AppLocalizationsEn();
    final order = _minimalOrder(
      items: [
        _item(type: GarmentType.perahanTunban, price: 2000),
        _item(type: GarmentType.waistcoat, price: 1000),
      ],
    );
    expect(orderGarmentSummaryLabel(l10n, order), l10n.ordersGarmentSummaryBoth);
  });

  test('referenceOrderItem resolves waistcoat line from items', () {
    final item = _item(type: GarmentType.waistcoat, styleName: 'Waskat');
    final order = _minimalOrder(items: [item]);
    expect(referenceOrderItem(order, GarmentType.waistcoat)?.styleName, 'Waskat');
    expect(buildItemStyleCopy(item)?.styleName, 'Waskat');
  });
}
