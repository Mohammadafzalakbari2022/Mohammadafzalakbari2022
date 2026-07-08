import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

import '../../core/defaults/afghan_market_defaults.dart';
import 'dev_shop_constants.dart';
import 'customer_name_rules.dart';
import 'entities/customer_entity.dart';
import 'entities/order_entity.dart';
import 'entities/order_item_entity.dart';
import 'entities/garment_type.dart';
import 'entities/order_measurement_snapshot_entity.dart';
import 'entities/order_measurement_snapshot_item_entity.dart';
import 'entities/order_status.dart';
import 'entities/payment_entity.dart';
import 'measurement_unit_codes.dart';
import 'order_list_repository.dart';
import 'order_measurement_snapshot_item_input.dart';
import 'entities/order_style_snapshot_entity.dart';
import 'entities/order_style_snapshot_figure_entity.dart';
import 'order_measurement_snapshot_view.dart';
import 'order_style_snapshot_figure_input.dart';
import 'order_style_snapshot_view.dart';
import 'order_customer_history.dart';
import 'order_item_input.dart';
import 'order_item_input_io.dart';
import 'order_item_persist.dart';
import 'order_item_summary.dart';
import 'order_sync_payload.dart';
import 'order_sync_payload_io.dart';
import 'order_summary.dart';
import 'seed_data.dart';
import 'catalog/catalog_order_snapshot.dart';
import 'style/order_style_snapshot_persist.dart';
import 'style/order_style_snapshot_persist_io.dart';
import 'sync_pull_payload.dart';
import '../../core/sync/sync_conflict_helpers.dart';

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
        ..displayCustomerNo = '00000001'
        ..phone = '0700000001'
        ..address = 'Kabul'
        ..notes = 'Prefers Friday fittings'
        ..createdAt = now,
      CustomerEntity()
        ..internalId = DevSeedIds.customer2
        ..shopId = kDevShopId
        ..name = 'Sara Mohseni'
        ..displayCustomerNo = '00000002'
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
        ..createdAt = now
        ..updatedAt = now
        ..totalAmountMinor = AfghanMarketDefaults.exampleOrderTotalAfn
        ..measurementsSnapshot =
            'Chest: 98 cm\nWaist: 84 cm\nLength: 112 cm'
        ..sourceMeasurementProfileId = DevSeedIds.measurementProfile1
        ..sourceMeasurementProfileLabel = 'Default',
      OrderEntity()
        ..internalId = DevSeedIds.order2
        ..shopId = kDevShopId
        ..customerInternalId = DevSeedIds.customer2
        ..displayOrderNo = '00000002'
        ..statusIndex = OrderLocalStatus.newOrder.code
        ..deliveryDate = now.add(const Duration(days: 5))
        ..createdAt = now
        ..updatedAt = now
        ..totalAmountMinor = 800
        ..measurementsSnapshot = 'Shoulder: 46 cm\nSleeve: 62 cm'
        ..sourceMeasurementProfileId = DevSeedIds.measurementProfile2
        ..sourceMeasurementProfileLabel = 'Default',
      OrderEntity()
        ..internalId = DevSeedIds.order3
        ..shopId = kDevShopId
        ..customerInternalId = DevSeedIds.customer1
        ..displayOrderNo = '00000003'
        ..statusIndex = OrderLocalStatus.ready.code
        ..deliveryDate = now
        ..createdAt = now
        ..updatedAt = now
        ..totalAmountMinor = 1200
        ..measurementsSnapshot = 'Full suit — see notes'
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
        ..amountMinor = 500
        ..method = 'cash'
        ..isAdjustment = false
        ..createdAt = now.subtract(const Duration(days: 1)),
      PaymentEntity()
        ..internalId = DevSeedIds.payment2
        ..shopId = kDevShopId
        ..orderInternalId = DevSeedIds.order1
        ..amountMinor = 200
        ..method = 'cash'
        ..isAdjustment = false
        ..createdAt = now,
      PaymentEntity()
        ..internalId = DevSeedIds.payment3
        ..shopId = kDevShopId
        ..orderInternalId = DevSeedIds.order3
        ..amountMinor = 1200
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
    final legacy = snapshots
        .where((s) => s.orderItemInternalId.trim().isEmpty)
        .toList();
    final s = legacy.isNotEmpty ? legacy.first : snapshots.first;
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

  Future<OrderStyleSnapshotView?> _hydrateStyleSnapshot(
    List<OrderStyleSnapshotEntity> headers,
  ) async {
    if (headers.isEmpty) return null;
    final legacy = headers
        .where((s) => s.orderItemInternalId.trim().isEmpty)
        .toList();
    final s = legacy.isNotEmpty ? legacy.first : headers.first;
    final figureRows = await _isar.orderStyleSnapshotFigureEntitys
        .filter()
        .snapshotInternalIdEqualTo(s.internalId)
        .sortBySortOrder()
        .findAll();
    final figures = figureRows
        .map(
          (e) {
            final textOptions = decodeOrderShapeOptionSnapshots(
              e.textOptionsSnapshotJson,
            );
            final sizeOptions = decodeOrderShapeSizeSnapshots(
              e.sizeOptionsSnapshotJson,
            );
            return OrderStyleSnapshotFigureView(
              styleFigureInternalId: e.styleFigureInternalId,
              figureNameSnapshot: e.figureNameSnapshot,
              imageRefSnapshot: e.imageRefSnapshot,
              sortOrder: e.sortOrder,
              textOptions: textOptions
                  .map(
                    (opt) => OrderShapeOptionSnapshotView(
                      id: opt.id,
                      labelSnapshot: opt.labelSnapshot,
                    ),
                  )
                  .toList(growable: false),
              sizeOptions: sizeOptions
                  .map(
                    (opt) => OrderShapeSizeSnapshotView(
                      id: opt.id,
                      valueSnapshot: opt.valueSnapshot,
                      labelSnapshot: opt.labelSnapshot,
                      unitSnapshot: opt.unitSnapshot,
                    ),
                  )
                  .toList(growable: false),
              noteSnapshot: e.noteSnapshot,
            );
          },
        )
        .toList();
    return OrderStyleSnapshotView(
      orderInternalId: s.orderInternalId,
      snapshotInternalId: s.internalId,
      styleNameSnapshot: s.styleNameSnapshot,
      styleNameInternalIdSnapshot: s.styleNameInternalIdSnapshot,
      createdAt: s.createdAt,
      figures: figures,
    );
  }

  @override
  Stream<OrderStyleSnapshotView?> watchOrderStyleSnapshot(
    String orderInternalId,
  ) {
    return _isar.orderStyleSnapshotEntitys
        .filter()
        .orderInternalIdEqualTo(orderInternalId)
        .watch(fireImmediately: true)
        .asyncMap(_hydrateStyleSnapshot);
  }

  @override
  Stream<OrderMeasurementSnapshotView?> watchOrderItemMeasurementSnapshot(
    String orderInternalId,
    String orderItemInternalId,
  ) {
    final itemId = orderItemInternalId.trim();
    if (itemId.isEmpty) {
      return watchOrderMeasurementSnapshot(orderInternalId);
    }
    return _isar.orderMeasurementSnapshotEntitys
        .filter()
        .orderInternalIdEqualTo(orderInternalId)
        .and()
        .orderItemInternalIdEqualTo(itemId)
        .watch(fireImmediately: true)
        .asyncMap(_hydrateSnapshot);
  }

  @override
  Stream<OrderStyleSnapshotView?> watchOrderItemStyleSnapshot(
    String orderInternalId,
    String orderItemInternalId,
  ) {
    final itemId = orderItemInternalId.trim();
    if (itemId.isEmpty) {
      return watchOrderStyleSnapshot(orderInternalId);
    }
    return _isar.orderStyleSnapshotEntitys
        .filter()
        .orderInternalIdEqualTo(orderInternalId)
        .and()
        .orderItemInternalIdEqualTo(itemId)
        .watch(fireImmediately: true)
        .asyncMap(_hydrateStyleSnapshot);
  }

  @override
  Stream<List<OrderItemSummary>> watchOrderItems(String orderInternalId) {
    return _isar.orderItemEntitys
        .filter()
        .orderInternalIdEqualTo(orderInternalId)
        .and()
        .deletedAtIsNull()
        .watch(fireImmediately: true)
        .map((rows) {
      final items = rows.map(orderItemSummaryFromEntity).toList();
      return OrderItemSummary.sorted(items);
    });
  }

  Future<void> _syncPrimaryItemFlatFieldsOnOrder(
    Isar isar,
    OrderEntity order,
  ) async {
    final items = await loadActiveOrderItems(isar, order.internalId);
    OrderItemEntity? primary;
    for (final item in items) {
      if (item.garmentTypeIndex == GarmentType.perahanTunban.code) {
        primary = item;
        break;
      }
    }
    primary ??= items.isEmpty ? null : items.first;
    if (primary != null) {
      copyOrderItemFieldsOntoOrderEntity(order, primary);
    }
  }

  Future<void> _recomputeOrderTotalInTxn(
    Isar isar,
    OrderEntity order,
    int paidMinor,
  ) async {
    final items = await loadActiveOrderItems(isar, order.internalId);
    if (items.isEmpty) return;
    final sum = sumOrderItemPrices(items);
    if (sum < paidMinor) {
      throw const OrderItemRepositoryException('order_total_below_paid');
    }
    order.totalAmountMinor = sum;
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

  @override
  Stream<OrderSummary?> watchOrderByInternalId(String internalId) {
    final id = internalId.trim();
    if (id.isEmpty) {
      return Stream.value(null);
    }
    return _isar.orderEntitys
        .filter()
        .internalIdEqualTo(id)
        .watch(fireImmediately: true)
        .asyncMap((rows) async {
          if (rows.isEmpty) return null;
          return _mapOrderEntity(rows.first);
        });
  }

  @override
  Future<Map<String, OrderSummary>> resolveOrdersByInternalIds({
    required String shopId,
    required Iterable<String> internalIds,
  }) async {
    final ids = internalIds
        .map((id) => id.trim())
        .where((id) => id.isNotEmpty)
        .toSet();
    if (ids.isEmpty) return {};

    final out = <String, OrderSummary>{};
    for (final id in ids) {
      final entity = await _isar.orderEntitys
          .filter()
          .shopIdEqualTo(shopId)
          .and()
          .internalIdEqualTo(id)
          .findFirst();
      if (entity == null) continue;
      out[id] = await _mapOrderEntity(entity);
    }
    return out;
  }

  Future<List<OrderSummary>> _mapOrders(List<OrderEntity> orders) async {
    final list = <OrderSummary>[];
    for (final o in orders) {
      list.add(await _mapOrderEntity(o));
    }
    list.sort((a, b) {
      final aCreated = a.createdAt;
      final bCreated = b.createdAt;
      return bCreated.compareTo(aCreated);
    });
    return list;
  }

  Future<OrderSummary> _mapOrderEntity(OrderEntity o) async {
    final c = await _isar.customerEntitys
        .filter()
        .internalIdEqualTo(o.customerInternalId)
        .findFirst();
    final payments = await _isar.paymentEntitys
        .filter()
        .orderInternalIdEqualTo(o.internalId)
        .findAll();
    final paidMinor = payments.fold<int>(0, (sum, p) => sum + p.amountMinor);
    final snapName = o.customerNameSnapshot.trim();
    final snapPhone = o.customerPhoneSnapshot.trim();
    final itemRows = await loadActiveOrderItems(_isar, o.internalId);
    final items = itemRows.map(orderItemSummaryFromEntity).toList();
    final flat = flatGarmentFieldsForOrderEntity(order: o, items: items);
    return OrderSummary(
      shopId: o.shopId,
      internalId: o.internalId,
      displayOrderNo: o.displayOrderNo,
      customerInternalId: o.customerInternalId,
      customerName: snapName.isNotEmpty ? snapName : (c?.name ?? '—'),
      customerPhone: snapPhone.isNotEmpty ? snapPhone : c?.phone,
      customerChangeHistory:
          parseOrderCustomerHistoryJson(o.customerChangeHistoryJson),
      measurementsSnapshot: flat.measurementsSnapshot,
      internalNotes: o.internalNotes,
      sourceMeasurementProfileId: flat.sourceMeasurementProfileId,
      sourceMeasurementProfileLabel: flat.sourceMeasurementProfileLabel,
      styleName: flat.styleName,
      styleNameInternalId: flat.styleNameInternalId,
      styleSelectionJson: flat.styleSelectionJson,
      styleSummary: flat.styleSummary,
      catalogItemInternalId: flat.catalogItemInternalId,
      catalogDesignNameSnapshot: flat.catalogDesignNameSnapshot,
      catalogDesignerShopNameSnapshot: flat.catalogDesignerShopNameSnapshot,
      catalogImagePathSnapshot: flat.catalogImagePathSnapshot,
      catalogThumbnailPathSnapshot: flat.catalogThumbnailPathSnapshot,
      fabricNameSnapshot: flat.fabricNameSnapshot,
      fabricColorSnapshot: flat.fabricColorSnapshot,
      fabricIdSnapshot: flat.fabricIdSnapshot,
      fabricNamePresetInternalId: flat.fabricNamePresetInternalId,
      fabricColorPresetInternalId: flat.fabricColorPresetInternalId,
      items: items,
      status: orderStatusFromCode(o.statusIndex),
      deliveryDate: o.deliveryDate,
      createdAt: o.createdAt ?? o.updatedAt,
      updatedAt: o.updatedAt,
      totalAmountMinor: o.totalAmountMinor,
      paidAmountMinor: paidMinor,
    );
  }

  Future<void> _insertSnapshotInTxn({
    required Isar isar,
    required String shopId,
    required String orderInternalId,
    String? orderItemInternalId,
    String? sourceMeasurementProfileId,
    required List<OrderMeasurementSnapshotItemInput> items,
  }) async {
    if (items.isEmpty) return;
    final snapId = _uuid.v4();
    final created = DateTime.now();
    final header = OrderMeasurementSnapshotEntity()
      ..internalId = snapId
      ..orderInternalId = orderInternalId
      ..orderItemInternalId = orderItemInternalId?.trim() ?? ''
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
    String? customerSnapshotName,
    String? customerSnapshotPhone,
    String? sourceMeasurementProfileId,
    String sourceMeasurementProfileLabel = '',
    List<OrderMeasurementSnapshotItemInput>? measurementSnapshotItems,
    required String styleName,
    String? styleNameInternalId,
    String styleSelectionJson = '',
    String styleSummary = '',
    String? catalogItemInternalId,
    String catalogDesignNameSnapshot = '',
    String catalogDesignerShopNameSnapshot = '',
    String? catalogImagePathSnapshot,
    String? catalogThumbnailPathSnapshot,
    String? catalogSourceImagePath,
    String? catalogSourceThumbnailPath,
    String fabricNameSnapshot = '',
    String fabricColorSnapshot = '',
    String fabricIdSnapshot = '',
    String? fabricNamePresetInternalId,
    String? fabricColorPresetInternalId,
  }) {
    return createOrderWithItems(
      shopId: shopId,
      customerInternalId: customerInternalId,
      deliveryDate: deliveryDate,
      customerSnapshotName: customerSnapshotName,
      customerSnapshotPhone: customerSnapshotPhone,
      items: [
        OrderItemCreateInput(
          garmentType: GarmentType.perahanTunban,
          priceAmountMinor: totalAmountMinor,
          measurementsSnapshot: measurementsSnapshot,
          sourceMeasurementProfileId: sourceMeasurementProfileId,
          sourceMeasurementProfileLabel: sourceMeasurementProfileLabel,
          measurementSnapshotItems: measurementSnapshotItems,
          styleName: styleName,
          styleNameInternalId: styleNameInternalId,
          styleSelectionJson: styleSelectionJson,
          styleSummary: styleSummary,
          catalogItemInternalId: catalogItemInternalId,
          catalogDesignNameSnapshot: catalogDesignNameSnapshot,
          catalogDesignerShopNameSnapshot: catalogDesignerShopNameSnapshot,
          catalogImagePathSnapshot: catalogImagePathSnapshot,
          catalogThumbnailPathSnapshot: catalogThumbnailPathSnapshot,
          catalogSourceImagePath: catalogSourceImagePath,
          catalogSourceThumbnailPath: catalogSourceThumbnailPath,
          fabricNameSnapshot: fabricNameSnapshot,
          fabricColorSnapshot: fabricColorSnapshot,
          fabricIdSnapshot: fabricIdSnapshot,
          fabricNamePresetInternalId: fabricNamePresetInternalId,
          fabricColorPresetInternalId: fabricColorPresetInternalId,
        ),
      ],
    );
  }

  @override
  Future<String> createOrderWithItems({
    required String shopId,
    required String customerInternalId,
    required DateTime deliveryDate,
    required List<OrderItemCreateInput> items,
    String? customerSnapshotName,
    String? customerSnapshotPhone,
  }) async {
    assertAtLeastOneItem(items);
    assertUniqueGarmentTypes(items);
    assertItemPricesValid(items);

    final now = DateTime.now();
    final internalId = _uuid.v4();
    final totalAmountMinor = sumCreateInputTotalMinor(items);

    final count = await _isar.orderEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .and()
        .deletedAtIsNull()
        .count();
    final displayOrderNo = (count + 1).toString().padLeft(8, '0');

    final customerRow = await _isar.customerEntitys
        .filter()
        .internalIdEqualTo(customerInternalId)
        .findFirst();
    final resolvedName = (customerSnapshotName?.trim().isNotEmpty ?? false)
        ? customerSnapshotName!.trim()
        : (customerRow?.name ?? '');
    assertValidCustomerName(resolvedName);
    final resolvedPhone = customerSnapshotPhone?.trim().isNotEmpty ?? false
        ? customerSnapshotPhone!.trim()
        : (customerRow?.phone ?? '');

    final primary = items.firstWhere(
      (i) => i.garmentType == GarmentType.perahanTunban,
      orElse: () => items.first,
    );

    final e = OrderEntity()
      ..internalId = internalId
      ..shopId = shopId
      ..customerInternalId = customerInternalId
      ..customerNameSnapshot = resolvedName
      ..customerPhoneSnapshot = resolvedPhone
      ..displayOrderNo = displayOrderNo
      ..statusIndex = OrderLocalStatus.newOrder.code
      ..deliveryDate = deliveryDate
      ..createdAt = now
      ..updatedAt = now
      ..totalAmountMinor = totalAmountMinor
      ..measurementsSnapshot = primary.measurementsSnapshot
      ..sourceMeasurementProfileId = primary.sourceMeasurementProfileId
      ..sourceMeasurementProfileLabel = primary.sourceMeasurementProfileLabel
      ..styleName = primary.styleName.trim()
      ..styleNameInternalId = primary.styleNameInternalId
      ..styleSelectionJson = primary.styleSelectionJson
      ..styleSummary = primary.styleSummary
      ..catalogItemInternalId = primary.catalogItemInternalId
      ..catalogDesignNameSnapshot = primary.catalogDesignNameSnapshot.trim()
      ..catalogDesignerShopNameSnapshot =
          primary.catalogDesignerShopNameSnapshot.trim()
      ..fabricNameSnapshot = primary.fabricNameSnapshot.trim()
      ..fabricColorSnapshot = primary.fabricColorSnapshot.trim()
      ..fabricIdSnapshot = primary.fabricIdSnapshot.trim()
      ..fabricNamePresetInternalId = primary.fabricNamePresetInternalId
      ..fabricColorPresetInternalId = primary.fabricColorPresetInternalId;

    await _isar.writeTxn(() async {
      await _isar.orderEntitys.putByInternalId(e);
      for (final input in items) {
        await upsertOrderItemInTxn(
          isar: _isar,
          shopId: shopId,
          orderInternalId: internalId,
          input: input,
          newId: _uuid.v4,
          newSnapshotInternalId: _uuid.v4,
        );
      }
      await _syncPrimaryItemFlatFieldsOnOrder(_isar, e);
      await _isar.orderEntitys.putByInternalId(e);
    });
    return internalId;
  }

  @override
  Future<void> upsertOrderItem({
    required String orderInternalId,
    required OrderItemCreateInput input,
  }) async {
    if (input.priceAmountMinor < 0 || input.clothPriceAmountMinor < 0) {
      throw const OrderItemRepositoryException('item_price_required');
    }
    final order = await _isar.orderEntitys.getByInternalId(orderInternalId);
    if (order == null) return;

    final payments = await _isar.paymentEntitys
        .filter()
        .orderInternalIdEqualTo(orderInternalId)
        .findAll();
    final paidMinor = payments.fold<int>(0, (sum, p) => sum + p.amountMinor);

    await _isar.writeTxn(() async {
      await upsertOrderItemInTxn(
        isar: _isar,
        shopId: order.shopId,
        orderInternalId: orderInternalId,
        input: input,
        newId: _uuid.v4,
        newSnapshotInternalId: _uuid.v4,
      );
      final row = await _isar.orderEntitys.getByInternalId(orderInternalId);
      if (row == null) return;
      await _recomputeOrderTotalInTxn(_isar, row, paidMinor);
      await _syncPrimaryItemFlatFieldsOnOrder(_isar, row);
      row.updatedAt = DateTime.now();
      await _isar.orderEntitys.putByInternalId(row);
    });
  }

  @override
  Future<void> addOrderItem({
    required String orderInternalId,
    required OrderItemCreateInput input,
  }) async {
    final existing = await findActiveOrderItemByGarmentType(
      _isar,
      orderInternalId,
      input.garmentType.code,
    );
    if (existing != null) {
      throw const OrderItemRepositoryException('duplicate_garment_type');
    }
    await upsertOrderItem(orderInternalId: orderInternalId, input: input);
  }

  @override
  Future<void> removeOrderItem({
    required String orderInternalId,
    required GarmentType garmentType,
  }) async {
    final items = await loadActiveOrderItems(_isar, orderInternalId);
    if (items.length <= 1) {
      throw const OrderItemRepositoryException('cannot_remove_last_item');
    }
    final target = await findActiveOrderItemByGarmentType(
      _isar,
      orderInternalId,
      garmentType.code,
    );
    if (target == null) return;

    final payments = await _isar.paymentEntitys
        .filter()
        .orderInternalIdEqualTo(orderInternalId)
        .findAll();
    final paidMinor = payments.fold<int>(0, (sum, p) => sum + p.amountMinor);

    await _isar.writeTxn(() async {
      final now = DateTime.now();
      target
        ..deletedAt = now
        ..updatedAt = now;
      await _isar.orderItemEntitys.putByInternalId(target);
      await deleteMeasurementSnapshotsForItem(_isar, target.internalId);
      await deleteOrderStyleSnapshotsForOrderItem(_isar, target.internalId);

      final row = await _isar.orderEntitys.getByInternalId(orderInternalId);
      if (row == null) return;
      await _recomputeOrderTotalInTxn(_isar, row, paidMinor);
      await _syncPrimaryItemFlatFieldsOnOrder(_isar, row);
      row.updatedAt = now;
      await _isar.orderEntitys.putByInternalId(row);
    });
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

  Future<void> _deleteMeasurementSnapshotsForOrder(
    Isar isar,
    String orderInternalId,
  ) async {
    final headers = await isar.orderMeasurementSnapshotEntitys
        .filter()
        .orderInternalIdEqualTo(orderInternalId)
        .findAll();
    for (final h in headers) {
      await isar.orderMeasurementSnapshotItemEntitys
          .filter()
          .snapshotInternalIdEqualTo(h.internalId)
          .deleteAll();
    }
    await isar.orderMeasurementSnapshotEntitys
        .filter()
        .orderInternalIdEqualTo(orderInternalId)
        .deleteAll();
  }

  @override
  Future<void> updateOrderDetails({
    required String orderInternalId,
    String? customerInternalId,
    String? customerSnapshotName,
    String? customerSnapshotPhone,
    DateTime? deliveryDate,
    int? totalAmountMinor,
    String? measurementsSnapshot,
    String? sourceMeasurementProfileId,
    String? sourceMeasurementProfileLabel,
    List<OrderMeasurementSnapshotItemInput>? measurementSnapshotItems,
    String? styleName,
    String? styleNameInternalId,
    String? styleSelectionJson,
    String? styleSummary,
    String? catalogItemInternalId,
    String? catalogDesignNameSnapshot,
    String? catalogDesignerShopNameSnapshot,
    String? catalogSourceImagePath,
    String? catalogSourceThumbnailPath,
    String? fabricNameSnapshot,
    String? fabricColorSnapshot,
    String? fabricIdSnapshot,
    String? fabricNamePresetInternalId,
    String? fabricColorPresetInternalId,
    String? internalNotes,
  }) async {
    final existing =
        await _isar.orderEntitys.getByInternalId(orderInternalId);
    if (existing == null) return;

    if (totalAmountMinor != null) {
      final payments = await _isar.paymentEntitys
          .filter()
          .orderInternalIdEqualTo(orderInternalId)
          .findAll();
      final paidMinor =
          payments.fold<int>(0, (sum, p) => sum + p.amountMinor);
      if (totalAmountMinor <= 0 || totalAmountMinor < paidMinor) {
        throw StateError('order_total_below_paid');
      }
    }

    String? resolvedImagePath;
    String? resolvedThumbPath;
    if (catalogDesignNameSnapshot != null &&
        catalogDesignNameSnapshot.trim().isNotEmpty &&
        catalogSourceImagePath != null &&
        catalogSourceImagePath.isNotEmpty) {
      final copied = await copyCatalogPathsToOrderSnapshot(
        orderInternalId: orderInternalId,
        imagePath: catalogSourceImagePath,
        thumbnailPath: catalogSourceThumbnailPath,
      );
      if (copied != null) {
        resolvedImagePath = copied.imagePath;
        resolvedThumbPath = copied.thumbnailPath;
      }
    }

    final now = DateTime.now();
    await _isar.writeTxn(() async {
      final e = await _isar.orderEntitys.getByInternalId(orderInternalId);
      if (e == null) return;

      if (customerInternalId != null) {
        e.customerInternalId = customerInternalId;
      }
      if (customerInternalId != null ||
          customerSnapshotName != null ||
          customerSnapshotPhone != null) {
        final fromName = e.customerNameSnapshot.trim().isNotEmpty
            ? e.customerNameSnapshot.trim()
            : (await _isar.customerEntitys
                    .filter()
                    .internalIdEqualTo(e.customerInternalId)
                    .findFirst())
                ?.name ??
                '';
        final fromPhone = e.customerPhoneSnapshot.trim().isNotEmpty
            ? e.customerPhoneSnapshot.trim()
            : (await _isar.customerEntitys
                    .filter()
                    .internalIdEqualTo(e.customerInternalId)
                    .findFirst())
                ?.phone;
        final toName = customerSnapshotName?.trim().isNotEmpty ?? false
            ? customerSnapshotName!.trim()
            : fromName;
        final toPhone = customerSnapshotPhone != null
            ? customerSnapshotPhone.trim()
            : (fromPhone ?? '');
        final history = parseOrderCustomerHistoryJson(
          e.customerChangeHistoryJson,
        );
        final updatedHistory = appendOrderCustomerHistory(
          existing: history,
          fromName: fromName,
          fromPhone: fromPhone,
          toName: toName,
          toPhone: toPhone.isEmpty ? null : toPhone,
          changedAt: now,
        );
        e.customerChangeHistoryJson =
            encodeOrderCustomerHistory(updatedHistory);
        e.customerNameSnapshot = toName;
        e.customerPhoneSnapshot = toPhone;
      }
      if (deliveryDate != null) e.deliveryDate = deliveryDate;
      if (totalAmountMinor != null) e.totalAmountMinor = totalAmountMinor;
      if (measurementsSnapshot != null) {
        e.measurementsSnapshot = measurementsSnapshot;
      }
      if (sourceMeasurementProfileId != null) {
        e.sourceMeasurementProfileId = sourceMeasurementProfileId;
      }
      if (sourceMeasurementProfileLabel != null) {
        e.sourceMeasurementProfileLabel = sourceMeasurementProfileLabel;
      }
      if (styleName != null) e.styleName = styleName.trim();
      if (styleNameInternalId != null) {
        e.styleNameInternalId = styleNameInternalId;
      }
      if (styleSelectionJson != null) {
        e.styleSelectionJson = styleSelectionJson;
      }
      if (styleSummary != null) e.styleSummary = styleSummary;
      if (catalogItemInternalId != null) {
        e.catalogItemInternalId = catalogItemInternalId;
      }
      if (catalogDesignNameSnapshot != null) {
        e.catalogDesignNameSnapshot = catalogDesignNameSnapshot.trim();
      }
      if (catalogDesignerShopNameSnapshot != null) {
        e.catalogDesignerShopNameSnapshot =
            catalogDesignerShopNameSnapshot.trim();
      }
      if (resolvedImagePath != null) {
        e.catalogImagePathSnapshot = resolvedImagePath;
      }
      if (resolvedThumbPath != null) {
        e.catalogThumbnailPathSnapshot = resolvedThumbPath;
      }
      if (fabricNameSnapshot != null) {
        e.fabricNameSnapshot = fabricNameSnapshot.trim();
      }
      if (fabricColorSnapshot != null) {
        e.fabricColorSnapshot = fabricColorSnapshot.trim();
      }
      if (fabricIdSnapshot != null) {
        e.fabricIdSnapshot = fabricIdSnapshot.trim();
      }
      if (fabricNamePresetInternalId != null) {
        e.fabricNamePresetInternalId = fabricNamePresetInternalId;
      }
      if (fabricColorPresetInternalId != null) {
        e.fabricColorPresetInternalId = fabricColorPresetInternalId;
      }
      if (internalNotes != null) e.internalNotes = internalNotes;

      e.updatedAt = now;
      await _isar.orderEntitys.putByInternalId(e);

      final perahanItem = await findActiveOrderItemByGarmentType(
        _isar,
        orderInternalId,
        GarmentType.perahanTunban.code,
      );

      if (totalAmountMinor != null && perahanItem != null) {
        final activeItems = await loadActiveOrderItems(_isar, orderInternalId);
        if (activeItems.length == 1) {
          perahanItem.priceAmountMinor = totalAmountMinor;
          perahanItem.updatedAt = now;
          await _isar.orderItemEntitys.putByInternalId(perahanItem);
        }
      }

      if (perahanItem != null &&
          (measurementsSnapshot != null ||
              sourceMeasurementProfileId != null ||
              sourceMeasurementProfileLabel != null ||
              styleName != null ||
              styleNameInternalId != null ||
              styleSelectionJson != null ||
              styleSummary != null ||
              catalogItemInternalId != null ||
              catalogDesignNameSnapshot != null ||
              catalogDesignerShopNameSnapshot != null ||
              resolvedImagePath != null ||
              resolvedThumbPath != null ||
              fabricNameSnapshot != null ||
              fabricColorSnapshot != null ||
              fabricIdSnapshot != null ||
              fabricNamePresetInternalId != null ||
              fabricColorPresetInternalId != null)) {
        perahanItem
          ..measurementsSnapshot = e.measurementsSnapshot
          ..sourceMeasurementProfileId = e.sourceMeasurementProfileId
          ..sourceMeasurementProfileLabel = e.sourceMeasurementProfileLabel
          ..styleName = e.styleName
          ..styleNameInternalId = e.styleNameInternalId
          ..styleSelectionJson = e.styleSelectionJson
          ..styleSummary = e.styleSummary
          ..catalogItemInternalId = e.catalogItemInternalId
          ..catalogDesignNameSnapshot = e.catalogDesignNameSnapshot
          ..catalogDesignerShopNameSnapshot = e.catalogDesignerShopNameSnapshot
          ..catalogImagePathSnapshot = e.catalogImagePathSnapshot
          ..catalogThumbnailPathSnapshot = e.catalogThumbnailPathSnapshot
          ..fabricNameSnapshot = e.fabricNameSnapshot
          ..fabricColorSnapshot = e.fabricColorSnapshot
          ..fabricIdSnapshot = e.fabricIdSnapshot
          ..fabricNamePresetInternalId = e.fabricNamePresetInternalId
          ..fabricColorPresetInternalId = e.fabricColorPresetInternalId
          ..updatedAt = now;
        await _isar.orderItemEntitys.putByInternalId(perahanItem);
      }

      if (measurementSnapshotItems != null) {
        if (perahanItem != null) {
          await deleteMeasurementSnapshotsForItem(_isar, perahanItem.internalId);
          if (measurementSnapshotItems.isNotEmpty) {
            await insertMeasurementSnapshotForItemInTxn(
              isar: _isar,
              shopId: e.shopId,
              orderInternalId: orderInternalId,
              orderItemInternalId: perahanItem.internalId,
              sourceMeasurementProfileId: e.sourceMeasurementProfileId,
              items: measurementSnapshotItems,
              newSnapshotInternalId: _uuid.v4,
            );
          }
        } else {
          await _deleteMeasurementSnapshotsForOrder(_isar, orderInternalId);
          if (measurementSnapshotItems.isNotEmpty) {
            await _insertSnapshotInTxn(
              isar: _isar,
              shopId: e.shopId,
              orderInternalId: orderInternalId,
              sourceMeasurementProfileId: e.sourceMeasurementProfileId,
              items: measurementSnapshotItems,
            );
          }
        }
      }

      final styleFieldsChanged = styleName != null ||
          styleNameInternalId != null ||
          styleSelectionJson != null ||
          styleSummary != null;
      if (styleFieldsChanged) {
        final figures = await loadStyleFiguresForShop(_isar, e.shopId);
        await persistOrderStyleSnapshotInTxn(
          isar: _isar,
          shopId: e.shopId,
          orderInternalId: orderInternalId,
          orderItemInternalId: perahanItem?.internalId,
          styleName: e.styleName,
          styleNameInternalId: e.styleNameInternalId,
          styleSelectionJson: e.styleSelectionJson,
          allFigures: figures,
          newSnapshotInternalId: () => _uuid.v4(),
        );
      }
    });
  }

  @override
  Future<void> softDeleteOrder(String orderInternalId) async {
    await _isar.writeTxn(() async {
      final e = await _isar.orderEntitys.getByInternalId(orderInternalId);
      if (e == null || e.deletedAt != null) return;
      final now = DateTime.now();
      e
        ..deletedAt = now
        ..updatedAt = now;
      await _isar.orderEntitys.putByInternalId(e);
    });
  }

  @override
  Future<void> mergeRemoteOrder({
    required String shopId,
    required String internalId,
    required String operation,
    Object? data,
    DateTime? serverUpdatedAt,
    Future<void> Function(
      Map<String, dynamic> localSnapshot,
      Map<String, dynamic> remoteSnapshot,
    )? onPullConflict,
  }) async {
    if (operation == 'delete') {
      await _isar.writeTxn(() async {
        final e = await _isar.orderEntitys.getByInternalId(internalId);
        if (e == null) return;
        final now = DateTime.now();
        e
          ..deletedAt = now
          ..updatedAt = now;
        await _isar.orderEntitys.putByInternalId(e);
      });
      return;
    }

    final m = syncPullDataMap(data);
    final now = DateTime.now();

    final existing = await _isar.orderEntitys.getByInternalId(internalId);
    if (serverUpdatedAt != null &&
        existing != null &&
        existing.deletedAt == null &&
        existing.updatedAt.isAfter(serverUpdatedAt)) {
      if (onPullConflict != null) {
        final m = syncPullDataMap(data);
        await onPullConflict(
          orderConflictSnapshotFromPullData(
            {},
            displayOrderNo: existing.displayOrderNo,
            customerName: existing.customerNameSnapshot,
            updatedAt: existing.updatedAt,
          ),
          orderConflictSnapshotFromPullData(m),
        );
      }
      return;
    }
    final customerId =
        syncPullString(m, const ['customer_internal_id', 'customerInternalId']) ??
            existing?.customerInternalId;
    if (customerId == null || customerId.isEmpty) return;

    final delivery = syncPullDateTime(
          m,
          const ['delivery_date', 'deliveryDate'],
        ) ??
        existing?.deliveryDate;
    if (delivery == null) return;

    final total = syncPullInt(m, const ['total_amount_minor', 'totalAmountMinor']) ??
        existing?.totalAmountMinor ??
        0;

    final statusIdx = syncPullInt(m, const ['status_index', 'statusIndex']) ??
        existing?.statusIndex ??
        OrderLocalStatus.newOrder.code;

    final measurements = syncPullString(
          m,
          const ['measurements_snapshot', 'measurementsSnapshot'],
        ) ??
        existing?.measurementsSnapshot ??
        '';

    final internalNotes = syncPullString(
          m,
          const ['internal_notes', 'internalNotes'],
        ) ??
        existing?.internalNotes ??
        '';

    final profileId = syncPullString(
          m,
          const ['source_measurement_profile_id', 'sourceMeasurementProfileId'],
        );
    final profileLabel = syncPullString(
          m,
          const [
            'source_measurement_profile_label',
            'sourceMeasurementProfileLabel',
          ],
    );

    final styleName = syncPullString(m, const ['style_name', 'styleName']) ??
        existing?.styleName ??
        '';
    final styleNameInternalId = syncPullString(
      m,
      const ['style_name_internal_id', 'styleNameInternalId'],
    );
    final styleSelectionJson = syncPullString(
          m,
          const ['style_selection_json', 'styleSelectionJson'],
        ) ??
        existing?.styleSelectionJson ??
        '';
    final styleSummary = syncPullString(
          m,
          const ['style_summary', 'styleSummary'],
        ) ??
        existing?.styleSummary ??
        '';

    final catalogItemInternalId = syncPullString(
      m,
      const ['catalog_item_internal_id', 'catalogItemInternalId'],
    );
    final catalogDesignNameSnapshot = syncPullString(
          m,
          const [
            'catalog_design_name_snapshot',
            'catalogDesignNameSnapshot',
          ],
        ) ??
        existing?.catalogDesignNameSnapshot ??
        '';
    final catalogDesignerShopNameSnapshot = syncPullString(
          m,
          const [
            'catalog_designer_shop_name_snapshot',
            'catalogDesignerShopNameSnapshot',
          ],
        ) ??
        existing?.catalogDesignerShopNameSnapshot ??
        '';
    final catalogImagePathSnapshot = syncPullString(
      m,
      const ['catalog_image_path_snapshot', 'catalogImagePathSnapshot'],
    );
    final catalogThumbnailPathSnapshot = syncPullString(
      m,
      const [
        'catalog_thumbnail_path_snapshot',
        'catalogThumbnailPathSnapshot',
      ],
    );

    final fabricNameSnapshot = syncPullString(
          m,
          const ['fabric_name', 'fabricName', 'fabric_name_snapshot'],
        ) ??
        existing?.fabricNameSnapshot ??
        '';
    final fabricColorSnapshot = syncPullString(
          m,
          const ['fabric_color', 'fabricColor', 'fabric_color_snapshot'],
        ) ??
        existing?.fabricColorSnapshot ??
        '';
    final fabricIdSnapshot = syncPullString(
          m,
          const ['fabric_id', 'fabricId', 'fabric_id_snapshot'],
        ) ??
        existing?.fabricIdSnapshot ??
        '';
    final fabricNamePresetInternalId = syncPullString(
      m,
      const [
        'fabric_name_preset_internal_id',
        'fabricNamePresetInternalId',
      ],
    );
    final fabricColorPresetInternalId = syncPullString(
      m,
      const [
        'fabric_color_preset_internal_id',
        'fabricColorPresetInternalId',
      ],
    );

    final displayNo = syncPullString(
          m,
          const ['display_order_no', 'displayOrderNo'],
        ) ??
        existing?.displayOrderNo;

    final createdAt =
        syncPullDateTime(m, const ['created_at', 'createdAt']) ??
            existing?.createdAt ??
            now;
    final updatedAt =
        syncPullDateTime(m, const ['updated_at', 'updatedAt']) ?? now;

    final customerNameSnapshot = syncPullString(
          m,
          const ['customer_snapshot_name', 'customerNameSnapshot'],
        ) ??
        existing?.customerNameSnapshot ??
        '';
    final customerPhoneSnapshot = syncPullString(
          m,
          const ['customer_snapshot_phone', 'customerPhoneSnapshot'],
        ) ??
        existing?.customerPhoneSnapshot ??
        '';
    final customerChangeHistoryJson = syncPullString(
          m,
          const [
            'customer_change_history_json',
            'customerChangeHistoryJson',
          ],
        ) ??
        existing?.customerChangeHistoryJson ??
        '';

    await _isar.writeTxn(() async {
      OrderEntity e;
      if (existing == null) {
        final count = await _isar.orderEntitys
            .filter()
            .shopIdEqualTo(shopId)
            .and()
            .deletedAtIsNull()
            .count();
        final resolvedDisplay = (displayNo != null && displayNo.isNotEmpty)
            ? displayNo
            : (count + 1).toString().padLeft(8, '0');
        e = OrderEntity()
          ..internalId = internalId
          ..shopId = shopId
          ..customerInternalId = customerId
          ..displayOrderNo = resolvedDisplay
          ..statusIndex = statusIdx
          ..deliveryDate = delivery
          ..createdAt = createdAt
          ..updatedAt = updatedAt
          ..totalAmountMinor = total
          ..measurementsSnapshot = measurements
          ..internalNotes = internalNotes
          ..sourceMeasurementProfileId = profileId
          ..sourceMeasurementProfileLabel = profileLabel ?? ''
          ..styleName = styleName
          ..styleNameInternalId = styleNameInternalId
          ..styleSelectionJson = styleSelectionJson
          ..styleSummary = styleSummary
          ..catalogItemInternalId = catalogItemInternalId
          ..catalogDesignNameSnapshot = catalogDesignNameSnapshot
          ..catalogDesignerShopNameSnapshot = catalogDesignerShopNameSnapshot
          ..catalogImagePathSnapshot = catalogImagePathSnapshot
          ..catalogThumbnailPathSnapshot = catalogThumbnailPathSnapshot
          ..fabricNameSnapshot = fabricNameSnapshot
          ..fabricColorSnapshot = fabricColorSnapshot
          ..fabricIdSnapshot = fabricIdSnapshot
          ..fabricNamePresetInternalId = fabricNamePresetInternalId
          ..fabricColorPresetInternalId = fabricColorPresetInternalId
          ..customerNameSnapshot = customerNameSnapshot
          ..customerPhoneSnapshot = customerPhoneSnapshot
          ..customerChangeHistoryJson = customerChangeHistoryJson
          ..deletedAt = null;
      } else {
        final row = await _isar.orderEntitys.getByInternalId(internalId);
        if (row == null) return;
        e = row;
        e
          ..shopId = shopId
          ..customerInternalId = customerId
          ..displayOrderNo =
              (displayNo != null && displayNo.isNotEmpty) ? displayNo : e.displayOrderNo
          ..statusIndex = statusIdx
          ..deliveryDate = delivery
          ..updatedAt = updatedAt
          ..totalAmountMinor = total
          ..measurementsSnapshot = measurements
          ..internalNotes = internalNotes
          ..sourceMeasurementProfileId = profileId ?? e.sourceMeasurementProfileId
          ..sourceMeasurementProfileLabel =
              profileLabel ?? e.sourceMeasurementProfileLabel
          ..styleName = styleName.isNotEmpty ? styleName : e.styleName
          ..styleNameInternalId = styleNameInternalId ?? e.styleNameInternalId
          ..styleSelectionJson = styleSelectionJson.isNotEmpty
              ? styleSelectionJson
              : e.styleSelectionJson
          ..styleSummary =
              styleSummary.isNotEmpty ? styleSummary : e.styleSummary
          ..catalogItemInternalId =
              catalogItemInternalId ?? e.catalogItemInternalId
          ..catalogDesignNameSnapshot = catalogDesignNameSnapshot.isNotEmpty
              ? catalogDesignNameSnapshot
              : e.catalogDesignNameSnapshot
          ..catalogDesignerShopNameSnapshot =
              catalogDesignerShopNameSnapshot.isNotEmpty
                  ? catalogDesignerShopNameSnapshot
                  : e.catalogDesignerShopNameSnapshot
          ..catalogImagePathSnapshot =
              catalogImagePathSnapshot ?? e.catalogImagePathSnapshot
          ..catalogThumbnailPathSnapshot =
              catalogThumbnailPathSnapshot ?? e.catalogThumbnailPathSnapshot
          ..fabricNameSnapshot = fabricNameSnapshot.isNotEmpty
              ? fabricNameSnapshot
              : e.fabricNameSnapshot
          ..fabricColorSnapshot = fabricColorSnapshot.isNotEmpty
              ? fabricColorSnapshot
              : e.fabricColorSnapshot
          ..fabricIdSnapshot =
              fabricIdSnapshot.isNotEmpty ? fabricIdSnapshot : e.fabricIdSnapshot
          ..fabricNamePresetInternalId =
              fabricNamePresetInternalId ?? e.fabricNamePresetInternalId
          ..fabricColorPresetInternalId =
              fabricColorPresetInternalId ?? e.fabricColorPresetInternalId
          ..customerNameSnapshot = customerNameSnapshot.isNotEmpty
              ? customerNameSnapshot
              : e.customerNameSnapshot
          ..customerPhoneSnapshot = customerPhoneSnapshot.isNotEmpty
              ? customerPhoneSnapshot
              : e.customerPhoneSnapshot
          ..customerChangeHistoryJson = customerChangeHistoryJson.isNotEmpty
              ? customerChangeHistoryJson
              : e.customerChangeHistoryJson
          ..deletedAt = null;
        e.createdAt ??= createdAt;
      }
      await _isar.orderEntitys.putByInternalId(e);

      final remoteItems = parseOrderItemsFromSyncData(m);
      if (remoteItems != null) {
        for (final itemMap in remoteItems) {
          await upsertOrderItemInTxn(
            isar: _isar,
            shopId: shopId,
            orderInternalId: internalId,
            input: orderItemCreateInputFromSyncMap(
              itemMap,
              fallbackInternalId: _uuid.v4(),
            ),
            newId: _uuid.v4,
            newSnapshotInternalId: _uuid.v4,
          );
        }
      } else {
        final existingItem = await findActiveOrderItemByGarmentType(
          _isar,
          internalId,
          GarmentType.perahanTunban.code,
        );
        await upsertOrderItemInTxn(
          isar: _isar,
          shopId: shopId,
          orderInternalId: internalId,
          input: orderItemCreateInputFromLegacyFlatOrder(
            order: e,
            internalId: existingItem?.internalId,
          ),
          newId: _uuid.v4,
          newSnapshotInternalId: _uuid.v4,
        );
      }

      final payments = await _isar.paymentEntitys
          .filter()
          .orderInternalIdEqualTo(internalId)
          .findAll();
      final paidMinor = payments.fold<int>(0, (sum, p) => sum + p.amountMinor);
      final activeItems = await loadActiveOrderItems(_isar, internalId);
      if (activeItems.isNotEmpty) {
        final sum = sumOrderItemPrices(activeItems);
        if (sum > 0 && sum >= paidMinor) {
          e.totalAmountMinor = sum;
        }
      }
      await _syncPrimaryItemFlatFieldsOnOrder(_isar, e);
      await _isar.orderEntitys.putByInternalId(e);

      final figures = await loadStyleFiguresForShop(_isar, shopId);
      final perahanItem = await findActiveOrderItemByGarmentType(
        _isar,
        internalId,
        GarmentType.perahanTunban.code,
      );
      await persistOrderStyleSnapshotInTxn(
        isar: _isar,
        shopId: shopId,
        orderInternalId: internalId,
        orderItemInternalId: perahanItem?.internalId,
        styleName: e.styleName,
        styleNameInternalId: e.styleNameInternalId,
        styleSelectionJson: e.styleSelectionJson,
        allFigures: figures,
        newSnapshotInternalId: () => _uuid.v4(),
      );
    });
  }
}
