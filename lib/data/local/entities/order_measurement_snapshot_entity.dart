import 'package:isar/isar.dart';

part 'order_measurement_snapshot_entity.g.dart';

/// Header row: one snapshot per order (plan-02: order_measurement_snapshots).
@collection
class OrderMeasurementSnapshotEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String internalId;

  @Index(unique: true, replace: true)
  late String orderInternalId;

  @Index()
  late String shopId;

  String? sourceMeasurementProfileId;

  late DateTime createdAt;
}
