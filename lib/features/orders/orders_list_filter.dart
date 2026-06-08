import '../../data/local/customer_display_no.dart';
import '../../data/local/entities/order_status.dart';
import '../../data/local/order_summary.dart';
import '../../core/formatting/display_order_no_format.dart';

/// Delivery date filter for the orders list (plan-12).
enum OrdersDeliveryDatePreset {
  any,
  today,
  thisWeek,
  custom,
}

/// List filters (plan-12): search + status + unpaid + delivery window + customer.
class OrdersListFilter {
  const OrdersListFilter({
    this.query = '',
    this.statusFilter = const {},
    this.onlyUnpaid = false,
    this.onlyOverdue = false,
    this.onlyDeliveredToday = false,
    this.customerInternalId,
    this.deliveryDatePreset = OrdersDeliveryDatePreset.any,
    this.customRangeStart,
    this.customRangeEnd,
  });

  final String query;
  /// Empty = do not filter by status. Non-empty = order status must be in set.
  final Set<OrderLocalStatus> statusFilter;
  final bool onlyUnpaid;
  /// Delivery date before today; excludes delivered/cancelled (plan-09).
  final bool onlyOverdue;
  /// Delivered with delivery date on today’s calendar.
  final bool onlyDeliveredToday;
  final String? customerInternalId;
  final OrdersDeliveryDatePreset deliveryDatePreset;
  final DateTime? customRangeStart;
  final DateTime? customRangeEnd;

  OrdersListFilter copyWith({
    String? query,
    Set<OrderLocalStatus>? statusFilter,
    bool? onlyUnpaid,
    bool? onlyOverdue,
    bool? onlyDeliveredToday,
    String? customerInternalId,
    bool clearCustomerInternalId = false,
    OrdersDeliveryDatePreset? deliveryDatePreset,
    DateTime? customRangeStart,
    DateTime? customRangeEnd,
    bool clearCustomRange = false,
  }) {
    return OrdersListFilter(
      query: query ?? this.query,
      statusFilter: statusFilter ?? this.statusFilter,
      onlyUnpaid: onlyUnpaid ?? this.onlyUnpaid,
      onlyOverdue: onlyOverdue ?? this.onlyOverdue,
      onlyDeliveredToday: onlyDeliveredToday ?? this.onlyDeliveredToday,
      customerInternalId: clearCustomerInternalId
          ? null
          : (customerInternalId ?? this.customerInternalId),
      deliveryDatePreset: deliveryDatePreset ?? this.deliveryDatePreset,
      customRangeStart:
          clearCustomRange ? null : (customRangeStart ?? this.customRangeStart),
      customRangeEnd:
          clearCustomRange ? null : (customRangeEnd ?? this.customRangeEnd),
    );
  }

  static DateTime _dateOnly(DateTime d) =>
      DateTime(d.year, d.month, d.day);

  static DateTime _startOfWeekMonday(DateTime d) {
    final day = _dateOnly(d);
    return day.subtract(Duration(days: day.weekday - DateTime.monday));
  }

  static bool _isOverdueOpenOrder(OrderSummary o, DateTime now) {
    if (o.status == OrderLocalStatus.delivered ||
        o.status == OrderLocalStatus.cancelled) {
      return false;
    }
    final todayStart = _dateOnly(now);
    return o.deliveryDate.isBefore(todayStart);
  }

  bool _matchesDeliveryWindow(OrderSummary o, DateTime now) {
    switch (deliveryDatePreset) {
      case OrdersDeliveryDatePreset.any:
        return true;
      case OrdersDeliveryDatePreset.today:
        final t = _dateOnly(now);
        final del = _dateOnly(o.deliveryDate);
        return del == t;
      case OrdersDeliveryDatePreset.thisWeek:
        final start = _startOfWeekMonday(now);
        final end = start.add(const Duration(days: 7));
        final del = o.deliveryDate;
        return !del.isBefore(start) && del.isBefore(end);
      case OrdersDeliveryDatePreset.custom:
        final start = customRangeStart;
        final end = customRangeEnd;
        if (start == null || end == null) return true;
        final ds = _dateOnly(start);
        final de = _dateOnly(end);
        final del = _dateOnly(o.deliveryDate);
        return !del.isBefore(ds) && !del.isAfter(de);
    }
  }

  List<OrderSummary> apply(
    List<OrderSummary> source, {
    DateTime? now,
    Map<String, String> customerDisplayNoById = const {},
  }) {
    final clock = now ?? DateTime.now();
    var list = source;
    final q = query.trim();
    final qLower = q.toLowerCase();
    if (q.isNotEmpty) {
      list = list.where((o) {
        final phone = (o.customerPhone ?? '').toLowerCase();
        final customerNo = customerDisplayNoById[o.customerInternalId] ?? '';
        return displayOrderNoMatchesQuery(o.displayOrderNo, q) ||
            customerDisplayNoMatchesQuery(customerNo, q) ||
            o.customerName.toLowerCase().contains(qLower) ||
            phone.contains(qLower);
      }).toList();
    }
    if (statusFilter.isNotEmpty) {
      list = list.where((o) => statusFilter.contains(o.status)).toList();
    }
    if (onlyUnpaid) {
      list = list.where((o) => o.isUnpaid).toList();
    }
    final cid = customerInternalId;
    if (cid != null && cid.isNotEmpty) {
      list = list.where((o) => o.customerInternalId == cid).toList();
    }
    list = list.where((o) => _matchesDeliveryWindow(o, clock)).toList();
    if (onlyOverdue) {
      list = list.where((o) => _isOverdueOpenOrder(o, clock)).toList();
    }
    if (onlyDeliveredToday) {
      final t = _dateOnly(clock);
      list = list
          .where(
            (o) =>
                o.status == OrderLocalStatus.delivered &&
                _dateOnly(o.deliveryDate) == t,
          )
          .toList();
    }
    return list;
  }
}
