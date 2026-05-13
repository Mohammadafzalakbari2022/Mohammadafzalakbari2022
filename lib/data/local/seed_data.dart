import 'entities/order_status.dart';
import 'dev_shop_constants.dart';
import 'order_summary.dart';

/// Fixed UUIDs so Isar + in-memory seeds match (plan-02 internal_id).
abstract final class DevSeedIds {
  static const customer1 = '11111111-1111-4111-8111-111111111111';
  static const customer2 = '22222222-2222-4222-8222-222222222222';
  static const order1 = 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa';
  static const order2 = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb';
  static const order3 = 'cccccccc-cccc-4ccc-8ccc-cccccccccccc';
  static const payment1 = 'dddddddd-dddd-4ddd-8ddd-dddddddddddd';
  static const payment2 = 'eeeeeeee-eeee-4eee-8eee-eeeeeeeeeeee';
  static const payment3 = 'ffffffff-ffff-4fff-8fff-ffffffffffff';
  static const measurementProfile1 =
      '33333333-3333-4333-8333-333333333333';
  static const measurementProfile2 =
      '44444444-4444-4444-8444-444444444444';
  static const mtChest = 'a1a1a1a1-a1a1-41a1-8a1a-a1a1a1a1a101';
  static const mtWaist = 'a2a2a2a2-a2a2-42a2-8a2a-a2a2a2a2a202';
  static const mtLength = 'a3a3a3a3-a3a3-43a3-8a3a-a3a3a3a3a303';
  static const mtShoulder = 'a4a4a4a4-a4a4-44a4-8a4a-a4a4a4a4a404';
  static const mtNeck = 'a5a5a5a5-a5a5-45a5-8a5a-a5a5a5a5a505';
  static const mtSleeve = 'a6a6a6a6-a6a6-46a6-8a6a-a6a6a6a6a606';
  static const orderMeasurementSnapshot1 =
      'd1d1d1d1-d1d1-41d1-8d1d-d1d1d1d1d101';
  static const orderMeasurementSnapshot2 =
      'd2d2d2d2-d2d2-42d2-8d2d-d2d2d2d2d202';
}

List<OrderSummary> devOrderSummaries(DateTime now) {
  return [
    OrderSummary(
      shopId: kDevShopId,
      internalId: DevSeedIds.order3,
      displayOrderNo: '00000003',
      customerInternalId: DevSeedIds.customer1,
      customerName: 'Ahmad Karimi',
      customerPhone: '0700000001',
      measurementsSnapshot: 'Full suit — see notes',
      styleNotes: 'Classic fit, plain cuffs',
      sourceMeasurementProfileId: DevSeedIds.measurementProfile1,
      sourceMeasurementProfileLabel: 'Default',
      status: OrderLocalStatus.ready,
      deliveryDate: now,
      totalAmountMinor: 120000,
      paidAmountMinor: 120000,
    ),
    OrderSummary(
      shopId: kDevShopId,
      internalId: DevSeedIds.order1,
      displayOrderNo: '00000001',
      customerInternalId: DevSeedIds.customer1,
      customerName: 'Ahmad Karimi',
      customerPhone: '0700000001',
      measurementsSnapshot:
          'Chest: 98 cm\nWaist: 84 cm\nLength: 112 cm',
      styleNotes: 'Karzai collar, two pockets',
      sourceMeasurementProfileId: DevSeedIds.measurementProfile1,
      sourceMeasurementProfileLabel: 'Default',
      status: OrderLocalStatus.inProgress,
      deliveryDate: now.add(const Duration(days: 2)),
      totalAmountMinor: 150000,
      paidAmountMinor: 70000,
    ),
    OrderSummary(
      shopId: kDevShopId,
      internalId: DevSeedIds.order2,
      displayOrderNo: '00000002',
      customerInternalId: DevSeedIds.customer2,
      customerName: 'Sara Mohseni',
      customerPhone: '0700000002',
      measurementsSnapshot: 'Shoulder: 46 cm\nSleeve: 62 cm',
      styleNotes: 'Simple collar',
      sourceMeasurementProfileId: DevSeedIds.measurementProfile2,
      sourceMeasurementProfileLabel: 'Default',
      status: OrderLocalStatus.newOrder,
      deliveryDate: now.add(const Duration(days: 5)),
      totalAmountMinor: 80000,
      paidAmountMinor: 0,
    ),
  ];
}
