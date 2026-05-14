import 'dart:async';

import 'package:uuid/uuid.dart';

import 'dev_shop_constants.dart';
import 'entities/order_status.dart';
import 'measurement_unit_codes.dart';
import 'order_list_repository.dart';
import 'order_measurement_snapshot_item_input.dart';
import 'order_measurement_snapshot_view.dart';
import 'order_summary.dart';
import 'seed_data.dart';
import 'sync_pull_payload.dart';

/// Web / non-native: in-memory list (Isar does not run on Flutter Web).
class MemoryOrderRepository implements OrderListRepository {
  final List<OrderSummary> _orders = [];
  final Map<String, OrderMeasurementSnapshotView> _measurementSnapshotsByOrder =
      {};
  final _controller = StreamController<List<OrderSummary>>.broadcast();
  final _snapshotController = StreamController<void>.broadcast();
  final _uuid = const Uuid();

  void _emitOrders() {
    _controller.add(const []);
  }

  void _emitSnapshots() {
    _snapshotController.add(null);
  }

  @override
  Future<void> seedIfEmpty() async {
    if (_orders.isNotEmpty) return;
    final now = DateTime.now();
    _orders.addAll(devOrderSummaries(now));

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
  Stream<List<OrderSummary>> watchOrders([String shopId = kDevShopId]) async* {
    await seedIfEmpty();
    yield _sortedForShop(shopId);
    yield* _controller.stream.map((_) => _sortedForShop(shopId));
  }

  List<OrderSummary> _sortedForShop(String shopId) {
    final list = _orders.where((o) => o.shopId == shopId).toList()
      ..sort((a, b) => b.deliveryDate.compareTo(a.deliveryDate));
    return list;
  }

  void applyPaymentDelta(String orderInternalId, int deltaMinor) {
    for (var i = 0; i < _orders.length; i++) {
      final o = _orders[i];
      if (o.internalId == orderInternalId) {
        _orders[i] = OrderSummary(
          shopId: o.shopId,
          internalId: o.internalId,
          displayOrderNo: o.displayOrderNo,
          customerInternalId: o.customerInternalId,
          customerName: o.customerName,
          customerPhone: o.customerPhone,
          measurementsSnapshot: o.measurementsSnapshot,
          styleNotes: o.styleNotes,
          internalNotes: o.internalNotes,
          sourceMeasurementProfileId: o.sourceMeasurementProfileId,
          sourceMeasurementProfileLabel: o.sourceMeasurementProfileLabel,
          status: o.status,
          deliveryDate: o.deliveryDate,
          createdAt: o.createdAt,
          updatedAt: DateTime.now(),
          totalAmountMinor: o.totalAmountMinor,
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
    required String styleNotes,
    String? customerSnapshotName,
    String? customerSnapshotPhone,
    String? sourceMeasurementProfileId,
    String sourceMeasurementProfileLabel = '',
    List<OrderMeasurementSnapshotItemInput>? measurementSnapshotItems,
  }) async {
    await seedIfEmpty();
    final nextNo = _nextOrderNo();
    final internalId = _uuid.v4();
    final now = DateTime.now();
    _orders.add(
      OrderSummary(
        shopId: shopId,
        internalId: internalId,
        displayOrderNo: nextNo,
        customerInternalId: customerInternalId,
        customerName:
            customerSnapshotName ?? _resolveCustomerName(customerInternalId),
        customerPhone: customerSnapshotPhone,
        measurementsSnapshot: measurementsSnapshot,
        styleNotes: styleNotes,
        internalNotes: '',
        sourceMeasurementProfileId: sourceMeasurementProfileId,
        sourceMeasurementProfileLabel: sourceMeasurementProfileLabel,
        status: OrderLocalStatus.newOrder,
        deliveryDate: deliveryDate,
        createdAt: now,
        updatedAt: now,
        totalAmountMinor: totalAmountMinor,
        paidAmountMinor: 0,
      ),
    );

    final snap = measurementSnapshotItems;
    if (snap != null && snap.isNotEmpty) {
      final snapId = _uuid.v4();
      final now = DateTime.now();
      _measurementSnapshotsByOrder[internalId] = OrderMeasurementSnapshotView(
        orderInternalId: internalId,
        snapshotInternalId: snapId,
        sourceMeasurementProfileId: sourceMeasurementProfileId,
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
      _emitSnapshots();
    }

    _emitOrders();
    return internalId;
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
        styleNotes: '',
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
        _orders[i] = OrderSummary(
          shopId: o.shopId,
          internalId: o.internalId,
          displayOrderNo: o.displayOrderNo,
          customerInternalId: o.customerInternalId,
          customerName: o.customerName,
          customerPhone: o.customerPhone,
          measurementsSnapshot: o.measurementsSnapshot,
          styleNotes: o.styleNotes,
          internalNotes: o.internalNotes,
          sourceMeasurementProfileId: o.sourceMeasurementProfileId,
          sourceMeasurementProfileLabel: o.sourceMeasurementProfileLabel,
          status: newStatus,
          deliveryDate: o.deliveryDate,
          createdAt: o.createdAt,
          updatedAt: DateTime.now(),
          totalAmountMinor: o.totalAmountMinor,
          paidAmountMinor: o.paidAmountMinor,
        );
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
        _orders[i] = OrderSummary(
          shopId: o.shopId,
          internalId: o.internalId,
          displayOrderNo: o.displayOrderNo,
          customerInternalId: o.customerInternalId,
          customerName: o.customerName,
          customerPhone: o.customerPhone,
          measurementsSnapshot: o.measurementsSnapshot,
          styleNotes: o.styleNotes,
          internalNotes: internalNotes,
          sourceMeasurementProfileId: o.sourceMeasurementProfileId,
          sourceMeasurementProfileLabel: o.sourceMeasurementProfileLabel,
          status: o.status,
          deliveryDate: o.deliveryDate,
          createdAt: o.createdAt,
          updatedAt: DateTime.now(),
          totalAmountMinor: o.totalAmountMinor,
          paidAmountMinor: o.paidAmountMinor,
        );
        _emitOrders();
        return;
      }
    }
  }

  @override
  Future<void> mergeRemoteOrder({
    required String shopId,
    required String internalId,
    required String operation,
    Object? data,
    DateTime? serverUpdatedAt,
  }) async {
    await seedIfEmpty();
    if (operation == 'delete') {
      _orders.removeWhere((o) => o.internalId == internalId);
      _measurementSnapshotsByOrder.remove(internalId);
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

    final styleNotes = syncPullString(m, const ['style_notes', 'styleNotes']) ??
        existing?.styleNotes ??
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
      styleNotes: styleNotes,
      internalNotes: internalNotes,
      sourceMeasurementProfileId: profileId ?? existing?.sourceMeasurementProfileId,
      sourceMeasurementProfileLabel:
          profileLabel ?? existing?.sourceMeasurementProfileLabel ?? '',
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
    _emitOrders();
  }
}
