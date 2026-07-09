import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/core/calendar/date_calendar_system.dart';
import 'package:pride_v3/data/local/entities/garment_type.dart';
import 'package:pride_v3/data/local/entities/order_status.dart';
import 'package:pride_v3/data/local/order_item_summary.dart';
import 'package:pride_v3/data/local/order_summary.dart';
import 'package:pride_v3/features/reports/report_cloth_calculations.dart';

void main() {
  OrderSummary order({
    required String id,
    required DateTime createdAt,
    List<OrderItemSummary> items = const [],
  }) {
    return OrderSummary(
      shopId: 'shop-1',
      internalId: id,
      displayOrderNo: '00000001',
      customerInternalId: 'cust-1',
      customerName: 'Ahmad',
      status: OrderLocalStatus.inProgress,
      deliveryDate: createdAt,
      createdAt: createdAt,
      updatedAt: createdAt,
      totalAmountMinor: 0,
      paidAmountMinor: 0,
      items: items,
    );
  }

  group('parseClothMeters', () {
    test('parses western and localized digits', () {
      expect(parseClothMeters('3.5'), 3.5);
      expect(parseClothMeters('۳.۵'), 3.5);
    });
  });

  group('ReportClothCalculations', () {
    test('aggregates revenue and meters for month', () {
      final orders = [
        order(
          id: 'o1',
          createdAt: DateTime(2026, 6, 5),
          items: [
            OrderItemSummary(
              internalId: 'i1',
              orderInternalId: 'o1',
              garmentType: GarmentType.perahanTunban,
              clothPriceAmountMinor: 120000,
              clothMetersSnapshot: '3',
              createdAt: DateTime(2026, 6, 5),
              updatedAt: DateTime(2026, 6, 5),
            ),
            OrderItemSummary(
              internalId: 'i2',
              orderInternalId: 'o1',
              garmentType: GarmentType.waistcoat,
              clothPriceAmountMinor: 80000,
              clothMetersSnapshot: '1.5',
              createdAt: DateTime(2026, 6, 5),
              updatedAt: DateTime(2026, 6, 5),
            ),
          ],
        ),
        order(
          id: 'o2',
          createdAt: DateTime(2026, 5, 20),
          items: [
            OrderItemSummary(
              internalId: 'i3',
              orderInternalId: 'o2',
              garmentType: GarmentType.perahanTunban,
              clothPriceAmountMinor: 50000,
              clothMetersSnapshot: '2',
              createdAt: DateTime(2026, 5, 20),
              updatedAt: DateTime(2026, 5, 20),
            ),
          ],
        ),
      ];

      final juneLines = ReportClothCalculations.linesInMonth(
        orders: orders,
        monthStart: DateTime(2026, 6, 1),
        monthEndExclusive: DateTime(2026, 7, 1),
      );
      expect(ReportClothCalculations.sumRevenueMinor(juneLines), 200000);
      expect(ReportClothCalculations.sumMeters(juneLines), 4.5);
      expect(ReportClothCalculations.countDistinctOrders(juneLines), 1);

      final byGarment = ReportClothCalculations.revenueByGarment(juneLines);
      expect(byGarment[GarmentType.perahanTunban], 120000);
      expect(byGarment[GarmentType.waistcoat], 80000);
    });

    test('monthRevenue uses calendar month', () {
      final orders = [
        order(
          id: 'o1',
          createdAt: DateTime(2026, 6, 10),
          items: [
            OrderItemSummary(
              internalId: 'i1',
              orderInternalId: 'o1',
              garmentType: GarmentType.perahanTunban,
              clothPriceAmountMinor: 90000,
              createdAt: DateTime(2026, 6, 10),
              updatedAt: DateTime(2026, 6, 10),
            ),
          ],
        ),
      ];
      expect(
        ReportClothCalculations.monthRevenue(
          orders: orders,
          now: DateTime(2026, 6, 15),
          calendar: DateCalendarSystem.gregorian,
        ),
        90000,
      );
    });

    test('computes cogs and margin for shop stock lines', () {
      final lines = [
        ClothReportLine(
          order: order(id: 'o1', createdAt: DateTime(2026, 6, 1)),
          item: OrderItemSummary(
            internalId: 'i1',
            orderInternalId: 'o1',
            garmentType: GarmentType.perahanTunban,
            clothPriceAmountMinor: 10000,
            clothSourceIndex: 1,
            clothSaleCostAmountMinor: 6000,
            createdAt: DateTime(2026, 6, 1),
            updatedAt: DateTime(2026, 6, 1),
          ),
        ),
      ];
      expect(ReportClothCalculations.sumCogsMinor(lines), 6000);
      expect(ReportClothCalculations.sumMarginMinor(lines), 4000);
    });
  });
}
