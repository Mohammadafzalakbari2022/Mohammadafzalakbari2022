import 'package:isar/isar.dart';

part 'task_entity.g.dart';

@collection
class TaskEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String internalId;

  @Index()
  late String shopId;

  @Index()
  late String title;

  String notes = '';

  @Index()
  late bool isDone;

  /// Optional date-only due date (local).
  @Index()
  DateTime? dueDate;

  @Index()
  late DateTime createdAt;

  @Index()
  late DateTime updatedAt;

  DateTime? deletedAt;
}

