import 'package:isar/isar.dart';

part 'measurement_profile_item_entity.g.dart';

/// One value for a profile (plan-02: customer_measurement_profile_items).
@collection
class MeasurementProfileItemEntity {
  Id id = Isar.autoIncrement;

  @Index()
  late String profileInternalId;

  @Index()
  late String shopId;

  @Index()
  late String measurementTypeInternalId;

  late String value;

  /// [MeasurementUnitCodes]
  late int unitCode;

  DateTime? deletedAt;
}
