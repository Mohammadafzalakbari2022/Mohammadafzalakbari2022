import '../../core/calendar/date_calendar_system.dart';
import '../../core/calendar/report_month_period.dart';
import '../../core/formatting/digit_normalizer.dart';
import '../../data/local/entities/garment_type.dart';
import '../../data/local/order_item_summary.dart';
import '../../data/local/order_summary.dart';

/// One order line with cloth data for report aggregation.
class ClothReportLine {
  const ClothReportLine({
    required this.order,
    required this.item,
  });

  final OrderSummary order;
  final OrderItemSummary item;

  int get revenueMinor => item.clothPriceAmountMinor;

  double get meters => parseClothMeters(item.clothMetersSnapshot);
}

/// Parses cloth meters text (supports localized digits).
double parseClothMeters(String raw) {
  final normalized = normalizeWesternDigits(raw.trim());
  if (normalized.isEmpty) return 0;
  return double.tryParse(normalized.replaceAll(',', '.')) ?? 0;
}

/// Offline cloth metrics from local order item rows.
abstract final class ReportClothCalculations {
  static List<ClothReportLine> linesFromOrders(List<OrderSummary> orders) {
    final rows = <ClothReportLine>[];
    for (final order in orders) {
      for (final item in order.items) {
        if (_itemHasClothData(item)) {
          rows.add(ClothReportLine(order: order, item: item));
        }
      }
    }
    return rows;
  }

  static bool _itemHasClothData(OrderItemSummary item) =>
      item.clothPriceAmountMinor > 0 ||
      item.clothMetersSnapshot.trim().isNotEmpty ||
      item.fabricNameSnapshot.trim().isNotEmpty;

  static List<ClothReportLine> linesInMonth({
    required List<OrderSummary> orders,
    required DateTime monthStart,
    required DateTime monthEndExclusive,
  }) {
    return linesFromOrders(orders).where((row) {
      final created = row.order.createdAt;
      return !created.isBefore(monthStart) && created.isBefore(monthEndExclusive);
    }).toList();
  }

  static int sumRevenueMinor(Iterable<ClothReportLine> lines) =>
      lines.fold<int>(0, (sum, row) => sum + row.revenueMinor);

  static double sumMeters(Iterable<ClothReportLine> lines) =>
      lines.fold<double>(0, (sum, row) => sum + row.meters);

  static int countDistinctOrders(Iterable<ClothReportLine> lines) =>
      lines.map((r) => r.order.internalId).toSet().length;

  static Map<GarmentType, int> revenueByGarment(Iterable<ClothReportLine> lines) {
    final map = <GarmentType, int>{};
    for (final row in lines) {
      map[row.item.garmentType] =
          (map[row.item.garmentType] ?? 0) + row.revenueMinor;
    }
    return map;
  }

  static Map<GarmentType, double> metersByGarment(Iterable<ClothReportLine> lines) {
    final map = <GarmentType, double>{};
    for (final row in lines) {
      map[row.item.garmentType] = (map[row.item.garmentType] ?? 0) + row.meters;
    }
    return map;
  }

  static List<MapEntry<DateTime, int>> dailyRevenueBuckets({
    required DateTime monthStart,
    required DateTime monthEndExclusive,
    required Iterable<ClothReportLine> lines,
  }) {
    final map = <DateTime, int>{};
    for (var d = DateTime(monthStart.year, monthStart.month, monthStart.day);
        d.isBefore(monthEndExclusive);
        d = d.add(const Duration(days: 1))) {
      map[d] = 0;
    }
    for (final row in lines) {
      final k = DateTime(
        row.order.createdAt.year,
        row.order.createdAt.month,
        row.order.createdAt.day,
      );
      if (map.containsKey(k)) {
        map[k] = (map[k] ?? 0) + row.revenueMinor;
      }
    }
    return map.entries.toList();
  }

  static int monthRevenue({
    required List<OrderSummary> orders,
    required DateTime now,
    required DateCalendarSystem calendar,
  }) {
    final start = startOfMonthContaining(now, calendar);
    final end = endExclusiveForMonthStart(start, calendar);
    return sumRevenueMinor(
      linesInMonth(
        orders: orders,
        monthStart: start,
        monthEndExclusive: end,
      ),
    );
  }
}
