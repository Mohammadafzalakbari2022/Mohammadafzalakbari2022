import 'package:isar/isar.dart';

part 'order_measurement_snapshot_entity.g.dart';

/// Header row: one snapshot per order (plan-02: order_measurement_snapshots).
@collection
class OrderMeasurementSnapshotEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String internalId;

  @Index()
  late String orderInternalId;

  /// Item-scoped snapshot (Phase 2+). Empty for legacy order-level rows.
  @Index()
  String orderItemInternalId = '';

  @Index()
  late String shopId;

  String? sourceMeasurementProfileId;

  late DateTime createdAt;
}
