import 'app_notification_summary.dart';
import 'dev_shop_constants.dart';

abstract class AppNotificationRepository {
  Stream<List<AppNotificationSummary>> watchNotifications(
      [String shopId = kDevShopId]);

  /// One-time localized welcome row (internal id fixed).
  Future<void> ensureWelcomeSeed({
    required String title,
    required String body,
  });

  Future<void> append({
    required String shopId,
    required String title,
    required String body,
    String? relatedOrderInternalId,
    String? internalId,
  });

  /// Remote sync pull (`plan-03`) — upsert or delete a notification by server id.
  Future<void> mergeRemoteNotification({
    required String shopId,
    required String internalId,
    required String operation,
    Object? data,
  });

  Future<void> markRead(String internalId);

  Future<void> markAllRead(String shopId);
}
