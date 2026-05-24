import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/features/orders/order_payment_rules.dart';

void main() {
  group('OrderPaymentRules', () {
    test('remainingMinor clamps at zero', () {
      expect(OrderPaymentRules.remainingMinor(1000, 300), 700);
      expect(OrderPaymentRules.remainingMinor(1000, 1200), 0);
    });

    test('effectivePaidMinor uses ledger when loaded', () {
      expect(
        OrderPaymentRules.effectivePaidMinor(
          orderSummaryPaidMinor: 200,
          paymentAmountsMinor: const [200, 300],
        ),
        500,
      );
      expect(
        OrderPaymentRules.effectivePaidMinor(
          orderSummaryPaidMinor: 200,
          paymentAmountsMinor: null,
        ),
        200,
      );
      expect(
        OrderPaymentRules.effectivePaidMinor(
          orderSummaryPaidMinor: 200,
          paymentAmountsMinor: const [],
        ),
        0,
      );
    });

    test('paidMinorForOrder uses ledger map when loaded', () {
      final map = OrderPaymentRules.sumPaidMinorByOrderId([
        (orderInternalId: 'a', amountMinor: 200),
        (orderInternalId: 'a', amountMinor: 300),
      ]);
      expect(
        OrderPaymentRules.paidMinorForOrder(
          orderSummaryPaidMinor: 200,
          paidByOrderId: map,
          orderInternalId: 'a',
          paymentsLedgerLoaded: true,
        ),
        500,
      );
      expect(
        OrderPaymentRules.paidMinorForOrder(
          orderSummaryPaidMinor: 200,
          paidByOrderId: map,
          orderInternalId: 'a',
          paymentsLedgerLoaded: false,
        ),
        200,
      );
    });

    test('isValidInitialPay', () {
      expect(OrderPaymentRules.isValidInitialPay(1000, 0), isTrue);
      expect(OrderPaymentRules.isValidInitialPay(1000, 500), isTrue);
      expect(OrderPaymentRules.isValidInitialPay(1000, 1000), isTrue);
      expect(OrderPaymentRules.isValidInitialPay(1000, 1001), isFalse);
      expect(OrderPaymentRules.isValidInitialPay(0, 0), isFalse);
    });

    test('canSetOrderTotal', () {
      expect(OrderPaymentRules.canSetOrderTotal(1500, 500), isTrue);
      expect(OrderPaymentRules.canSetOrderTotal(500, 500), isTrue);
      expect(OrderPaymentRules.canSetOrderTotal(400, 500), isFalse);
    });

    test('resolveFieldAmount positive sets value', () {
      expect(
        OrderPaymentRules.resolveFieldAmount(currentMinor: 5000, raw: '4500'),
        4500,
      );
      expect(
        OrderPaymentRules.resolveFieldAmount(currentMinor: 0, raw: '2000'),
        2000,
      );
    });

    test('resolveFieldAmount negative deducts', () {
      expect(
        OrderPaymentRules.resolveFieldAmount(currentMinor: 5000, raw: '-500'),
        4500,
      );
      expect(
        OrderPaymentRules.resolveFieldAmount(currentMinor: 2000, raw: '-300'),
        1700,
      );
    });

    test('resolveFieldAmount rejects below zero', () {
      expect(
        OrderPaymentRules.resolveFieldAmount(currentMinor: 200, raw: '-500'),
        isNull,
      );
    });

    test('validatePaymentState', () {
      expect(
        OrderPaymentRules.validatePaymentState(
          totalMinor: 5000,
          depositAmountsMinor: [2000, 3000],
        ),
        isTrue,
      );
      expect(
        OrderPaymentRules.validatePaymentState(
          totalMinor: 5000,
          depositAmountsMinor: [2000, 4000],
        ),
        isFalse,
      );
    });

    test('canRecordNextPayment', () {
      expect(
        OrderPaymentRules.canRecordNextPayment(
          totalMinor: 5000,
          paidMinor: 2000,
          nextPaymentMinor: 3000,
        ),
        isTrue,
      );
      expect(
        OrderPaymentRules.canRecordNextPayment(
          totalMinor: 5000,
          paidMinor: 2000,
          nextPaymentMinor: 4000,
        ),
        isFalse,
      );
      expect(
        OrderPaymentRules.canRecordNextPayment(
          totalMinor: 5000,
          paidMinor: 2000,
          nextPaymentMinor: -100,
        ),
        isFalse,
      );
    });

  });
}
