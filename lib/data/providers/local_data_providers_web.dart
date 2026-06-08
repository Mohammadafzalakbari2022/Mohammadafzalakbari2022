import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/auth_providers.dart';
import '../local/dev_shop_constants.dart';
import '../local/entities/garment_type.dart';
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
import '../local/order_style_snapshot_view.dart';
import '../local/sync_outbox_pending_view.dart';
import '../local/sync_outbox_repository.dart';
import '../local/app_notification_repository.dart';
import '../local/app_notification_summary.dart';
import '../local/memory_app_notification_repository.dart';
import '../local/memory_sync_outbox_repository.dart';
import '../local/memory_fabric_preset_repository.dart';
import '../local/memory_style_catalog_repository.dart';
import '../local/fabric_preset_repository.dart';
import '../local/fabric_preset_summary.dart';
import '../local/style_catalog_repository.dart';
import '../local/style_name_summary.dart';
import '../local/style_part_summary.dart';
import '../local/style_figure_config_summary.dart';
import '../local/style_figure_size_option_summary.dart';
import '../local/style_figure_summary.dart';
import '../local/style_figure_text_option_summary.dart';
import '../local/memory_shop_finance_repository.dart';
import '../local/shop_finance_models.dart';
import '../local/shop_finance_repository.dart';

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
  final shopId = ref.watch(effectiveShopIdProvider);
  await repo.seedIfEmpty(shopId);
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

final orderStyleSnapshotProvider = StreamProvider.family<
    OrderStyleSnapshotView?, String>((ref, orderInternalId) async* {
  final repo = await ref.watch(orderListRepositoryProvider.future);
  yield* repo.watchOrderStyleSnapshot(orderInternalId);
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

final styleCatalogRepositoryProvider =
    FutureProvider<StyleCatalogRepository>((ref) async {
  final repo = MemoryStyleCatalogRepository();
  final shopId = ref.watch(effectiveShopIdProvider);
  await repo.seedIfEmpty(shopId);
  return repo;
});

final styleNamesForGarmentProvider = StreamProvider.family<
    List<StyleNameSummary>, GarmentType>((ref, garment) async* {
  final repo = await ref.watch(styleCatalogRepositoryProvider.future);
  final shopId = ref.watch(effectiveShopIdProvider);
  yield* repo.watchStyleNames(shopId, garmentTypeIndex: garment.code);
});

final stylePartsForGarmentProvider = StreamProvider.family<
    List<StylePartSummary>, GarmentType>((ref, garment) async* {
  final repo = await ref.watch(styleCatalogRepositoryProvider.future);
  final shopId = ref.watch(effectiveShopIdProvider);
  yield* repo.watchStyleParts(shopId, garmentTypeIndex: garment.code);
});

final styleFiguresForGarmentProvider = StreamProvider.family<
    List<StyleFigureSummary>, GarmentType>((ref, garment) async* {
  final repo = await ref.watch(styleCatalogRepositoryProvider.future);
  final shopId = ref.watch(effectiveShopIdProvider);
  yield* repo.watchAllFigures(shopId, garmentTypeIndex: garment.code);
});

final styleFigureConfigsForGarmentProvider = FutureProvider.family<
    Map<String, StyleFigureConfigSummary>, GarmentType>((ref, garment) async {
  final repo = await ref.watch(styleCatalogRepositoryProvider.future);
  final shopId = ref.watch(effectiveShopIdProvider);
  return repo.loadAllFigureConfigs(
    shopId,
    garmentTypeIndex: garment.code,
  );
});

final styleNamesStreamProvider =
    StreamProvider<List<StyleNameSummary>>((ref) async* {
  final repo = await ref.watch(styleCatalogRepositoryProvider.future);
  final shopId = ref.watch(effectiveShopIdProvider);
  yield* repo.watchStyleNames(
    shopId,
    garmentTypeIndex: GarmentType.perahanTunban.code,
  );
});

final stylePartsStreamProvider =
    StreamProvider<List<StylePartSummary>>((ref) async* {
  final repo = await ref.watch(styleCatalogRepositoryProvider.future);
  final shopId = ref.watch(effectiveShopIdProvider);
  yield* repo.watchStyleParts(
    shopId,
    garmentTypeIndex: GarmentType.perahanTunban.code,
  );
});

final styleFiguresForPartProvider = StreamProvider.family<
    List<StyleFigureSummary>, String>((ref, partInternalId) async* {
  final repo = await ref.watch(styleCatalogRepositoryProvider.future);
  final shopId = ref.watch(effectiveShopIdProvider);
  yield* repo.watchFiguresForPart(shopId, partInternalId);
});

final styleAllFiguresStreamProvider =
    StreamProvider<List<StyleFigureSummary>>((ref) async* {
  final repo = await ref.watch(styleCatalogRepositoryProvider.future);
  final shopId = ref.watch(effectiveShopIdProvider);
  yield* repo.watchAllFigures(
    shopId,
    garmentTypeIndex: GarmentType.perahanTunban.code,
  );
});

final styleFigureTextOptionsProvider = StreamProvider.family<
    List<StyleFigureTextOptionSummary>, String>((ref, figureId) async* {
  final repo = await ref.watch(styleCatalogRepositoryProvider.future);
  final shopId = ref.watch(effectiveShopIdProvider);
  yield* repo.watchTextOptionsForFigure(shopId, figureId);
});

final styleFigureSizeOptionsProvider = StreamProvider.family<
    List<StyleFigureSizeOptionSummary>, String>((ref, figureId) async* {
  final repo = await ref.watch(styleCatalogRepositoryProvider.future);
  final shopId = ref.watch(effectiveShopIdProvider);
  yield* repo.watchSizeOptionsForFigure(shopId, figureId);
});

final styleAllFigureConfigsProvider =
    FutureProvider<Map<String, StyleFigureConfigSummary>>((ref) async {
  final repo = await ref.watch(styleCatalogRepositoryProvider.future);
  final shopId = ref.watch(effectiveShopIdProvider);
  return repo.loadAllFigureConfigs(shopId);
});

final fabricPresetRepositoryProvider =
    FutureProvider<FabricPresetRepository>((ref) async {
  return MemoryFabricPresetRepository();
});

final fabricNamesStreamProvider =
    StreamProvider<List<FabricPresetSummary>>((ref) async* {
  final repo = await ref.watch(fabricPresetRepositoryProvider.future);
  final shopId = ref.watch(effectiveShopIdProvider);
  yield* repo.watchFabricNames(shopId);
});

final fabricColorsStreamProvider =
    StreamProvider<List<FabricPresetSummary>>((ref) async* {
  final repo = await ref.watch(fabricPresetRepositoryProvider.future);
  final shopId = ref.watch(effectiveShopIdProvider);
  yield* repo.watchFabricColors(shopId);
});

final shopFinanceRepositoryProvider =
    FutureProvider<ShopFinanceRepository>((ref) async {
  return MemoryShopFinanceRepository();
});

final shopRentsStreamProvider =
    StreamProvider.family<List<ShopRentSummary>, String>((ref, shopId) async* {
  final repo = await ref.watch(shopFinanceRepositoryProvider.future);
  yield* repo.watchRents(shopId);
});

final shopRentPaymentsStreamProvider =
    StreamProvider.family<List<ShopRentPaymentSummary>, String>(
        (ref, shopId) async* {
  final repo = await ref.watch(shopFinanceRepositoryProvider.future);
  yield* repo.watchRentPayments(shopId);
});

final shopExpensesStreamProvider =
    StreamProvider.family<List<ShopExpenseSummary>, String>(
        (ref, shopId) async* {
  final repo = await ref.watch(shopFinanceRepositoryProvider.future);
  yield* repo.watchExpenses(shopId);
});
