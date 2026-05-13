import 'sync_outbox_pending_view.dart';

/// Local-only queue of mutations waiting for a future sync API (plan-03).
abstract class SyncOutboxRepository {
  Future<void> enqueue({
    required String shopId,
    required String kind,
    String entityRef = '',
    String payloadJson = '{}',
  });

  Stream<int> watchPendingCount(String shopId);

  Stream<List<SyncOutboxPendingView>> watchPendingEntries(
    String shopId, {
    int limit = 50,
  });
}
