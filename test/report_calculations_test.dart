import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/data/local/entities/order_status.dart';
import 'package:pride_v3/data/local/order_summary.dart';
import 'package:pride_v3/features/reports/report_calculations.dart';

OrderSummary _order({
  required String id,
  OrderLocalStatus status = OrderLocalStatus.newOrder,
  int total = 10000,
  int paid = 0,
  DateTime? delivery,
}) {
  final now = DateTime(2026, 3, 1);
  return OrderSummary(
    shopId: 'shop-1',
    internalId: id,
    displayOrderNo: '1',
    customerInternalId: 'cust-1',
    customerName: 'Test',
    status: status,
    deliveryDate: delivery ?? now.add(const Duration(days: 7)),
    createdAt: now,
    updatedAt: now,
    totalAmountMinor: total,
    paidAmountMinor: paid,
  );
}

void main() {
  group('ReportCalculations', () {
    test('effectiveRemainingMinor uses ledger when loaded', () {
      final order = _order(id: 'o1', total: 10000, paid: 2000);
      final paidByOrderId = {'o1': 5000};
      expect(
        ReportCalculations.effectiveRemainingMinor(
          order: order,
          paidByOrderId: paidByOrderId,
          paymentsLedgerLoaded: true,
        ),
        5000,
      );
    });

    test('effectiveRemainingMinor clamps overpayment to zero', () {
      final order = _order(id: 'o1', total: 10000, paid: 2000);
      final paidByOrderId = {'o1': 12000};
      expect(
        ReportCalculations.effectiveRemainingMinor(
          order: order,
          paidByOrderId: paidByOrderId,
          paymentsLedgerLoaded: true,
        ),
        0,
      );
    });

    test('openUnpaidOrders includes only open statuses with balance', () {
      final orders = [
        _order(id: 'a', status: OrderLocalStatus.newOrder, total: 5000),
        _order(id: 'b', status: OrderLocalStatus.delivered, total: 5000),
        _order(id: 'c', status: OrderLocalStatus.inProgress, total: 3000),
      ];
      final paidByOrderId = {'a': 0, 'b': 1000, 'c': 3000};
      final open = ReportCalculations.openUnpaidOrders(
        orders: orders,
        paidByOrderId: paidByOrderId,
        paymentsLedgerLoaded: true,
      );
      expect(open.map((o) => o.internalId).toList(), ['a']);
    });

    test('isOverdueOpenOrder excludes delivered and cancelled', () {
      final now = DateTime(2026, 6, 10);
      final overdue = _order(
        id: 'o1',
        status: OrderLocalStatus.inProgress,
        delivery: DateTime(2026, 6, 1),
      );
      final delivered = _order(
        id: 'o2',
        status: OrderLocalStatus.delivered,
        delivery: DateTime(2026, 6, 1),
      );
      expect(ReportCalculations.isOverdueOpenOrder(overdue, now), isTrue);
      expect(ReportCalculations.isOverdueOpenOrder(delivered, now), isFalse);
    });

    test('sumAllUnpaidTotal sums ledger-aware remaining', () {
      final orders = [
        _order(id: 'a', status: OrderLocalStatus.newOrder, total: 5000),
        _order(id: 'b', status: OrderLocalStatus.delivered, total: 8000),
      ];
      final paidByOrderId = {'a': 2000, 'b': 3000};
      expect(
        ReportCalculations.sumAllUnpaidTotal(
          orders: orders,
          paidByOrderId: paidByOrderId,
          paymentsLedgerLoaded: true,
        ),
        8000,
      );
    });

    test('unpaidDueInMonthTotal filters by delivery month', () {
      final orders = [
        _order(
          id: 'a',
          status: OrderLocalStatus.newOrder,
          total: 5000,
          delivery: DateTime(2026, 6, 15),
        ),
        _order(
          id: 'b',
          status: OrderLocalStatus.newOrder,
          total: 3000,
          delivery: DateTime(2026, 7, 1),
        ),
      ];
      final paidByOrderId = {'a': 0, 'b': 0};
      final sum = ReportCalculations.unpaidDueInMonthTotal(
        orders: orders,
        paidByOrderId: paidByOrderId,
        paymentsLedgerLoaded: true,
        monthStart: DateTime(2026, 6, 1),
        monthEndExclusive: DateTime(2026, 7, 1),
      );
      expect(sum, 5000);
    });
  });
}
