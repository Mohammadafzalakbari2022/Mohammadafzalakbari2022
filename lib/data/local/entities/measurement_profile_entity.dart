import 'package:isar/isar.dart';

part 'measurement_profile_entity.g.dart';

/// Customer measurement profile (plan-02). Body is free-form until `measurement_types` ship.
@collection
class MeasurementProfileEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String internalId;

  @Index()
  late String shopId;

  @Index()
  late String customerInternalId;

  late String label;

  /// Extra notes (free-form). Stored as `body` in Isar for schema stability.
  late String body;

  /// [MeasurementUnitCodes]
  @Index()
  late int unitCode;

  @Index()
  late DateTime createdAt;

  @Index()
  late DateTime updatedAt;

  DateTime? deletedAt;
}
