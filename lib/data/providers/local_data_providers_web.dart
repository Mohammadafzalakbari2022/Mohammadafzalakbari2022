import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/auth_providers.dart';
import '../local/dev_shop_constants.dart';
import '../local/customer_list_repository.dart';
import '../local/customer_summary.dart';
import '../local/memory_customer_repository.dart';
import '../local/memory_order_repository.dart';
import '../local/memory_payment_repository.dart';
import '../local/memory_task_repository.dart';
import '../local/order_list_repository.dart';
import '../local/order_summary.dart';
import '../local/payment_repository.dart';
import '../local/payment_summary.dart';
import '../local/task_repository.dart';
import '../local/task_summary.dart';
import '../local/catalog_repository.dart';
import '../local/catalog_item_summary.dart';
import '../local/catalog_item_detail.dart';
import '../local/memory_catalog_repository.dart';
import '../local/memory_measurement_profile_repository.dart';
import '../local/measurement_profile_repository.dart';
import '../local/measurement_profile_summary.dart';
import '../local/measurement_type_summary.dart';
import '../local/order_measurement_snapshot_view.dart';
import '../local/sync_outbox_pending_view.dart';
import '../local/sync_outbox_repository.dart';
import '../local/app_notification_repository.dart';
import '../local/app_notification_summary.dart';
import '../local/memory_app_notification_repository.dart';
import '../local/memory_sync_outbox_repository.dart';

/// Web: in-memory orders only. Isar `.g.dart` uses int64 schema IDs that JS cannot compile.
final orderListRepositoryProvider =
    FutureProvider<OrderListRepository>((ref) async {
  final repo = MemoryOrderRepository();
  await repo.seedIfEmpty();
  return repo;
});

final ordersListStreamProvider =
    StreamProvider<List<OrderSummary>>((ref) async* {
  final repo = await ref.watch(orderListRepositoryProvider.future);
  final shopId = ref.watch(effectiveShopIdProvider);
  yield* repo.watchOrders(shopId);
});

final paymentRepositoryProvider = FutureProvider<PaymentRepository>((ref) async {
  final orders = await ref.watch(orderListRepositoryProvider.future);
  // Web uses MemoryOrderRepository here.
  return MemoryPaymentRepository(orders as MemoryOrderRepository);
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
  // Web uses in-memory list.
  return MemoryTaskRepository();
});

final tasksForShopProvider =
    StreamProvider.family<List<TaskSummary>, String>((ref, shopId) async* {
  final repo = await ref.watch(taskRepositoryProvider.future);
  yield* repo.watchTasks(shopId);
});

final customerListRepositoryProvider =
    FutureProvider<CustomerListRepository>((ref) async {
  final repo = MemoryCustomerRepository();
  await repo.seedIfEmpty();
  return repo;
});

final customersListStreamProvider =
    StreamProvider<List<CustomerSummary>>((ref) async* {
  final repo = await ref.watch(customerListRepositoryProvider.future);
  final shopId = ref.watch(effectiveShopIdProvider);
  yield* repo.watchCustomers(shopId);
});

final catalogRepositoryProvider = FutureProvider<CatalogRepository>((ref) async {
  final repo = MemoryCatalogRepository();
  await repo.seedIfEmpty();
  return repo;
});

final myCatalogStreamProvider =
    StreamProvider<List<CatalogItemSummary>>((ref) async* {
  final repo = await ref.watch(catalogRepositoryProvider.future);
  final shopId = ref.watch(effectiveShopIdProvider);
  yield* repo.watchMyDesigns(shopId);
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
  await ref.watch(customerListRepositoryProvider.future);
  final repo = MemoryMeasurementProfileRepository();
  await repo.seedIfEmpty();
  return repo;
});

final measurementProfilesForCustomerProvider = StreamProvider.family<
    List<MeasurementProfileSummary>, String>((ref, customerId) async* {
  final repo = await ref.watch(measurementProfileRepositoryProvider.future);
  final shopId = ref.watch(effectiveShopIdProvider);
  yield* repo.watchForCustomer(
    shopId: shopId,
    customerInternalId: customerId,
  );
});

final measurementTypesStreamProvider =
    StreamProvider<List<MeasurementTypeSummary>>((ref) async* {
  final repo = await ref.watch(measurementProfileRepositoryProvider.future);
  final shopId = ref.watch(effectiveShopIdProvider);
  yield* repo.watchActiveMeasurementTypes(shopId);
});

final measurementTypesAdminStreamProvider =
    StreamProvider<List<MeasurementTypeSummary>>((ref) async* {
  final repo = await ref.watch(measurementProfileRepositoryProvider.future);
  final shopId = ref.watch(effectiveShopIdProvider);
  yield* repo.watchMeasurementTypesAdmin(shopId);
});

final orderMeasurementSnapshotProvider = StreamProvider.family<
    OrderMeasurementSnapshotView?, String>((ref, orderInternalId) async* {
  final repo = await ref.watch(orderListRepositoryProvider.future);
  yield* repo.watchOrderMeasurementSnapshot(orderInternalId);
});

final appNotificationRepositoryProvider =
    FutureProvider<AppNotificationRepository>((ref) async {
  return MemoryAppNotificationRepository();
});

final appNotificationsStreamProvider =
    StreamProvider<List<AppNotificationSummary>>((ref) async* {
  final repo = await ref.watch(appNotificationRepositoryProvider.future);
  final shopId = ref.watch(effectiveShopIdProvider);
  yield* repo.watchNotifications(shopId);
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
  return MemorySyncOutboxRepository();
});

final syncPendingOutboxCountProvider = StreamProvider<int>((ref) async* {
  final repo = await ref.watch(syncOutboxRepositoryProvider.future);
  final shopId = ref.watch(effectiveShopIdProvider);
  yield* repo.watchPendingCount(shopId);
});

final syncPendingOutboxEntriesProvider =
    StreamProvider<List<SyncOutboxPendingView>>((ref) async* {
  final repo = await ref.watch(syncOutboxRepositoryProvider.future);
  final shopId = ref.watch(effectiveShopIdProvider);
  yield* repo.watchPendingEntries(shopId, limit: 50);
});
