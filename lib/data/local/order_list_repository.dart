import 'dev_shop_constants.dart';
import 'entities/garment_type.dart';
import 'entities/order_status.dart';
import 'order_item_input.dart';
import 'order_item_summary.dart';
import 'order_measurement_snapshot_item_input.dart';
import 'order_measurement_snapshot_view.dart';
import 'order_style_snapshot_view.dart';
import 'order_summary.dart';

abstract class OrderListRepository {
  Stream<List<OrderSummary>> watchOrders([String shopId = kDevShopId]);

  /// Single order by canonical internal id (includes soft-deleted rows for audit/ledger).
  Stream<OrderSummary?> watchOrderByInternalId(String internalId);

  /// Batch resolve orders for payment ledger / reports (includes soft-deleted).
  Future<Map<String, OrderSummary>> resolveOrdersByInternalIds({
    required String shopId,
    required Iterable<String> internalIds,
  });

  /// Structured measurements captured at order creation (plan-02).
  Stream<OrderMeasurementSnapshotView?> watchOrderMeasurementSnapshot(
    String orderInternalId,
  );

  /// Frozen style on an order (figures + name); null when not persisted yet.
  Stream<OrderStyleSnapshotView?> watchOrderStyleSnapshot(
    String orderInternalId,
  );

  /// Structured measurements for one garment line (Phase 5+).
  Stream<OrderMeasurementSnapshotView?> watchOrderItemMeasurementSnapshot(
    String orderInternalId,
    String orderItemInternalId,
  );

  /// Frozen style for one garment line (Phase 5+).
  Stream<OrderStyleSnapshotView?> watchOrderItemStyleSnapshot(
    String orderInternalId,
    String orderItemInternalId,
  );

  /// Garment lines on an order (Phase 2+).
  Stream<List<OrderItemSummary>> watchOrderItems(String orderInternalId);

  /// Inserts demo rows when DB is empty (dev / first run).
  Future<void> seedIfEmpty();

  /// Creates a new order locally and returns its internal id (plan-11).
  ///
  /// Note: payments are stored separately in [PaymentRepository].
  ///
  /// [customerSnapshotName] / [customerSnapshotPhone] are used by the in-memory
  /// repository (Web) where orders are not joined to a customer table on insert.
  ///
  /// [measurementSnapshotItems]: when non-null and non-empty, persists
  /// [OrderMeasurementSnapshotView] rows alongside [measurementsSnapshot] text.
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
  });

  /// Creates an order with one or more garment items (Phase 2+).
  Future<String> createOrderWithItems({
    required String shopId,
    required String customerInternalId,
    required DateTime deliveryDate,
    required List<OrderItemCreateInput> items,
    String? customerSnapshotName,
    String? customerSnapshotPhone,
  });

  /// Creates or replaces the item for [input.garmentType] on an existing order.
  Future<void> upsertOrderItem({
    required String orderInternalId,
    required OrderItemCreateInput input,
  });

  /// Adds a new garment item; throws if the garment type already exists.
  Future<void> addOrderItem({
    required String orderInternalId,
    required OrderItemCreateInput input,
  });

  /// Removes one garment item; throws if it is the last item on the order.
  Future<void> removeOrderItem({
    required String orderInternalId,
    required GarmentType garmentType,
  });

  /// Update order status locally (plan-12).
  Future<void> updateOrderStatus({
    required String orderInternalId,
    required OrderLocalStatus newStatus,
  });

  /// Soft-delete an order on this device (synced when online).
  Future<void> softDeleteOrder(String orderInternalId);

  /// Staff-only internal notes (plan-12); allowed while license is valid.
  Future<void> updateOrderInternalNotes({
    required String orderInternalId,
    required String internalNotes,
  });

  /// Patch order fields after save (all statuses). Null params are left unchanged.
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
  });

  /// Apply one row from `GET /sync/pull` (`plan-03` / phase-1b).
  ///
  /// When [serverUpdatedAt] is set and the local row is newer, upserts are skipped
  /// (last-write-wins for conflicts). Deletes always apply.
  ///
  /// [onPullConflict] is invoked when a pull upsert is skipped due to a newer local row.
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
  });
}
