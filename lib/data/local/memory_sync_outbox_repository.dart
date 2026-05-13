import 'dart:async';

import 'package:uuid/uuid.dart';

import 'sync_outbox_pending_view.dart';
import 'sync_outbox_repository.dart';

class _MemRow {
  _MemRow({
    required this.entryId,
    required this.shopId,
    required this.kind,
    required this.entityRef,
    required this.payloadJson,
    required this.queuedAt,
  });

  final String entryId;
  final String shopId;
  final String kind;
  final String entityRef;
  final String payloadJson;
  final DateTime queuedAt;
  DateTime? syncedAt;
}

/// Web / in-memory outbox (mirrors [IsarSyncOutboxRepository]).
class MemorySyncOutboxRepository implements SyncOutboxRepository {
  final List<_MemRow> _rows = [];
  final _signal = StreamController<void>.broadcast();
  final _uuid = const Uuid();

  void _emit() {
    if (!_signal.isClosed) _signal.add(null);
  }

  List<_MemRow> _pendingFor(String shopId) {
    return _rows
        .where((r) => r.shopId == shopId && r.syncedAt == null)
        .toList()
      ..sort((a, b) => b.queuedAt.compareTo(a.queuedAt));
  }

  @override
  Future<void> enqueue({
    required String shopId,
    required String kind,
    String entityRef = '',
    String payloadJson = '{}',
  }) async {
    _rows.add(
      _MemRow(
        entryId: _uuid.v4(),
        shopId: shopId,
        kind: kind,
        entityRef: entityRef,
        payloadJson: payloadJson,
        queuedAt: DateTime.now(),
      ),
    );
    _emit();
  }

  @override
  Stream<int> watchPendingCount(String shopId) async* {
    yield _pendingFor(shopId).length;
    await for (final _ in _signal.stream) {
      yield _pendingFor(shopId).length;
    }
  }

  @override
  Stream<List<SyncOutboxPendingView>> watchPendingEntries(
    String shopId, {
    int limit = 50,
  }) async* {
    List<SyncOutboxPendingView> mapRows() {
      final list = _pendingFor(shopId);
      final take = list.length > limit ? list.sublist(0, limit) : list;
      return [
        for (final e in take)
          SyncOutboxPendingView(
            entryId: e.entryId,
            kind: e.kind,
            entityRef: e.entityRef,
            queuedAt: e.queuedAt,
          ),
      ];
    }

    yield mapRows();
    await for (final _ in _signal.stream) {
      yield mapRows();
    }
  }
}
