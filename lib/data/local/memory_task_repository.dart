import 'dart:async';

import 'package:uuid/uuid.dart';

import 'task_repository.dart';
import 'task_summary.dart';
import 'sync_pull_payload.dart';

class MemoryTaskRepository implements TaskRepository {
  final _uuid = const Uuid();
  final _controller = StreamController<void>.broadcast();

  final List<TaskSummary> _tasks = [];

  void _emit() => _controller.add(null);

  @override
  Stream<List<TaskSummary>> watchTasks(String shopId) async* {
    yield _forShop(shopId);
    yield* _controller.stream.map((_) => _forShop(shopId));
  }

  List<TaskSummary> _forShop(String shopId) {
    final list = _tasks
        .where((t) => t.shopId == shopId && t.deletedAt == null)
        .toList()
      ..sort((a, b) {
        final cmpDone = a.isDone.toString().compareTo(b.isDone.toString());
        if (cmpDone != 0) return cmpDone;
        final ad = a.dueDate?.millisecondsSinceEpoch ?? 1 << 62;
        final bd = b.dueDate?.millisecondsSinceEpoch ?? 1 << 62;
        final cmpDue = ad.compareTo(bd);
        if (cmpDue != 0) return cmpDue;
        return b.updatedAt.compareTo(a.updatedAt);
      });
    return list;
  }

  @override
  Future<String> upsertTask({
    required String shopId,
    required String? internalId,
    required String title,
    required String notes,
    required DateTime? dueDate,
  }) async {
    final now = DateTime.now();
    final id = (internalId == null || internalId.isEmpty) ? _uuid.v4() : internalId;

    final idx = _tasks.indexWhere((t) => t.internalId == id);
    if (idx == -1) {
      _tasks.add(
        TaskSummary(
          internalId: id,
          shopId: shopId,
          title: title.trim(),
          notes: notes,
          isDone: false,
          dueDate: dueDate,
          createdAt: now,
          updatedAt: now,
          deletedAt: null,
        ),
      );
      _emit();
      return id;
    }

    final prev = _tasks[idx];
    _tasks[idx] = TaskSummary(
      internalId: prev.internalId,
      shopId: shopId,
      title: title.trim(),
      notes: notes,
      isDone: prev.isDone,
      dueDate: dueDate,
      createdAt: prev.createdAt,
      updatedAt: now,
      deletedAt: null,
    );
    _emit();
    return id;
  }

  @override
  Future<void> setTaskDone({
    required String internalId,
    required bool isDone,
  }) async {
    final idx = _tasks.indexWhere((t) => t.internalId == internalId);
    if (idx == -1) return;
    final prev = _tasks[idx];
    _tasks[idx] = TaskSummary(
      internalId: prev.internalId,
      shopId: prev.shopId,
      title: prev.title,
      notes: prev.notes,
      isDone: isDone,
      dueDate: prev.dueDate,
      createdAt: prev.createdAt,
      updatedAt: DateTime.now(),
      deletedAt: prev.deletedAt,
    );
    _emit();
  }

  @override
  Future<void> softDeleteTask(String internalId) async {
    final idx = _tasks.indexWhere((t) => t.internalId == internalId);
    if (idx == -1) return;
    final prev = _tasks[idx];
    _tasks[idx] = TaskSummary(
      internalId: prev.internalId,
      shopId: prev.shopId,
      title: prev.title,
      notes: prev.notes,
      isDone: prev.isDone,
      dueDate: prev.dueDate,
      createdAt: prev.createdAt,
      updatedAt: DateTime.now(),
      deletedAt: DateTime.now(),
    );
    _emit();
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

    final idx = _tasks.indexWhere((t) => t.internalId == internalId);
    if (idx == -1) {
      _tasks.add(
        TaskSummary(
          internalId: internalId,
          shopId: shopId,
          title: title.trim(),
          notes: notes,
          isDone: isDone,
          dueDate: dueDate,
          createdAt: createdRemote,
          updatedAt: updatedRemote,
          deletedAt: null,
        ),
      );
      _emit();
      return;
    }
    final prev = _tasks[idx];
    _tasks[idx] = TaskSummary(
      internalId: prev.internalId,
      shopId: shopId,
      title: title.trim(),
      notes: notes,
      isDone: isDone,
      dueDate: dueDate,
      createdAt: prev.createdAt,
      updatedAt: updatedRemote,
      deletedAt: null,
    );
    _emit();
  }
}

