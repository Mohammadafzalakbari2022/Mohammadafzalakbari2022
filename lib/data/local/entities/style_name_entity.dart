import 'package:isar/isar.dart';

part 'style_name_entity.g.dart';

@collection
class StyleNameEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String internalId;

  @Index()
  late String shopId;

  /// [GarmentType] code (`0` = Perahan/Tunban, `1` = Waistcoat).
  @Index()
  int garmentTypeIndex = 0;

  late String name;

  @Index()
  late int sortOrder;

  @Index()
  late bool isActive;

  late DateTime createdAt;

  late DateTime updatedAt;

  DateTime? deletedAt;
}
