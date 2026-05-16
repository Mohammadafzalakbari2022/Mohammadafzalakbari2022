import 'sync_change_server_time.dart';
import '../../data/local/app_notification_repository.dart';
import '../../data/local/catalog_repository.dart';
import '../../data/local/style_catalog_repository.dart';
import '../../data/local/customer_list_repository.dart';
import '../../data/local/measurement_profile_repository.dart';
import '../../data/local/order_list_repository.dart';
import '../../data/local/payment_repository.dart';
import '../../data/local/task_repository.dart';

/// Applies `GET /sync/pull` `changes` locally (`plan-03`). Entity coverage grows incrementally.
class SyncInboundApplier {
  SyncInboundApplier({
    required this.notifications,
    required this.customers,
    required this.tasks,
    required this.payments,
    required this.orders,
    required this.measurementProfiles,
    required this.catalog,
    required this.styleCatalog,
    required this.shopId,
  });

  final AppNotificationRepository notifications;
  final CustomerListRepository customers;
  final TaskRepository tasks;
  final PaymentRepository payments;
  final OrderListRepository orders;
  final MeasurementProfileRepository measurementProfiles;
  final CatalogRepository catalog;
  final StyleCatalogRepository styleCatalog;
  final String shopId;

  /// Returns number of rows applied (skipped kinds return 0 contribution per change).
  Future<int> applyChanges(List<Map<String, dynamic>> changes) async {
    var applied = 0;
    for (final raw in changes) {
      final et = raw['entity_type'];
      final op = raw['operation'];
      final id = raw['internal_id'];
      if (et is! String || op is! String || id is! String) continue;
      if (et == 'notification') {
        await notifications.mergeRemoteNotification(
          shopId: shopId,
          internalId: id,
          operation: op,
          data: raw['data'],
        );
        applied++;
      } else if (et == 'customer') {
        await customers.mergeRemoteCustomer(
          shopId: shopId,
          internalId: id,
          operation: op,
          data: raw['data'],
        );
        applied++;
      } else if (et == 'task') {
        await tasks.mergeRemoteTask(
          shopId: shopId,
          internalId: id,
          operation: op,
          data: raw['data'],
        );
        applied++;
      } else if (et == 'payment') {
        await payments.mergeRemotePayment(
          shopId: shopId,
          internalId: id,
          operation: op,
          data: raw['data'],
        );
        applied++;
      } else if (et == 'order') {
        await orders.mergeRemoteOrder(
          shopId: shopId,
          internalId: id,
          operation: op,
          data: raw['data'],
          serverUpdatedAt: parseSyncChangeServerUpdatedAt(raw),
        );
        applied++;
      } else if (et == 'measurement_type') {
        await measurementProfiles.mergeRemoteMeasurementType(
          shopId: shopId,
          internalId: id,
          operation: op,
          data: raw['data'],
        );
        applied++;
      } else if (et == 'measurement_profile') {
        await measurementProfiles.mergeRemoteMeasurementProfile(
          shopId: shopId,
          internalId: id,
          operation: op,
          data: raw['data'],
        );
        applied++;
      } else if (et == 'catalog_item') {
        await catalog.mergeRemoteCatalogItem(
          shopId: shopId,
          internalId: id,
          operation: op,
          data: raw['data'],
        );
        applied++;
      } else if (et == 'style_name') {
        await styleCatalog.mergeRemoteStyleName(
          shopId: shopId,
          internalId: id,
          operation: op,
          data: raw['data'],
        );
        applied++;
      } else if (et == 'style_part') {
        await styleCatalog.mergeRemoteStylePart(
          shopId: shopId,
          internalId: id,
          operation: op,
          data: raw['data'],
        );
        applied++;
      } else if (et == 'style_figure') {
        await styleCatalog.mergeRemoteStyleFigure(
          shopId: shopId,
          internalId: id,
          operation: op,
          data: raw['data'],
        );
        applied++;
      }
    }
    return applied;
  }
}
