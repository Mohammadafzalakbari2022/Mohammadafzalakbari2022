/// Values to persist for one measurement type on a profile.
class MeasurementProfileItemInput {
  const MeasurementProfileItemInput({
    required this.measurementTypeInternalId,
    required this.value,
    required this.unitCode,
  });

  final String measurementTypeInternalId;
  final String value;
  final int unitCode;
}
