import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../persistence/shared_preferences_provider.dart';
import '../persistence/sync_conflict_storage.dart';
import 'sync_conflict_record.dart';

final syncConflictStorageProvider = Provider<SyncConflictStorage>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SyncConflictStorage(prefs);
});

final syncConflictsForShopProvider =
    FutureProvider.family<List<SyncConflictRecord>, String>((ref, shopId) async {
  final storage = ref.watch(syncConflictStorageProvider);
  return storage.list(shopId);
});

class SyncConflictRecorder {
  SyncConflictRecorder(this._storage, this._shopId);

  final SyncConflictStorage _storage;
  final String _shopId;
  final _uuid = const Uuid();

  Future<void> recordPullSkipped({
    required String entityType,
    required String internalId,
    required Map<String, dynamic> localSnapshot,
    required Map<String, dynamic> remoteSnapshot,
    String? displayLabel,
  }) async {
    await _storage.upsert(
      _shopId,
      SyncConflictRecord(
        conflictId: _uuid.v4(),
        shopId: _shopId,
        entityType: entityType,
        internalId: internalId,
        direction: 'pull_skipped',
        localSnapshotJson: encodeSyncConflictSnapshot(localSnapshot),
        remoteSnapshotJson: encodeSyncConflictSnapshot(remoteSnapshot),
        detectedAt: DateTime.now(),
        displayLabel: displayLabel,
      ),
    );
  }

  Future<void> recordPushConflict({
    required String entityType,
    required String internalId,
    required Map<String, dynamic> localSnapshot,
    String? message,
    String? displayLabel,
  }) async {
    await _storage.upsert(
      _shopId,
      SyncConflictRecord(
        conflictId: _uuid.v4(),
        shopId: _shopId,
        entityType: entityType,
        internalId: internalId,
        direction: 'push_rejected',
        localSnapshotJson: encodeSyncConflictSnapshot(localSnapshot),
        remoteSnapshotJson: encodeSyncConflictSnapshot({
          'message': ?message,
        }),
        detectedAt: DateTime.now(),
        displayLabel: displayLabel,
      ),
    );
  }

  Future<void> dismiss(String internalId) =>
      _storage.remove(_shopId, internalId);
}
