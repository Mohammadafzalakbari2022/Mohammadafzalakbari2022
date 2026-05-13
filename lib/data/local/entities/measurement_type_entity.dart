import 'package:isar/isar.dart';

part 'measurement_type_entity.g.dart';

/// Shop-defined measurement field (plan-02: measurement_types).
@collection
class MeasurementTypeEntity {
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
