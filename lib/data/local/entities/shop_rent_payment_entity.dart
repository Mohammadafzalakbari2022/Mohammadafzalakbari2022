import 'package:isar/isar.dart';

part 'shop_rent_payment_entity.g.dart';

@collection
class ShopRentPaymentEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String internalId;

  @Index()
  late String shopId;

  @Index()
  late String rentInternalId;

  late int amountMinor;

  late DateTime paidAt;

  String note = '';

  @Index()
  late DateTime createdAt;
}
