/// Shop measurement field row (plan-02: measurement_types).
class MeasurementTypeSummary {
  const MeasurementTypeSummary({
    required this.internalId,
    required this.name,
    required this.sortOrder,
    required this.isActive,
  });

  final String internalId;
  final String name;
  final int sortOrder;
  final bool isActive;
}
