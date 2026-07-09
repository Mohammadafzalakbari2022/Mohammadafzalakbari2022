import 'package:isar/isar.dart';

part 'order_item_entity.g.dart';

/// One garment line on an order (Perahan/Tunban or Waistcoat).
///
/// Uniqueness of `(orderInternalId, garmentTypeIndex)` is enforced in the
/// repository (Isar composite unique index is not used in this project).
@collection
class OrderItemEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String internalId;

  @Index()
  late String shopId;

  @Index()
  late String orderInternalId;

  /// [GarmentType] code (`0` = Perahan/Tunban, `1` = Waistcoat).
  @Index()
  late int garmentTypeIndex;

  @Index()
  late int sortOrder;

  late int priceAmountMinor;

  String itemNotes = '';

  String measurementsSnapshot = '';

  String? sourceMeasurementProfileId;

  String sourceMeasurementProfileLabel = '';

  String styleName = '';

  String? styleNameInternalId;

  String styleSelectionJson = '';

  String styleSummary = '';

  String? catalogItemInternalId;

  String catalogDesignNameSnapshot = '';

  String catalogDesignerShopNameSnapshot = '';

  String? catalogImagePathSnapshot;

  String? catalogThumbnailPathSnapshot;

  String fabricNameSnapshot = '';

  String fabricColorSnapshot = '';

  String fabricIdSnapshot = '';

  String? fabricNamePresetInternalId;

  String? fabricColorPresetInternalId;

  /// Customer cloth length (free text, e.g. `3.5` meters).
  String clothMetersSnapshot = '';

  /// Cloth/material cost in minor currency units (0 = unset).
  int clothPriceAmountMinor = 0;

  /// [ClothSource] code (0 = customer supplied, 1 = shop stock).
  int clothSourceIndex = 0;

  String? clothStockSkuInternalId;

  /// Manual COGS for shop-stock cloth sales (minor currency, 0 = unset).
  int clothSaleCostAmountMinor = 0;

  late DateTime createdAt;

  late DateTime updatedAt;

  DateTime? deletedAt;
}
