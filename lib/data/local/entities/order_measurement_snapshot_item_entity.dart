import 'package:isar/isar.dart';

part 'order_measurement_snapshot_item_entity.g.dart';

/// Frozen measurement values on an order (plan-02: order_measurement_snapshot_items).
@collection
class OrderMeasurementSnapshotItemEntity {
  Id id = Isar.autoIncrement;

  @Index()
  late String snapshotInternalId;

  @Index()
  late String shopId;

  @Index()
  late String measurementTypeInternalId;

  /// Label at order time (type rename later does not affect this order).
  late String typeNameSnapshot;

  late String value;

  /// [MeasurementUnitCodes]
  late int unitCode;

  @Index()
  late int sortOrder;
}
