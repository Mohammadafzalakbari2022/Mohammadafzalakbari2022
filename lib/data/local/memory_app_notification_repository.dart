import 'dart:async';

import 'package:pride_v3/core/feedback/notification_sound_bridge.dart';
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
    String? internalId,
  }) async {
    _items.add(
      AppNotificationSummary(
        internalId: internalId ?? _uuid.v4(),
        shopId: shopId,
        title: title,
        body: body,
        createdAt: DateTime.now(),
        readAt: null,
        relatedOrderInternalId: relatedOrderInternalId,
      ),
    );
    _emit();
    await NotificationSoundBridge.onNotificationInserted();
  }

  @override
  Future<void> mergeRemoteNotification({
    required String shopId,
    required String internalId,
    required String operation,
    Object? data,
  }) async {
    if (operation == 'delete') {
      _items.removeWhere((n) => n.internalId == internalId);
      _emit();
      return;
    }
    if (operation != 'upsert' || data is! Map) return;
    final m = Map<String, dynamic>.from(data);
    final title = m['title'];
    final body = m['body'];
    if (title is! String || body is! String) return;
    final rel = m['related_order_internal_id'];
    final createdRaw = m['created_at'];
    final createdAt = createdRaw is String
        ? (DateTime.tryParse(createdRaw) ?? DateTime.now())
        : DateTime.now();
    DateTime? readAt;
    final readRaw = m['read_at'];
    if (readRaw is String) readAt = DateTime.tryParse(readRaw);

    final idx = _items.indexWhere((n) => n.internalId == internalId);
    final row = AppNotificationSummary(
      internalId: internalId,
      shopId: shopId,
      title: title,
      body: body,
      createdAt: createdAt,
      readAt: readAt,
      relatedOrderInternalId:
          rel is String && rel.isNotEmpty ? rel : null,
    );
    final isNew = idx < 0;
    if (idx >= 0) {
      _items[idx] = row;
    } else {
      _items.add(row);
    }
    _emit();
    if (isNew) {
      await NotificationSoundBridge.onNotificationInserted();
    }
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
