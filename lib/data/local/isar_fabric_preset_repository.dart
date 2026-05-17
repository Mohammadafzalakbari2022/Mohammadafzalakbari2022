import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

import 'entities/fabric_color_preset_entity.dart';
import 'entities/fabric_name_preset_entity.dart';
import 'fabric_preset_repository.dart';
import 'fabric_preset_summary.dart';
import 'sync_pull_payload.dart';

class IsarFabricPresetRepository implements FabricPresetRepository {
  IsarFabricPresetRepository(this._isar);

  final Isar _isar;
  final _uuid = const Uuid();

  List<FabricPresetSummary> _mapNames(List<FabricNamePresetEntity> rows) {
    final list = rows
        .map(
          (e) => FabricPresetSummary(
            internalId: e.internalId,
            shopId: e.shopId,
            name: e.name,
            sortOrder: e.sortOrder,
            isActive: e.isActive,
          ),
        )
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return list;
  }

  List<FabricPresetSummary> _mapColors(List<FabricColorPresetEntity> rows) {
    final list = rows
        .map(
          (e) => FabricPresetSummary(
            internalId: e.internalId,
            shopId: e.shopId,
            name: e.name,
            sortOrder: e.sortOrder,
            isActive: e.isActive,
          ),
        )
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return list;
  }

  Future<int> _nextNameSortOrder(String shopId) async {
    final rows = await _isar.fabricNamePresetEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .and()
        .deletedAtIsNull()
        .findAll();
    var max = 0;
    for (final e in rows) {
      if (e.sortOrder > max) max = e.sortOrder;
    }
    return max + 10;
  }

  Future<int> _nextColorSortOrder(String shopId) async {
    final rows = await _isar.fabricColorPresetEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .and()
        .deletedAtIsNull()
        .findAll();
    var max = 0;
    for (final e in rows) {
      if (e.sortOrder > max) max = e.sortOrder;
    }
    return max + 10;
  }

  Future<void> _softDeleteName(String internalId) async {
    await _isar.writeTxn(() async {
      final e = await _isar.fabricNamePresetEntitys.getByInternalId(internalId);
      if (e == null || e.deletedAt != null) return;
      e
        ..deletedAt = DateTime.now()
        ..updatedAt = DateTime.now();
      await _isar.fabricNamePresetEntitys.putByInternalId(e);
    });
  }

  Future<void> _softDeleteColor(String internalId) async {
    await _isar.writeTxn(() async {
      final e =
          await _isar.fabricColorPresetEntitys.getByInternalId(internalId);
      if (e == null || e.deletedAt != null) return;
      e
        ..deletedAt = DateTime.now()
        ..updatedAt = DateTime.now();
      await _isar.fabricColorPresetEntitys.putByInternalId(e);
    });
  }

  @override
  Stream<List<FabricPresetSummary>> watchFabricNames(String shopId) {
    return _isar.fabricNamePresetEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .and()
        .deletedAtIsNull()
        .watch(fireImmediately: true)
        .map(_mapNames);
  }

  @override
  Stream<List<FabricPresetSummary>> watchFabricColors(String shopId) {
    return _isar.fabricColorPresetEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .and()
        .deletedAtIsNull()
        .watch(fireImmediately: true)
        .map(_mapColors);
  }

  @override
  Future<String> createFabricName({
    required String shopId,
    required String name,
    int? sortOrder,
  }) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) throw ArgumentError.value(name, 'name');
    final now = DateTime.now();
    final so = sortOrder ?? await _nextNameSortOrder(shopId);
    final id = _uuid.v4();
    final e = FabricNamePresetEntity()
      ..internalId = id
      ..shopId = shopId
      ..name = trimmed
      ..sortOrder = so
      ..isActive = true
      ..createdAt = now
      ..updatedAt = now;
    await _isar.writeTxn(() async {
      await _isar.fabricNamePresetEntitys.putByInternalId(e);
    });
    return id;
  }

  @override
  Future<void> updateFabricName({
    required String internalId,
    required String name,
    int? sortOrder,
    bool? isActive,
  }) async {
    await _isar.writeTxn(() async {
      final e = await _isar.fabricNamePresetEntitys.getByInternalId(internalId);
      if (e == null || e.deletedAt != null) return;
      final trimmed = name.trim();
      if (trimmed.isNotEmpty) e.name = trimmed;
      if (sortOrder != null) e.sortOrder = sortOrder;
      if (isActive != null) e.isActive = isActive;
      e.updatedAt = DateTime.now();
      await _isar.fabricNamePresetEntitys.putByInternalId(e);
    });
  }

  @override
  Future<void> softDeleteFabricName(String internalId) =>
      _softDeleteName(internalId);

  @override
  Future<String> createFabricColor({
    required String shopId,
    required String name,
    int? sortOrder,
  }) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) throw ArgumentError.value(name, 'name');
    final now = DateTime.now();
    final so = sortOrder ?? await _nextColorSortOrder(shopId);
    final id = _uuid.v4();
    final e = FabricColorPresetEntity()
      ..internalId = id
      ..shopId = shopId
      ..name = trimmed
      ..sortOrder = so
      ..isActive = true
      ..createdAt = now
      ..updatedAt = now;
    await _isar.writeTxn(() async {
      await _isar.fabricColorPresetEntitys.putByInternalId(e);
    });
    return id;
  }

  @override
  Future<void> updateFabricColor({
    required String internalId,
    required String name,
    int? sortOrder,
    bool? isActive,
  }) async {
    await _isar.writeTxn(() async {
      final e =
          await _isar.fabricColorPresetEntitys.getByInternalId(internalId);
      if (e == null || e.deletedAt != null) return;
      final trimmed = name.trim();
      if (trimmed.isNotEmpty) e.name = trimmed;
      if (sortOrder != null) e.sortOrder = sortOrder;
      if (isActive != null) e.isActive = isActive;
      e.updatedAt = DateTime.now();
      await _isar.fabricColorPresetEntitys.putByInternalId(e);
    });
  }

  @override
  Future<void> softDeleteFabricColor(String internalId) =>
      _softDeleteColor(internalId);

  Future<void> _mergeRemoteName({
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
    if (name == null || name.trim().isEmpty) return;
    final sortOrder = syncPullInt(m, const ['sort_order', 'sortOrder']);
    final isActive = syncPullBool(m, const ['is_active', 'isActive']) ?? true;
    final now = DateTime.now();
    final created =
        syncPullDateTime(m, const ['created_at', 'createdAt']) ?? now;
    final updated =
        syncPullDateTime(m, const ['updated_at', 'updatedAt']) ?? now;
    await _isar.writeTxn(() async {
      final existing =
          await _isar.fabricNamePresetEntitys.getByInternalId(internalId);
      if (existing == null) {
        final so = sortOrder ?? await _nextNameSortOrder(shopId);
        final e = FabricNamePresetEntity()
          ..internalId = internalId
          ..shopId = shopId
          ..name = name.trim()
          ..sortOrder = so
          ..isActive = isActive
          ..createdAt = created
          ..updatedAt = updated;
        await _isar.fabricNamePresetEntitys.putByInternalId(e);
        return;
      }
      existing
        ..shopId = shopId
        ..name = name.trim()
        ..sortOrder = sortOrder ?? existing.sortOrder
        ..isActive = isActive
        ..updatedAt = updated
        ..deletedAt = null;
      await _isar.fabricNamePresetEntitys.putByInternalId(existing);
    });
  }

  Future<void> _mergeRemoteColor({
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
    if (name == null || name.trim().isEmpty) return;
    final sortOrder = syncPullInt(m, const ['sort_order', 'sortOrder']);
    final isActive = syncPullBool(m, const ['is_active', 'isActive']) ?? true;
    final now = DateTime.now();
    final created =
        syncPullDateTime(m, const ['created_at', 'createdAt']) ?? now;
    final updated =
        syncPullDateTime(m, const ['updated_at', 'updatedAt']) ?? now;
    await _isar.writeTxn(() async {
      final existing =
          await _isar.fabricColorPresetEntitys.getByInternalId(internalId);
      if (existing == null) {
        final so = sortOrder ?? await _nextColorSortOrder(shopId);
        final e = FabricColorPresetEntity()
          ..internalId = internalId
          ..shopId = shopId
          ..name = name.trim()
          ..sortOrder = so
          ..isActive = isActive
          ..createdAt = created
          ..updatedAt = updated;
        await _isar.fabricColorPresetEntitys.putByInternalId(e);
        return;
      }
      existing
        ..shopId = shopId
        ..name = name.trim()
        ..sortOrder = sortOrder ?? existing.sortOrder
        ..isActive = isActive
        ..updatedAt = updated
        ..deletedAt = null;
      await _isar.fabricColorPresetEntitys.putByInternalId(existing);
    });
  }

  @override
  Future<void> mergeRemoteFabricName({
    required String shopId,
    required String internalId,
    required String operation,
    Object? data,
  }) =>
      _mergeRemoteName(
        shopId: shopId,
        internalId: internalId,
        operation: operation,
        data: data,
      );

  @override
  Future<void> mergeRemoteFabricColor({
    required String shopId,
    required String internalId,
    required String operation,
    Object? data,
  }) =>
      _mergeRemoteColor(
        shopId: shopId,
        internalId: internalId,
        operation: operation,
        data: data,
      );
}
