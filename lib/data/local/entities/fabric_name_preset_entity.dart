import 'package:isar/isar.dart';

part 'fabric_name_preset_entity.g.dart';

@collection
class FabricNamePresetEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String internalId;

  @Index()
  late String shopId;

  late String name;

  @Index()
  late int sortOrder;

  @Index()
  late bool isActive;

  late DateTime createdAt;

  late DateTime updatedAt;

  DateTime? deletedAt;
}
