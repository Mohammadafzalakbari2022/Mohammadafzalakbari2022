import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/data/local/dev_shop_constants.dart';
import 'package:pride_v3/data/local/entities/garment_type.dart';
import 'package:pride_v3/data/local/entities/order_status.dart';
import 'package:pride_v3/data/local/memory_order_repository.dart';
import 'package:pride_v3/data/local/order_item_input.dart';
import 'package:pride_v3/data/local/order_item_summary.dart';
import 'package:pride_v3/data/local/order_summary.dart';
import 'package:pride_v3/data/local/order_sync_payload.dart';

void main() {
  group('MemoryOrderRepository multi-garment', () {
    late MemoryOrderRepository repo;

    setUp(() {
      repo = MemoryOrderRepository();
    });

    Future<String> createBaseOrder({int total = 1000}) {
      return repo.createOrderWithItems(
        shopId: kDevShopId,
        customerInternalId: 'cust-test-1',
        customerSnapshotName: 'Test Customer',
        deliveryDate: DateTime(2026, 6, 15),
        items: [
          OrderItemCreateInput(
            garmentType: GarmentType.perahanTunban,
            priceAmountMinor: total,
            measurementsSnapshot: 'Chest: 40',
            styleName: 'Classic',
          ),
        ],
      );
    }

    test('createOrderWithItems creates Perahan item and populates summary', () async {
      final orderId = await createBaseOrder(total: 1200);
      final orders = await repo.watchOrders(kDevShopId).first;
      final order = orders.firstWhere((o) => o.internalId == orderId);
      expect(order.hasPerahanTunban, isTrue);
      expect(order.items, hasLength(1));
      expect(order.items.first.priceAmountMinor, 1200);
      expect(order.totalAmountMinor, 1200);
      expect(order.styleName, 'Classic');
    });

    test('legacy createOrder still creates one Perahan item', () async {
      final orderId = await repo.createOrder(
        shopId: kDevShopId,
        customerInternalId: 'cust-test-2',
        customerSnapshotName: 'Test Customer',
        deliveryDate: DateTime(2026, 6, 16),
        totalAmountMinor: 900,
        measurementsSnapshot: 'Waist: 30',
        styleName: 'Qasimi',
      );
      final orders = await repo.watchOrders(kDevShopId).first;
      final order = orders.firstWhere((o) => o.internalId == orderId);
      expect(order.items, hasLength(1));
      expect(order.items.first.garmentType, GarmentType.perahanTunban);
    });

    test('create order with Perahan and Waistcoat sums total', () async {
      final orderId = await repo.createOrderWithItems(
        shopId: kDevShopId,
        customerInternalId: 'cust-test-3',
        customerSnapshotName: 'Test Customer',
        deliveryDate: DateTime(2026, 6, 17),
        items: [
          const OrderItemCreateInput(
            garmentType: GarmentType.perahanTunban,
            priceAmountMinor: 1200,
            styleName: 'Perahan',
          ),
          const OrderItemCreateInput(
            garmentType: GarmentType.waistcoat,
            priceAmountMinor: 800,
            styleName: 'Waistcoat',
          ),
        ],
      );
      final orders = await repo.watchOrders(kDevShopId).first;
      final order = orders.firstWhere((o) => o.internalId == orderId);
      expect(order.hasMultipleGarments, isTrue);
      expect(order.itemPriceTotalAmountMinor, 2000);
      expect(order.totalAmountMinor, 2000);
    });

    test('create order total includes cloth price', () async {
      final orderId = await repo.createOrderWithItems(
        shopId: kDevShopId,
        customerInternalId: 'cust-cloth',
        customerSnapshotName: 'Cloth Customer',
        deliveryDate: DateTime(2026, 6, 19),
        items: const [
          OrderItemCreateInput(
            garmentType: GarmentType.perahanTunban,
            priceAmountMinor: 1000,
            clothPriceAmountMinor: 300,
          ),
        ],
      );
      final orders = await repo.watchOrders(kDevShopId).first;
      final order = orders.firstWhere((o) => o.internalId == orderId);
      expect(order.totalAmountMinor, 1300);
    });

    test('upsert allows zero garment price', () async {
      final orderId = await createBaseOrder(total: 500);
      await repo.upsertOrderItem(
        orderInternalId: orderId,
        input: const OrderItemCreateInput(
          garmentType: GarmentType.perahanTunban,
          priceAmountMinor: 0,
        ),
      );
      final items = await repo.watchOrderItems(orderId).first;
      expect(items.single.priceAmountMinor, 0);
    });

    test('duplicate garment type is rejected', () async {
      await expectLater(
        repo.createOrderWithItems(
          shopId: kDevShopId,
          customerInternalId: 'cust-dup',
          deliveryDate: DateTime(2026, 6, 18),
          items: const [
            OrderItemCreateInput(
              garmentType: GarmentType.waistcoat,
              priceAmountMinor: 500,
            ),
            OrderItemCreateInput(
              garmentType: GarmentType.waistcoat,
              priceAmountMinor: 600,
            ),
          ],
        ),
        throwsA(isA<OrderItemRepositoryException>()),
      );
    });

    test('add waistcoat to existing order', () async {
      final orderId = await createBaseOrder(total: 1200);
      await repo.addOrderItem(
        orderInternalId: orderId,
        input: const OrderItemCreateInput(
          garmentType: GarmentType.waistcoat,
          priceAmountMinor: 800,
          styleName: 'Vest',
        ),
      );
      final items = await repo.watchOrderItems(orderId).first;
      expect(items, hasLength(2));
      expect(
        items.fold<int>(0, (sum, i) => sum + i.priceAmountMinor),
        2000,
      );
    });

    test('cannot remove last item', () async {
      final orderId = await createBaseOrder();
      await expectLater(
        repo.removeOrderItem(
          orderInternalId: orderId,
          garmentType: GarmentType.perahanTunban,
        ),
        throwsA(isA<OrderItemRepositoryException>()),
      );
    });

    test('mergeRemoteOrder legacy flat payload creates Perahan item', () async {
      await repo.mergeRemoteOrder(
        shopId: kDevShopId,
        internalId: 'remote-order-1',
        operation: 'upsert',
        data: {
          'customer_internal_id': 'cust-remote',
          'delivery_date': DateTime(2026, 7, 1).toUtc().toIso8601String(),
          'total_amount_minor': 1500,
          'measurements_snapshot': 'Shoulder: 18',
          'style_name': 'Remote Style',
        },
      );
      final orders = await repo.watchOrders(kDevShopId).first;
      final order = orders.firstWhere((o) => o.internalId == 'remote-order-1');
      expect(order.items, hasLength(1));
      expect(order.items.first.garmentType, GarmentType.perahanTunban);
      expect(order.items.first.priceAmountMinor, 1500);
    });

    test('mergeRemoteOrder items[] payload merges both garments', () async {
      await repo.mergeRemoteOrder(
        shopId: kDevShopId,
        internalId: 'remote-order-2',
        operation: 'upsert',
        data: {
          'customer_internal_id': 'cust-remote-2',
          'delivery_date': DateTime(2026, 7, 2).toUtc().toIso8601String(),
          'total_amount_minor': 2000,
          'items': [
            {
              'internal_id': 'item-p',
              'garment_type': 'perahan_tunban',
              'price_amount_minor': 1200,
              'style_name': 'P',
            },
            {
              'internal_id': 'item-w',
              'garment_type': 'waistcoat',
              'price_amount_minor': 800,
              'style_name': 'W',
            },
          ],
        },
      );
      final items = await repo.watchOrderItems('remote-order-2').first;
      expect(items, hasLength(2));
      expect(items.any((i) => i.isWaistcoat), isTrue);
    });
  });

  group('buildOrderSyncPayloadData dual-write', () {
    test('includes flat fields and items[]', () {
      final now = DateTime(2026, 6, 1);
      final order = OrderSummary(
        shopId: kDevShopId,
        internalId: 'o1',
        displayOrderNo: '00000001',
        customerInternalId: 'c1',
        customerName: 'Test',
        status: OrderLocalStatus.newOrder,
        deliveryDate: now,
        createdAt: now,
        updatedAt: now,
        totalAmountMinor: 2000,
        paidAmountMinor: 0,
        styleName: 'Perahan Style',
        measurementsSnapshot: 'Chest: 40',
      );
      final payload = buildOrderSyncPayloadData(
        order: order,
        items: [
          OrderItemSummary(
            internalId: 'item-p',
            orderInternalId: 'o1',
            garmentType: GarmentType.perahanTunban,
            priceAmountMinor: 1200,
            styleName: 'Perahan Style',
            createdAt: now,
            updatedAt: now,
          ),
          OrderItemSummary(
            internalId: 'item-w',
            orderInternalId: 'o1',
            garmentType: GarmentType.waistcoat,
            priceAmountMinor: 800,
            styleName: 'Vest',
            createdAt: now,
            updatedAt: now,
          ),
        ],
      );

      expect(payload['style_name'], 'Perahan Style');
      expect(payload['total_amount_minor'], 2000);
      final items = payload['items'] as List<dynamic>;
      expect(items, hasLength(2));
      expect((items.first as Map)['garment_type'], 'perahan_tunban');
    });
  });
}
