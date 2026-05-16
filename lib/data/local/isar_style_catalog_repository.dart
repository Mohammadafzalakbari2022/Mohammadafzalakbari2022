import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

import 'entities/style_figure_entity.dart';
import 'entities/style_name_entity.dart';
import 'entities/style_part_entity.dart';
import 'style/style_catalog_seed.dart';
import 'style_catalog_repository.dart';
import 'style_figure_summary.dart';
import 'style_name_summary.dart';
import 'style_part_summary.dart';
import 'sync_pull_payload.dart';

class IsarStyleCatalogRepository implements StyleCatalogRepository {
  IsarStyleCatalogRepository(this._isar);

  final Isar _isar;
  final _uuid = const Uuid();

  @override
  Future<void> seedIfEmpty(String shopId) async {
    await seedStyleCatalogIfEmpty(_isar, shopId);
  }

  @override
  Stream<List<StyleNameSummary>> watchStyleNames(String shopId) {
    return _isar.styleNameEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .and()
        .deletedAtIsNull()
        .watch(fireImmediately: true)
        .map(_mapNames);
  }

  @override
  Stream<List<StylePartSummary>> watchStyleParts(String shopId) {
    return _isar.stylePartEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .and()
        .deletedAtIsNull()
        .watch(fireImmediately: true)
        .map(_mapParts);
  }

  @override
  Stream<List<StyleFigureSummary>> watchFiguresForPart(
    String shopId,
    String partInternalId,
  ) {
    return _isar.styleFigureEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .and()
        .partInternalIdEqualTo(partInternalId)
        .and()
        .deletedAtIsNull()
        .watch(fireImmediately: true)
        .map(_mapFigures);
  }

  @override
  Stream<List<StyleFigureSummary>> watchAllFigures(String shopId) {
    return _isar.styleFigureEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .and()
        .deletedAtIsNull()
        .watch(fireImmediately: true)
        .map(_mapFigures);
  }

  List<StyleNameSummary> _mapNames(List<StyleNameEntity> rows) {
    final list = rows
        .map(
          (e) => StyleNameSummary(
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

  List<StylePartSummary> _mapParts(List<StylePartEntity> rows) {
    final list = rows
        .map(
          (e) => StylePartSummary(
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

  List<StyleFigureSummary> _mapFigures(List<StyleFigureEntity> rows) {
    final list = rows
        .map(
          (e) => StyleFigureSummary(
            internalId: e.internalId,
            shopId: e.shopId,
            partInternalId: e.partInternalId,
            name: e.name,
            imageRef: e.imageRef,
            sortOrder: e.sortOrder,
            isActive: e.isActive,
          ),
        )
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return list;
  }

  Future<int> _nextNameSortOrder(String shopId) async {
    final rows = await _isar.styleNameEntitys
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

  Future<int> _nextPartSortOrder(String shopId) async {
    final rows = await _isar.stylePartEntitys
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

  Future<int> _nextFigureSortOrder(String shopId, String partInternalId) async {
    final rows = await _isar.styleFigureEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .and()
        .partInternalIdEqualTo(partInternalId)
        .and()
        .deletedAtIsNull()
        .findAll();
    var max = 0;
    for (final e in rows) {
      if (e.sortOrder > max) max = e.sortOrder;
    }
    return max + 10;
  }

  @override
  Future<String> createStyleName({
    required String shopId,
    required String name,
    int? sortOrder,
  }) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) throw ArgumentError.value(name, 'name');
    final now = DateTime.now();
    final so = sortOrder ?? await _nextNameSortOrder(shopId);
    final id = _uuid.v4();
    final e = StyleNameEntity()
      ..internalId = id
      ..shopId = shopId
      ..name = trimmed
      ..sortOrder = so
      ..isActive = true
      ..createdAt = now
      ..updatedAt = now;
    await _isar.writeTxn(() async {
      await _isar.styleNameEntitys.putByInternalId(e);
    });
    return id;
  }

  @override
  Future<void> updateStyleName({
    required String internalId,
    required String name,
    int? sortOrder,
    bool? isActive,
  }) async {
    await _isar.writeTxn(() async {
      final e = await _isar.styleNameEntitys.getByInternalId(internalId);
      if (e == null || e.deletedAt != null) return;
      final trimmed = name.trim();
      if (trimmed.isNotEmpty) e.name = trimmed;
      if (sortOrder != null) e.sortOrder = sortOrder;
      if (isActive != null) e.isActive = isActive;
      e.updatedAt = DateTime.now();
      await _isar.styleNameEntitys.putByInternalId(e);
    });
  }

  @override
  Future<void> softDeleteStyleName(String internalId) async {
    await _softDelete(
      () => _isar.styleNameEntitys.getByInternalId(internalId),
      (e) => _isar.styleNameEntitys.putByInternalId(e as StyleNameEntity),
    );
  }

  @override
  Future<String> createStylePart({
    required String shopId,
    required String name,
    int? sortOrder,
  }) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) throw ArgumentError.value(name, 'name');
    final now = DateTime.now();
    final so = sortOrder ?? await _nextPartSortOrder(shopId);
    final id = _uuid.v4();
    final e = StylePartEntity()
      ..internalId = id
      ..shopId = shopId
      ..name = trimmed
      ..sortOrder = so
      ..isActive = true
      ..createdAt = now
      ..updatedAt = now;
    await _isar.writeTxn(() async {
      await _isar.stylePartEntitys.putByInternalId(e);
    });
    return id;
  }

  @override
  Future<void> updateStylePart({
    required String internalId,
    required String name,
    int? sortOrder,
    bool? isActive,
  }) async {
    await _isar.writeTxn(() async {
      final e = await _isar.stylePartEntitys.getByInternalId(internalId);
      if (e == null || e.deletedAt != null) return;
      final trimmed = name.trim();
      if (trimmed.isNotEmpty) e.name = trimmed;
      if (sortOrder != null) e.sortOrder = sortOrder;
      if (isActive != null) e.isActive = isActive;
      e.updatedAt = DateTime.now();
      await _isar.stylePartEntitys.putByInternalId(e);
    });
  }

  @override
  Future<void> softDeleteStylePart(String internalId) async {
    await _softDelete(
      () => _isar.stylePartEntitys.getByInternalId(internalId),
      (e) => _isar.stylePartEntitys.putByInternalId(e as StylePartEntity),
    );
  }

  @override
  Future<String> createStyleFigure({
    required String shopId,
    required String partInternalId,
    required String name,
    required String imageRef,
    int? sortOrder,
  }) async {
    if (imageRef.trim().isEmpty) throw ArgumentError.value(imageRef, 'imageRef');
    final now = DateTime.now();
    final so =
        sortOrder ?? await _nextFigureSortOrder(shopId, partInternalId);
    final id = _uuid.v4();
    final e = StyleFigureEntity()
      ..internalId = id
      ..shopId = shopId
      ..partInternalId = partInternalId
      ..name = name.trim()
      ..imageRef = imageRef.trim()
      ..sortOrder = so
      ..isActive = true
      ..createdAt = now
      ..updatedAt = now;
    await _isar.writeTxn(() async {
      await _isar.styleFigureEntitys.putByInternalId(e);
    });
    return id;
  }

  @override
  Future<void> updateStyleFigure({
    required String internalId,
    String? name,
    String? imageRef,
    int? sortOrder,
    bool? isActive,
  }) async {
    await _isar.writeTxn(() async {
      final e = await _isar.styleFigureEntitys.getByInternalId(internalId);
      if (e == null || e.deletedAt != null) return;
      if (name != null) {
        final t = name.trim();
        if (t.isNotEmpty) e.name = t;
      }
      if (imageRef != null && imageRef.trim().isNotEmpty) {
        e.imageRef = imageRef.trim();
      }
      if (sortOrder != null) e.sortOrder = sortOrder;
      if (isActive != null) e.isActive = isActive;
      e.updatedAt = DateTime.now();
      await _isar.styleFigureEntitys.putByInternalId(e);
    });
  }

  @override
  Future<void> softDeleteStyleFigure(String internalId) async {
    await _softDelete(
      () => _isar.styleFigureEntitys.getByInternalId(internalId),
      (e) => _isar.styleFigureEntitys.putByInternalId(e as StyleFigureEntity),
    );
  }

  Future<void> _softDelete(
    Future<dynamic> Function() load,
    Future<void> Function(dynamic) put,
  ) async {
    await _isar.writeTxn(() async {
      final e = await load();
      if (e == null || e.deletedAt != null) return;
      e.deletedAt = DateTime.now();
      e.updatedAt = DateTime.now();
      await put(e);
    });
  }

  @override
  Future<void> mergeRemoteStyleName({
    required String shopId,
    required String internalId,
    required String operation,
    Object? data,
  }) async {
    if (operation == 'delete') {
      await softDeleteStyleName(internalId);
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
      final existing = await _isar.styleNameEntitys.getByInternalId(internalId);
      if (existing == null) {
        final so = sortOrder ?? await _nextNameSortOrder(shopId);
        final e = StyleNameEntity()
          ..internalId = internalId
          ..shopId = shopId
          ..name = name.trim()
          ..sortOrder = so
          ..isActive = isActive
          ..createdAt = created
          ..updatedAt = updated;
        await _isar.styleNameEntitys.putByInternalId(e);
        return;
      }
      existing
        ..shopId = shopId
        ..name = name.trim()
        ..sortOrder = sortOrder ?? existing.sortOrder
        ..isActive = isActive
        ..updatedAt = updated
        ..deletedAt = null;
      await _isar.styleNameEntitys.putByInternalId(existing);
    });
  }

  @override
  Future<void> mergeRemoteStylePart({
    required String shopId,
    required String internalId,
    required String operation,
    Object? data,
  }) async {
    if (operation == 'delete') {
      await softDeleteStylePart(internalId);
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
      final existing = await _isar.stylePartEntitys.getByInternalId(internalId);
      if (existing == null) {
        final so = sortOrder ?? await _nextPartSortOrder(shopId);
        final e = StylePartEntity()
          ..internalId = internalId
          ..shopId = shopId
          ..name = name.trim()
          ..sortOrder = so
          ..isActive = isActive
          ..createdAt = created
          ..updatedAt = updated;
        await _isar.stylePartEntitys.putByInternalId(e);
        return;
      }
      existing
        ..shopId = shopId
        ..name = name.trim()
        ..sortOrder = sortOrder ?? existing.sortOrder
        ..isActive = isActive
        ..updatedAt = updated
        ..deletedAt = null;
      await _isar.stylePartEntitys.putByInternalId(existing);
    });
  }

  @override
  Future<void> mergeRemoteStyleFigure({
    required String shopId,
    required String internalId,
    required String operation,
    Object? data,
  }) async {
    if (operation == 'delete') {
      await softDeleteStyleFigure(internalId);
      return;
    }
    final m = syncPullDataMap(data);
    final name = syncPullString(m, const ['name']);
    final partId = syncPullString(
      m,
      const ['part_internal_id', 'partInternalId'],
    );
    final imageRef = syncPullString(m, const ['image_ref', 'imageRef']);
    if (name == null ||
        name.trim().isEmpty ||
        partId == null ||
        partId.isEmpty ||
        imageRef == null ||
        imageRef.trim().isEmpty) {
      return;
    }
    final sortOrder = syncPullInt(m, const ['sort_order', 'sortOrder']);
    final isActive = syncPullBool(m, const ['is_active', 'isActive']) ?? true;
    final now = DateTime.now();
    final created =
        syncPullDateTime(m, const ['created_at', 'createdAt']) ?? now;
    final updated =
        syncPullDateTime(m, const ['updated_at', 'updatedAt']) ?? now;
    await _isar.writeTxn(() async {
      final existing =
          await _isar.styleFigureEntitys.getByInternalId(internalId);
      if (existing == null) {
        final so = sortOrder ?? await _nextFigureSortOrder(shopId, partId);
        final e = StyleFigureEntity()
          ..internalId = internalId
          ..shopId = shopId
          ..partInternalId = partId
          ..name = name.trim()
          ..imageRef = imageRef.trim()
          ..sortOrder = so
          ..isActive = isActive
          ..createdAt = created
          ..updatedAt = updated;
        await _isar.styleFigureEntitys.putByInternalId(e);
        return;
      }
      existing
        ..shopId = shopId
        ..partInternalId = partId
        ..name = name.trim()
        ..imageRef = imageRef.trim()
        ..sortOrder = sortOrder ?? existing.sortOrder
        ..isActive = isActive
        ..updatedAt = updated
        ..deletedAt = null;
      await _isar.styleFigureEntitys.putByInternalId(existing);
    });
  }
}
