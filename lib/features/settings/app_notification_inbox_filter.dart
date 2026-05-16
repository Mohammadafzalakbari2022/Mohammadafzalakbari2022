import '../../data/local/app_notification_summary.dart';

/// Inbox filter for local notifications (title/body heuristics; plan-15).
enum AppNotificationInboxFilter {
  all,
  orders,
  license,
  backup,
}

extension AppNotificationInboxFilterX on AppNotificationSummary {
  bool matchesInboxFilter(AppNotificationInboxFilter filter) {
    if (filter == AppNotificationInboxFilter.all) return true;
    if (filter == AppNotificationInboxFilter.orders) {
      return (relatedOrderInternalId != null &&
              relatedOrderInternalId!.isNotEmpty) ||
          _blob.contains('order');
    }
    if (filter == AppNotificationInboxFilter.license) {
      return _blob.contains('license') ||
          _blob.contains('subscription') ||
          _blob.contains('trial') ||
          _blob.contains('activation');
    }
    if (filter == AppNotificationInboxFilter.backup) {
      return _blob.contains('backup') || _blob.contains('restore');
    }
    return true;
  }

  String get _blob => '${title.toLowerCase()} ${body.toLowerCase()}';
}
