import 'package:isar/isar.dart';

import 'catalog/catalog_order_snapshot.dart';
import 'entities/garment_type.dart';
import 'entities/order_item_entity.dart';
import 'order_item_input.dart';
import 'order_measurement_snapshot_item_input.dart';
import 'style/order_style_snapshot_persist_io.dart';
import 'entities/order_measurement_snapshot_entity.dart';
import 'entities/order_measurement_snapshot_item_entity.dart';

Future<List<OrderItemEntity>> loadActiveOrderItems(
  Isar isar,
  String orderInternalId,
) async {
  final rows = await isar.orderItemEntitys
      .filter()
      .orderInternalIdEqualTo(orderInternalId)
      .and()
      .deletedAtIsNull()
      .findAll();
  rows.sort((a, b) {
    final bySort = a.sortOrder.compareTo(b.sortOrder);
    if (bySort != 0) return bySort;
    return a.garmentTypeIndex.compareTo(b.garmentTypeIndex);
  });
  return rows;
}

Future<OrderItemEntity?> findActiveOrderItemByGarmentType(
  Isar isar,
  String orderInternalId,
  int garmentTypeIndex,
) async {
  return isar.orderItemEntitys
      .filter()
      .orderInternalIdEqualTo(orderInternalId)
      .and()
      .garmentTypeIndexEqualTo(garmentTypeIndex)
      .and()
      .deletedAtIsNull()
      .findFirst();
}

OrderItemEntity buildOrderItemEntity({
  required String internalId,
  required String shopId,
  required String orderInternalId,
  required OrderItemCreateInput input,
  required DateTime now,
}) {
  return OrderItemEntity()
    ..internalId = internalId
    ..shopId = shopId
    ..orderInternalId = orderInternalId
    ..garmentTypeIndex = input.garmentType.code
    ..sortOrder = input.sortOrder ?? input.garmentType.defaultSortOrder
    ..priceAmountMinor = input.priceAmountMinor
    ..itemNotes = input.itemNotes.trim()
    ..measurementsSnapshot = input.measurementsSnapshot
    ..sourceMeasurementProfileId = input.sourceMeasurementProfileId
    ..sourceMeasurementProfileLabel = input.sourceMeasurementProfileLabel
    ..styleName = input.styleName.trim()
    ..styleNameInternalId = input.styleNameInternalId
    ..styleSelectionJson = input.styleSelectionJson
    ..styleSummary = input.styleSummary
    ..catalogItemInternalId = input.catalogItemInternalId
    ..catalogDesignNameSnapshot = input.catalogDesignNameSnapshot.trim()
    ..catalogDesignerShopNameSnapshot =
        input.catalogDesignerShopNameSnapshot.trim()
    ..catalogImagePathSnapshot = input.catalogImagePathSnapshot
    ..catalogThumbnailPathSnapshot = input.catalogThumbnailPathSnapshot
    ..fabricNameSnapshot = input.fabricNameSnapshot.trim()
    ..fabricColorSnapshot = input.fabricColorSnapshot.trim()
    ..fabricIdSnapshot = input.fabricIdSnapshot.trim()
    ..fabricNamePresetInternalId = input.fabricNamePresetInternalId
    ..fabricColorPresetInternalId = input.fabricColorPresetInternalId
    ..clothMetersSnapshot = input.clothMetersSnapshot.trim()
    ..clothPriceAmountMinor = input.clothPriceAmountMinor
    ..clothSourceIndex = input.clothSourceIndex
    ..clothStockSkuInternalId = input.clothStockSkuInternalId
    ..clothSaleCostAmountMinor = input.clothSaleCostAmountMinor
    ..createdAt = now
    ..updatedAt = now;
}

Future<void> resolveCatalogPathsForItemInput({
  required String orderInternalId,
  required OrderItemCreateInput input,
  required void Function(String? imagePath, String? thumbPath) apply,
}) async {
  if (input.catalogDesignNameSnapshot.trim().isNotEmpty &&
      input.catalogSourceImagePath != null &&
      input.catalogSourceImagePath!.isNotEmpty) {
    final copied = await copyCatalogPathsToOrderSnapshot(
      orderInternalId: orderInternalId,
      imagePath: input.catalogSourceImagePath!,
      thumbnailPath: input.catalogSourceThumbnailPath,
    );
    if (copied != null) {
      apply(copied.imagePath, copied.thumbnailPath);
    }
  }
}

Future<void> deleteMeasurementSnapshotsForItem(
  Isar isar,
  String orderItemInternalId,
) async {
  final headers = await isar.orderMeasurementSnapshotEntitys
      .filter()
      .orderItemInternalIdEqualTo(orderItemInternalId)
      .findAll();
  for (final h in headers) {
    await isar.orderMeasurementSnapshotItemEntitys
        .filter()
        .snapshotInternalIdEqualTo(h.internalId)
        .deleteAll();
  }
  await isar.orderMeasurementSnapshotEntitys
      .filter()
      .orderItemInternalIdEqualTo(orderItemInternalId)
      .deleteAll();
}

Future<void> insertMeasurementSnapshotForItemInTxn({
  required Isar isar,
  required String shopId,
  required String orderInternalId,
  required String orderItemInternalId,
  String? sourceMeasurementProfileId,
  required List<OrderMeasurementSnapshotItemInput> items,
  required String Function() newSnapshotInternalId,
}) async {
  if (items.isEmpty) return;
  final snapId = newSnapshotInternalId();
  final created = DateTime.now();
  final header = OrderMeasurementSnapshotEntity()
    ..internalId = snapId
    ..orderInternalId = orderInternalId
    ..orderItemInternalId = orderItemInternalId
    ..shopId = shopId
    ..sourceMeasurementProfileId = sourceMeasurementProfileId
    ..createdAt = created;
  await isar.orderMeasurementSnapshotEntitys.putByInternalId(header);
  final rows = <OrderMeasurementSnapshotItemEntity>[];
  for (final it in items) {
    rows.add(
      OrderMeasurementSnapshotItemEntity()
        ..snapshotInternalId = snapId
        ..shopId = shopId
        ..measurementTypeInternalId = it.measurementTypeInternalId
        ..typeNameSnapshot = it.typeName
        ..value = it.value
        ..unitCode = it.unitCode
        ..sortOrder = it.sortOrder,
    );
  }
  await isar.orderMeasurementSnapshotItemEntitys.putAll(rows);
}

Future<void> persistItemGarmentSnapshotsInTxn({
  required Isar isar,
  required String shopId,
  required String orderInternalId,
  required OrderItemEntity item,
  required OrderItemCreateInput input,
  required String Function() newSnapshotInternalId,
}) async {
  final snapItems = input.measurementSnapshotItems;
  if (snapItems != null) {
    await deleteMeasurementSnapshotsForItem(isar, item.internalId);
    if (snapItems.isNotEmpty) {
      await insertMeasurementSnapshotForItemInTxn(
        isar: isar,
        shopId: shopId,
        orderInternalId: orderInternalId,
        orderItemInternalId: item.internalId,
        sourceMeasurementProfileId: input.sourceMeasurementProfileId,
        items: snapItems,
        newSnapshotInternalId: newSnapshotInternalId,
      );
    }
  }

  final figures = await loadStyleFiguresForShop(isar, shopId);
  await persistOrderStyleSnapshotInTxn(
    isar: isar,
    shopId: shopId,
    orderInternalId: orderInternalId,
    orderItemInternalId: item.internalId,
    styleName: input.styleName,
    styleNameInternalId: input.styleNameInternalId,
    styleSelectionJson: input.styleSelectionJson,
    allFigures: figures,
    newSnapshotInternalId: newSnapshotInternalId,
  );
}

Future<OrderItemEntity> upsertOrderItemInTxn({
  required Isar isar,
  required String shopId,
  required String orderInternalId,
  required OrderItemCreateInput input,
  required String Function() newId,
  required String Function() newSnapshotInternalId,
}) async {
  final existing = await findActiveOrderItemByGarmentType(
    isar,
    orderInternalId,
    input.garmentType.code,
  );
  final now = DateTime.now();
  final itemId = existing?.internalId ?? input.internalId ?? newId();
  var entity = existing ??
      buildOrderItemEntity(
        internalId: itemId,
        shopId: shopId,
        orderInternalId: orderInternalId,
        input: input,
        now: now,
      );

  String? imagePath = input.catalogImagePathSnapshot;
  String? thumbPath = input.catalogThumbnailPathSnapshot;
  await resolveCatalogPathsForItemInput(
    orderInternalId: orderInternalId,
    input: input,
    apply: (img, thumb) {
      imagePath = img;
      thumbPath = thumb;
    },
  );

  entity
    ..priceAmountMinor = input.priceAmountMinor
    ..itemNotes = input.itemNotes.trim()
    ..measurementsSnapshot = input.measurementsSnapshot
    ..sourceMeasurementProfileId = input.sourceMeasurementProfileId
    ..sourceMeasurementProfileLabel = input.sourceMeasurementProfileLabel
    ..styleName = input.styleName.trim()
    ..styleNameInternalId = input.styleNameInternalId
    ..styleSelectionJson = input.styleSelectionJson
    ..styleSummary = input.styleSummary
    ..catalogItemInternalId = input.catalogItemInternalId
    ..catalogDesignNameSnapshot = input.catalogDesignNameSnapshot.trim()
    ..catalogDesignerShopNameSnapshot =
        input.catalogDesignerShopNameSnapshot.trim()
    ..catalogImagePathSnapshot = imagePath
    ..catalogThumbnailPathSnapshot = thumbPath
    ..fabricNameSnapshot = input.fabricNameSnapshot.trim()
    ..fabricColorSnapshot = input.fabricColorSnapshot.trim()
    ..fabricIdSnapshot = input.fabricIdSnapshot.trim()
    ..fabricNamePresetInternalId = input.fabricNamePresetInternalId
    ..fabricColorPresetInternalId = input.fabricColorPresetInternalId
    ..clothMetersSnapshot = input.clothMetersSnapshot.trim()
    ..clothPriceAmountMinor = input.clothPriceAmountMinor
    ..clothSourceIndex = input.clothSourceIndex
    ..clothStockSkuInternalId = input.clothStockSkuInternalId
    ..clothSaleCostAmountMinor = input.clothSaleCostAmountMinor
    ..sortOrder = input.sortOrder ?? input.garmentType.defaultSortOrder
    ..updatedAt = now;
  if (existing == null) {
    entity.createdAt = now;
  }

  await isar.orderItemEntitys.putByInternalId(entity);
  await persistItemGarmentSnapshotsInTxn(
    isar: isar,
    shopId: shopId,
    orderInternalId: orderInternalId,
    item: entity,
    input: input,
    newSnapshotInternalId: newSnapshotInternalId,
  );
  return entity;
}
