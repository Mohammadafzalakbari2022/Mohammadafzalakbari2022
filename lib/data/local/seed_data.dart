import '../../core/defaults/afghan_market_defaults.dart';
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

  static const styleNameQasimi = 's1s1s1s1-s1s1-41s1-8s1s-s1s1s1s1s101';
  static const styleNameKandahari = 's2s2s2s2-s2s2-42s2-8s2s-s2s2s2s2s202';
  static const styleNameArabi = 's3s3s3s3-s3s3-43s3-8s3s-s3s3s3s3s303';
  static const styleNameClassic = 's4s4s4s4-s4s4-44s4-8s4s-s4s4s4s4s404';
  static const styleNameModern = 's5s5s5s5-s5s5-45s5-8s5s-s5s5s5s5s505';

  static const stylePartSleeve = 'p1p1p1p1-p1p1-41p1-8p1p-p1p1p1p1p101';
  static const stylePartCollar = 'p2p2p2p2-p2p2-42p2-8p2p-p2p2p2p2p202';
  static const stylePartPocket = 'p3p3p3p3-p3p3-43p3-8p3p-p3p3p3p3p303';
  static const stylePartCuff = 'p4p4p4p4-p4p4-44p4-8p4p-p4p4p4p4p404';
  static const stylePartNeck = 'p5p5p5p5-p5p5-45p5-8p5p-p5p5p5p5p505';
  static const stylePartFront = 'p6p6p6p6-p6p6-46p6-8p6p-p6p6p6p6p606';
  static const stylePartBottom = 'p7p7p7p7-p7p7-47p7-8p7p-p7p7p7p7p707';

  static const styleFigure1 = 'f1f1f1f1-f1f1-41f1-8f1f-f1f1f1f1f101';
  static const styleFigure2 = 'f2f2f2f2-f2f2-42f2-8f2f-f2f2f2f2f202';
  static const styleFigure3 = 'f3f3f3f3-f3f3-43f3-8f3f-f3f3f3f3f303';
  static const styleFigure4 = 'f4f4f4f4-f4f4-44f4-8f4f-f4f4f4f4f404';
  static const styleFigure5 = 'f5f5f5f5-f5f5-45f5-8f5f-f5f5f5f5f505';
  static const styleFigure6 = 'f6f6f6f6-f6f6-46f6-8f6f-f6f6f6f6f606';
  static const styleFigure7 = 'f7f7f7f7-f7f7-47f7-8f7f-f7f7f7f7f707';
  static const styleFigure8 = 'f8f8f8f8-f8f8-48f8-8f8f-f8f8f8f8f808';
  static const styleFigure9 = 'f9f9f9f9-f9f9-49f9-8f9f-f9f9f9f9f909';
  static const styleFigure10 = 'fafafafa-fafa-4afa-8afa-fafafafafa10';
  static const styleFigure11 = 'fbfbfbfb-fbfb-4bfb-8bfb-fbfbfbfbfb11';
  static const styleFigure12 = 'fcfcfcfc-fcfc-4cfc-8cfc-fcfcfcfcfc12';
  static const styleFigure13 = 'f0f0f0f0-f0f0-40f0-80f0-f0f0f0f0f013';
  static const styleFigure14 = 'f1f1f1f1-f1f1-41f1-81f1-f1f1f1f1f014';
  static const styleFigure15 = 'f2f2f2f2-f2f2-42f2-82f2-f2f2f2f2f015';
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
      sourceMeasurementProfileId: DevSeedIds.measurementProfile1,
      sourceMeasurementProfileLabel: 'Default',
      status: OrderLocalStatus.ready,
      deliveryDate: now,
      createdAt: now,
      updatedAt: now,
      totalAmountMinor: 1200,
      paidAmountMinor: 1200,
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
      sourceMeasurementProfileId: DevSeedIds.measurementProfile1,
      sourceMeasurementProfileLabel: 'Default',
      status: OrderLocalStatus.inProgress,
      deliveryDate: now.add(const Duration(days: 2)),
      createdAt: now,
      updatedAt: now,
      totalAmountMinor: AfghanMarketDefaults.exampleOrderTotalAfn,
      paidAmountMinor: 700,
    ),
    OrderSummary(
      shopId: kDevShopId,
      internalId: DevSeedIds.order2,
      displayOrderNo: '00000002',
      customerInternalId: DevSeedIds.customer2,
      customerName: 'Sara Mohseni',
      customerPhone: '0700000002',
      measurementsSnapshot: 'Shoulder: 46 cm\nSleeve: 62 cm',
      sourceMeasurementProfileId: DevSeedIds.measurementProfile2,
      sourceMeasurementProfileLabel: 'Default',
      status: OrderLocalStatus.newOrder,
      deliveryDate: now.add(const Duration(days: 5)),
      createdAt: now,
      updatedAt: now,
      totalAmountMinor: AfghanMarketDefaults.exampleGarmentLaborAfn * 2 + 200,
      paidAmountMinor: 0,
    ),
  ];
}
