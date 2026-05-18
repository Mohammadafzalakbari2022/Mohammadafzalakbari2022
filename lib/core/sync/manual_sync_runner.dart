import 'package:shared_preferences/shared_preferences.dart';

import '../../data/local/app_notification_repository.dart';
import '../../data/local/catalog_repository.dart';
import '../../data/local/customer_list_repository.dart';
import '../../data/local/measurement_profile_repository.dart';
import '../../data/local/order_list_repository.dart';
import '../../data/local/payment_repository.dart';
import '../../data/local/sync_outbox_repository.dart';
import '../../data/local/task_repository.dart';
import '../../data/local/shop_finance_repository.dart';
import '../../data/local/fabric_preset_repository.dart';
import '../../data/local/style_catalog_repository.dart';
import '../api/pride_api_sync.dart';
import '../persistence/sync_cursor_storage.dart';
import 'outbox_push_batch.dart';
import 'sync_inbound_applier.dart';

sealed class ManualSyncOutcome {
  const ManualSyncOutcome();
}

final class ManualSyncSuccess extends ManualSyncOutcome {
  const ManualSyncSuccess({
    required this.pushedMutationCount,
    required this.remoteChangeCount,
  });

  final int pushedMutationCount;
  final int remoteChangeCount;
}

final class ManualSyncFailure extends ManualSyncOutcome {
  const ManualSyncFailure(this.message);

  final String message;
}

const int _kMaxPullPages = 32;
const int _kMaxPushBatchesPerRun = 5;

/// Runs `GET /sync/pull` (paged, cursor persisted), applies supported entities, then `POST /sync/push`.
Future<ManualSyncOutcome> runManualSyncWithOutbox({
  required SyncOutboxRepository outboxRepo,
  required String accessToken,
  required SharedPreferences prefs,
  required String syncShopId,
  required AppNotificationRepository notifications,
  required CustomerListRepository customers,
  required TaskRepository tasks,
  required PaymentRepository payments,
  required OrderListRepository orders,
  required MeasurementProfileRepository measurementProfiles,
  required CatalogRepository catalog,
  required StyleCatalogRepository styleCatalog,
  required FabricPresetRepository fabricPresets,
  required ShopFinanceRepository shopFinance,
}) async {
  final applier = SyncInboundApplier(
    notifications: notifications,
    customers: customers,
    tasks: tasks,
    payments: payments,
    orders: orders,
    measurementProfiles: measurementProfiles,
    catalog: catalog,
    styleCatalog: styleCatalog,
    fabricPresets: fabricPresets,
    shopFinance: shopFinance,
    shopId: syncShopId,
  );

  var remoteChangeCount = 0;
  var cursor = SyncCursorStorage.read(prefs, syncShopId);

  for (var page = 0; page < _kMaxPullPages; page++) {
    final pull = await getPrideApiSyncPull(
      accessToken: accessToken,
      cursor: cursor,
    );
    switch (pull) {
      case PrideApiSyncPullFailure(:final message, :final errorCode):
        if (errorCode == 'license_expired') {
          return const ManualSyncFailure('license_expired');
        }
        return ManualSyncFailure(message);
      case PrideApiSyncPullOk(:final changes, :final nextCursor):
        remoteChangeCount += changes.length;
        await applier.applyChanges(changes);
        await SyncCursorStorage.write(prefs, syncShopId, nextCursor);
        cursor = nextCursor;
        if (changes.isEmpty) break;
        if (changes.length < 500) break;
    }
  }

  var pushedMutationCount = 0;
  for (var batchIndex = 0; batchIndex < _kMaxPushBatchesPerRun; batchIndex++) {
    final pending =
        await outboxRepo.listPendingEntries(syncShopId, limit: 100);
    if (pending.isEmpty) break;

    final batch = buildOutboxPushBatch(pending);
    if (batch.mutations.isEmpty) break;

    final push = await postPrideApiSyncPush(
      accessToken: accessToken,
      mutations: batch.mutations,
    );
    switch (push) {
      case PrideApiSyncPushFailure(:final message, :final errorCode):
        if (errorCode == 'license_expired') {
          return const ManualSyncFailure('license_expired');
        }
        return ManualSyncFailure(message);
      case PrideApiSyncPushOk(:final results):
        if (results.length != batch.mutations.length) {
          return const ManualSyncFailure('Unexpected server response length');
        }
        for (final r in results) {
          if (r.status != 'accepted') {
            return ManualSyncFailure(
              'Sync incomplete: ${r.internalId} → ${r.status}',
            );
          }
        }
        await outboxRepo.markPendingSynced(
          syncShopId,
          batch.entryIdsToClear,
        );
        pushedMutationCount += batch.mutations.length;
    }
  }

  return ManualSyncSuccess(
    pushedMutationCount: pushedMutationCount,
    remoteChangeCount: remoteChangeCount,
  );
}
