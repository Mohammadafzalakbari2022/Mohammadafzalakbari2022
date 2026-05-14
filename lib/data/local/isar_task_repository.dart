import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

import 'entities/task_entity.dart';
import 'sync_pull_payload.dart';
import 'task_repository.dart';
import 'task_summary.dart';

class IsarTaskRepository implements TaskRepository {
  IsarTaskRepository(this._isar);

  final Isar _isar;
  final _uuid = const Uuid();

  @override
  Stream<List<TaskSummary>> watchTasks(String shopId) {
    return _isar.taskEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .deletedAtIsNull()
        // Open first, then due date, then updated desc.
        .sortByIsDone()
        .thenByDueDate()
        .thenByUpdatedAtDesc()
        .watch(fireImmediately: true)
        .map(
          (rows) => rows
              .map(
                (t) => TaskSummary(
                  internalId: t.internalId,
                  shopId: t.shopId,
                  title: t.title,
                  notes: t.notes,
                  isDone: t.isDone,
                  dueDate: t.dueDate,
                  createdAt: t.createdAt,
                  updatedAt: t.updatedAt,
                  deletedAt: t.deletedAt,
                ),
              )
              .toList(),
        );
  }

  @override
  Future<void> upsertTask({
    required String shopId,
    required String? internalId,
    required String title,
    required String notes,
    required DateTime? dueDate,
  }) async {
    final now = DateTime.now();
    await _isar.writeTxn(() async {
      if (internalId == null || internalId.isEmpty) {
        final e = TaskEntity()
          ..internalId = _uuid.v4()
          ..shopId = shopId
          ..title = title.trim()
          ..notes = notes
          ..isDone = false
          ..dueDate = dueDate
          ..createdAt = now
          ..updatedAt = now
          ..deletedAt = null;
        await _isar.taskEntitys.putByInternalId(e);
        return;
      }

      final existing = await _isar.taskEntitys.getByInternalId(internalId);
      final e = existing ??
          (TaskEntity()
            ..internalId = internalId
            ..shopId = shopId
            ..createdAt = now
            ..isDone = false);

      e
        ..shopId = shopId
        ..title = title.trim()
        ..notes = notes
        ..dueDate = dueDate
        ..updatedAt = now
        ..deletedAt = null;

      await _isar.taskEntitys.putByInternalId(e);
    });
  }

  @override
  Future<void> setTaskDone({
    required String internalId,
    required bool isDone,
  }) async {
    final now = DateTime.now();
    await _isar.writeTxn(() async {
      final e = await _isar.taskEntitys.getByInternalId(internalId);
      if (e == null) return;
      e
        ..isDone = isDone
        ..updatedAt = now;
      await _isar.taskEntitys.putByInternalId(e);
    });
  }

  @override
  Future<void> softDeleteTask(String internalId) async {
    final now = DateTime.now();
    await _isar.writeTxn(() async {
      final e = await _isar.taskEntitys.getByInternalId(internalId);
      if (e == null) return;
      e
        ..deletedAt = now
        ..updatedAt = now;
      await _isar.taskEntitys.putByInternalId(e);
    });
  }

  @override
  Future<void> mergeRemoteTask({
    required String shopId,
    required String internalId,
    required String operation,
    Object? data,
  }) async {
    if (operation == 'delete') {
      await softDeleteTask(internalId);
      return;
    }
    final m = syncPullDataMap(data);
    final title = syncPullString(m, const ['title']);
    if (title == null || title.trim().isEmpty) return;
    final notes = syncPullString(m, const ['notes']) ?? '';
    final isDone = syncPullBool(m, const ['is_done', 'isDone']) ?? false;
    final dueDate = syncPullDateTime(m, const ['due_date', 'dueDate']);
    final now = DateTime.now();
    final createdRemote =
        syncPullDateTime(m, const ['created_at', 'createdAt']) ?? now;
    final updatedRemote =
        syncPullDateTime(m, const ['updated_at', 'updatedAt']) ?? now;

    await _isar.writeTxn(() async {
      final existing = await _isar.taskEntitys.getByInternalId(internalId);
      if (existing == null) {
        final e = TaskEntity()
          ..internalId = internalId
          ..shopId = shopId
          ..title = title.trim()
          ..notes = notes
          ..isDone = isDone
          ..dueDate = dueDate
          ..createdAt = createdRemote
          ..updatedAt = updatedRemote
          ..deletedAt = null;
        await _isar.taskEntitys.putByInternalId(e);
        return;
      }
      existing
        ..shopId = shopId
        ..title = title.trim()
        ..notes = notes
        ..isDone = isDone
        ..dueDate = dueDate
        ..updatedAt = updatedRemote
        ..deletedAt = null;
      await _isar.taskEntitys.putByInternalId(existing);
    });
  }
}

