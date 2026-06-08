import 'entities/garment_type.dart';
import 'entities/order_status.dart';
import 'order_item_input.dart';
import 'order_item_summary.dart';
import 'order_summary.dart';
import 'sync_pull_payload.dart';

/// Builds sync `data` map for an order upsert with dual-write flat + `items[]`.
Map<String, dynamic> buildOrderSyncPayloadData({
  required OrderSummary order,
  required List<OrderItemSummary> items,
  Map<String, dynamic> extra = const {},
}) {
  final primary = primaryPerahanItemSummary(items);
  final flatSource = primary != null
      ? _flatFromItemSummary(primary)
      : _flatFromOrderSummary(order);

  final payload = <String, dynamic>{
    'customer_internal_id': order.customerInternalId,
    'delivery_date': order.deliveryDate.toUtc().toIso8601String(),
    'total_amount_minor': order.totalAmountMinor,
    'measurements_snapshot': flatSource.measurementsSnapshot,
    if (flatSource.sourceMeasurementProfileId != null &&
        flatSource.sourceMeasurementProfileId!.trim().isNotEmpty)
      'source_measurement_profile_id': flatSource.sourceMeasurementProfileId,
    'source_measurement_profile_label':
        flatSource.sourceMeasurementProfileLabel,
    'style_name': flatSource.styleName,
    if (flatSource.styleNameInternalId != null &&
        flatSource.styleNameInternalId!.trim().isNotEmpty)
      'style_name_internal_id': flatSource.styleNameInternalId,
    if (flatSource.styleSelectionJson.trim().isNotEmpty)
      'style_selection_json': flatSource.styleSelectionJson,
    if (flatSource.styleSummary.trim().isNotEmpty)
      'style_summary': flatSource.styleSummary,
    if (flatSource.catalogItemInternalId != null)
      'catalog_item_internal_id': flatSource.catalogItemInternalId,
    if (flatSource.catalogDesignNameSnapshot.trim().isNotEmpty)
      'catalog_design_name_snapshot': flatSource.catalogDesignNameSnapshot,
    if (flatSource.catalogDesignerShopNameSnapshot.trim().isNotEmpty)
      'catalog_designer_shop_name_snapshot':
          flatSource.catalogDesignerShopNameSnapshot,
    if (flatSource.fabricNameSnapshot.trim().isNotEmpty)
      'fabric_name': flatSource.fabricNameSnapshot,
    if (flatSource.fabricColorSnapshot.trim().isNotEmpty)
      'fabric_color': flatSource.fabricColorSnapshot,
    if (flatSource.fabricIdSnapshot.trim().isNotEmpty)
      'fabric_id': flatSource.fabricIdSnapshot,
    if (flatSource.fabricNamePresetInternalId != null &&
        flatSource.fabricNamePresetInternalId!.trim().isNotEmpty)
      'fabric_name_preset_internal_id': flatSource.fabricNamePresetInternalId,
    if (flatSource.fabricColorPresetInternalId != null &&
        flatSource.fabricColorPresetInternalId!.trim().isNotEmpty)
      'fabric_color_preset_internal_id': flatSource.fabricColorPresetInternalId,
    if (order.customerName.trim().isNotEmpty)
      'customer_snapshot_name': order.customerName.trim(),
    if (order.customerPhone != null && order.customerPhone!.trim().isNotEmpty)
      'customer_snapshot_phone': order.customerPhone!.trim(),
    if (order.internalNotes.trim().isNotEmpty)
      'internal_notes': order.internalNotes.trim(),
    'status_index': order.status.code,
    'display_order_no': order.displayOrderNo,
    'updated_at': order.updatedAt.toUtc().toIso8601String(),
    'created_at': order.createdAt.toUtc().toIso8601String(),
    ...extra,
  };

  if (items.isNotEmpty) {
    payload['items'] = items.map(orderItemSummaryToSyncMap).toList();
  }

  return payload;
}

Map<String, dynamic> orderItemSummaryToSyncMap(OrderItemSummary item) {
  return {
    'internal_id': item.internalId,
    'garment_type': item.garmentType.apiKey,
    'sort_order': item.sortOrder,
    'price_amount_minor': item.priceAmountMinor,
    if (item.itemNotes.trim().isNotEmpty) 'item_notes': item.itemNotes.trim(),
    if (item.measurementsSnapshot.trim().isNotEmpty)
      'measurements_snapshot': item.measurementsSnapshot.trim(),
    if (item.sourceMeasurementProfileId != null &&
        item.sourceMeasurementProfileId!.trim().isNotEmpty)
      'source_measurement_profile_id': item.sourceMeasurementProfileId!.trim(),
    if (item.sourceMeasurementProfileLabel.trim().isNotEmpty)
      'source_measurement_profile_label':
          item.sourceMeasurementProfileLabel.trim(),
    if (item.styleName.trim().isNotEmpty) 'style_name': item.styleName.trim(),
    if (item.styleNameInternalId != null &&
        item.styleNameInternalId!.trim().isNotEmpty)
      'style_name_internal_id': item.styleNameInternalId!.trim(),
    if (item.styleSelectionJson.trim().isNotEmpty)
      'style_selection_json': item.styleSelectionJson,
    if (item.styleSummary.trim().isNotEmpty)
      'style_summary': item.styleSummary.trim(),
    if (item.catalogItemInternalId != null)
      'catalog_item_internal_id': item.catalogItemInternalId,
    if (item.catalogDesignNameSnapshot.trim().isNotEmpty)
      'catalog_design_name_snapshot': item.catalogDesignNameSnapshot.trim(),
    if (item.catalogDesignerShopNameSnapshot.trim().isNotEmpty)
      'catalog_designer_shop_name_snapshot':
          item.catalogDesignerShopNameSnapshot.trim(),
    if (item.fabricNameSnapshot.trim().isNotEmpty)
      'fabric_name': item.fabricNameSnapshot.trim(),
    if (item.fabricColorSnapshot.trim().isNotEmpty)
      'fabric_color': item.fabricColorSnapshot.trim(),
    if (item.fabricIdSnapshot.trim().isNotEmpty)
      'fabric_id': item.fabricIdSnapshot.trim(),
    if (item.fabricNamePresetInternalId != null &&
        item.fabricNamePresetInternalId!.trim().isNotEmpty)
      'fabric_name_preset_internal_id': item.fabricNamePresetInternalId!.trim(),
    if (item.fabricColorPresetInternalId != null &&
        item.fabricColorPresetInternalId!.trim().isNotEmpty)
      'fabric_color_preset_internal_id':
          item.fabricColorPresetInternalId!.trim(),
  };
}

List<Map<String, dynamic>>? parseOrderItemsFromSyncData(Object? data) {
  final m = syncPullDataMap(data);
  final raw = m['items'];
  if (raw is! List) return null;
  final out = <Map<String, dynamic>>[];
  for (final entry in raw) {
    if (entry is Map) {
      out.add(Map<String, dynamic>.from(entry));
    }
  }
  return out.isEmpty ? null : out;
}

OrderItemCreateInput orderItemCreateInputFromSyncMap(
  Map<String, dynamic> m, {
  String? fallbackInternalId,
}) {
  final garmentRaw = syncPullString(m, const ['garment_type', 'garmentType']);
  final garmentType = garmentTypeFromApiKey(garmentRaw);
  return OrderItemCreateInput(
    internalId: syncPullString(m, const ['internal_id', 'internalId']) ??
        fallbackInternalId,
    garmentType: garmentType,
    priceAmountMinor: syncPullInt(
          m,
          const ['price_amount_minor', 'priceAmountMinor'],
        ) ??
        0,
    sortOrder: syncPullInt(m, const ['sort_order', 'sortOrder']),
    itemNotes: syncPullString(m, const ['item_notes', 'itemNotes']) ?? '',
    measurementsSnapshot: syncPullString(
          m,
          const ['measurements_snapshot', 'measurementsSnapshot'],
        ) ??
        '',
    sourceMeasurementProfileId: syncPullString(
      m,
      const ['source_measurement_profile_id', 'sourceMeasurementProfileId'],
    ),
    sourceMeasurementProfileLabel: syncPullString(
          m,
          const [
            'source_measurement_profile_label',
            'sourceMeasurementProfileLabel',
          ],
        ) ??
        '',
    styleName: syncPullString(m, const ['style_name', 'styleName']) ?? '',
    styleNameInternalId: syncPullString(
      m,
      const ['style_name_internal_id', 'styleNameInternalId'],
    ),
    styleSelectionJson: syncPullString(
          m,
          const ['style_selection_json', 'styleSelectionJson'],
        ) ??
        '',
    styleSummary: syncPullString(m, const ['style_summary', 'styleSummary']) ??
        '',
    catalogItemInternalId: syncPullString(
      m,
      const ['catalog_item_internal_id', 'catalogItemInternalId'],
    ),
    catalogDesignNameSnapshot: syncPullString(
          m,
          const [
            'catalog_design_name_snapshot',
            'catalogDesignNameSnapshot',
          ],
        ) ??
        '',
    catalogDesignerShopNameSnapshot: syncPullString(
          m,
          const [
            'catalog_designer_shop_name_snapshot',
            'catalogDesignerShopNameSnapshot',
          ],
        ) ??
        '',
    fabricNameSnapshot: syncPullString(
          m,
          const ['fabric_name', 'fabricName', 'fabric_name_snapshot'],
        ) ??
        '',
    fabricColorSnapshot: syncPullString(
          m,
          const ['fabric_color', 'fabricColor', 'fabric_color_snapshot'],
        ) ??
        '',
    fabricIdSnapshot: syncPullString(
          m,
          const ['fabric_id', 'fabricId', 'fabric_id_snapshot'],
        ) ??
        '',
    fabricNamePresetInternalId: syncPullString(
      m,
      const [
        'fabric_name_preset_internal_id',
        'fabricNamePresetInternalId',
      ],
    ),
    fabricColorPresetInternalId: syncPullString(
      m,
      const [
        'fabric_color_preset_internal_id',
        'fabricColorPresetInternalId',
      ],
    ),
  );
}

OrderItemCreateInput orderItemCreateInputFromLegacyFlatSummary({
  required OrderSummary order,
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
  String fabricNameSnapshot,
  String fabricColorSnapshot,
  String fabricIdSnapshot,
  String? fabricNamePresetInternalId,
  String? fabricColorPresetInternalId,
}) _flatFromItemSummary(OrderItemSummary item) {
  return (
    measurementsSnapshot: item.measurementsSnapshot,
    sourceMeasurementProfileId: item.sourceMeasurementProfileId,
    sourceMeasurementProfileLabel: item.sourceMeasurementProfileLabel,
    styleName: item.styleName,
    styleNameInternalId: item.styleNameInternalId,
    styleSelectionJson: item.styleSelectionJson,
    styleSummary: item.styleSummary,
    catalogItemInternalId: item.catalogItemInternalId,
    catalogDesignNameSnapshot: item.catalogDesignNameSnapshot,
    catalogDesignerShopNameSnapshot: item.catalogDesignerShopNameSnapshot,
    fabricNameSnapshot: item.fabricNameSnapshot,
    fabricColorSnapshot: item.fabricColorSnapshot,
    fabricIdSnapshot: item.fabricIdSnapshot,
    fabricNamePresetInternalId: item.fabricNamePresetInternalId,
    fabricColorPresetInternalId: item.fabricColorPresetInternalId,
  );
}

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
  String fabricNameSnapshot,
  String fabricColorSnapshot,
  String fabricIdSnapshot,
  String? fabricNamePresetInternalId,
  String? fabricColorPresetInternalId,
}) _flatFromOrderSummary(OrderSummary order) {
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
    fabricNameSnapshot: order.fabricNameSnapshot,
    fabricColorSnapshot: order.fabricColorSnapshot,
    fabricIdSnapshot: order.fabricIdSnapshot,
    fabricNamePresetInternalId: order.fabricNamePresetInternalId,
    fabricColorPresetInternalId: order.fabricColorPresetInternalId,
  );
}

Map<String, dynamic> orderItemCreateInputToSyncMap(OrderItemCreateInput item) {
  return {
    'garment_type': item.garmentType.apiKey,
    'sort_order': item.sortOrder ?? item.garmentType.defaultSortOrder,
    'price_amount_minor': item.priceAmountMinor,
    if (item.itemNotes.trim().isNotEmpty) 'item_notes': item.itemNotes.trim(),
    if (item.measurementsSnapshot.trim().isNotEmpty)
      'measurements_snapshot': item.measurementsSnapshot.trim(),
    if (item.sourceMeasurementProfileId != null &&
        item.sourceMeasurementProfileId!.trim().isNotEmpty)
      'source_measurement_profile_id': item.sourceMeasurementProfileId!.trim(),
    if (item.sourceMeasurementProfileLabel.trim().isNotEmpty)
      'source_measurement_profile_label':
          item.sourceMeasurementProfileLabel.trim(),
    if (item.styleName.trim().isNotEmpty) 'style_name': item.styleName.trim(),
    if (item.styleNameInternalId != null &&
        item.styleNameInternalId!.trim().isNotEmpty)
      'style_name_internal_id': item.styleNameInternalId!.trim(),
    if (item.styleSelectionJson.trim().isNotEmpty)
      'style_selection_json': item.styleSelectionJson,
    if (item.styleSummary.trim().isNotEmpty)
      'style_summary': item.styleSummary.trim(),
    if (item.catalogItemInternalId != null)
      'catalog_item_internal_id': item.catalogItemInternalId,
    if (item.catalogDesignNameSnapshot.trim().isNotEmpty)
      'catalog_design_name_snapshot': item.catalogDesignNameSnapshot.trim(),
    if (item.catalogDesignerShopNameSnapshot.trim().isNotEmpty)
      'catalog_designer_shop_name_snapshot':
          item.catalogDesignerShopNameSnapshot.trim(),
    if (item.fabricNameSnapshot.trim().isNotEmpty)
      'fabric_name': item.fabricNameSnapshot.trim(),
    if (item.fabricColorSnapshot.trim().isNotEmpty)
      'fabric_color': item.fabricColorSnapshot.trim(),
    if (item.fabricIdSnapshot.trim().isNotEmpty)
      'fabric_id': item.fabricIdSnapshot.trim(),
    if (item.fabricNamePresetInternalId != null &&
        item.fabricNamePresetInternalId!.trim().isNotEmpty)
      'fabric_name_preset_internal_id': item.fabricNamePresetInternalId!.trim(),
    if (item.fabricColorPresetInternalId != null &&
        item.fabricColorPresetInternalId!.trim().isNotEmpty)
      'fabric_color_preset_internal_id':
          item.fabricColorPresetInternalId!.trim(),
  };
}

/// Dual-write payload for a newly created order (composer save).
Map<String, dynamic> buildNewOrderCreateSyncPayload({
  required String customerInternalId,
  required DateTime deliveryDate,
  required int totalAmountMinor,
  required int initialPaidMinor,
  required List<OrderItemCreateInput> items,
  String? customerSnapshotName,
  String? customerSnapshotPhone,
}) {
  final primary = items
          .where((i) => i.garmentType == GarmentType.perahanTunban)
          .firstOrNull ??
      (items.isNotEmpty ? items.first : null);

  final payload = <String, dynamic>{
    'customer_internal_id': customerInternalId,
    'delivery_date': deliveryDate.toUtc().toIso8601String(),
    'total_amount_minor': totalAmountMinor,
    'initial_paid_minor': initialPaidMinor,
    if (customerSnapshotName != null && customerSnapshotName.trim().isNotEmpty)
      'customer_snapshot_name': customerSnapshotName.trim(),
    if (customerSnapshotPhone != null &&
        customerSnapshotPhone.trim().isNotEmpty)
      'customer_snapshot_phone': customerSnapshotPhone.trim(),
    if (items.isNotEmpty)
      'items': items.map(orderItemCreateInputToSyncMap).toList(),
  };

  if (primary != null) {
    payload.addAll({
      'measurements_snapshot': primary.measurementsSnapshot,
      if (primary.sourceMeasurementProfileId != null &&
          primary.sourceMeasurementProfileId!.trim().isNotEmpty)
        'source_measurement_profile_id': primary.sourceMeasurementProfileId,
      'source_measurement_profile_label':
          primary.sourceMeasurementProfileLabel,
      'style_name': primary.styleName.trim(),
      if (primary.styleNameInternalId != null &&
          primary.styleNameInternalId!.trim().isNotEmpty)
        'style_name_internal_id': primary.styleNameInternalId!.trim(),
      if (primary.styleSelectionJson.trim().isNotEmpty)
        'style_selection_json': primary.styleSelectionJson,
      if (primary.styleSummary.trim().isNotEmpty)
        'style_summary': primary.styleSummary.trim(),
      if (primary.catalogItemInternalId != null)
        'catalog_item_internal_id': primary.catalogItemInternalId,
      if (primary.catalogDesignNameSnapshot.trim().isNotEmpty)
        'catalog_design_name_snapshot': primary.catalogDesignNameSnapshot.trim(),
      if (primary.catalogDesignerShopNameSnapshot.trim().isNotEmpty)
        'catalog_designer_shop_name_snapshot':
            primary.catalogDesignerShopNameSnapshot.trim(),
      if (primary.fabricNameSnapshot.trim().isNotEmpty)
        'fabric_name': primary.fabricNameSnapshot.trim(),
      if (primary.fabricColorSnapshot.trim().isNotEmpty)
        'fabric_color': primary.fabricColorSnapshot.trim(),
      if (primary.fabricIdSnapshot.trim().isNotEmpty)
        'fabric_id': primary.fabricIdSnapshot.trim(),
      if (primary.fabricNamePresetInternalId != null &&
          primary.fabricNamePresetInternalId!.trim().isNotEmpty)
        'fabric_name_preset_internal_id':
            primary.fabricNamePresetInternalId!.trim(),
      if (primary.fabricColorPresetInternalId != null &&
          primary.fabricColorPresetInternalId!.trim().isNotEmpty)
        'fabric_color_preset_internal_id':
            primary.fabricColorPresetInternalId!.trim(),
    });
  }

  return payload;
}
