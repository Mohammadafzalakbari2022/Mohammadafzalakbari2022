import 'measurement_profile_formatting.dart';
import 'measurement_profile_line.dart';

/// List row for a customer's measurement profile (plan-13).
class MeasurementProfileSummary {
  const MeasurementProfileSummary({
    required this.internalId,
    required this.shopId,
    required this.customerInternalId,
    required this.label,
    required this.lines,
    required this.notes,
    required this.unitCode,
    required this.createdAt,
    required this.updatedAt,
  });

  final String internalId;
  final String shopId;
  final String customerInternalId;
  final String label;
  final List<MeasurementProfileLine> lines;
  /// Extra free-form notes; stored in Isar `MeasurementProfileEntity.body`.
  final String notes;
  /// Default unit for the profile (used when adding new lines in UI).
  final int unitCode;
  final DateTime createdAt;
  final DateTime updatedAt;

  String get displayMeasurementsText =>
      MeasurementProfileFormatting.buildDisplayText(
        lines: lines,
        notes: notes,
      );
}
