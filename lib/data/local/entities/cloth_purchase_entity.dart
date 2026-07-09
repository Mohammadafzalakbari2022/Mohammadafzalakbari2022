import 'package:isar/isar.dart';

part 'cloth_purchase_entity.g.dart';

@collection
class ClothPurchaseEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String internalId;

  @Index()
  late String shopId;

  @Index()
  late String supplierInternalId;

  /// Date-only purchase date (local midnight).
  @Index()
  late DateTime purchaseDate;

  /// Sum of line totals in minor currency units.
  late int totalAmountMinor;

  String note = '';

  @Index()
  late DateTime createdAt;

  @Index()
  late DateTime updatedAt;

  DateTime? deletedAt;
}
