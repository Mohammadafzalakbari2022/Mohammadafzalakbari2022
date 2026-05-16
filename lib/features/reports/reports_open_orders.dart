import '../../data/local/entities/order_status.dart';
import '../../data/local/order_summary.dart';

bool isOpenOrderStatus(OrderLocalStatus status) {
  return status == OrderLocalStatus.newOrder ||
      status == OrderLocalStatus.inProgress ||
      status == OrderLocalStatus.ready;
}

List<OrderSummary> openUnpaidOrders(List<OrderSummary> orders) {
  return orders
      .where(
        (o) => isOpenOrderStatus(o.status) && o.remainingAmountMinor > 0,
      )
      .toList()
    ..sort((a, b) => b.remainingAmountMinor.compareTo(a.remainingAmountMinor));
}

int openUnpaidOrdersTotal(List<OrderSummary> orders) {
  return openUnpaidOrders(orders)
      .fold<int>(0, (sum, o) => sum + o.remainingAmountMinor);
}
