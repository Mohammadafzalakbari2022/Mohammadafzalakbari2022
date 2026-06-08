import 'entities/garment_type.dart';
import 'entities/order_status.dart';
import 'order_customer_history.dart';
import 'order_item_summary.dart';

/// Row for orders list (plan-12).
class OrderSummary {
  const OrderSummary({
    required this.shopId,
    required this.internalId,
    required this.displayOrderNo,
    required this.customerInternalId,
    required this.customerName,
    this.customerPhone,
    this.customerChangeHistory = const [],
    this.measurementsSnapshot = '',
    this.internalNotes = '',
    this.sourceMeasurementProfileId,
    this.sourceMeasurementProfileLabel = '',
    this.styleName = '',
    this.styleNameInternalId,
    this.styleSelectionJson = '',
    this.styleSummary = '',
    this.catalogItemInternalId,
    this.catalogDesignNameSnapshot = '',
    this.catalogDesignerShopNameSnapshot = '',
    this.catalogImagePathSnapshot,
    this.catalogThumbnailPathSnapshot,
    this.fabricNameSnapshot = '',
    this.fabricColorSnapshot = '',
    this.fabricIdSnapshot = '',
    this.fabricNamePresetInternalId,
    this.fabricColorPresetInternalId,
    this.items = const [],
    required this.status,
    required this.deliveryDate,
    required this.createdAt,
    required this.updatedAt,
    required this.totalAmountMinor,
    required this.paidAmountMinor,
  });

  final String shopId;
  final String internalId;
  final String displayOrderNo;
  final String customerInternalId;
  final String customerName;
  final String? customerPhone;
  final List<OrderCustomerHistoryEntry> customerChangeHistory;
  final String measurementsSnapshot;
  final String internalNotes;
  final String? sourceMeasurementProfileId;
  final String sourceMeasurementProfileLabel;
  final String styleName;
  final String? styleNameInternalId;
  final String styleSelectionJson;
  final String styleSummary;
  final String? catalogItemInternalId;
  final String catalogDesignNameSnapshot;
  final String catalogDesignerShopNameSnapshot;
  final String? catalogImagePathSnapshot;
  final String? catalogThumbnailPathSnapshot;
  final String fabricNameSnapshot;
  final String fabricColorSnapshot;
  final String fabricIdSnapshot;
  final String? fabricNamePresetInternalId;
  final String? fabricColorPresetInternalId;

  /// Garment lines when persisted (Phase 2+). Empty for legacy flat orders today.
  final List<OrderItemSummary> items;

  final OrderLocalStatus status;

  bool get hasCustomerFabric =>
      fabricNameSnapshot.trim().isNotEmpty ||
      fabricColorSnapshot.trim().isNotEmpty ||
      fabricIdSnapshot.trim().isNotEmpty;
  final DateTime deliveryDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int totalAmountMinor;
  final int paidAmountMinor;

  int get remainingAmountMinor => totalAmountMinor - paidAmountMinor;

  bool get isUnpaid => remainingAmountMinor > 0;

  /// Items sorted for display (Perahan/Tunban before Waistcoat).
  List<OrderItemSummary> get sortedItems => OrderItemSummary.sorted(items);

  /// First item of [type] in [items], if any.
  OrderItemSummary? itemOf(GarmentType type) {
    for (final item in items) {
      if (item.garmentType == type) return item;
    }
    return null;
  }

  bool get hasPerahanTunban =>
      itemOf(GarmentType.perahanTunban) != null;

  bool get hasWaistcoat => itemOf(GarmentType.waistcoat) != null;

  /// Sum of [OrderItemSummary.priceAmountMinor] across [items].
  int get itemPriceTotalAmountMinor =>
      items.fold<int>(0, (sum, item) => sum + item.priceAmountMinor);

  bool get hasMultipleGarments => items.length > 1;

  /// Non-localized key for list/detail labels (l10n maps this in UI layer).
  String get garmentSummaryKey {
    if (items.isEmpty) return kGarmentTypePerahanTunbanApiKey;
    final types = sortedItems.map((i) => i.garmentType.apiKey).toList();
    return types.join('+');
  }

  /// Read-only view of legacy flat garment fields as one Perahan/Tunban item.
  ///
  /// Does not mutate storage; existing UI continues to use flat fields until
  /// Phase 2+ migration and repository wiring.
  OrderItemSummary? legacyPerahanTunbanItemView() {
    if (!_hasLegacyFlatGarmentData) return null;
    return OrderItemSummary(
      internalId: '',
      orderInternalId: internalId,
      garmentType: GarmentType.perahanTunban,
      sortOrder: GarmentType.perahanTunban.defaultSortOrder,
      priceAmountMinor: totalAmountMinor,
      measurementsSnapshot: measurementsSnapshot,
      sourceMeasurementProfileId: sourceMeasurementProfileId,
      sourceMeasurementProfileLabel: sourceMeasurementProfileLabel,
      styleName: styleName,
      styleNameInternalId: styleNameInternalId,
      styleSelectionJson: styleSelectionJson,
      styleSummary: styleSummary,
      catalogItemInternalId: catalogItemInternalId,
      catalogDesignNameSnapshot: catalogDesignNameSnapshot,
      catalogDesignerShopNameSnapshot: catalogDesignerShopNameSnapshot,
      catalogImagePathSnapshot: catalogImagePathSnapshot,
      catalogThumbnailPathSnapshot: catalogThumbnailPathSnapshot,
      fabricNameSnapshot: fabricNameSnapshot,
      fabricColorSnapshot: fabricColorSnapshot,
      fabricIdSnapshot: fabricIdSnapshot,
      fabricNamePresetInternalId: fabricNamePresetInternalId,
      fabricColorPresetInternalId: fabricColorPresetInternalId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  bool get _hasLegacyFlatGarmentData =>
      measurementsSnapshot.trim().isNotEmpty ||
      styleName.trim().isNotEmpty ||
      styleSelectionJson.trim().isNotEmpty ||
      styleSummary.trim().isNotEmpty ||
      catalogDesignNameSnapshot.trim().isNotEmpty ||
      hasCustomerFabric;
}
