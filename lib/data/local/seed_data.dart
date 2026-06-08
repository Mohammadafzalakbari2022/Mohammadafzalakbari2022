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

  static const waistcoatStyleName = 'wcncncnc-ncnc-4ncn-8ncn-ncncncncnc01';
  static const waistcoatPart01 = 'wcp01pcpc-pcpc-4cpc-8cpc-pcpcpcpcpc01';
  static const waistcoatPart02 = 'wcp02pcpc-pcpc-4cpc-8cpc-pcpcpcpcpc02';
  static const waistcoatPart03 = 'wcp03pcpc-pcpc-4cpc-8cpc-pcpcpcpcpc03';
  static const waistcoatPart04 = 'wcp04pcpc-pcpc-4cpc-8cpc-pcpcpcpcpc04';
  static const waistcoatPart05 = 'wcp05pcpc-pcpc-4cpc-8cpc-pcpcpcpcpc05';
  static const waistcoatPart06 = 'wcp06pcpc-pcpc-4cpc-8cpc-pcpcpcpcpc06';
  static const waistcoatPart07 = 'wcp07pcpc-pcpc-4cpc-8cpc-pcpcpcpcpc07';
  static const waistcoatPart08 = 'wcp08pcpc-pcpc-4cpc-8cpc-pcpcpcpcpc08';
  static const waistcoatFigure01 = 'wcf01fcfc-fcfc-4cfc-8cfc-fcfcfcfcfc01';
  static const waistcoatFigure02 = 'wcf02fcfc-fcfc-4cfc-8cfc-fcfcfcfcfc02';
  static const waistcoatFigure03 = 'wcf03fcfc-fcfc-4cfc-8cfc-fcfcfcfcfc03';
  static const waistcoatFigure04 = 'wcf04fcfc-fcfc-4cfc-8cfc-fcfcfcfcfc04';
  static const waistcoatFigure05 = 'wcf05fcfc-fcfc-4cfc-8cfc-fcfcfcfcfc05';
  static const waistcoatFigure06 = 'wcf06fcfc-fcfc-4cfc-8cfc-fcfcfcfcfc06';
  static const waistcoatFigure07 = 'wcf07fcfc-fcfc-4cfc-8cfc-fcfcfcfcfc07';
  static const waistcoatFigure08 = 'wcf08fcfc-fcfc-4cfc-8cfc-fcfcfcfcfc08';
  static const waistcoatFigure09 = 'wcf09fcfc-fcfc-4cfc-8cfc-fcfcfcfcfc09';
  static const waistcoatFigure10 = 'wcf10fcfc-fcfc-4cfc-8cfc-fcfcfcfcfc10';
  static const waistcoatFigure11 = 'wcf11fcfc-fcfc-4cfc-8cfc-fcfcfcfcfc11';
  static const waistcoatFigure12 = 'wcf12fcfc-fcfc-4cfc-8cfc-fcfcfcfcfc12';
  static const waistcoatFigure13 = 'wcf13fcfc-fcfc-4cfc-8cfc-fcfcfcfcfc13';
  static const waistcoatFigure14 = 'wcf14fcfc-fcfc-4cfc-8cfc-fcfcfcfcfc14';
  static const waistcoatFigure15 = 'wcf15fcfc-fcfc-4cfc-8cfc-fcfcfcfcfc15';
  static const waistcoatFigure16 = 'wcf16fcfc-fcfc-4cfc-8cfc-fcfcfcfcfc16';
  static const waistcoatFigure17 = 'wcf17fcfc-fcfc-4cfc-8cfc-fcfcfcfcfc17';
  static const waistcoatFigure18 = 'wcf18fcfc-fcfc-4cfc-8cfc-fcfcfcfcfc18';
  static const waistcoatFigure19 = 'wcf19fcfc-fcfc-4cfc-8cfc-fcfcfcfcfc19';
  static const waistcoatFigure20 = 'wcf20fcfc-fcfc-4cfc-8cfc-fcfcfcfcfc20';
  static const waistcoatFigure21 = 'wcf21fcfc-fcfc-4cfc-8cfc-fcfcfcfcfc21';
  static const waistcoatFigure22 = 'wcf22fcfc-fcfc-4cfc-8cfc-fcfcfcfcfc22';
  static const waistcoatFigure23 = 'wcf23fcfc-fcfc-4cfc-8cfc-fcfcfcfcfc23';
  static const waistcoatFigure24 = 'wcf24fcfc-fcfc-4cfc-8cfc-fcfcfcfcfc24';
  static const waistcoatFigure25 = 'wcf25fcfc-fcfc-4cfc-8cfc-fcfcfcfcfc25';
  static const waistcoatFigure26 = 'wcf26fcfc-fcfc-4cfc-8cfc-fcfcfcfcfc26';
  static const waistcoatFigure27 = 'wcf27fcfc-fcfc-4cfc-8cfc-fcfcfcfcfc27';
  static const waistcoatFigure28 = 'wcf28fcfc-fcfc-4cfc-8cfc-fcfcfcfcfc28';
  static const waistcoatFigure29 = 'wcf29fcfc-fcfc-4cfc-8cfc-fcfcfcfcfc29';
  static const waistcoatFigure30 = 'wcf30fcfc-fcfc-4cfc-8cfc-fcfcfcfcfc30';
  static const waistcoatFigure31 = 'wcf31fcfc-fcfc-4cfc-8cfc-fcfcfcfcfc31';
  static const waistcoatFigure32 = 'wcf32fcfc-fcfc-4cfc-8cfc-fcfcfcfcfc32';
  static const waistcoatFigure33 = 'wcf33fcfc-fcfc-4cfc-8cfc-fcfcfcfcfc33';
  static const waistcoatFigure34 = 'wcf34fcfc-fcfc-4cfc-8cfc-fcfcfcfcfc34';
  static const waistcoatFigure35 = 'wcf35fcfc-fcfc-4cfc-8cfc-fcfcfcfcfc35';
  static const waistcoatFigure36 = 'wcf36fcfc-fcfc-4cfc-8cfc-fcfcfcfcfc36';
  static const waistcoatFigure37 = 'wcf37fcfc-fcfc-4cfc-8cfc-fcfcfcfcfc37';
  static const waistcoatFigure38 = 'wcf38fcfc-fcfc-4cfc-8cfc-fcfcfcfcfc38';
  static const waistcoatFigure39 = 'wcf39fcfc-fcfc-4cfc-8cfc-fcfcfcfcfc39';
  static const waistcoatFigure40 = 'wcf40fcfc-fcfc-4cfc-8cfc-fcfcfcfcfc40';
  static const waistcoatFigure41 = 'wcf41fcfc-fcfc-4cfc-8cfc-fcfcfcfcfc41';
  static const waistcoatFigure42 = 'wcf42fcfc-fcfc-4cfc-8cfc-fcfcfcfcfc42';
  static const waistcoatFigure43 = 'wcf43fcfc-fcfc-4cfc-8cfc-fcfcfcfcfc43';
  static const waistcoatFigure44 = 'wcf44fcfc-fcfc-4cfc-8cfc-fcfcfcfcfc44';
  static const waistcoatFigure45 = 'wcf45fcfc-fcfc-4cfc-8cfc-fcfcfcfcfc45';
  static const waistcoatFigure46 = 'wcf46fcfc-fcfc-4cfc-8cfc-fcfcfcfcfc46';
  static const waistcoatFigure47 = 'wcf47fcfc-fcfc-4cfc-8cfc-fcfcfcfcfc47';
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
