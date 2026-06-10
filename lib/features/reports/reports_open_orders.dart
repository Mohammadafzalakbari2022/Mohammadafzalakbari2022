import '../../data/local/entities/order_status.dart';
import '../../data/local/order_summary.dart';
import 'report_calculations.dart';

export 'report_calculations.dart' show ReportCalculations;

bool isOpenOrderStatus(OrderLocalStatus status) =>
    ReportCalculations.isOpenOrderStatus(status);

List<OrderSummary> openUnpaidOrders(
  List<OrderSummary> orders, {
  Map<String, int> paidByOrderId = const {},
  bool paymentsLedgerLoaded = false,
}) {
  return ReportCalculations.openUnpaidOrders(
    orders: orders,
    paidByOrderId: paidByOrderId,
    paymentsLedgerLoaded: paymentsLedgerLoaded,
  );
}

int openUnpaidOrdersTotal(
  List<OrderSummary> orders, {
  Map<String, int> paidByOrderId = const {},
  bool paymentsLedgerLoaded = false,
}) {
  return ReportCalculations.sumOpenUnpaidTotal(
    orders: orders,
    paidByOrderId: paidByOrderId,
    paymentsLedgerLoaded: paymentsLedgerLoaded,
  );
}
