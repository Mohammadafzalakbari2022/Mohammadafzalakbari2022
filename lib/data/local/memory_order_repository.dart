import 'dart:async';

import 'package:uuid/uuid.dart';

import 'dev_shop_constants.dart';
import 'customer_name_rules.dart';
import 'entities/order_status.dart';
import 'entities/garment_type.dart';
import 'measurement_unit_codes.dart';
import 'order_item_input.dart';
import 'order_item_summary.dart';
import 'order_list_repository.dart';
import 'order_measurement_snapshot_item_input.dart';
import 'order_measurement_snapshot_view.dart';
import 'order_style_snapshot_view.dart';
import 'order_customer_history.dart';
import 'order_summary.dart';
import 'order_sync_payload.dart';
import 'seed_data.dart';
import 'catalog/catalog_order_snapshot.dart';
import 'style/order_style_snapshot_persist.dart';
import 'sync_pull_payload.dart';
import '../../core/sync/sync_conflict_helpers.dart';

/// Web / non-native: in-memory list (Isar does not run on Flutter Web).
class MemoryOrderRepository implements OrderListRepository {
  final List<OrderSummary> _orders = [];
  final Map<String, OrderMeasurementSnapshotView> _measurementSnapshotsByOrder =
      {};
  final Map<String, OrderStyleSnapshotView> _styleSnapshotsByOrder = {};
  final Map<String, OrderMeasurementSnapshotView> _measurementSnapshotsByItem =
      {};
  final Map<String, OrderStyleSnapshotView> _styleSnapshotsByItem = {};
  final _controller = StreamController<List<OrderSummary>>.broadcast();
  final _snapshotController = StreamController<void>.broadcast();
  final _itemsController = StreamController<void>.broadcast();
  final _uuid = const Uuid();

  void _emitOrders() {
    _controller.add(const []);
  }

  OrderSummary _copyOrder(
    OrderSummary o, {
    OrderLocalStatus? status,
    String? internalNotes,
    int? paidAmountMinor,
    DateTime? updatedAt,
    String? customerInternalId,
    String? customerName,
    String? customerPhone,
    List<OrderCustomerHistoryEntry>? customerChangeHistory,
    DateTime? deliveryDate,
    int? totalAmountMinor,
    String? measurementsSnapshot,
    String? sourceMeasurementProfileId,
    String? sourceMeasurementProfileLabel,
    String? styleName,
    String? styleNameInternalId,
    String? styleSelectionJson,
    String? styleSummary,
    String? catalogItemInternalId,
    String? catalogDesignNameSnapshot,
    String? catalogDesignerShopNameSnapshot,
    String? catalogImagePathSnapshot,
    String? catalogThumbnailPathSnapshot,
    String? fabricNameSnapshot,
    String? fabricColorSnapshot,
    String? fabricIdSnapshot,
    String? fabricNamePresetInternalId,
    String? fabricColorPresetInternalId,
    List<OrderItemSummary>? items,
  }) {
    return OrderSummary(
      shopId: o.shopId,
      internalId: o.internalId,
      displayOrderNo: o.displayOrderNo,
      customerInternalId: customerInternalId ?? o.customerInternalId,
      customerName: customerName ?? o.customerName,
      customerPhone: customerPhone ?? o.customerPhone,
      customerChangeHistory:
          customerChangeHistory ?? o.customerChangeHistory,
      measurementsSnapshot: measurementsSnapshot ?? o.measurementsSnapshot,
      internalNotes: internalNotes ?? o.internalNotes,
      sourceMeasurementProfileId:
          sourceMeasurementProfileId ?? o.sourceMeasurementProfileId,
      sourceMeasurementProfileLabel: sourceMeasurementProfileLabel ??
          o.sourceMeasurementProfileLabel,
      styleName: styleName ?? o.styleName,
      styleNameInternalId: styleNameInternalId ?? o.styleNameInternalId,
      styleSelectionJson: styleSelectionJson ?? o.styleSelectionJson,
      styleSummary: styleSummary ?? o.styleSummary,
      catalogItemInternalId:
          catalogItemInternalId ?? o.catalogItemInternalId,
      catalogDesignNameSnapshot:
          catalogDesignNameSnapshot ?? o.catalogDesignNameSnapshot,
      catalogDesignerShopNameSnapshot: catalogDesignerShopNameSnapshot ??
          o.catalogDesignerShopNameSnapshot,
      catalogImagePathSnapshot:
          catalogImagePathSnapshot ?? o.catalogImagePathSnapshot,
      catalogThumbnailPathSnapshot:
          catalogThumbnailPathSnapshot ?? o.catalogThumbnailPathSnapshot,
      fabricNameSnapshot: fabricNameSnapshot ?? o.fabricNameSnapshot,
      fabricColorSnapshot: fabricColorSnapshot ?? o.fabricColorSnapshot,
      fabricIdSnapshot: fabricIdSnapshot ?? o.fabricIdSnapshot,
      fabricNamePresetInternalId:
          fabricNamePresetInternalId ?? o.fabricNamePresetInternalId,
      fabricColorPresetInternalId:
          fabricColorPresetInternalId ?? o.fabricColorPresetInternalId,
      items: items ?? o.items,
      status: status ?? o.status,
      deliveryDate: deliveryDate ?? o.deliveryDate,
      createdAt: o.createdAt,
      updatedAt: updatedAt ?? o.updatedAt,
      totalAmountMinor: totalAmountMinor ?? o.totalAmountMinor,
      paidAmountMinor: paidAmountMinor ?? o.paidAmountMinor,
    );
  }

  void _emitSnapshots() {
    _snapshotController.add(null);
  }

  void _emitItems() {
    _itemsController.add(null);
  }

  void _migrateMemoryItemsIfNeeded() {
    for (var i = 0; i < _orders.length; i++) {
      final o = _orders[i];
      if (o.items.isNotEmpty) continue;
      final view = o.legacyPerahanTunbanItemView();
      if (view == null) {
        _orders[i] = _copyOrder(
          o,
          items: [
            OrderItemSummary(
              internalId: _uuid.v4(),
              orderInternalId: o.internalId,
              garmentType: GarmentType.perahanTunban,
              sortOrder: GarmentType.perahanTunban.defaultSortOrder,
              priceAmountMinor: o.totalAmountMinor,
              createdAt: o.createdAt,
              updatedAt: o.updatedAt,
            ),
          ],
        );
      } else {
        _orders[i] = _copyOrder(
          o,
          items: [view.copyWith(internalId: _uuid.v4())],
        );
      }
    }
  }

  OrderItemSummary? _itemOf(String orderInternalId, GarmentType type) {
    final order = _orders.cast<OrderSummary?>().firstWhere(
          (o) => o!.internalId == orderInternalId,
          orElse: () => null,
        );
    return order?.itemOf(type);
  }

  int _indexOfOrder(String orderInternalId) {
    return _orders.indexWhere((o) => o.internalId == orderInternalId);
  }

  void _persistStyleSnapshot({
    required String orderInternalId,
    required String styleName,
    String? styleNameInternalId,
    required String styleSelectionJson,
  }) {
    _styleSnapshotsByOrder.remove(orderInternalId);
    final view = buildOrderStyleSnapshotView(
      orderInternalId: orderInternalId,
      styleName: styleName,
      styleNameInternalId: styleNameInternalId,
      styleSelectionJson: styleSelectionJson,
      snapshotInternalId: _uuid.v4(),
    );
    if (view != null) {
      _styleSnapshotsByOrder[orderInternalId] = view;
    }
  }

  @override
  Future<void> seedIfEmpty() async {
    if (_orders.isNotEmpty) return;
    final now = DateTime.now();
    _orders.addAll(devOrderSummaries(now));
    _migrateMemoryItemsIfNeeded();

    _measurementSnapshotsByOrder[DevSeedIds.order1] =
        OrderMeasurementSnapshotView(
      orderInternalId: DevSeedIds.order1,
      snapshotInternalId: DevSeedIds.orderMeasurementSnapshot1,
      sourceMeasurementProfileId: DevSeedIds.measurementProfile1,
      createdAt: now,
      items: const [
        OrderMeasurementSnapshotItemView(
          measurementTypeInternalId: DevSeedIds.mtChest,
          typeName: 'Chest',
          value: '98',
          unitCode: MeasurementUnitCodes.cm,
          sortOrder: 10,
        ),
        OrderMeasurementSnapshotItemView(
          measurementTypeInternalId: DevSeedIds.mtWaist,
          typeName: 'Waist',
          value: '84',
          unitCode: MeasurementUnitCodes.cm,
          sortOrder: 20,
        ),
        OrderMeasurementSnapshotItemView(
          measurementTypeInternalId: DevSeedIds.mtLength,
          typeName: 'Length',
          value: '112',
          unitCode: MeasurementUnitCodes.cm,
          sortOrder: 30,
        ),
      ],
    );
    _measurementSnapshotsByOrder[DevSeedIds.order2] =
        OrderMeasurementSnapshotView(
      orderInternalId: DevSeedIds.order2,
      snapshotInternalId: DevSeedIds.orderMeasurementSnapshot2,
      sourceMeasurementProfileId: DevSeedIds.measurementProfile2,
      createdAt: now,
      items: const [
        OrderMeasurementSnapshotItemView(
          measurementTypeInternalId: DevSeedIds.mtShoulder,
          typeName: 'Shoulder',
          value: '46',
          unitCode: MeasurementUnitCodes.cm,
          sortOrder: 40,
        ),
        OrderMeasurementSnapshotItemView(
          measurementTypeInternalId: DevSeedIds.mtSleeve,
          typeName: 'Sleeve',
          value: '62',
          unitCode: MeasurementUnitCodes.cm,
          sortOrder: 60,
        ),
      ],
    );

    _emitOrders();
    _emitSnapshots();
  }

  @override
  Stream<OrderMeasurementSnapshotView?> watchOrderMeasurementSnapshot(
    String orderInternalId,
  ) async* {
    await seedIfEmpty();
    yield _measurementSnapshotsByOrder[orderInternalId];
    await for (final _ in _snapshotController.stream) {
      yield _measurementSnapshotsByOrder[orderInternalId];
    }
  }

  @override
  Stream<OrderStyleSnapshotView?> watchOrderStyleSnapshot(
    String orderInternalId,
  ) async* {
    await seedIfEmpty();
    yield _styleSnapshotsByOrder[orderInternalId];
    await for (final _ in _snapshotController.stream) {
      yield _styleSnapshotsByOrder[orderInternalId];
    }
  }

  @override
  Stream<OrderMeasurementSnapshotView?> watchOrderItemMeasurementSnapshot(
    String orderInternalId,
    String orderItemInternalId,
  ) async* {
    await seedIfEmpty();
    final itemId = orderItemInternalId.trim();
    if (itemId.isEmpty) {
      yield* watchOrderMeasurementSnapshot(orderInternalId);
      return;
    }
    yield _measurementSnapshotsByItem[itemId] ??
        _measurementSnapshotsByOrder[orderInternalId];
    await for (final _ in _snapshotController.stream) {
      yield _measurementSnapshotsByItem[itemId] ??
          _measurementSnapshotsByOrder[orderInternalId];
    }
  }

  @override
  Stream<OrderStyleSnapshotView?> watchOrderItemStyleSnapshot(
    String orderInternalId,
    String orderItemInternalId,
  ) async* {
    await seedIfEmpty();
    final itemId = orderItemInternalId.trim();
    if (itemId.isEmpty) {
      yield* watchOrderStyleSnapshot(orderInternalId);
      return;
    }
    yield _styleSnapshotsByItem[itemId] ??
        _styleSnapshotsByOrder[orderInternalId];
    await for (final _ in _snapshotController.stream) {
      yield _styleSnapshotsByItem[itemId] ??
          _styleSnapshotsByOrder[orderInternalId];
    }
  }

  @override
  Stream<List<OrderItemSummary>> watchOrderItems(String orderInternalId) async* {
    await seedIfEmpty();
    final idx = _indexOfOrder(orderInternalId);
    yield idx < 0 ? const [] : OrderItemSummary.sorted(_orders[idx].items);
    await for (final _ in _itemsController.stream) {
      final i = _indexOfOrder(orderInternalId);
      yield i < 0 ? const [] : OrderItemSummary.sorted(_orders[i].items);
    }
  }

  @override
  Stream<List<OrderSummary>> watchOrders([String shopId = kDevShopId]) async* {
    await seedIfEmpty();
    yield _sortedForShop(shopId);
    yield* _controller.stream.map((_) => _sortedForShop(shopId));
  }

  @override
  Stream<OrderSummary?> watchOrderByInternalId(String internalId) async* {
    await seedIfEmpty();
    final id = internalId.trim();
    OrderSummary? current() {
      final i = _indexOfOrder(id);
      return i < 0 ? null : _orders[i];
    }

    yield current();
    yield* _controller.stream.map((_) => current());
  }

  @override
  Future<Map<String, OrderSummary>> resolveOrdersByInternalIds({
    required String shopId,
    required Iterable<String> internalIds,
  }) async {
    await seedIfEmpty();
    final ids = internalIds
        .map((id) => id.trim())
        .where((id) => id.isNotEmpty)
        .toSet();
    if (ids.isEmpty) return {};

    final out = <String, OrderSummary>{};
    for (final o in _orders) {
      if (o.shopId != shopId) continue;
      if (ids.contains(o.internalId)) {
        out[o.internalId] = o;
      }
    }
    return out;
  }

  List<OrderSummary> _sortedForShop(String shopId) {
    final list = _orders.where((o) => o.shopId == shopId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  void applyPaymentDelta(String orderInternalId, int deltaMinor) {
    for (var i = 0; i < _orders.length; i++) {
      final o = _orders[i];
      if (o.internalId == orderInternalId) {
        _orders[i] = _copyOrder(
          o,
          updatedAt: DateTime.now(),
          paidAmountMinor: o.paidAmountMinor + deltaMinor,
        );
        _emitOrders();
        return;
      }
    }
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
    await seedIfEmpty();
    assertAtLeastOneItem(items);
    assertUniqueGarmentTypes(items);
    assertItemPricesValid(items);

    final nextNo = _nextOrderNo();
    final internalId = _uuid.v4();
    final now = DateTime.now();
    final totalAmountMinor =
        items.fold<int>(0, (sum, item) => sum + item.priceAmountMinor);
    final primary = items.firstWhere(
      (i) => i.garmentType == GarmentType.perahanTunban,
      orElse: () => items.first,
    );

    String? resolvedImagePath = primary.catalogImagePathSnapshot;
    String? resolvedThumbPath = primary.catalogThumbnailPathSnapshot;
    if (primary.catalogDesignNameSnapshot.trim().isNotEmpty &&
        primary.catalogSourceImagePath != null &&
        primary.catalogSourceImagePath!.isNotEmpty) {
      final copied = await copyCatalogPathsToOrderSnapshot(
        orderInternalId: internalId,
        imagePath: primary.catalogSourceImagePath!,
        thumbnailPath: primary.catalogSourceThumbnailPath,
      );
      if (copied != null) {
        resolvedImagePath = copied.imagePath;
        resolvedThumbPath = copied.thumbnailPath;
      }
    }

    final itemSummaries = <OrderItemSummary>[];
    for (final input in items) {
      itemSummaries.add(
        OrderItemSummary(
          internalId: input.internalId ?? _uuid.v4(),
          orderInternalId: internalId,
          garmentType: input.garmentType,
          sortOrder: input.sortOrder ?? input.garmentType.defaultSortOrder,
          priceAmountMinor: input.priceAmountMinor,
          itemNotes: input.itemNotes,
          measurementsSnapshot: input.measurementsSnapshot,
          sourceMeasurementProfileId: input.sourceMeasurementProfileId,
          sourceMeasurementProfileLabel: input.sourceMeasurementProfileLabel,
          styleName: input.styleName,
          styleNameInternalId: input.styleNameInternalId,
          styleSelectionJson: input.styleSelectionJson,
          styleSummary: input.styleSummary,
          catalogItemInternalId: input.catalogItemInternalId,
          catalogDesignNameSnapshot: input.catalogDesignNameSnapshot,
          catalogDesignerShopNameSnapshot:
              input.catalogDesignerShopNameSnapshot,
          catalogImagePathSnapshot: input.garmentType == primary.garmentType
              ? resolvedImagePath
              : input.catalogImagePathSnapshot,
          catalogThumbnailPathSnapshot: input.garmentType == primary.garmentType
              ? resolvedThumbPath
              : input.catalogThumbnailPathSnapshot,
          fabricNameSnapshot: input.fabricNameSnapshot,
          fabricColorSnapshot: input.fabricColorSnapshot,
          fabricIdSnapshot: input.fabricIdSnapshot,
          fabricNamePresetInternalId: input.fabricNamePresetInternalId,
          fabricColorPresetInternalId: input.fabricColorPresetInternalId,
          clothMetersSnapshot: input.clothMetersSnapshot,
          clothPriceAmountMinor: input.clothPriceAmountMinor,
          createdAt: now,
          updatedAt: now,
        ),
      );
    }

    final resolvedCustomerName = customerSnapshotName?.trim().isNotEmpty ?? false
        ? customerSnapshotName!.trim()
        : _resolveCustomerName(customerInternalId);
    assertValidCustomerName(resolvedCustomerName);

    _orders.add(
      OrderSummary(
        shopId: shopId,
        internalId: internalId,
        displayOrderNo: nextNo,
        customerInternalId: customerInternalId,
        customerName: resolvedCustomerName,
        customerPhone: customerSnapshotPhone,
        measurementsSnapshot: primary.measurementsSnapshot,
        internalNotes: '',
        sourceMeasurementProfileId: primary.sourceMeasurementProfileId,
        sourceMeasurementProfileLabel: primary.sourceMeasurementProfileLabel,
        styleName: primary.styleName.trim(),
        styleNameInternalId: primary.styleNameInternalId,
        styleSelectionJson: primary.styleSelectionJson,
        styleSummary: primary.styleSummary,
        catalogItemInternalId: primary.catalogItemInternalId,
        catalogDesignNameSnapshot: primary.catalogDesignNameSnapshot.trim(),
        catalogDesignerShopNameSnapshot:
            primary.catalogDesignerShopNameSnapshot.trim(),
        catalogImagePathSnapshot: resolvedImagePath,
        catalogThumbnailPathSnapshot: resolvedThumbPath,
        fabricNameSnapshot: primary.fabricNameSnapshot.trim(),
        fabricColorSnapshot: primary.fabricColorSnapshot.trim(),
        fabricIdSnapshot: primary.fabricIdSnapshot.trim(),
        fabricNamePresetInternalId: primary.fabricNamePresetInternalId,
        fabricColorPresetInternalId: primary.fabricColorPresetInternalId,
        items: itemSummaries,
        status: OrderLocalStatus.newOrder,
        deliveryDate: deliveryDate,
        createdAt: now,
        updatedAt: now,
        totalAmountMinor: totalAmountMinor,
        paidAmountMinor: 0,
      ),
    );

    final snap = primary.measurementSnapshotItems;
    if (snap != null && snap.isNotEmpty) {
      final snapId = _uuid.v4();
      _measurementSnapshotsByOrder[internalId] = OrderMeasurementSnapshotView(
        orderInternalId: internalId,
        snapshotInternalId: snapId,
        sourceMeasurementProfileId: primary.sourceMeasurementProfileId,
        createdAt: now,
        items: [
          for (final it in snap)
            OrderMeasurementSnapshotItemView(
              measurementTypeInternalId: it.measurementTypeInternalId,
              typeName: it.typeName,
              value: it.value,
              unitCode: it.unitCode,
              sortOrder: it.sortOrder,
            ),
        ],
      );
    }

    _persistStyleSnapshot(
      orderInternalId: internalId,
      styleName: primary.styleName.trim(),
      styleNameInternalId: primary.styleNameInternalId,
      styleSelectionJson: primary.styleSelectionJson,
    );
    _emitSnapshots();
    _emitItems();
    _emitOrders();
    return internalId;
  }

  @override
  Future<void> upsertOrderItem({
    required String orderInternalId,
    required OrderItemCreateInput input,
  }) async {
    if (input.priceAmountMinor <= 0) {
      throw const OrderItemRepositoryException('item_price_required');
    }
    final idx = _indexOfOrder(orderInternalId);
    if (idx < 0) return;
    final order = _orders[idx];
    final items = List<OrderItemSummary>.from(order.items);
    final existingIndex = items.indexWhere(
      (item) => item.garmentType == input.garmentType,
    );
    final now = DateTime.now();
    final summary = OrderItemSummary(
      internalId: existingIndex >= 0
          ? items[existingIndex].internalId
          : (input.internalId ?? _uuid.v4()),
      orderInternalId: orderInternalId,
      garmentType: input.garmentType,
      sortOrder: input.sortOrder ?? input.garmentType.defaultSortOrder,
      priceAmountMinor: input.priceAmountMinor,
      itemNotes: input.itemNotes,
      measurementsSnapshot: input.measurementsSnapshot,
      sourceMeasurementProfileId: input.sourceMeasurementProfileId,
      sourceMeasurementProfileLabel: input.sourceMeasurementProfileLabel,
      styleName: input.styleName,
      styleNameInternalId: input.styleNameInternalId,
      styleSelectionJson: input.styleSelectionJson,
      styleSummary: input.styleSummary,
      catalogItemInternalId: input.catalogItemInternalId,
      catalogDesignNameSnapshot: input.catalogDesignNameSnapshot,
      catalogDesignerShopNameSnapshot: input.catalogDesignerShopNameSnapshot,
      catalogImagePathSnapshot: input.catalogImagePathSnapshot,
      catalogThumbnailPathSnapshot: input.catalogThumbnailPathSnapshot,
      fabricNameSnapshot: input.fabricNameSnapshot,
      fabricColorSnapshot: input.fabricColorSnapshot,
      fabricIdSnapshot: input.fabricIdSnapshot,
      fabricNamePresetInternalId: input.fabricNamePresetInternalId,
      fabricColorPresetInternalId: input.fabricColorPresetInternalId,
      clothMetersSnapshot: input.clothMetersSnapshot,
      clothPriceAmountMinor: input.clothPriceAmountMinor,
      createdAt: existingIndex >= 0 ? items[existingIndex].createdAt : now,
      updatedAt: now,
    );
    if (existingIndex >= 0) {
      items[existingIndex] = summary;
    } else {
      items.add(summary);
    }
    final total = sumOrderItemPriceSummaries(items);
    if (total <= 0 || total < order.paidAmountMinor) {
      throw const OrderItemRepositoryException('order_total_below_paid');
    }
    final primary = primaryPerahanItemSummary(items);
    _orders[idx] = _copyOrder(
      order,
      items: items,
      totalAmountMinor: total,
      updatedAt: now,
      measurementsSnapshot: primary?.measurementsSnapshot,
      sourceMeasurementProfileId: primary?.sourceMeasurementProfileId,
      sourceMeasurementProfileLabel: primary?.sourceMeasurementProfileLabel,
      styleName: primary?.styleName,
      styleNameInternalId: primary?.styleNameInternalId,
      styleSelectionJson: primary?.styleSelectionJson,
      styleSummary: primary?.styleSummary,
      catalogItemInternalId: primary?.catalogItemInternalId,
      catalogDesignNameSnapshot: primary?.catalogDesignNameSnapshot,
      catalogDesignerShopNameSnapshot: primary?.catalogDesignerShopNameSnapshot,
      catalogImagePathSnapshot: primary?.catalogImagePathSnapshot,
      catalogThumbnailPathSnapshot: primary?.catalogThumbnailPathSnapshot,
      fabricNameSnapshot: primary?.fabricNameSnapshot,
      fabricColorSnapshot: primary?.fabricColorSnapshot,
      fabricIdSnapshot: primary?.fabricIdSnapshot,
      fabricNamePresetInternalId: primary?.fabricNamePresetInternalId,
      fabricColorPresetInternalId: primary?.fabricColorPresetInternalId,
    );
    _emitItems();
    _emitOrders();
  }

  @override
  Future<void> addOrderItem({
    required String orderInternalId,
    required OrderItemCreateInput input,
  }) async {
    if (_itemOf(orderInternalId, input.garmentType) != null) {
      throw const OrderItemRepositoryException('duplicate_garment_type');
    }
    await upsertOrderItem(orderInternalId: orderInternalId, input: input);
  }

  @override
  Future<void> removeOrderItem({
    required String orderInternalId,
    required GarmentType garmentType,
  }) async {
    final idx = _indexOfOrder(orderInternalId);
    if (idx < 0) return;
    final order = _orders[idx];
    if (order.items.length <= 1) {
      throw const OrderItemRepositoryException('cannot_remove_last_item');
    }
    final items = order.items
        .where((item) => item.garmentType != garmentType)
        .toList(growable: false);
    final total = sumOrderItemPriceSummaries(items);
    if (total < order.paidAmountMinor) {
      throw const OrderItemRepositoryException('order_total_below_paid');
    }
    final primary = primaryPerahanItemSummary(items);
    _orders[idx] = _copyOrder(
      order,
      items: items,
      totalAmountMinor: total,
      updatedAt: DateTime.now(),
      measurementsSnapshot: primary?.measurementsSnapshot,
      sourceMeasurementProfileId: primary?.sourceMeasurementProfileId,
      sourceMeasurementProfileLabel: primary?.sourceMeasurementProfileLabel,
      styleName: primary?.styleName,
      styleNameInternalId: primary?.styleNameInternalId,
      styleSelectionJson: primary?.styleSelectionJson,
      styleSummary: primary?.styleSummary,
      catalogItemInternalId: primary?.catalogItemInternalId,
      catalogDesignNameSnapshot: primary?.catalogDesignNameSnapshot,
      catalogDesignerShopNameSnapshot: primary?.catalogDesignerShopNameSnapshot,
      catalogImagePathSnapshot: primary?.catalogImagePathSnapshot,
      catalogThumbnailPathSnapshot: primary?.catalogThumbnailPathSnapshot,
      fabricNameSnapshot: primary?.fabricNameSnapshot,
      fabricColorSnapshot: primary?.fabricColorSnapshot,
      fabricIdSnapshot: primary?.fabricIdSnapshot,
      fabricNamePresetInternalId: primary?.fabricNamePresetInternalId,
      fabricColorPresetInternalId: primary?.fabricColorPresetInternalId,
    );
    _emitItems();
    _emitOrders();
  }

  String _nextOrderNo() {
    var maxNo = 0;
    for (final o in _orders) {
      final n = int.tryParse(o.displayOrderNo) ?? 0;
      if (n > maxNo) maxNo = n;
    }
    final next = maxNo + 1;
    return next.toString().padLeft(8, '0');
  }

  String _resolveCustomerName(String customerInternalId) {
    final seeded = _orders.firstWhere(
      (o) => o.customerInternalId == customerInternalId,
      orElse: () => OrderSummary(
        shopId: kDevShopId,
        internalId: '',
        displayOrderNo: '',
        customerInternalId: customerInternalId,
        customerName: '—',
        customerPhone: null,
        measurementsSnapshot: '',
        internalNotes: '',
        sourceMeasurementProfileId: null,
        sourceMeasurementProfileLabel: '',
        status: OrderLocalStatus.newOrder,
        deliveryDate: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        totalAmountMinor: 0,
        paidAmountMinor: 0,
      ),
    );
    return seeded.customerName;
  }

  @override
  Future<void> updateOrderStatus({
    required String orderInternalId,
    required OrderLocalStatus newStatus,
  }) async {
    for (var i = 0; i < _orders.length; i++) {
      final o = _orders[i];
      if (o.internalId == orderInternalId) {
        _orders[i] = _copyOrder(o, status: newStatus, updatedAt: DateTime.now());
        _emitOrders();
        return;
      }
    }
  }

  @override
  Future<void> updateOrderInternalNotes({
    required String orderInternalId,
    required String internalNotes,
  }) async {
    for (var i = 0; i < _orders.length; i++) {
      final o = _orders[i];
      if (o.internalId == orderInternalId) {
        _orders[i] = _copyOrder(
          o,
          internalNotes: internalNotes,
          updatedAt: DateTime.now(),
        );
        _emitOrders();
        return;
      }
    }
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
    for (var i = 0; i < _orders.length; i++) {
      final o = _orders[i];
      if (o.internalId != orderInternalId) continue;

      if (totalAmountMinor != null &&
          (totalAmountMinor <= 0 || totalAmountMinor < o.paidAmountMinor)) {
        throw StateError('order_total_below_paid');
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

      final cid = customerInternalId ?? o.customerInternalId;
      final fromName = o.customerName;
      final fromPhone = o.customerPhone;
      final toName = customerSnapshotName?.trim().isNotEmpty ?? false
          ? customerSnapshotName!.trim()
          : (customerInternalId != null
              ? _resolveCustomerName(cid)
              : o.customerName);
      final toPhone = customerSnapshotPhone != null
          ? (customerSnapshotPhone.trim().isEmpty
              ? null
              : customerSnapshotPhone.trim())
          : (customerInternalId != null
              ? _resolveCustomerPhone(cid)
              : o.customerPhone);
      List<OrderCustomerHistoryEntry>? history;
      if (customerInternalId != null ||
          customerSnapshotName != null ||
          customerSnapshotPhone != null) {
        history = appendOrderCustomerHistory(
          existing: o.customerChangeHistory,
          fromName: fromName,
          fromPhone: fromPhone,
          toName: toName,
          toPhone: toPhone,
          changedAt: DateTime.now(),
        );
      }
      _orders[i] = _copyOrder(
        o,
        customerInternalId: customerInternalId,
        customerName: toName,
        customerPhone: toPhone,
        customerChangeHistory: history,
        deliveryDate: deliveryDate,
        totalAmountMinor: totalAmountMinor,
        measurementsSnapshot: measurementsSnapshot,
        sourceMeasurementProfileId: sourceMeasurementProfileId,
        sourceMeasurementProfileLabel: sourceMeasurementProfileLabel,
        styleName: styleName,
        styleNameInternalId: styleNameInternalId,
        styleSelectionJson: styleSelectionJson,
        styleSummary: styleSummary,
        catalogItemInternalId: catalogItemInternalId,
        catalogDesignNameSnapshot: catalogDesignNameSnapshot,
        catalogDesignerShopNameSnapshot: catalogDesignerShopNameSnapshot,
        catalogImagePathSnapshot: resolvedImagePath,
        catalogThumbnailPathSnapshot: resolvedThumbPath,
        fabricNameSnapshot: fabricNameSnapshot,
        fabricColorSnapshot: fabricColorSnapshot,
        fabricIdSnapshot: fabricIdSnapshot,
        fabricNamePresetInternalId: fabricNamePresetInternalId,
        fabricColorPresetInternalId: fabricColorPresetInternalId,
        internalNotes: internalNotes,
        updatedAt: DateTime.now(),
      );

      if (measurementSnapshotItems != null) {
        _measurementSnapshotsByOrder.remove(orderInternalId);
        if (measurementSnapshotItems.isNotEmpty) {
          final snapId = _uuid.v4();
          _measurementSnapshotsByOrder[orderInternalId] =
              OrderMeasurementSnapshotView(
            orderInternalId: orderInternalId,
            snapshotInternalId: snapId,
            sourceMeasurementProfileId: sourceMeasurementProfileId,
            createdAt: DateTime.now(),
            items: [
              for (final it in measurementSnapshotItems)
                OrderMeasurementSnapshotItemView(
                  measurementTypeInternalId: it.measurementTypeInternalId,
                  typeName: it.typeName,
                  value: it.value,
                  unitCode: it.unitCode,
                  sortOrder: it.sortOrder,
                ),
            ],
          );
        }
        _emitSnapshots();
      }

      if (styleName != null ||
          styleNameInternalId != null ||
          styleSelectionJson != null ||
          styleSummary != null) {
        final updated = _orders[i];
        _persistStyleSnapshot(
          orderInternalId: orderInternalId,
          styleName: updated.styleName,
          styleNameInternalId: updated.styleNameInternalId,
          styleSelectionJson: updated.styleSelectionJson,
        );
        _emitSnapshots();
      }
      _emitOrders();
      return;
    }
  }

  String? _resolveCustomerPhone(String customerInternalId) {
    for (final o in _orders) {
      if (o.customerInternalId == customerInternalId) return o.customerPhone;
    }
    return null;
  }

  @override
  Future<void> softDeleteOrder(String orderInternalId) async {
    _orders.removeWhere((o) => o.internalId == orderInternalId);
    _measurementSnapshotsByOrder.remove(orderInternalId);
    _styleSnapshotsByOrder.remove(orderInternalId);
    _emitOrders();
    _emitSnapshots();
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
    await seedIfEmpty();
    if (operation == 'delete') {
      _orders.removeWhere((o) => o.internalId == internalId);
      _measurementSnapshotsByOrder.remove(internalId);
      _styleSnapshotsByOrder.remove(internalId);
      _emitOrders();
      _emitSnapshots();
      return;
    }

    final m = syncPullDataMap(data);
    final now = DateTime.now();
    final idx = _orders.indexWhere((o) => o.internalId == internalId);
    final existing = idx == -1 ? null : _orders[idx];
    if (serverUpdatedAt != null &&
        existing != null &&
        existing.updatedAt.isAfter(serverUpdatedAt)) {
      if (onPullConflict != null) {
        final m = syncPullDataMap(data);
        await onPullConflict(
          orderConflictSnapshotFromPullData(
            {},
            displayOrderNo: existing.displayOrderNo,
            customerName: existing.customerName,
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
        existing?.status.code ??
        OrderLocalStatus.newOrder.code;
    final status = orderStatusFromCode(statusIdx);

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

    final resolvedDisplay = (displayNo != null && displayNo.isNotEmpty)
        ? displayNo
        : (existing == null ? _nextOrderNo() : existing.displayOrderNo);

    final row = OrderSummary(
      shopId: shopId,
      internalId: internalId,
      displayOrderNo: resolvedDisplay,
      customerInternalId: customerId,
      customerName: existing?.customerName ?? _resolveCustomerName(customerId),
      customerPhone: existing?.customerPhone,
      measurementsSnapshot: measurements,
      internalNotes: internalNotes,
      sourceMeasurementProfileId: profileId ?? existing?.sourceMeasurementProfileId,
      sourceMeasurementProfileLabel:
          profileLabel ?? existing?.sourceMeasurementProfileLabel ?? '',
      styleName: styleName,
      styleNameInternalId: styleNameInternalId ?? existing?.styleNameInternalId,
      styleSelectionJson: styleSelectionJson,
      styleSummary: styleSummary,
      catalogItemInternalId:
          catalogItemInternalId ?? existing?.catalogItemInternalId,
      catalogDesignNameSnapshot: catalogDesignNameSnapshot,
      catalogDesignerShopNameSnapshot: catalogDesignerShopNameSnapshot,
      catalogImagePathSnapshot:
          catalogImagePathSnapshot ?? existing?.catalogImagePathSnapshot,
      catalogThumbnailPathSnapshot: catalogThumbnailPathSnapshot ??
          existing?.catalogThumbnailPathSnapshot,
      fabricNameSnapshot: fabricNameSnapshot.isNotEmpty
          ? fabricNameSnapshot
          : (existing?.fabricNameSnapshot ?? ''),
      fabricColorSnapshot: fabricColorSnapshot.isNotEmpty
          ? fabricColorSnapshot
          : (existing?.fabricColorSnapshot ?? ''),
      fabricIdSnapshot: fabricIdSnapshot.isNotEmpty
          ? fabricIdSnapshot
          : (existing?.fabricIdSnapshot ?? ''),
      fabricNamePresetInternalId: fabricNamePresetInternalId ??
          existing?.fabricNamePresetInternalId,
      fabricColorPresetInternalId: fabricColorPresetInternalId ??
          existing?.fabricColorPresetInternalId,
      status: status,
      deliveryDate: delivery,
      createdAt: createdAt,
      updatedAt: updatedAt,
      totalAmountMinor: total,
      paidAmountMinor: existing?.paidAmountMinor ?? 0,
    );

    if (idx == -1) {
      _orders.add(row);
    } else {
      _orders[idx] = row;
    }

    final remoteItems = parseOrderItemsFromSyncData(m);
    final itemSummaries = <OrderItemSummary>[];
    if (remoteItems != null) {
      for (final itemMap in remoteItems) {
        final input = orderItemCreateInputFromSyncMap(
          itemMap,
          fallbackInternalId: _uuid.v4(),
        );
        itemSummaries.add(
          OrderItemSummary(
            internalId: input.internalId ?? _uuid.v4(),
            orderInternalId: internalId,
            garmentType: input.garmentType,
            sortOrder: input.sortOrder ?? input.garmentType.defaultSortOrder,
            priceAmountMinor: input.priceAmountMinor,
            itemNotes: input.itemNotes,
            measurementsSnapshot: input.measurementsSnapshot,
            sourceMeasurementProfileId: input.sourceMeasurementProfileId,
            sourceMeasurementProfileLabel: input.sourceMeasurementProfileLabel,
            styleName: input.styleName,
            styleNameInternalId: input.styleNameInternalId,
            styleSelectionJson: input.styleSelectionJson,
            styleSummary: input.styleSummary,
            catalogItemInternalId: input.catalogItemInternalId,
            catalogDesignNameSnapshot: input.catalogDesignNameSnapshot,
            catalogDesignerShopNameSnapshot: input.catalogDesignerShopNameSnapshot,
            fabricNameSnapshot: input.fabricNameSnapshot,
            fabricColorSnapshot: input.fabricColorSnapshot,
            fabricIdSnapshot: input.fabricIdSnapshot,
            fabricNamePresetInternalId: input.fabricNamePresetInternalId,
            fabricColorPresetInternalId: input.fabricColorPresetInternalId,
            clothMetersSnapshot: input.clothMetersSnapshot,
            clothPriceAmountMinor: input.clothPriceAmountMinor,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
        );
      }
    } else {
      final legacy = orderItemCreateInputFromLegacyFlatSummary(order: row);
      itemSummaries.add(
        OrderItemSummary(
          internalId: _uuid.v4(),
          orderInternalId: internalId,
          garmentType: legacy.garmentType,
          sortOrder: legacy.sortOrder ?? legacy.garmentType.defaultSortOrder,
          priceAmountMinor: legacy.priceAmountMinor,
          measurementsSnapshot: legacy.measurementsSnapshot,
          sourceMeasurementProfileId: legacy.sourceMeasurementProfileId,
          sourceMeasurementProfileLabel: legacy.sourceMeasurementProfileLabel,
          styleName: legacy.styleName,
          styleNameInternalId: legacy.styleNameInternalId,
          styleSelectionJson: legacy.styleSelectionJson,
          styleSummary: legacy.styleSummary,
          catalogItemInternalId: legacy.catalogItemInternalId,
          catalogDesignNameSnapshot: legacy.catalogDesignNameSnapshot,
          catalogDesignerShopNameSnapshot: legacy.catalogDesignerShopNameSnapshot,
          fabricNameSnapshot: legacy.fabricNameSnapshot,
          fabricColorSnapshot: legacy.fabricColorSnapshot,
          fabricIdSnapshot: legacy.fabricIdSnapshot,
          fabricNamePresetInternalId: legacy.fabricNamePresetInternalId,
          fabricColorPresetInternalId: legacy.fabricColorPresetInternalId,
          createdAt: createdAt,
          updatedAt: updatedAt,
        ),
      );
    }

    final mergedIdx = _indexOfOrder(internalId);
    if (mergedIdx >= 0) {
      final mergedTotal = itemSummaries.isEmpty
          ? total
          : sumOrderItemPriceSummaries(itemSummaries);
      final primary = primaryPerahanItemSummary(itemSummaries);
      _orders[mergedIdx] = _copyOrder(
        _orders[mergedIdx],
        items: itemSummaries,
        totalAmountMinor: mergedTotal,
        measurementsSnapshot: primary?.measurementsSnapshot ?? measurements,
        sourceMeasurementProfileId:
            primary?.sourceMeasurementProfileId ?? profileId,
        sourceMeasurementProfileLabel:
            primary?.sourceMeasurementProfileLabel ?? profileLabel ?? '',
        styleName: primary?.styleName ?? styleName,
        styleNameInternalId:
            primary?.styleNameInternalId ?? styleNameInternalId,
        styleSelectionJson: primary?.styleSelectionJson ?? styleSelectionJson,
        styleSummary: primary?.styleSummary ?? styleSummary,
        catalogItemInternalId:
            primary?.catalogItemInternalId ?? catalogItemInternalId,
        catalogDesignNameSnapshot:
            primary?.catalogDesignNameSnapshot ?? catalogDesignNameSnapshot,
        catalogDesignerShopNameSnapshot: primary
                ?.catalogDesignerShopNameSnapshot ??
            catalogDesignerShopNameSnapshot,
        fabricNameSnapshot: primary?.fabricNameSnapshot ?? fabricNameSnapshot,
        fabricColorSnapshot: primary?.fabricColorSnapshot ?? fabricColorSnapshot,
        fabricIdSnapshot: primary?.fabricIdSnapshot ?? fabricIdSnapshot,
        fabricNamePresetInternalId: primary?.fabricNamePresetInternalId ??
            fabricNamePresetInternalId,
        fabricColorPresetInternalId: primary?.fabricColorPresetInternalId ??
            fabricColorPresetInternalId,
      );
    }

    _persistStyleSnapshot(
      orderInternalId: internalId,
      styleName: _orders[_indexOfOrder(internalId)].styleName,
      styleNameInternalId: _orders[_indexOfOrder(internalId)].styleNameInternalId,
      styleSelectionJson: _orders[_indexOfOrder(internalId)].styleSelectionJson,
    );
    _emitOrders();
    _emitSnapshots();
    _emitItems();
  }
}
