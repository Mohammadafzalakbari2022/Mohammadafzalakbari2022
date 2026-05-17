import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

import '../../core/defaults/afghan_market_defaults.dart';
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
import 'entities/order_style_snapshot_entity.dart';
import 'entities/order_style_snapshot_figure_entity.dart';
import 'order_measurement_snapshot_view.dart';
import 'order_style_snapshot_view.dart';
import 'order_summary.dart';
import 'seed_data.dart';
import 'catalog/catalog_order_snapshot.dart';
import 'sync_pull_payload.dart';

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

  Future<OrderStyleSnapshotView?> _hydrateStyleSnapshot(
    List<OrderStyleSnapshotEntity> headers,
  ) async {
    if (headers.isEmpty) return null;
    final s = headers.first;
    final figureRows = await _isar.orderStyleSnapshotFigureEntitys
        .filter()
        .snapshotInternalIdEqualTo(s.internalId)
        .sortBySortOrder()
        .findAll();
    final figures = figureRows
        .map(
          (e) => OrderStyleSnapshotFigureView(
            styleFigureInternalId: e.styleFigureInternalId,
            figureNameSnapshot: e.figureNameSnapshot,
            imageRefSnapshot: e.imageRefSnapshot,
            sortOrder: e.sortOrder,
          ),
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
          internalNotes: o.internalNotes,
          sourceMeasurementProfileId: o.sourceMeasurementProfileId,
          sourceMeasurementProfileLabel: o.sourceMeasurementProfileLabel,
          styleName: o.styleName,
          styleNameInternalId: o.styleNameInternalId,
          styleSelectionJson: o.styleSelectionJson,
          styleSummary: o.styleSummary,
          catalogItemInternalId: o.catalogItemInternalId,
          catalogDesignNameSnapshot: o.catalogDesignNameSnapshot,
          catalogDesignerShopNameSnapshot: o.catalogDesignerShopNameSnapshot,
          catalogImagePathSnapshot: o.catalogImagePathSnapshot,
          catalogThumbnailPathSnapshot: o.catalogThumbnailPathSnapshot,
          fabricNameSnapshot: o.fabricNameSnapshot,
          fabricColorSnapshot: o.fabricColorSnapshot,
          fabricIdSnapshot: o.fabricIdSnapshot,
          fabricNamePresetInternalId: o.fabricNamePresetInternalId,
          fabricColorPresetInternalId: o.fabricColorPresetInternalId,
          status: orderStatusFromCode(o.statusIndex),
          deliveryDate: o.deliveryDate,
          createdAt: o.createdAt ?? o.updatedAt,
          updatedAt: o.updatedAt,
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
  }) async {
    final now = DateTime.now();
    final internalId = _uuid.v4();

    String? resolvedImagePath = catalogImagePathSnapshot;
    String? resolvedThumbPath = catalogThumbnailPathSnapshot;
    if (catalogDesignNameSnapshot.trim().isNotEmpty &&
        (catalogSourceImagePath != null && catalogSourceImagePath.isNotEmpty)) {
      final copied = await copyCatalogPathsToOrderSnapshot(
        orderInternalId: internalId,
        imagePath: catalogSourceImagePath,
        thumbnailPath: catalogSourceThumbnailPath,
      );
      if (copied != null) {
        resolvedImagePath = copied.imagePath;
        resolvedThumbPath = copied.thumbnailPath;
      }
    }

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
      ..createdAt = now
      ..updatedAt = now
      ..totalAmountMinor = totalAmountMinor
      ..measurementsSnapshot = measurementsSnapshot
      ..sourceMeasurementProfileId = sourceMeasurementProfileId
      ..sourceMeasurementProfileLabel = sourceMeasurementProfileLabel
      ..styleName = styleName.trim()
      ..styleNameInternalId = styleNameInternalId
      ..styleSelectionJson = styleSelectionJson
      ..styleSummary = styleSummary
      ..catalogItemInternalId = catalogItemInternalId
      ..catalogDesignNameSnapshot = catalogDesignNameSnapshot.trim()
      ..catalogDesignerShopNameSnapshot = catalogDesignerShopNameSnapshot.trim()
      ..catalogImagePathSnapshot = resolvedImagePath
      ..catalogThumbnailPathSnapshot = resolvedThumbPath
      ..fabricNameSnapshot = fabricNameSnapshot.trim()
      ..fabricColorSnapshot = fabricColorSnapshot.trim()
      ..fabricIdSnapshot = fabricIdSnapshot.trim()
      ..fabricNamePresetInternalId = fabricNamePresetInternalId
      ..fabricColorPresetInternalId = fabricColorPresetInternalId;

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

  @override
  Future<void> mergeRemoteOrder({
    required String shopId,
    required String internalId,
    required String operation,
    Object? data,
    DateTime? serverUpdatedAt,
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
          ..deletedAt = null;
        e.createdAt ??= createdAt;
      }
      await _isar.orderEntitys.putByInternalId(e);
    });
  }
}
