import 'entities/garment_type.dart';
import 'entities/order_entity.dart';
import 'entities/order_item_entity.dart';
import 'order_item_input.dart';
import 'order_item_summary.dart';

int sumOrderItemPrices(Iterable<OrderItemEntity> items) =>
    items.fold<int>(0, (sum, item) => sum + item.priceAmountMinor);

OrderItemSummary orderItemSummaryFromEntity(OrderItemEntity e) {
  return OrderItemSummary(
    internalId: e.internalId,
    orderInternalId: e.orderInternalId,
    garmentType: garmentTypeFromCode(e.garmentTypeIndex),
    sortOrder: e.sortOrder,
    priceAmountMinor: e.priceAmountMinor,
    itemNotes: e.itemNotes,
    measurementsSnapshot: e.measurementsSnapshot,
    sourceMeasurementProfileId: e.sourceMeasurementProfileId,
    sourceMeasurementProfileLabel: e.sourceMeasurementProfileLabel,
    styleName: e.styleName,
    styleNameInternalId: e.styleNameInternalId,
    styleSelectionJson: e.styleSelectionJson,
    styleSummary: e.styleSummary,
    catalogItemInternalId: e.catalogItemInternalId,
    catalogDesignNameSnapshot: e.catalogDesignNameSnapshot,
    catalogDesignerShopNameSnapshot: e.catalogDesignerShopNameSnapshot,
    catalogImagePathSnapshot: e.catalogImagePathSnapshot,
    catalogThumbnailPathSnapshot: e.catalogThumbnailPathSnapshot,
    fabricNameSnapshot: e.fabricNameSnapshot,
    fabricColorSnapshot: e.fabricColorSnapshot,
    fabricIdSnapshot: e.fabricIdSnapshot,
    fabricNamePresetInternalId: e.fabricNamePresetInternalId,
    fabricColorPresetInternalId: e.fabricColorPresetInternalId,
    createdAt: e.createdAt,
    updatedAt: e.updatedAt,
  );
}

OrderItemEntity orderItemEntityFromOrderFlat({
  required String internalId,
  required String shopId,
  required String orderInternalId,
  required GarmentType garmentType,
  required OrderEntity order,
  int? priceAmountMinor,
  DateTime? now,
}) {
  final ts = now ?? DateTime.now();
  return OrderItemEntity()
    ..internalId = internalId
    ..shopId = shopId
    ..orderInternalId = orderInternalId
    ..garmentTypeIndex = garmentType.code
    ..sortOrder = garmentType.defaultSortOrder
    ..priceAmountMinor = priceAmountMinor ?? order.totalAmountMinor
    ..measurementsSnapshot = order.measurementsSnapshot
    ..sourceMeasurementProfileId = order.sourceMeasurementProfileId
    ..sourceMeasurementProfileLabel = order.sourceMeasurementProfileLabel
    ..styleName = order.styleName
    ..styleNameInternalId = order.styleNameInternalId
    ..styleSelectionJson = order.styleSelectionJson
    ..styleSummary = order.styleSummary
    ..catalogItemInternalId = order.catalogItemInternalId
    ..catalogDesignNameSnapshot = order.catalogDesignNameSnapshot
    ..catalogDesignerShopNameSnapshot = order.catalogDesignerShopNameSnapshot
    ..catalogImagePathSnapshot = order.catalogImagePathSnapshot
    ..catalogThumbnailPathSnapshot = order.catalogThumbnailPathSnapshot
    ..fabricNameSnapshot = order.fabricNameSnapshot
    ..fabricColorSnapshot = order.fabricColorSnapshot
    ..fabricIdSnapshot = order.fabricIdSnapshot
    ..fabricNamePresetInternalId = order.fabricNamePresetInternalId
    ..fabricColorPresetInternalId = order.fabricColorPresetInternalId
    ..createdAt = order.createdAt ?? ts
    ..updatedAt = order.updatedAt;
}

void copyOrderItemFieldsOntoOrderEntity(
  OrderEntity order,
  OrderItemEntity item,
) {
  order
    ..measurementsSnapshot = item.measurementsSnapshot
    ..sourceMeasurementProfileId = item.sourceMeasurementProfileId
    ..sourceMeasurementProfileLabel = item.sourceMeasurementProfileLabel
    ..styleName = item.styleName
    ..styleNameInternalId = item.styleNameInternalId
    ..styleSelectionJson = item.styleSelectionJson
    ..styleSummary = item.styleSummary
    ..catalogItemInternalId = item.catalogItemInternalId
    ..catalogDesignNameSnapshot = item.catalogDesignNameSnapshot
    ..catalogDesignerShopNameSnapshot = item.catalogDesignerShopNameSnapshot
    ..catalogImagePathSnapshot = item.catalogImagePathSnapshot
    ..catalogThumbnailPathSnapshot = item.catalogThumbnailPathSnapshot
    ..fabricNameSnapshot = item.fabricNameSnapshot
    ..fabricColorSnapshot = item.fabricColorSnapshot
    ..fabricIdSnapshot = item.fabricIdSnapshot
    ..fabricNamePresetInternalId = item.fabricNamePresetInternalId
    ..fabricColorPresetInternalId = item.fabricColorPresetInternalId;
}

/// Denormalized flat garment fields from items or legacy order entity row.
({
  String measurementsSnapshot,
  String? sourceMeasurementProfileId,
  String sourceMeasurementProfileLabel,
  String styleName,
  String? styleNameInternalId,
  String styleSelectionJson,
  String styleSummary,
  String? catalogItemInternalId,
  String catalogDesignNameSnapshot,
  String catalogDesignerShopNameSnapshot,
  String? catalogImagePathSnapshot,
  String? catalogThumbnailPathSnapshot,
  String fabricNameSnapshot,
  String fabricColorSnapshot,
  String fabricIdSnapshot,
  String? fabricNamePresetInternalId,
  String? fabricColorPresetInternalId,
}) flatGarmentFieldsForOrderEntity({
  required OrderEntity order,
  required List<OrderItemSummary> items,
}) {
  final primary = primaryPerahanItemSummary(items);
  if (primary != null) {
    return (
      measurementsSnapshot: primary.measurementsSnapshot,
      sourceMeasurementProfileId: primary.sourceMeasurementProfileId,
      sourceMeasurementProfileLabel: primary.sourceMeasurementProfileLabel,
      styleName: primary.styleName,
      styleNameInternalId: primary.styleNameInternalId,
      styleSelectionJson: primary.styleSelectionJson,
      styleSummary: primary.styleSummary,
      catalogItemInternalId: primary.catalogItemInternalId,
      catalogDesignNameSnapshot: primary.catalogDesignNameSnapshot,
      catalogDesignerShopNameSnapshot: primary.catalogDesignerShopNameSnapshot,
      catalogImagePathSnapshot: primary.catalogImagePathSnapshot,
      catalogThumbnailPathSnapshot: primary.catalogThumbnailPathSnapshot,
      fabricNameSnapshot: primary.fabricNameSnapshot,
      fabricColorSnapshot: primary.fabricColorSnapshot,
      fabricIdSnapshot: primary.fabricIdSnapshot,
      fabricNamePresetInternalId: primary.fabricNamePresetInternalId,
      fabricColorPresetInternalId: primary.fabricColorPresetInternalId,
    );
  }
  return (
    measurementsSnapshot: order.measurementsSnapshot,
    sourceMeasurementProfileId: order.sourceMeasurementProfileId,
    sourceMeasurementProfileLabel: order.sourceMeasurementProfileLabel,
    styleName: order.styleName,
    styleNameInternalId: order.styleNameInternalId,
    styleSelectionJson: order.styleSelectionJson,
    styleSummary: order.styleSummary,
    catalogItemInternalId: order.catalogItemInternalId,
    catalogDesignNameSnapshot: order.catalogDesignNameSnapshot,
    catalogDesignerShopNameSnapshot: order.catalogDesignerShopNameSnapshot,
    catalogImagePathSnapshot: order.catalogImagePathSnapshot,
    catalogThumbnailPathSnapshot: order.catalogThumbnailPathSnapshot,
    fabricNameSnapshot: order.fabricNameSnapshot,
    fabricColorSnapshot: order.fabricColorSnapshot,
    fabricIdSnapshot: order.fabricIdSnapshot,
    fabricNamePresetInternalId: order.fabricNamePresetInternalId,
    fabricColorPresetInternalId: order.fabricColorPresetInternalId,
  );
}

bool orderEntityHasLegacyGarmentData(OrderEntity order) =>
    order.measurementsSnapshot.trim().isNotEmpty ||
    order.styleName.trim().isNotEmpty ||
    order.styleSelectionJson.trim().isNotEmpty ||
    order.styleSummary.trim().isNotEmpty ||
    order.catalogDesignNameSnapshot.trim().isNotEmpty ||
    order.fabricNameSnapshot.trim().isNotEmpty ||
    order.fabricColorSnapshot.trim().isNotEmpty ||
    order.fabricIdSnapshot.trim().isNotEmpty;
