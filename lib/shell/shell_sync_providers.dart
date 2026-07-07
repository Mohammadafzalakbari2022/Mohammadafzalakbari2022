import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth_providers.dart';
import '../core/persistence/shared_preferences_bootstrap.dart';
import '../core/sync/sync_coordinator.dart';
import '../data/local/dev_shop_constants.dart';
import '../data/providers/local_data_providers.dart';

/// Live connectivity (plan-09). Emits after initial check, then on changes.
final connectivityListProvider =
    StreamProvider<List<ConnectivityResult>>((ref) async* {
  await waitForPlatformChannelsReady();
  final c = Connectivity();
  yield await c.checkConnectivity();
  yield* c.onConnectivityChanged;
});

/// True when any interface is not [ConnectivityResult.none].
final connectivityOnlineProvider = Provider<bool>((ref) {
  final async = ref.watch(connectivityListProvider);
  return async.maybeWhen(
    data: (list) =>
        list.any((r) => r != ConnectivityResult.none),
    orElse: () => false,
  );
});

/// Last time a successful server sync completed (plan-03).
///
/// Seeded from [SyncDiagnosticsStorage] in [main.dart]; updated after manual sync.
final lastSuccessfulSyncAtProvider = StateProvider<DateTime?>((ref) => null);

/// True while a manual or automatic push/pull sync is running.
final syncInProgressProvider = Provider<bool>((ref) {
  final coordinator = SyncCoordinator.instance;
  void listener() => ref.invalidateSelf();
  coordinator.addListener(listener);
  ref.onDispose(() => coordinator.removeListener(listener));
  return coordinator.busy;
});

/// Enqueue a local mutation for a future sync worker (plan-03). Fire-and-forget.
void recordSyncOutboxMutation(
  WidgetRef ref, {
  required String kind,
  String entityRef = '',
  String payloadJson = '{}',
  String? shopId,
}) {
  unawaited(Future(() async {
    final repo = await ref.read(syncOutboxRepositoryProvider.future);
    final sid =
        shopId ?? effectiveShopIdFromAuth(ref.read(authSessionProvider).shopId);
    await repo.enqueue(
      shopId: sid,
      kind: kind,
      entityRef: entityRef,
      payloadJson: payloadJson,
    );
  }));
}
