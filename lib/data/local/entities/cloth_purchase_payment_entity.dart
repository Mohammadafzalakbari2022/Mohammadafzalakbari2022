import 'package:isar/isar.dart';

part 'cloth_purchase_payment_entity.g.dart';

/// Append-only supplier payment row for a cloth purchase.
@collection
class ClothPurchasePaymentEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String internalId;

  @Index()
  late String shopId;

  @Index()
  late String purchaseInternalId;

  late int amountMinor;

  @Index()
  late DateTime paidAt;

  String note = '';

  @Index()
  late DateTime createdAt;
}
