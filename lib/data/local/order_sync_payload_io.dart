import 'entities/garment_type.dart';
import 'entities/order_entity.dart';
import 'order_item_input.dart';
import 'order_item_summary.dart';
import 'order_sync_payload.dart';

OrderItemCreateInput orderItemCreateInputFromLegacyFlatOrder({
  required OrderEntity order,
  String? internalId,
}) {
  return OrderItemCreateInput(
    internalId: internalId,
    garmentType: GarmentType.perahanTunban,
    priceAmountMinor: order.totalAmountMinor,
    sortOrder: GarmentType.perahanTunban.defaultSortOrder,
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
