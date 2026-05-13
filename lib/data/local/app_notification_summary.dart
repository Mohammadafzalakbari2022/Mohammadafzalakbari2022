class AppNotificationSummary {
  const AppNotificationSummary({
    required this.internalId,
    required this.shopId,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.readAt,
    this.relatedOrderInternalId,
  });

  final String internalId;
  final String shopId;
  final String title;
  final String body;
  final DateTime createdAt;
  final DateTime? readAt;
  final String? relatedOrderInternalId;

  bool get isRead => readAt != null;
}
