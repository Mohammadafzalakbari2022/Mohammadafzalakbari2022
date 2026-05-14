import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

import 'entities/sync_outbox_entity.dart';
import 'sync_outbox_pending_view.dart';
import 'sync_outbox_repository.dart';

class IsarSyncOutboxRepository implements SyncOutboxRepository {
  IsarSyncOutboxRepository(this._isar);

  final Isar _isar;
  final _uuid = const Uuid();

  @override
  Future<void> enqueue({
    required String shopId,
    required String kind,
    String entityRef = '',
    String payloadJson = '{}',
  }) async {
    final e = SyncOutboxEntity()
      ..entryId = _uuid.v4()
      ..shopId = shopId
      ..kind = kind
      ..entityRef = entityRef
      ..payloadJson = payloadJson
      ..queuedAt = DateTime.now();
    await _isar.writeTxn(() async {
      await _isar.syncOutboxEntitys.putByEntryId(e);
    });
  }

  @override
  Stream<int> watchPendingCount(String shopId) {
    return _isar.syncOutboxEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .and()
        .syncedAtIsNull()
        .watch(fireImmediately: true)
        .map((list) => list.length);
  }

  @override
  Stream<List<SyncOutboxPendingView>> watchPendingEntries(
    String shopId, {
    int limit = 50,
  }) {
    return _isar.syncOutboxEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .and()
        .syncedAtIsNull()
        .sortByQueuedAtDesc()
        .watch(fireImmediately: true)
        .map((list) {
      final take = list.length > limit ? list.sublist(0, limit) : list;
      return [
        for (final e in take)
          SyncOutboxPendingView(
            entryId: e.entryId,
            kind: e.kind,
            entityRef: e.entityRef,
            queuedAt: e.queuedAt,
            payloadJson: e.payloadJson,
          ),
      ];
    });
  }

  @override
  Future<List<SyncOutboxPendingView>> listPendingEntries(
    String shopId, {
    int limit = 100,
  }) async {
    final list = await _isar.syncOutboxEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .and()
        .syncedAtIsNull()
        .sortByQueuedAtDesc()
        .findAll();
    final take = list.length > limit ? list.sublist(0, limit) : list;
    return [
      for (final e in take)
        SyncOutboxPendingView(
          entryId: e.entryId,
          kind: e.kind,
          entityRef: e.entityRef,
          queuedAt: e.queuedAt,
          payloadJson: e.payloadJson,
        ),
    ];
  }

  @override
  Future<void> markPendingSynced(String shopId, List<String> entryIds) async {
    if (entryIds.isEmpty) return;
    final now = DateTime.now();
    await _isar.writeTxn(() async {
      for (final id in entryIds) {
        final e = await _isar.syncOutboxEntitys.getByEntryId(id);
        if (e == null || e.shopId != shopId || e.syncedAt != null) continue;
        e.syncedAt = now;
        await _isar.syncOutboxEntitys.putByEntryId(e);
      }
    });
  }
}
