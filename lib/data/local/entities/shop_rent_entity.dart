import 'package:isar/isar.dart';

part 'shop_rent_entity.g.dart';

@collection
class ShopRentEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String internalId;

  @Index()
  late String shopId;

  late int amountMinor;

  /// Date-only due date (local midnight).
  @Index()
  late DateTime dueDate;

  /// Months between due dates when renewed.
  late int periodMonths;

  @Index()
  late DateTime createdAt;

  @Index()
  late DateTime updatedAt;

  DateTime? deletedAt;
}
