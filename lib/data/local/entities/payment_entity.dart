import 'package:isar/isar.dart';

part 'payment_entity.g.dart';

@collection
class PaymentEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String internalId;

  @Index()
  late String shopId;

  @Index()
  late String orderInternalId;

  /// Minor units (no decimals).
  @Index()
  late int amountMinor;

  /// e.g. cash/manual
  late String method;

  /// If true, this is a correction/reversal entry (still append-only).
  @Index()
  late bool isAdjustment;

  @Index()
  late DateTime createdAt;
}

