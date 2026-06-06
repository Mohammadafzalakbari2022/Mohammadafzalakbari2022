import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../auth/auth_providers.dart';
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
import '../local/entities/fabric_color_preset_entity.dart';
import '../local/entities/fabric_name_preset_entity.dart';
import '../local/entities/style_name_entity.dart';
import '../local/fabric_preset_repository.dart';
import '../local/fabric_preset_summary.dart';
import '../local/isar_fabric_preset_repository.dart';
import '../local/entities/style_part_entity.dart';
import '../local/entities/shop_expense_entity.dart';
import '../local/entities/shop_rent_entity.dart';
import '../local/entities/shop_rent_payment_entity.dart';
import '../local/entities/style_figure_entity.dart';
import '../local/entities/style_figure_preset_entity.dart';
import '../local/entities/style_figure_size_option_entity.dart';
import '../local/entities/style_figure_text_option_entity.dart';
import '../local/isar_shop_finance_repository.dart';
import '../local/shop_finance_models.dart';
import '../local/shop_finance_repository.dart';
import '../local/isar_style_catalog_repository.dart';
import '../local/style_catalog_repository.dart';
import '../local/style_name_summary.dart';
import '../local/style_part_summary.dart';
import '../local/style_figure_config_summary.dart';
import '../local/style_figure_preset_summary.dart';
import '../local/style_figure_size_option_summary.dart';
import '../local/style_figure_summary.dart';
import '../local/style_figure_text_option_summary.dart';
import '../local/app_notification_repository.dart';
import '../local/app_notification_summary.dart';
import '../local/isar_app_notification_repository.dart';
import '../local/isar_order_repository.dart';
import '../local/isar_payment_repository.dart';
import '../local/isar_task_repository.dart';
import '../local/customer_list_repository.dart';
import '../local/order_list_repository.dart';
import '../local/customer_summary.dart';
import '../local/entities/order_style_snapshot_entity.dart';
import '../local/entities/order_style_snapshot_figure_entity.dart';
import '../local/order_measurement_snapshot_view.dart';
import '../local/order_style_snapshot_view.dart';
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
      OrderStyleSnapshotEntitySchema,
      OrderStyleSnapshotFigureEntitySchema,
      AppNotificationEntitySchema,
      SyncOutboxEntitySchema,
      TaskEntitySchema,
      StyleNameEntitySchema,
      StylePartEntitySchema,
      StyleFigureEntitySchema,
      StyleFigureTextOptionEntitySchema,
      StyleFigureSizeOptionEntitySchema,
      StyleFigurePresetEntitySchema,
      FabricNamePresetEntitySchema,
      FabricColorPresetEntitySchema,
      ShopRentEntitySchema,
      ShopRentPaymentEntitySchema,
      ShopExpenseEntitySchema,
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
  final shopId = ref.watch(effectiveShopIdProvider);
  yield* repo.watchOrders(shopId);
});

final customersListStreamProvider =
    StreamProvider<List<CustomerSummary>>((ref) async* {
  final repo = await ref.watch(customerListRepositoryProvider.future);
  final shopId = ref.watch(effectiveShopIdProvider);
  yield* repo.watchCustomers(shopId);
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
  await ref.watch(orderListRepositoryProvider.future);
  final isar = await ref.watch(isarProvider.future);
  final repo = IsarMeasurementProfileRepository(isar);
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
  final isar = await ref.watch(isarProvider.future);
  return IsarAppNotificationRepository(isar);
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
  final isar = await ref.watch(isarProvider.future);
  return IsarSyncOutboxRepository(isar);
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
  final isar = await ref.watch(isarProvider.future);
  final repo = IsarStyleCatalogRepository(isar);
  final shopId = ref.watch(effectiveShopIdProvider);
  await repo.seedIfEmpty(shopId);
  return repo;
});

final styleNamesStreamProvider =
    StreamProvider<List<StyleNameSummary>>((ref) async* {
  final repo = await ref.watch(styleCatalogRepositoryProvider.future);
  final shopId = ref.watch(effectiveShopIdProvider);
  yield* repo.watchStyleNames(shopId);
});

final stylePartsStreamProvider =
    StreamProvider<List<StylePartSummary>>((ref) async* {
  final repo = await ref.watch(styleCatalogRepositoryProvider.future);
  final shopId = ref.watch(effectiveShopIdProvider);
  yield* repo.watchStyleParts(shopId);
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
  yield* repo.watchAllFigures(shopId);
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

final styleFigurePresetsProvider = StreamProvider.family<
    List<StyleFigurePresetSummary>, String>((ref, figureId) async* {
  final repo = await ref.watch(styleCatalogRepositoryProvider.future);
  final shopId = ref.watch(effectiveShopIdProvider);
  yield* repo.watchPresetsForFigure(shopId, figureId);
});

final styleAllFigureConfigsProvider =
    FutureProvider<Map<String, StyleFigureConfigSummary>>((ref) async {
  final repo = await ref.watch(styleCatalogRepositoryProvider.future);
  final shopId = ref.watch(effectiveShopIdProvider);
  return repo.loadAllFigureConfigs(shopId);
});

final fabricPresetRepositoryProvider =
    FutureProvider<FabricPresetRepository>((ref) async {
  final isar = await ref.watch(isarProvider.future);
  return IsarFabricPresetRepository(isar);
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
  final isar = await ref.watch(isarProvider.future);
  return IsarShopFinanceRepository(isar);
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
