/// One structured line hydrated for UI (plan-02 profile items).
class MeasurementProfileLine {
  const MeasurementProfileLine({
    required this.measurementTypeInternalId,
    required this.typeName,
    required this.value,
    required this.unitCode,
  });

  final String measurementTypeInternalId;
  final String typeName;
  final String value;
  final int unitCode;
}
