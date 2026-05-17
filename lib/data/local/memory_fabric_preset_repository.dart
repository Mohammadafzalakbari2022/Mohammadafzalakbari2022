import 'dart:async';

import 'package:uuid/uuid.dart';

import 'fabric_preset_repository.dart';
import 'fabric_preset_summary.dart';
import 'sync_pull_payload.dart';

class MemoryFabricPresetRepository implements FabricPresetRepository {
  final List<FabricPresetSummary> _names = [];
  final List<FabricPresetSummary> _colors = [];
  final _namesCtrl = StreamController<List<FabricPresetSummary>>.broadcast();
  final _colorsCtrl = StreamController<List<FabricPresetSummary>>.broadcast();
  final _uuid = const Uuid();

  void _emitNames() => _namesCtrl.add(const []);
  void _emitColors() => _colorsCtrl.add(const []);

  List<FabricPresetSummary> _namesFor(String shopId) =>
      _names.where((e) => e.shopId == shopId).toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

  List<FabricPresetSummary> _colorsFor(String shopId) =>
      _colors.where((e) => e.shopId == shopId).toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

  int _nextSort(List<FabricPresetSummary> rows) {
    var max = 0;
    for (final e in rows) {
      if (e.sortOrder > max) max = e.sortOrder;
    }
    return max + 10;
  }

  @override
  Stream<List<FabricPresetSummary>> watchFabricNames(String shopId) async* {
    yield _namesFor(shopId);
    yield* _namesCtrl.stream.map((_) => _namesFor(shopId));
  }

  @override
  Stream<List<FabricPresetSummary>> watchFabricColors(String shopId) async* {
    yield _colorsFor(shopId);
    yield* _colorsCtrl.stream.map((_) => _colorsFor(shopId));
  }

  @override
  Future<String> createFabricName({
    required String shopId,
    required String name,
    int? sortOrder,
  }) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) throw ArgumentError.value(name, 'name');
    final id = _uuid.v4();
    _names.add(
      FabricPresetSummary(
        internalId: id,
        shopId: shopId,
        name: trimmed,
        sortOrder: sortOrder ?? _nextSort(_namesFor(shopId)),
        isActive: true,
      ),
    );
    _emitNames();
    return id;
  }

  @override
  Future<void> updateFabricName({
    required String internalId,
    required String name,
    int? sortOrder,
    bool? isActive,
  }) async {
    final i = _names.indexWhere((e) => e.internalId == internalId);
    if (i < 0) return;
    final old = _names[i];
    _names[i] = FabricPresetSummary(
      internalId: old.internalId,
      shopId: old.shopId,
      name: name.trim().isNotEmpty ? name.trim() : old.name,
      sortOrder: sortOrder ?? old.sortOrder,
      isActive: isActive ?? old.isActive,
    );
    _emitNames();
  }

  @override
  Future<void> softDeleteFabricName(String internalId) async {
    _names.removeWhere((e) => e.internalId == internalId);
    _emitNames();
  }

  @override
  Future<String> createFabricColor({
    required String shopId,
    required String name,
    int? sortOrder,
  }) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) throw ArgumentError.value(name, 'name');
    final id = _uuid.v4();
    _colors.add(
      FabricPresetSummary(
        internalId: id,
        shopId: shopId,
        name: trimmed,
        sortOrder: sortOrder ?? _nextSort(_colorsFor(shopId)),
        isActive: true,
      ),
    );
    _emitColors();
    return id;
  }

  @override
  Future<void> updateFabricColor({
    required String internalId,
    required String name,
    int? sortOrder,
    bool? isActive,
  }) async {
    final i = _colors.indexWhere((e) => e.internalId == internalId);
    if (i < 0) return;
    final old = _colors[i];
    _colors[i] = FabricPresetSummary(
      internalId: old.internalId,
      shopId: old.shopId,
      name: name.trim().isNotEmpty ? name.trim() : old.name,
      sortOrder: sortOrder ?? old.sortOrder,
      isActive: isActive ?? old.isActive,
    );
    _emitColors();
  }

  @override
  Future<void> softDeleteFabricColor(String internalId) async {
    _colors.removeWhere((e) => e.internalId == internalId);
    _emitColors();
  }

  @override
  Future<void> mergeRemoteFabricName({
    required String shopId,
    required String internalId,
    required String operation,
    Object? data,
  }) async {
    if (operation == 'delete') {
      await softDeleteFabricName(internalId);
      return;
    }
    final m = syncPullDataMap(data);
    final name = syncPullString(m, const ['name']);
    if (name == null) return;
    final i = _names.indexWhere((e) => e.internalId == internalId);
    if (i < 0) {
      await createFabricName(shopId: shopId, name: name);
    } else {
      await updateFabricName(internalId: internalId, name: name);
    }
  }

  @override
  Future<void> mergeRemoteFabricColor({
    required String shopId,
    required String internalId,
    required String operation,
    Object? data,
  }) async {
    if (operation == 'delete') {
      await softDeleteFabricColor(internalId);
      return;
    }
    final m = syncPullDataMap(data);
    final name = syncPullString(m, const ['name']);
    if (name == null) return;
    final i = _colors.indexWhere((e) => e.internalId == internalId);
    if (i < 0) {
      await createFabricColor(shopId: shopId, name: name);
    } else {
      await updateFabricColor(internalId: internalId, name: name);
    }
  }
}
