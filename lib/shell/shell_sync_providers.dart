import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local/dev_shop_constants.dart';
import '../data/providers/local_data_providers.dart';

/// Live connectivity (plan-09). Emits after initial check, then on changes.
final connectivityListProvider =
    StreamProvider<List<ConnectivityResult>>((ref) async* {
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
    orElse: () => true,
  );
});

/// Last time a successful server sync completed (null until API exists; plan-03).
final lastSuccessfulSyncAtProvider = StateProvider<DateTime?>((ref) => null);

/// Enqueue a local mutation for a future sync worker (plan-03). Fire-and-forget.
void recordSyncOutboxMutation(
  WidgetRef ref, {
  required String kind,
  String entityRef = '',
  String payloadJson = '{}',
  String shopId = kDevShopId,
}) {
  unawaited(Future(() async {
    final repo = await ref.read(syncOutboxRepositoryProvider.future);
    await repo.enqueue(
      shopId: shopId,
      kind: kind,
      entityRef: entityRef,
      payloadJson: payloadJson,
    );
  }));
}
