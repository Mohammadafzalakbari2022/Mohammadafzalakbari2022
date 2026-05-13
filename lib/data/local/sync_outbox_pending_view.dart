/// One pending row for diagnostics UI (plan-03 / plan-15).
class SyncOutboxPendingView {
  const SyncOutboxPendingView({
    required this.entryId,
    required this.kind,
    required this.entityRef,
    required this.queuedAt,
  });

  final String entryId;
  final String kind;
  final String entityRef;
  final DateTime queuedAt;
}
