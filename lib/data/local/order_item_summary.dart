import 'entities/garment_type.dart';

/// Read model for one garment line on an order (pure Dart; Isar entity in Phase 2).
class OrderItemSummary {
  const OrderItemSummary({
    required this.internalId,
    required this.orderInternalId,
    required this.garmentType,
    this.sortOrder = 0,
    this.priceAmountMinor = 0,
    this.itemNotes = '',
    this.measurementsSnapshot = '',
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
    required this.createdAt,
    required this.updatedAt,
  });

  final String internalId;
  final String orderInternalId;
  final GarmentType garmentType;
  final int sortOrder;
  final int priceAmountMinor;
  final String itemNotes;
  final String measurementsSnapshot;
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
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isPerahanTunban => garmentType == GarmentType.perahanTunban;

  bool get isWaistcoat => garmentType == GarmentType.waistcoat;

  bool get hasPrice => priceAmountMinor > 0;

  bool get hasStyle =>
      styleName.trim().isNotEmpty ||
      styleSelectionJson.trim().isNotEmpty ||
      styleSummary.trim().isNotEmpty;

  bool get hasFabric =>
      fabricNameSnapshot.trim().isNotEmpty ||
      fabricColorSnapshot.trim().isNotEmpty ||
      fabricIdSnapshot.trim().isNotEmpty;

  bool get hasCatalogDesign => catalogDesignNameSnapshot.trim().isNotEmpty;

  OrderItemSummary copyWith({
    String? internalId,
    String? orderInternalId,
    GarmentType? garmentType,
    int? sortOrder,
    int? priceAmountMinor,
    String? itemNotes,
    String? measurementsSnapshot,
    String? sourceMeasurementProfileId,
    String? sourceMeasurementProfileLabel,
    String? styleName,
    String? styleNameInternalId,
    String? styleSelectionJson,
    String? styleSummary,
    String? catalogItemInternalId,
    String? catalogDesignNameSnapshot,
    String? catalogDesignerShopNameSnapshot,
    String? catalogImagePathSnapshot,
    String? catalogThumbnailPathSnapshot,
    String? fabricNameSnapshot,
    String? fabricColorSnapshot,
    String? fabricIdSnapshot,
    String? fabricNamePresetInternalId,
    String? fabricColorPresetInternalId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OrderItemSummary(
      internalId: internalId ?? this.internalId,
      orderInternalId: orderInternalId ?? this.orderInternalId,
      garmentType: garmentType ?? this.garmentType,
      sortOrder: sortOrder ?? this.sortOrder,
      priceAmountMinor: priceAmountMinor ?? this.priceAmountMinor,
      itemNotes: itemNotes ?? this.itemNotes,
      measurementsSnapshot: measurementsSnapshot ?? this.measurementsSnapshot,
      sourceMeasurementProfileId:
          sourceMeasurementProfileId ?? this.sourceMeasurementProfileId,
      sourceMeasurementProfileLabel: sourceMeasurementProfileLabel ??
          this.sourceMeasurementProfileLabel,
      styleName: styleName ?? this.styleName,
      styleNameInternalId: styleNameInternalId ?? this.styleNameInternalId,
      styleSelectionJson: styleSelectionJson ?? this.styleSelectionJson,
      styleSummary: styleSummary ?? this.styleSummary,
      catalogItemInternalId:
          catalogItemInternalId ?? this.catalogItemInternalId,
      catalogDesignNameSnapshot:
          catalogDesignNameSnapshot ?? this.catalogDesignNameSnapshot,
      catalogDesignerShopNameSnapshot: catalogDesignerShopNameSnapshot ??
          this.catalogDesignerShopNameSnapshot,
      catalogImagePathSnapshot:
          catalogImagePathSnapshot ?? this.catalogImagePathSnapshot,
      catalogThumbnailPathSnapshot:
          catalogThumbnailPathSnapshot ?? this.catalogThumbnailPathSnapshot,
      fabricNameSnapshot: fabricNameSnapshot ?? this.fabricNameSnapshot,
      fabricColorSnapshot: fabricColorSnapshot ?? this.fabricColorSnapshot,
      fabricIdSnapshot: fabricIdSnapshot ?? this.fabricIdSnapshot,
      fabricNamePresetInternalId:
          fabricNamePresetInternalId ?? this.fabricNamePresetInternalId,
      fabricColorPresetInternalId:
          fabricColorPresetInternalId ?? this.fabricColorPresetInternalId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Stable sort: [sortOrder] first, then garment type default order.
  static int compareByDisplayOrder(OrderItemSummary a, OrderItemSummary b) {
    final bySort = a.sortOrder.compareTo(b.sortOrder);
    if (bySort != 0) return bySort;
    return compareGarmentTypeSortOrder(a.garmentType, b.garmentType);
  }

  static List<OrderItemSummary> sorted(List<OrderItemSummary> items) {
    final copy = List<OrderItemSummary>.from(items);
    copy.sort(compareByDisplayOrder);
    return copy;
  }
}
