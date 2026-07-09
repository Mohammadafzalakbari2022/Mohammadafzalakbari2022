import 'package:isar/isar.dart';

part 'cloth_stock_movement_entity.g.dart';

/// Append-only stock movement row (purchase, sale, void, adjustment).
@collection
class ClothStockMovementEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String internalId;

  @Index()
  late String shopId;

  @Index()
  late String skuInternalId;

  /// [ClothStockMovementType] code.
  @Index()
  late int movementTypeIndex;

  /// Signed quantity delta in milli-meters (negative = out, positive = in).
  late int qtyMilliDelta;

  String? orderItemInternalId;

  String? purchaseLineInternalId;

  String note = '';

  @Index()
  late DateTime createdAt;
}
