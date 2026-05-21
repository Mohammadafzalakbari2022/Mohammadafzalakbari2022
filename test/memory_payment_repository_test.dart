import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/data/local/dev_shop_constants.dart';
import 'package:pride_v3/data/local/memory_order_repository.dart';
import 'package:pride_v3/data/local/memory_payment_repository.dart';
import 'package:pride_v3/data/local/seed_data.dart';
import 'package:pride_v3/features/orders/order_payment_mutations.dart';

void main() {
  group('MemoryPaymentRepository', () {
    late MemoryOrderRepository orders;
    late MemoryPaymentRepository payments;

    setUp(() {
      orders = MemoryOrderRepository();
      payments = MemoryPaymentRepository(orders);
    });

    test('append and update adjust order paid total', () async {
      await orders.seedIfEmpty();
      const orderId = DevSeedIds.order2;
      const shopId = kDevShopId;

      final before = (await orders.watchOrders(shopId).first)
          .firstWhere((o) => o.internalId == orderId);
      expect(before.paidAmountMinor, 0);

      final payId = await OrderPaymentMutations.persistAppend(
        repo: payments,
        shopId: shopId,
        orderInternalId: orderId,
        amountMinor: 2000,
        internalId: 'pay-test-1',
      );
      expect(payId, 'pay-test-1');

      final afterAppend = (await orders.watchOrders(shopId).first)
          .firstWhere((o) => o.internalId == orderId);
      expect(afterAppend.paidAmountMinor, 2000);

      await OrderPaymentMutations.persistUpdate(
        repo: payments,
        internalId: payId,
        amountMinor: 1500,
      );

      final afterUpdate = (await orders.watchOrders(shopId).first)
          .firstWhere((o) => o.internalId == orderId);
      expect(afterUpdate.paidAmountMinor, 1500);

      final rows = await payments.watchPaymentsForOrder(orderId).first;
      expect(rows.single.amountMinor, 1500);
    });

    test('mergeRemotePayment upsert updates paid total', () async {
      await orders.seedIfEmpty();
      const orderId = DevSeedIds.order2;
      const shopId = kDevShopId;

      await payments.mergeRemotePayment(
        shopId: shopId,
        internalId: 'pay-remote-1',
        operation: 'upsert',
        data: {
          'order_internal_id': orderId,
          'amount_minor': 800,
          'method': 'cash',
          'is_adjustment': false,
          'created_at': DateTime.utc(2026, 5, 1).toIso8601String(),
        },
      );

      final o = (await orders.watchOrders(shopId).first)
          .firstWhere((x) => x.internalId == orderId);
      expect(o.paidAmountMinor, 800);
    });
  });
}
