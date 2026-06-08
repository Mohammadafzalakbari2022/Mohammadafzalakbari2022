import 'entities/garment_type.dart';

/// In-memory composer state for one garment line (pure Dart; UI wiring in Phase 3).
class OrderItemDraft {
  const OrderItemDraft({
    required this.garmentType,
    this.included = false,
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
    this.catalogDesignName = '',
    this.catalogDesignerShopName = '',
    this.catalogImagePath,
    this.catalogThumbnailPath,
    this.fabricName = '',
    this.fabricColor = '',
    this.fabricId = '',
    this.fabricNamePresetInternalId,
    this.fabricColorPresetInternalId,
  });

  final GarmentType garmentType;
  final bool included;
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
  final String catalogDesignName;
  final String catalogDesignerShopName;
  final String? catalogImagePath;
  final String? catalogThumbnailPath;
  final String fabricName;
  final String fabricColor;
  final String fabricId;
  final String? fabricNamePresetInternalId;
  final String? fabricColorPresetInternalId;

  factory OrderItemDraft.empty(GarmentType type) =>
      OrderItemDraft(garmentType: type, included: type == GarmentType.perahanTunban);

  bool get hasRequiredPrice => priceAmountMinor > 0;

  bool get hasAnyContent =>
      measurementsSnapshot.trim().isNotEmpty ||
      styleName.trim().isNotEmpty ||
      styleSelectionJson.trim().isNotEmpty ||
      styleSummary.trim().isNotEmpty ||
      catalogDesignName.trim().isNotEmpty ||
      fabricName.trim().isNotEmpty ||
      fabricColor.trim().isNotEmpty ||
      fabricId.trim().isNotEmpty ||
      itemNotes.trim().isNotEmpty ||
      priceAmountMinor > 0;

  /// Minimal save readiness for Phase 3 validation (price only when included).
  bool get canSaveBasic => !included || hasRequiredPrice;

  OrderItemDraft copyWith({
    GarmentType? garmentType,
    bool? included,
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
    String? catalogDesignName,
    String? catalogDesignerShopName,
    String? catalogImagePath,
    String? catalogThumbnailPath,
    String? fabricName,
    String? fabricColor,
    String? fabricId,
    String? fabricNamePresetInternalId,
    String? fabricColorPresetInternalId,
  }) {
    return OrderItemDraft(
      garmentType: garmentType ?? this.garmentType,
      included: included ?? this.included,
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
      catalogDesignName: catalogDesignName ?? this.catalogDesignName,
      catalogDesignerShopName:
          catalogDesignerShopName ?? this.catalogDesignerShopName,
      catalogImagePath: catalogImagePath ?? this.catalogImagePath,
      catalogThumbnailPath: catalogThumbnailPath ?? this.catalogThumbnailPath,
      fabricName: fabricName ?? this.fabricName,
      fabricColor: fabricColor ?? this.fabricColor,
      fabricId: fabricId ?? this.fabricId,
      fabricNamePresetInternalId:
          fabricNamePresetInternalId ?? this.fabricNamePresetInternalId,
      fabricColorPresetInternalId:
          fabricColorPresetInternalId ?? this.fabricColorPresetInternalId,
    );
  }
}
