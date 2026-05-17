import 'fabric_preset_summary.dart';

abstract class FabricPresetRepository {
  Stream<List<FabricPresetSummary>> watchFabricNames(String shopId);
  Stream<List<FabricPresetSummary>> watchFabricColors(String shopId);

  Future<String> createFabricName({
    required String shopId,
    required String name,
    int? sortOrder,
  });
  Future<void> updateFabricName({
    required String internalId,
    required String name,
    int? sortOrder,
    bool? isActive,
  });
  Future<void> softDeleteFabricName(String internalId);

  Future<String> createFabricColor({
    required String shopId,
    required String name,
    int? sortOrder,
  });
  Future<void> updateFabricColor({
    required String internalId,
    required String name,
    int? sortOrder,
    bool? isActive,
  });
  Future<void> softDeleteFabricColor(String internalId);

  Future<void> mergeRemoteFabricName({
    required String shopId,
    required String internalId,
    required String operation,
    Object? data,
  });
  Future<void> mergeRemoteFabricColor({
    required String shopId,
    required String internalId,
    required String operation,
    Object? data,
  });
}
