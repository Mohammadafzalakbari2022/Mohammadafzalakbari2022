import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../local/dev_shop_constants.dart';
import '../local/entities/measurement_profile_entity.dart';
import '../local/entities/measurement_profile_item_entity.dart';
import '../local/entities/measurement_type_entity.dart';
import '../local/entities/customer_entity.dart';
import '../local/entities/order_entity.dart';
import '../local/entities/order_measurement_snapshot_entity.dart';
import '../local/entities/order_measurement_snapshot_item_entity.dart';
import '../local/entities/payment_entity.dart';
import '../local/entities/catalog_item_entity.dart';
import '../local/entities/app_notification_entity.dart';
import '../local/entities/sync_outbox_entity.dart';
import '../local/entities/task_entity.dart';
import '../local/app_notification_repository.dart';
import '../local/app_notification_summary.dart';
import '../local/isar_app_notification_repository.dart';
import '../local/isar_order_repository.dart';
import '../local/isar_payment_repository.dart';
import '../local/isar_task_repository.dart';
import '../local/customer_list_repository.dart';
import '../local/order_list_repository.dart';
import '../local/customer_summary.dart';
import '../local/order_measurement_snapshot_view.dart';
import '../local/order_summary.dart';
import '../local/payment_repository.dart';
import '../local/payment_summary.dart';
import '../local/task_repository.dart';
import '../local/task_summary.dart';
import '../local/catalog_repository.dart';
import '../local/catalog_item_summary.dart';
import '../local/catalog_item_detail.dart';
import '../local/isar_catalog_repository.dart';
import '../local/isar_customer_repository.dart';
import '../local/isar_measurement_profile_repository.dart';
import '../local/isar_sync_outbox_repository.dart';
import '../local/measurement_profile_repository.dart';
import '../local/measurement_profile_summary.dart';
import '../local/measurement_type_summary.dart';
import '../local/sync_outbox_pending_view.dart';
import '../local/sync_outbox_repository.dart';

/// Open Isar (Android, iOS, desktop). Not used on Web — see [local_data_providers_web.dart].
final isarProvider = FutureProvider<Isar>((ref) async {
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [
      CustomerEntitySchema,
      OrderEntitySchema,
      PaymentEntitySchema,
      CatalogItemEntitySchema,
      MeasurementProfileEntitySchema,
      MeasurementTypeEntitySchema,
      MeasurementProfileItemEntitySchema,
      OrderMeasurementSnapshotEntitySchema,
      OrderMeasurementSnapshotItemEntitySchema,
      AppNotificationEntitySchema,
      SyncOutboxEntitySchema,
      TaskEntitySchema,
    ],
    directory: dir.path,
  );
  ref.onDispose(() {
    isar.close();
  });
  return isar;
});

final orderListRepositoryProvider =
    FutureProvider<OrderListRepository>((ref) async {
  final isar = await ref.watch(isarProvider.future);
  final repo = IsarOrderRepository(isar);
  await repo.seedIfEmpty();
  return repo;
});

final customerListRepositoryProvider =
    FutureProvider<CustomerListRepository>((ref) async {
  final isar = await ref.watch(isarProvider.future);
  // Ensure seed ran (customers created in order seeding).
  await ref.watch(orderListRepositoryProvider.future);
  final repo = IsarCustomerRepository(isar);
  await repo.seedIfEmpty();
  return repo;
});

final ordersListStreamProvider =
    StreamProvider<List<OrderSummary>>((ref) async* {
  final repo = await ref.watch(orderListRepositoryProvider.future);
  yield* repo.watchOrders(kDevShopId);
});

final customersListStreamProvider =
    StreamProvider<List<CustomerSummary>>((ref) async* {
  final repo = await ref.watch(customerListRepositoryProvider.future);
  yield* repo.watchCustomers(kDevShopId);
});

final paymentRepositoryProvider = FutureProvider<PaymentRepository>((ref) async {
  final isar = await ref.watch(isarProvider.future);
  return IsarPaymentRepository(isar);
});

final paymentsForOrderProvider =
    StreamProvider.family<List<PaymentSummary>, String>((ref, orderId) async* {
  final repo = await ref.watch(paymentRepositoryProvider.future);
  yield* repo.watchPaymentsForOrder(orderId);
});

final paymentsForShopProvider =
    StreamProvider.family<List<PaymentSummary>, String>((ref, shopId) async* {
  final repo = await ref.watch(paymentRepositoryProvider.future);
  yield* repo.watchAllPaymentsForShop(shopId);
});

final taskRepositoryProvider = FutureProvider<TaskRepository>((ref) async {
  final isar = await ref.watch(isarProvider.future);
  return IsarTaskRepository(isar);
});

final tasksForShopProvider =
    StreamProvider.family<List<TaskSummary>, String>((ref, shopId) async* {
  final repo = await ref.watch(taskRepositoryProvider.future);
  yield* repo.watchTasks(shopId);
});

final catalogRepositoryProvider = FutureProvider<CatalogRepository>((ref) async {
  final isar = await ref.watch(isarProvider.future);
  final repo = IsarCatalogRepository(isar);
  await repo.seedIfEmpty();
  return repo;
});

final myCatalogStreamProvider =
    StreamProvider<List<CatalogItemSummary>>((ref) async* {
  final repo = await ref.watch(catalogRepositoryProvider.future);
  yield* repo.watchMyDesigns(kDevShopId);
});

final sharedCatalogStreamProvider =
    StreamProvider<List<CatalogItemSummary>>((ref) async* {
  final repo = await ref.watch(catalogRepositoryProvider.future);
  yield* repo.watchCommunityDesigns(kDevShopId);
});

final catalogItemDetailProvider =
    StreamProvider.family<CatalogItemDetail?, String>((ref, id) async* {
  final repo = await ref.watch(catalogRepositoryProvider.future);
  yield* repo.watchItem(id);
});

final measurementProfileRepositoryProvider =
    FutureProvider<MeasurementProfileRepository>((ref) async {
  await ref.watch(orderListRepositoryProvider.future);
  final isar = await ref.watch(isarProvider.future);
  final repo = IsarMeasurementProfileRepository(isar);
  await repo.seedIfEmpty();
  return repo;
});

final measurementProfilesForCustomerProvider = StreamProvider.family<
    List<MeasurementProfileSummary>, String>((ref, customerId) async* {
  final repo = await ref.watch(measurementProfileRepositoryProvider.future);
  yield* repo.watchForCustomer(
    shopId: kDevShopId,
    customerInternalId: customerId,
  );
});

final measurementTypesStreamProvider =
    StreamProvider<List<MeasurementTypeSummary>>((ref) async* {
  final repo = await ref.watch(measurementProfileRepositoryProvider.future);
  yield* repo.watchActiveMeasurementTypes(kDevShopId);
});

final measurementTypesAdminStreamProvider =
    StreamProvider<List<MeasurementTypeSummary>>((ref) async* {
  final repo = await ref.watch(measurementProfileRepositoryProvider.future);
  yield* repo.watchMeasurementTypesAdmin(kDevShopId);
});

final orderMeasurementSnapshotProvider = StreamProvider.family<
    OrderMeasurementSnapshotView?, String>((ref, orderInternalId) async* {
  final repo = await ref.watch(orderListRepositoryProvider.future);
  yield* repo.watchOrderMeasurementSnapshot(orderInternalId);
});

final appNotificationRepositoryProvider =
    FutureProvider<AppNotificationRepository>((ref) async {
  final isar = await ref.watch(isarProvider.future);
  return IsarAppNotificationRepository(isar);
});

final appNotificationsStreamProvider =
    StreamProvider<List<AppNotificationSummary>>((ref) async* {
  final repo = await ref.watch(appNotificationRepositoryProvider.future);
  yield* repo.watchNotifications(kDevShopId);
});

final unreadAppNotificationCountProvider = Provider<int>((ref) {
  final async = ref.watch(appNotificationsStreamProvider);
  return async.maybeWhen(
    data: (list) => list.where((n) => !n.isRead).length,
    orElse: () => 0,
  );
});

final syncOutboxRepositoryProvider =
    FutureProvider<SyncOutboxRepository>((ref) async {
  final isar = await ref.watch(isarProvider.future);
  return IsarSyncOutboxRepository(isar);
});

final syncPendingOutboxCountProvider = StreamProvider<int>((ref) async* {
  final repo = await ref.watch(syncOutboxRepositoryProvider.future);
  yield* repo.watchPendingCount(kDevShopId);
});

final syncPendingOutboxEntriesProvider =
    StreamProvider<List<SyncOutboxPendingView>>((ref) async* {
  final repo = await ref.watch(syncOutboxRepositoryProvider.future);
  yield* repo.watchPendingEntries(kDevShopId, limit: 50);
});
