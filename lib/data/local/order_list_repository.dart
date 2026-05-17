import 'dev_shop_constants.dart';
import 'entities/order_status.dart';
import 'order_measurement_snapshot_item_input.dart';
import 'order_measurement_snapshot_view.dart';
import 'order_style_snapshot_view.dart';
import 'order_summary.dart';

abstract class OrderListRepository {
  Stream<List<OrderSummary>> watchOrders([String shopId = kDevShopId]);

  /// Structured measurements captured at order creation (plan-02).
  Stream<OrderMeasurementSnapshotView?> watchOrderMeasurementSnapshot(
    String orderInternalId,
  );

  /// Frozen style on an order (figures + name); null when not persisted yet.
  Stream<OrderStyleSnapshotView?> watchOrderStyleSnapshot(
    String orderInternalId,
  );

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

  /// Update order status locally (plan-12).
  Future<void> updateOrderStatus({
    required String orderInternalId,
    required OrderLocalStatus newStatus,
  });

  /// Staff-only internal notes (plan-12); allowed while license is valid.
  Future<void> updateOrderInternalNotes({
    required String orderInternalId,
    required String internalNotes,
  });

  /// Apply one row from `GET /sync/pull` (`plan-03` / phase-1b).
  ///
  /// When [serverUpdatedAt] is set and the local row is newer, upserts are skipped
  /// (last-write-wins for conflicts). Deletes always apply.
  Future<void> mergeRemoteOrder({
    required String shopId,
    required String internalId,
    required String operation,
    Object? data,
    DateTime? serverUpdatedAt,
  });
}
