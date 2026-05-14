import 'measurement_profile_item_input.dart';
import 'measurement_profile_summary.dart';
import 'measurement_type_summary.dart';

abstract class MeasurementProfileRepository {
  Stream<List<MeasurementTypeSummary>> watchActiveMeasurementTypes(
    String shopId,
  );

  /// Active + inactive types for the shop (excludes soft-deleted), sorted.
  Stream<List<MeasurementTypeSummary>> watchMeasurementTypesAdmin(
    String shopId,
  );

  Future<String> createMeasurementType({
    required String shopId,
    required String name,
  });

  Future<void> updateMeasurementType({
    required String internalId,
    required String name,
    required int sortOrder,
    required bool isActive,
  });

  Future<void> softDeleteMeasurementType(String internalId);

  Stream<List<MeasurementProfileSummary>> watchForCustomer({
    required String shopId,
    required String customerInternalId,
  });

  Future<void> seedIfEmpty();

  Future<String> createProfile({
    required String shopId,
    required String customerInternalId,
    required String label,
    required String notes,
    required int unitCode,
    required List<MeasurementProfileItemInput> items,
  });

  Future<void> updateProfile({
    required String internalId,
    required String label,
    required String notes,
    required int unitCode,
    required List<MeasurementProfileItemInput> items,
  });

  /// Apply one row from `GET /sync/pull` (`plan-03`).
  Future<void> mergeRemoteMeasurementType({
    required String shopId,
    required String internalId,
    required String operation,
    Object? data,
  });
}
