import 'package:isar/isar.dart';

part 'app_notification_entity.g.dart';

/// In-app notification row (plan-15 inbox; local-only until sync).
@collection
class AppNotificationEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String internalId;

  @Index()
  late String shopId;

  late String title;

  late String body;

  @Index()
  late DateTime createdAt;

  DateTime? readAt;

  /// Optional deep link to an order.
  String? relatedOrderInternalId;
}
