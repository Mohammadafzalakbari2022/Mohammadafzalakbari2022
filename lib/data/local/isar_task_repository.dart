import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

import 'entities/task_entity.dart';
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
}

