import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

import 'dev_shop_constants.dart';
import 'entities/customer_entity.dart';
import 'entities/order_entity.dart';
import 'entities/order_measurement_snapshot_entity.dart';
import 'entities/order_measurement_snapshot_item_entity.dart';
import 'entities/order_status.dart';
import 'entities/payment_entity.dart';
import 'measurement_unit_codes.dart';
import 'order_list_repository.dart';
import 'order_measurement_snapshot_item_input.dart';
import 'order_measurement_snapshot_view.dart';
import 'order_summary.dart';
import 'seed_data.dart';

class IsarOrderRepository implements OrderListRepository {
  IsarOrderRepository(this._isar);

  final Isar _isar;
  final _uuid = const Uuid();

  @override
  Future<void> seedIfEmpty() async {
    if (await _isar.orderEntitys.count() > 0) return;

    final now = DateTime.now();

    final customers = [
      CustomerEntity()
        ..internalId = DevSeedIds.customer1
        ..shopId = kDevShopId
        ..name = 'Ahmad Karimi'
        ..phone = '0700000001'
        ..address = 'Kabul'
        ..notes = 'Prefers Friday fittings'
        ..createdAt = now,
      CustomerEntity()
        ..internalId = DevSeedIds.customer2
        ..shopId = kDevShopId
        ..name = 'Sara Mohseni'
        ..phone = '0700000002'
        ..address = null
        ..notes = null
        ..createdAt = now,
    ];

    final orders = [
      OrderEntity()
        ..internalId = DevSeedIds.order1
        ..shopId = kDevShopId
        ..customerInternalId = DevSeedIds.customer1
        ..displayOrderNo = '00000001'
        ..statusIndex = OrderLocalStatus.inProgress.code
        ..deliveryDate = now.add(const Duration(days: 2))
        ..updatedAt = now
        ..totalAmountMinor = 150000
        ..measurementsSnapshot =
            'Chest: 98 cm\nWaist: 84 cm\nLength: 112 cm'
        ..styleNotes = 'Karzai collar, two pockets'
        ..sourceMeasurementProfileId = DevSeedIds.measurementProfile1
        ..sourceMeasurementProfileLabel = 'Default',
      OrderEntity()
        ..internalId = DevSeedIds.order2
        ..shopId = kDevShopId
        ..customerInternalId = DevSeedIds.customer2
        ..displayOrderNo = '00000002'
        ..statusIndex = OrderLocalStatus.newOrder.code
        ..deliveryDate = now.add(const Duration(days: 5))
        ..updatedAt = now
        ..totalAmountMinor = 80000
        ..measurementsSnapshot = 'Shoulder: 46 cm\nSleeve: 62 cm'
        ..styleNotes = 'Simple collar'
        ..sourceMeasurementProfileId = DevSeedIds.measurementProfile2
        ..sourceMeasurementProfileLabel = 'Default',
      OrderEntity()
        ..internalId = DevSeedIds.order3
        ..shopId = kDevShopId
        ..customerInternalId = DevSeedIds.customer1
        ..displayOrderNo = '00000003'
        ..statusIndex = OrderLocalStatus.ready.code
        ..deliveryDate = now
        ..updatedAt = now
        ..totalAmountMinor = 120000
        ..measurementsSnapshot = 'Full suit — see notes'
        ..styleNotes = 'Classic fit, plain cuffs'
        ..sourceMeasurementProfileId = DevSeedIds.measurementProfile1
        ..sourceMeasurementProfileLabel = 'Default',
    ];

    final snap1 = OrderMeasurementSnapshotEntity()
      ..internalId = DevSeedIds.orderMeasurementSnapshot1
      ..orderInternalId = DevSeedIds.order1
      ..shopId = kDevShopId
      ..sourceMeasurementProfileId = DevSeedIds.measurementProfile1
      ..createdAt = now;
    final snap2 = OrderMeasurementSnapshotEntity()
      ..internalId = DevSeedIds.orderMeasurementSnapshot2
      ..orderInternalId = DevSeedIds.order2
      ..shopId = kDevShopId
      ..sourceMeasurementProfileId = DevSeedIds.measurementProfile2
      ..createdAt = now;

    final snapItems = <OrderMeasurementSnapshotItemEntity>[
      OrderMeasurementSnapshotItemEntity()
        ..snapshotInternalId = DevSeedIds.orderMeasurementSnapshot1
        ..shopId = kDevShopId
        ..measurementTypeInternalId = DevSeedIds.mtChest
        ..typeNameSnapshot = 'Chest'
        ..value = '98'
        ..unitCode = MeasurementUnitCodes.cm
        ..sortOrder = 10,
      OrderMeasurementSnapshotItemEntity()
        ..snapshotInternalId = DevSeedIds.orderMeasurementSnapshot1
        ..shopId = kDevShopId
        ..measurementTypeInternalId = DevSeedIds.mtWaist
        ..typeNameSnapshot = 'Waist'
        ..value = '84'
        ..unitCode = MeasurementUnitCodes.cm
        ..sortOrder = 20,
      OrderMeasurementSnapshotItemEntity()
        ..snapshotInternalId = DevSeedIds.orderMeasurementSnapshot1
        ..shopId = kDevShopId
        ..measurementTypeInternalId = DevSeedIds.mtLength
        ..typeNameSnapshot = 'Length'
        ..value = '112'
        ..unitCode = MeasurementUnitCodes.cm
        ..sortOrder = 30,
      OrderMeasurementSnapshotItemEntity()
        ..snapshotInternalId = DevSeedIds.orderMeasurementSnapshot2
        ..shopId = kDevShopId
        ..measurementTypeInternalId = DevSeedIds.mtShoulder
        ..typeNameSnapshot = 'Shoulder'
        ..value = '46'
        ..unitCode = MeasurementUnitCodes.cm
        ..sortOrder = 40,
      OrderMeasurementSnapshotItemEntity()
        ..snapshotInternalId = DevSeedIds.orderMeasurementSnapshot2
        ..shopId = kDevShopId
        ..measurementTypeInternalId = DevSeedIds.mtSleeve
        ..typeNameSnapshot = 'Sleeve'
        ..value = '62'
        ..unitCode = MeasurementUnitCodes.cm
        ..sortOrder = 60,
    ];

    final payments = [
      PaymentEntity()
        ..internalId = DevSeedIds.payment1
        ..shopId = kDevShopId
        ..orderInternalId = DevSeedIds.order1
        ..amountMinor = 50000
        ..method = 'cash'
        ..isAdjustment = false
        ..createdAt = now.subtract(const Duration(days: 1)),
      PaymentEntity()
        ..internalId = DevSeedIds.payment2
        ..shopId = kDevShopId
        ..orderInternalId = DevSeedIds.order1
        ..amountMinor = 20000
        ..method = 'cash'
        ..isAdjustment = false
        ..createdAt = now,
      PaymentEntity()
        ..internalId = DevSeedIds.payment3
        ..shopId = kDevShopId
        ..orderInternalId = DevSeedIds.order3
        ..amountMinor = 120000
        ..method = 'cash'
        ..isAdjustment = false
        ..createdAt = now,
    ];

    await _isar.writeTxn(() async {
      await _isar.customerEntitys.putAll(customers);
      await _isar.orderEntitys.putAll(orders);
      await _isar.orderMeasurementSnapshotEntitys.putAll([snap1, snap2]);
      await _isar.orderMeasurementSnapshotItemEntitys.putAll(snapItems);
      await _isar.paymentEntitys.putAll(payments);
    });
  }

  Future<OrderMeasurementSnapshotView?> _hydrateSnapshot(
    List<OrderMeasurementSnapshotEntity> snapshots,
  ) async {
    if (snapshots.isEmpty) return null;
    final s = snapshots.first;
    final raw = await _isar.orderMeasurementSnapshotItemEntitys
        .filter()
        .snapshotInternalIdEqualTo(s.internalId)
        .sortBySortOrder()
        .findAll();
    final items = raw
        .map(
          (e) => OrderMeasurementSnapshotItemView(
            measurementTypeInternalId: e.measurementTypeInternalId,
            typeName: e.typeNameSnapshot,
            value: e.value,
            unitCode: e.unitCode,
            sortOrder: e.sortOrder,
          ),
        )
        .toList();
    return OrderMeasurementSnapshotView(
      orderInternalId: s.orderInternalId,
      snapshotInternalId: s.internalId,
      sourceMeasurementProfileId: s.sourceMeasurementProfileId,
      createdAt: s.createdAt,
      items: items,
    );
  }

  @override
  Stream<OrderMeasurementSnapshotView?> watchOrderMeasurementSnapshot(
    String orderInternalId,
  ) {
    return _isar.orderMeasurementSnapshotEntitys
        .filter()
        .orderInternalIdEqualTo(orderInternalId)
        .watch(fireImmediately: true)
        .asyncMap(_hydrateSnapshot);
  }

  @override
  Stream<List<OrderSummary>> watchOrders([String shopId = kDevShopId]) {
    return _isar.orderEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .and()
        .deletedAtIsNull()
        .watch(fireImmediately: true)
        .asyncMap(_mapOrders);
  }

  Future<List<OrderSummary>> _mapOrders(List<OrderEntity> orders) async {
    final list = <OrderSummary>[];
    for (final o in orders) {
      final c = await _isar.customerEntitys
          .filter()
          .internalIdEqualTo(o.customerInternalId)
          .findFirst();
      final payments = await _isar.paymentEntitys
          .filter()
          .orderInternalIdEqualTo(o.internalId)
          .findAll();
      final paidMinor = payments.fold<int>(0, (sum, p) => sum + p.amountMinor);
      list.add(
        OrderSummary(
          shopId: o.shopId,
          internalId: o.internalId,
          displayOrderNo: o.displayOrderNo,
          customerInternalId: o.customerInternalId,
          customerName: c?.name ?? '—',
          customerPhone: c?.phone,
          measurementsSnapshot: o.measurementsSnapshot,
          styleNotes: o.styleNotes,
          internalNotes: o.internalNotes,
          sourceMeasurementProfileId: o.sourceMeasurementProfileId,
          sourceMeasurementProfileLabel: o.sourceMeasurementProfileLabel,
          status: orderStatusFromCode(o.statusIndex),
          deliveryDate: o.deliveryDate,
          totalAmountMinor: o.totalAmountMinor,
          paidAmountMinor: paidMinor,
        ),
      );
    }
    list.sort((a, b) => b.deliveryDate.compareTo(a.deliveryDate));
    return list;
  }

  Future<void> _insertSnapshotInTxn({
    required Isar isar,
    required String shopId,
    required String orderInternalId,
    String? sourceMeasurementProfileId,
    required List<OrderMeasurementSnapshotItemInput> items,
  }) async {
    if (items.isEmpty) return;
    final snapId = _uuid.v4();
    final created = DateTime.now();
    final header = OrderMeasurementSnapshotEntity()
      ..internalId = snapId
      ..orderInternalId = orderInternalId
      ..shopId = shopId
      ..sourceMeasurementProfileId = sourceMeasurementProfileId
      ..createdAt = created;
    await isar.orderMeasurementSnapshotEntitys.putByInternalId(header);
    final rows = <OrderMeasurementSnapshotItemEntity>[];
    for (final it in items) {
      rows.add(
        OrderMeasurementSnapshotItemEntity()
          ..snapshotInternalId = snapId
          ..shopId = shopId
          ..measurementTypeInternalId = it.measurementTypeInternalId
          ..typeNameSnapshot = it.typeName
          ..value = it.value
          ..unitCode = it.unitCode
          ..sortOrder = it.sortOrder,
      );
    }
    await isar.orderMeasurementSnapshotItemEntitys.putAll(rows);
  }

  @override
  Future<String> createOrder({
    required String shopId,
    required String customerInternalId,
    required DateTime deliveryDate,
    required int totalAmountMinor,
    required String measurementsSnapshot,
    required String styleNotes,
    String? customerSnapshotName,
    String? customerSnapshotPhone,
    String? sourceMeasurementProfileId,
    String sourceMeasurementProfileLabel = '',
    List<OrderMeasurementSnapshotItemInput>? measurementSnapshotItems,
  }) async {
    final now = DateTime.now();
    final internalId = _uuid.v4();

    final count = await _isar.orderEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .and()
        .deletedAtIsNull()
        .count();
    final displayOrderNo = (count + 1).toString().padLeft(8, '0');

    final e = OrderEntity()
      ..internalId = internalId
      ..shopId = shopId
      ..customerInternalId = customerInternalId
      ..displayOrderNo = displayOrderNo
      ..statusIndex = OrderLocalStatus.newOrder.code
      ..deliveryDate = deliveryDate
      ..updatedAt = now
      ..totalAmountMinor = totalAmountMinor
      ..measurementsSnapshot = measurementsSnapshot
      ..styleNotes = styleNotes
      ..sourceMeasurementProfileId = sourceMeasurementProfileId
      ..sourceMeasurementProfileLabel = sourceMeasurementProfileLabel;

    final snap = measurementSnapshotItems;
    await _isar.writeTxn(() async {
      await _isar.orderEntitys.putByInternalId(e);
      if (snap != null && snap.isNotEmpty) {
        await _insertSnapshotInTxn(
          isar: _isar,
          shopId: shopId,
          orderInternalId: internalId,
          sourceMeasurementProfileId: sourceMeasurementProfileId,
          items: snap,
        );
      }
    });
    return internalId;
  }

  @override
  Future<void> updateOrderStatus({
    required String orderInternalId,
    required OrderLocalStatus newStatus,
  }) async {
    await _isar.writeTxn(() async {
      final existing =
          await _isar.orderEntitys.getByInternalId(orderInternalId);
      if (existing == null) return;
      existing.statusIndex = newStatus.code;
      existing.updatedAt = DateTime.now();
      await _isar.orderEntitys.putByInternalId(existing);
    });
  }

  @override
  Future<void> updateOrderInternalNotes({
    required String orderInternalId,
    required String internalNotes,
  }) async {
    await _isar.writeTxn(() async {
      final existing =
          await _isar.orderEntitys.getByInternalId(orderInternalId);
      if (existing == null) return;
      existing.internalNotes = internalNotes;
      existing.updatedAt = DateTime.now();
      await _isar.orderEntitys.putByInternalId(existing);
    });
  }
}
