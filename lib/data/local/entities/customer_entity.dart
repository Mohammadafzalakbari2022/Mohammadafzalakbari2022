import 'package:isar/isar.dart';

part 'customer_entity.g.dart';

@collection
class CustomerEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String internalId;

  @Index()
  late String shopId;

  late String name;

  String? phone;

  String? address;

  String? notes;

  @Index()
  late DateTime createdAt;

  DateTime? deletedAt;
}
