import 'dart:async';

import 'package:uuid/uuid.dart';

import 'task_repository.dart';
import 'task_summary.dart';

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
  Future<void> upsertTask({
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
      return;
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
}

