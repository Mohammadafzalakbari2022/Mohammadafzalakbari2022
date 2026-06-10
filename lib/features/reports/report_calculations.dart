import '../../core/calendar/date_calendar_system.dart';
import '../../core/calendar/report_month_period.dart';
import '../../data/local/entities/order_status.dart';
import '../../data/local/order_summary.dart';
import '../../data/local/payment_summary.dart';
import '../orders/order_payment_rules.dart';

/// Shared report aggregation aligned with [OrderPaymentRules] and orders list.
abstract final class ReportCalculations {
  static DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  static Map<String, int> paidByOrderIdFromPayments(
    Iterable<PaymentSummary> payments,
  ) {
    return OrderPaymentRules.sumPaidMinorByOrderId(
      payments.map(
        (p) => (orderInternalId: p.orderInternalId, amountMinor: p.amountMinor),
      ),
    );
  }

  static int effectiveRemainingMinor({
    required OrderSummary order,
    required Map<String, int> paidByOrderId,
    required bool paymentsLedgerLoaded,
  }) {
    final paid = OrderPaymentRules.paidMinorForOrder(
      orderSummaryPaidMinor: order.paidAmountMinor,
      paidByOrderId: paidByOrderId,
      orderInternalId: order.internalId,
      paymentsLedgerLoaded: paymentsLedgerLoaded,
    );
    return OrderPaymentRules.remainingMinor(order.totalAmountMinor, paid);
  }

  static bool isUnpaid({
    required OrderSummary order,
    required Map<String, int> paidByOrderId,
    required bool paymentsLedgerLoaded,
  }) {
    return effectiveRemainingMinor(
          order: order,
          paidByOrderId: paidByOrderId,
          paymentsLedgerLoaded: paymentsLedgerLoaded,
        ) >
        0;
  }

  static bool isOpenOrderStatus(OrderLocalStatus status) {
    return status == OrderLocalStatus.newOrder ||
        status == OrderLocalStatus.inProgress ||
        status == OrderLocalStatus.ready;
  }

  /// Overdue open orders — excludes delivered/cancelled (matches orders list).
  static bool isOverdueOpenOrder(OrderSummary order, DateTime now) {
    if (order.status == OrderLocalStatus.delivered ||
        order.status == OrderLocalStatus.cancelled) {
      return false;
    }
    return order.deliveryDate.isBefore(dateOnly(now));
  }

  static List<OrderSummary> unpaidOrders({
    required List<OrderSummary> orders,
    required Map<String, int> paidByOrderId,
    required bool paymentsLedgerLoaded,
  }) {
    return orders
        .where(
          (o) => isUnpaid(
            order: o,
            paidByOrderId: paidByOrderId,
            paymentsLedgerLoaded: paymentsLedgerLoaded,
          ),
        )
        .toList();
  }

  static List<OrderSummary> openUnpaidOrders({
    required List<OrderSummary> orders,
    required Map<String, int> paidByOrderId,
    required bool paymentsLedgerLoaded,
  }) {
    return orders
        .where(
          (o) =>
              isOpenOrderStatus(o.status) &&
              isUnpaid(
                order: o,
                paidByOrderId: paidByOrderId,
                paymentsLedgerLoaded: paymentsLedgerLoaded,
              ),
        )
        .toList()
      ..sort(
        (a, b) => effectiveRemainingMinor(
              order: b,
              paidByOrderId: paidByOrderId,
              paymentsLedgerLoaded: paymentsLedgerLoaded,
            ).compareTo(
              effectiveRemainingMinor(
                order: a,
                paidByOrderId: paidByOrderId,
                paymentsLedgerLoaded: paymentsLedgerLoaded,
              ),
            ),
      );
  }

  static int sumUnpaidRemaining({
    required List<OrderSummary> orders,
    required Map<String, int> paidByOrderId,
    required bool paymentsLedgerLoaded,
  }) {
    return orders.fold<int>(
      0,
      (sum, o) =>
          sum +
          effectiveRemainingMinor(
            order: o,
            paidByOrderId: paidByOrderId,
            paymentsLedgerLoaded: paymentsLedgerLoaded,
          ),
    );
  }

  static int sumOpenUnpaidTotal({
    required List<OrderSummary> orders,
    required Map<String, int> paidByOrderId,
    required bool paymentsLedgerLoaded,
  }) {
    return sumUnpaidRemaining(
      orders: openUnpaidOrders(
        orders: orders,
        paidByOrderId: paidByOrderId,
        paymentsLedgerLoaded: paymentsLedgerLoaded,
      ),
      paidByOrderId: paidByOrderId,
      paymentsLedgerLoaded: paymentsLedgerLoaded,
    );
  }

  static int sumAllUnpaidTotal({
    required List<OrderSummary> orders,
    required Map<String, int> paidByOrderId,
    required bool paymentsLedgerLoaded,
  }) {
    return sumUnpaidRemaining(
      orders: unpaidOrders(
        orders: orders,
        paidByOrderId: paidByOrderId,
        paymentsLedgerLoaded: paymentsLedgerLoaded,
      ),
      paidByOrderId: paidByOrderId,
      paymentsLedgerLoaded: paymentsLedgerLoaded,
    );
  }

  static int monthPaymentIncome({
    required List<PaymentSummary> payments,
    required DateTime now,
    required DateCalendarSystem calendar,
  }) {
    final start = startOfMonthContaining(now, calendar);
    final end = endExclusiveForMonthStart(start, calendar);
    return payments
        .where(
          (p) => !p.createdAt.isBefore(start) && p.createdAt.isBefore(end),
        )
        .fold<int>(0, (s, p) => s + p.amountMinor);
  }

  static int unpaidDueInMonthTotal({
    required List<OrderSummary> orders,
    required Map<String, int> paidByOrderId,
    required bool paymentsLedgerLoaded,
    required DateTime monthStart,
    required DateTime monthEndExclusive,
  }) {
    var sum = 0;
    for (final o in orders) {
      final remaining = effectiveRemainingMinor(
        order: o,
        paidByOrderId: paidByOrderId,
        paymentsLedgerLoaded: paymentsLedgerLoaded,
      );
      if (remaining <= 0) continue;
      final d = o.deliveryDate;
      if (!d.isBefore(monthStart) && d.isBefore(monthEndExclusive)) {
        sum += remaining;
      }
    }
    return sum;
  }

  static Map<OrderLocalStatus, int> countByStatus(List<OrderSummary> orders) {
    final counts = <OrderLocalStatus, int>{};
    for (final o in orders) {
      counts[o.status] = (counts[o.status] ?? 0) + 1;
    }
    return counts;
  }
}
