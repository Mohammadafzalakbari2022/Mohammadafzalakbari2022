import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

import 'entities/garment_type.dart';
import 'entities/order_entity.dart';
import 'entities/order_item_entity.dart';
import 'entities/order_measurement_snapshot_entity.dart';
import 'entities/order_style_snapshot_entity.dart';
import 'order_item_input.dart';

/// One-time migration: flat orders → [OrderItemEntity] rows (Phase 2).
abstract final class IsarOrderMigrationV4 {
  static const migrationLabel = 'order_items_v4';
  static const _uuid = Uuid();

  /// Idempotent: safe to call after Isar open and after seed.
  static Future<void> runIfNeeded({required Isar isar}) async {
    final orders = await isar.orderEntitys.filter().deletedAtIsNull().findAll();
    if (orders.isEmpty) return;

    await isar.writeTxn(() async {
      for (final order in orders) {
        await _migrateOrderInTxn(isar, order);
      }
    });
  }

  static Future<void> _migrateOrderInTxn(
    Isar isar,
    OrderEntity order,
  ) async {
    final existingItems = await isar.orderItemEntitys
        .filter()
        .orderInternalIdEqualTo(order.internalId)
        .and()
        .deletedAtIsNull()
        .findAll();

    OrderItemEntity perahanItem;
    if (existingItems.isEmpty) {
      final itemId = _uuid.v4();
      final now = DateTime.now();
      perahanItem = orderItemEntityFromOrderFlat(
        internalId: itemId,
        shopId: order.shopId,
        orderInternalId: order.internalId,
        garmentType: GarmentType.perahanTunban,
        order: order,
        priceAmountMinor: order.totalAmountMinor,
        now: now,
      );
      await isar.orderItemEntitys.putByInternalId(perahanItem);
    } else {
      perahanItem = _pickPerahanItem(existingItems);
    }

    await _backfillMeasurementSnapshots(isar, order.internalId, perahanItem);
    await _backfillStyleSnapshots(isar, order.internalId, perahanItem);

    final activeItems = await isar.orderItemEntitys
        .filter()
        .orderInternalIdEqualTo(order.internalId)
        .and()
        .deletedAtIsNull()
        .findAll();
    if (activeItems.isNotEmpty) {
      final sum = sumOrderItemPrices(activeItems);
      if (order.totalAmountMinor != sum) {
        order.totalAmountMinor = sum;
        await isar.orderEntitys.putByInternalId(order);
      }
    }
  }

  static OrderItemEntity _pickPerahanItem(List<OrderItemEntity> items) {
    for (final item in items) {
      if (item.garmentTypeIndex == GarmentType.perahanTunban.code) {
        return item;
      }
    }
    return items.first;
  }

  static Future<void> _backfillMeasurementSnapshots(
    Isar isar,
    String orderInternalId,
    OrderItemEntity perahanItem,
  ) async {
    final headers = await isar.orderMeasurementSnapshotEntitys
        .filter()
        .orderInternalIdEqualTo(orderInternalId)
        .findAll();
    for (final header in headers) {
      if (header.orderItemInternalId.trim().isEmpty) {
        header.orderItemInternalId = perahanItem.internalId;
        await isar.orderMeasurementSnapshotEntitys.putByInternalId(header);
      }
    }
  }

  static Future<void> _backfillStyleSnapshots(
    Isar isar,
    String orderInternalId,
    OrderItemEntity perahanItem,
  ) async {
    final headers = await isar.orderStyleSnapshotEntitys
        .filter()
        .orderInternalIdEqualTo(orderInternalId)
        .findAll();
    for (final header in headers) {
      if (header.orderItemInternalId.trim().isEmpty) {
        header.orderItemInternalId = perahanItem.internalId;
        await isar.orderStyleSnapshotEntitys.putByInternalId(header);
      }
    }
  }
}
