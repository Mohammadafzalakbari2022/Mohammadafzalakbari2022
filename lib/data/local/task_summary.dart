class TaskSummary {
  const TaskSummary({
    required this.internalId,
    required this.shopId,
    required this.title,
    required this.notes,
    required this.isDone,
    required this.dueDate,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  final String internalId;
  final String shopId;
  final String title;
  final String notes;
  final bool isDone;
  final DateTime? dueDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
}

