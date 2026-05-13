import 'task_summary.dart';

abstract class TaskRepository {
  Stream<List<TaskSummary>> watchTasks(String shopId);

  Future<void> upsertTask({
    required String shopId,
    required String? internalId,
    required String title,
    required String notes,
    required DateTime? dueDate,
  });

  Future<void> setTaskDone({
    required String internalId,
    required bool isDone,
  });

  Future<void> softDeleteTask(String internalId);
}

