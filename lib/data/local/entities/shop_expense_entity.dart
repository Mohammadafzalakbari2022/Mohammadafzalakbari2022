import 'package:isar/isar.dart';

part 'shop_expense_entity.g.dart';

/// 0 = daily, 1 = food/drinks, 2 = other
@collection
class ShopExpenseEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String internalId;

  @Index()
  late String shopId;

  @Index()
  late int category;

  late int amountMinor;

  @Index()
  late DateTime expenseDate;

  String note = '';

  @Index()
  late DateTime createdAt;

  @Index()
  late DateTime updatedAt;

  DateTime? deletedAt;
}
