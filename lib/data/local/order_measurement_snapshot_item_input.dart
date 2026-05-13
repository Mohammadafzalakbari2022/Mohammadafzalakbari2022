/// One frozen measurement line stored on an order (plan-02).
class OrderMeasurementSnapshotItemInput {
  const OrderMeasurementSnapshotItemInput({
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
