/// Hydrated order measurement snapshot for UI (plan-02).
class OrderMeasurementSnapshotView {
  const OrderMeasurementSnapshotView({
    required this.orderInternalId,
    required this.snapshotInternalId,
    this.sourceMeasurementProfileId,
    required this.createdAt,
    required this.items,
  });

  final String orderInternalId;
  final String snapshotInternalId;
  final String? sourceMeasurementProfileId;
  final DateTime createdAt;
  final List<OrderMeasurementSnapshotItemView> items;
}

class OrderMeasurementSnapshotItemView {
  const OrderMeasurementSnapshotItemView({
    required this.measurementTypeInternalId,
    required this.typeName,
    required this.value,
    required this.unitCode,
    required this.sortOrder,
  });

  final String measurementTypeInternalId;
  final String typeName;
  final String value;
  final int unitCode;
  final int sortOrder;
}
