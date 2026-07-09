import 'package:isar/isar.dart';

part 'cloth_purchase_line_entity.g.dart';

@collection
class ClothPurchaseLineEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String internalId;

  @Index()
  late String shopId;

  @Index()
  late String purchaseInternalId;

  @Index()
  late String skuInternalId;

  /// Quantity purchased in milli-meters.
  late int qtyMilli;

  /// Unit cost per meter in minor currency.
  late int unitCostAmountMinor;

  /// Line total in minor currency.
  late int lineTotalMinor;

  @Index()
  late DateTime createdAt;
}
