import 'package:isar/isar.dart';

part 'cloth_supplier_entity.g.dart';

@collection
class ClothSupplierEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String internalId;

  @Index()
  late String shopId;

  late String name;

  String phone = '';

  String notes = '';

  @Index()
  late DateTime createdAt;

  @Index()
  late DateTime updatedAt;

  DateTime? deletedAt;
}
