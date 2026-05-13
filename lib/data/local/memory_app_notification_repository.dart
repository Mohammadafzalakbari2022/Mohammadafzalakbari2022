import 'dart:async';

import 'package:uuid/uuid.dart';

import 'app_notification_repository.dart';
import 'app_notification_summary.dart';
import 'dev_shop_constants.dart';

/// Web: in-memory notification inbox.
class MemoryAppNotificationRepository implements AppNotificationRepository {
  final List<AppNotificationSummary> _items = [];
  final _controller = StreamController<List<void>>.broadcast();
  final _uuid = const Uuid();

  void _emit() => _controller.add(const []);

  List<AppNotificationSummary> _sortedForShop(String shopId) {
    final list = _items.where((n) => n.shopId == shopId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  @override
  Stream<List<AppNotificationSummary>> watchNotifications(
      [String shopId = kDevShopId]) async* {
    yield _sortedForShop(shopId);
    yield* _controller.stream.map((_) => _sortedForShop(shopId));
  }

  @override
  Future<void> ensureWelcomeSeed({
    required String title,
    required String body,
  }) async {
    if (_items.any((n) => n.internalId == 'notif-seed-welcome')) return;
    _items.add(
      AppNotificationSummary(
        internalId: 'notif-seed-welcome',
        shopId: kDevShopId,
        title: title,
        body: body,
        createdAt: DateTime.now(),
        readAt: null,
        relatedOrderInternalId: null,
      ),
    );
    _emit();
  }

  @override
  Future<void> append({
    required String shopId,
    required String title,
    required String body,
    String? relatedOrderInternalId,
  }) async {
    _items.add(
      AppNotificationSummary(
        internalId: _uuid.v4(),
        shopId: shopId,
        title: title,
        body: body,
        createdAt: DateTime.now(),
        readAt: null,
        relatedOrderInternalId: relatedOrderInternalId,
      ),
    );
    _emit();
  }

  @override
  Future<void> markRead(String internalId) async {
    final idx = _items.indexWhere((n) => n.internalId == internalId);
    if (idx < 0) return;
    final n = _items[idx];
    if (n.readAt != null) return;
    _items[idx] = AppNotificationSummary(
      internalId: n.internalId,
      shopId: n.shopId,
      title: n.title,
      body: n.body,
      createdAt: n.createdAt,
      readAt: DateTime.now(),
      relatedOrderInternalId: n.relatedOrderInternalId,
    );
    _emit();
  }

  @override
  Future<void> markAllRead(String shopId) async {
    var changed = false;
    final now = DateTime.now();
    for (var i = 0; i < _items.length; i++) {
      final n = _items[i];
      if (n.shopId != shopId || n.readAt != null) continue;
      _items[i] = AppNotificationSummary(
        internalId: n.internalId,
        shopId: n.shopId,
        title: n.title,
        body: n.body,
        createdAt: n.createdAt,
        readAt: now,
        relatedOrderInternalId: n.relatedOrderInternalId,
      );
      changed = true;
    }
    if (changed) _emit();
  }
}
