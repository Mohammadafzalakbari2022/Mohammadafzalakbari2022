import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/auth_providers.dart';
import '../../data/providers/local_data_providers.dart';
import '../../licensing/license_providers.dart';
import '../../shell/shell_sync_providers.dart';
import '../persistence/shared_preferences_provider.dart';
import '../persistence/sync_diagnostics_storage.dart';
import 'sync_coordinator.dart';
import 'manual_sync_runner.dart';
import 'sync_conflict_recorder.dart';

sealed class ManualSyncUiOutcome {
  const ManualSyncUiOutcome();
}

final class ManualSyncUiSuccess extends ManualSyncUiOutcome {
  const ManualSyncUiSuccess({
    required this.pushedMutationCount,
    required this.remoteChangeCount,
  });

  final int pushedMutationCount;
  final int remoteChangeCount;
}

final class ManualSyncUiFailure extends ManualSyncUiOutcome {
  const ManualSyncUiFailure(this.messageKey, {this.detail});

  /// `sign_in` | `offline` | `license` | `busy` | `error`
  final String messageKey;
  final String? detail;
}

/// Shared manual sync for dashboard and Settings → Sync diagnostics.
Future<ManualSyncUiOutcome> runManualSyncFromRef(WidgetRef ref) async {
  final auth = ref.read(authSessionProvider);
  final token = auth.accessToken;
  if (!auth.hasApiSession || token == null) {
    return const ManualSyncUiFailure('sign_in');
  }
  if (!ref.read(connectivityOnlineProvider)) {
    return const ManualSyncUiFailure('offline');
  }
  if (ref.read(licenseEditingBlockedProvider)) {
    return const ManualSyncUiFailure('license');
  }

  try {
    final uiOutcome = await SyncCoordinator.instance.runExclusive(() async {
      final repo = await ref.read(syncOutboxRepositoryProvider.future);
      final notifRepo =
          await ref.read(appNotificationRepositoryProvider.future);
      final customersRepo =
          await ref.read(customerListRepositoryProvider.future);
      final tasksRepo = await ref.read(taskRepositoryProvider.future);
      final paymentsRepo = await ref.read(paymentRepositoryProvider.future);
      final ordersRepo = await ref.read(orderListRepositoryProvider.future);
      final measurementRepo =
          await ref.read(measurementProfileRepositoryProvider.future);
      final catalogRepo = await ref.read(catalogRepositoryProvider.future);
      final styleCatalogRepo =
          await ref.read(styleCatalogRepositoryProvider.future);
      final fabricPresetsRepo =
          await ref.read(fabricPresetRepositoryProvider.future);
      final shopFinanceRepo =
          await ref.read(shopFinanceRepositoryProvider.future);
      final prefs = ref.read(sharedPreferencesProvider);
      final syncShopId = ref.read(effectiveShopIdProvider);
      final conflictStorage = ref.read(syncConflictStorageProvider);
      final conflictRecorder =
          SyncConflictRecorder(conflictStorage, syncShopId);

      final outcome = await runManualSyncWithOutbox(
        outboxRepo: repo,
        accessToken: token,
        prefs: prefs,
        syncShopId: syncShopId,
        notifications: notifRepo,
        customers: customersRepo,
        tasks: tasksRepo,
        payments: paymentsRepo,
        orders: ordersRepo,
        measurementProfiles: measurementRepo,
        catalog: catalogRepo,
        styleCatalog: styleCatalogRepo,
        fabricPresets: fabricPresetsRepo,
        shopFinance: shopFinanceRepo,
        conflictRecorder: conflictRecorder,
      );

      switch (outcome) {
        case ManualSyncSuccess(
            :final pushedMutationCount,
            :final remoteChangeCount,
          ):
          final at = DateTime.now();
          ref.read(lastSuccessfulSyncAtProvider.notifier).state = at;
          await SyncDiagnosticsStorage.recordSuccessfulSync(prefs, at);
          return ManualSyncUiSuccess(
            pushedMutationCount: pushedMutationCount,
            remoteChangeCount: remoteChangeCount,
          );
        case ManualSyncFailure(:final message):
          return message == 'license_expired'
              ? const ManualSyncUiFailure('license')
              : ManualSyncUiFailure('error', detail: message);
      }
    });
    if (uiOutcome == null) {
      return const ManualSyncUiFailure('busy');
    }
    return uiOutcome;
  } catch (e) {
    return ManualSyncUiFailure('error', detail: e.toString());
  }
}
