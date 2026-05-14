/// One pending row for diagnostics UI (plan-03 / plan-15).
class SyncOutboxPendingView {
  const SyncOutboxPendingView({
    required this.entryId,
    required this.kind,
    required this.entityRef,
    required this.queuedAt,
    this.payloadJson = '{}',
  });

  final String entryId;
  final String kind;
  final String entityRef;
  final DateTime queuedAt;

  /// Opaque JSON for a future sync worker (`plan-04` push `data`).
  final String payloadJson;
}
