import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

import 'app_notification_repository.dart';
import 'app_notification_summary.dart';
import 'dev_shop_constants.dart';
import 'entities/app_notification_entity.dart';

class IsarAppNotificationRepository implements AppNotificationRepository {
  IsarAppNotificationRepository(this._isar);

  final Isar _isar;
  final _uuid = const Uuid();

  AppNotificationSummary _map(AppNotificationEntity e) {
    return AppNotificationSummary(
      internalId: e.internalId,
      shopId: e.shopId,
      title: e.title,
      body: e.body,
      createdAt: e.createdAt,
      readAt: e.readAt,
      relatedOrderInternalId: e.relatedOrderInternalId,
    );
  }

  @override
  Future<void> ensureWelcomeSeed({
    required String title,
    required String body,
  }) async {
    await _isar.writeTxn(() async {
      final existing =
          await _isar.appNotificationEntitys.getByInternalId('notif-seed-welcome');
      if (existing != null) return;
      final e = AppNotificationEntity()
        ..internalId = 'notif-seed-welcome'
        ..shopId = kDevShopId
        ..title = title
        ..body = body
        ..createdAt = DateTime.now()
        ..readAt = null
        ..relatedOrderInternalId = null;
      await _isar.appNotificationEntitys.putByInternalId(e);
    });
  }

  @override
  Stream<List<AppNotificationSummary>> watchNotifications(
      [String shopId = kDevShopId]) {
    return _isar.appNotificationEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .sortByCreatedAtDesc()
        .watch(fireImmediately: true)
        .map((rows) => rows.map(_map).toList());
  }

  @override
  Future<void> append({
    required String shopId,
    required String title,
    required String body,
    String? relatedOrderInternalId,
  }) async {
    final e = AppNotificationEntity()
      ..internalId = _uuid.v4()
      ..shopId = shopId
      ..title = title
      ..body = body
      ..createdAt = DateTime.now()
      ..readAt = null
      ..relatedOrderInternalId = relatedOrderInternalId;

    await _isar.writeTxn(() async {
      await _isar.appNotificationEntitys.putByInternalId(e);
    });
  }

  @override
  Future<void> markRead(String internalId) async {
    await _isar.writeTxn(() async {
      final e =
          await _isar.appNotificationEntitys.getByInternalId(internalId);
      if (e == null) return;
      if (e.readAt != null) return;
      e.readAt = DateTime.now();
      await _isar.appNotificationEntitys.putByInternalId(e);
    });
  }

  @override
  Future<void> markAllRead(String shopId) async {
    await _isar.writeTxn(() async {
      final list = await _isar.appNotificationEntitys
          .filter()
          .shopIdEqualTo(shopId)
          .readAtIsNull()
          .findAll();
      final now = DateTime.now();
      for (final e in list) {
        e.readAt = now;
        await _isar.appNotificationEntitys.putByInternalId(e);
      }
    });
  }
}
