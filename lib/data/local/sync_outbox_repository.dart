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

  /// One-shot pending list (same shape as [watchPendingEntries] first emission).
  Future<List<SyncOutboxPendingView>> listPendingEntries(
    String shopId, {
    int limit = 100,
  });

  /// Marks pending rows as uploaded (plan-04 scaffold); no-ops for unknown ids.
  Future<void> markPendingSynced(String shopId, List<String> entryIds);
}
