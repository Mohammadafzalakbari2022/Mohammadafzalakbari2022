import 'package:isar/isar.dart';

part 'cloth_stock_sku_entity.g.dart';

/// Shop cloth inventory SKU (distinct from fabric name/color presets).
@collection
class ClothStockSkuEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String internalId;

  @Index()
  late String shopId;

  /// Human-readable SKU code (unique per shop in repository logic).
  late String skuCode;

  late String name;

  String color = '';

  String? fabricNamePresetInternalId;

  String? fabricColorPresetInternalId;

  /// Cached on-hand quantity in milli-meters (meters × 1000).
  late int qtyOnHandMilli;

  @Index()
  late DateTime createdAt;

  @Index()
  late DateTime updatedAt;

  DateTime? deletedAt;
}
