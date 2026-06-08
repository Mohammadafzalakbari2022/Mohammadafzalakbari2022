import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

import 'entities/garment_type.dart';
import 'entities/style_figure_entity.dart';
import 'entities/style_figure_size_option_entity.dart';
import 'entities/style_figure_text_option_entity.dart';
import 'entities/style_name_entity.dart';
import 'entities/style_part_entity.dart';
import 'measurement_unit_codes.dart';
import 'style/style_catalog_seed.dart';
import 'style/style_figure_image_ref.dart';
import 'style_catalog_repository.dart';
import 'style_figure_config_summary.dart';
import 'style_figure_size_option_summary.dart';
import 'style_figure_summary.dart';
import 'style_figure_text_option_summary.dart';
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
  Stream<List<StyleNameSummary>> watchStyleNames(
    String shopId, {
    int garmentTypeIndex = 0,
  }) {
    return _isar.styleNameEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .and()
        .garmentTypeIndexEqualTo(garmentTypeIndex)
        .and()
        .deletedAtIsNull()
        .watch(fireImmediately: true)
        .map(_mapNames);
  }

  @override
  Stream<List<StylePartSummary>> watchStyleParts(
    String shopId, {
    int garmentTypeIndex = 0,
  }) {
    return _isar.stylePartEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .and()
        .garmentTypeIndexEqualTo(garmentTypeIndex)
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
  Stream<List<StyleFigureSummary>> watchAllFigures(
    String shopId, {
    int garmentTypeIndex = 0,
  }) {
    return _isar.styleFigureEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .and()
        .garmentTypeIndexEqualTo(garmentTypeIndex)
        .and()
        .deletedAtIsNull()
        .watch(fireImmediately: true)
        .map(_mapFigures);
  }

  @override
  Stream<StyleFigureSummary?> watchStyleFigureById(
    String shopId,
    String internalId,
  ) {
    return _isar.styleFigureEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .and()
        .internalIdEqualTo(internalId)
        .and()
        .deletedAtIsNull()
        .watch(fireImmediately: true)
        .map((rows) {
          if (rows.isEmpty) return null;
          return _mapFigures(rows).first;
        });
  }

  List<StyleNameSummary> _mapNames(List<StyleNameEntity> rows) {
    final list = rows
        .map(
          (e) => StyleNameSummary(
            internalId: e.internalId,
            shopId: e.shopId,
            garmentTypeIndex: e.garmentTypeIndex,
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
            garmentTypeIndex: e.garmentTypeIndex,
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
            garmentTypeIndex: e.garmentTypeIndex,
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

  Future<int> _nextNameSortOrder(
    String shopId,
    int garmentTypeIndex,
  ) async {
    final rows = await _isar.styleNameEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .and()
        .garmentTypeIndexEqualTo(garmentTypeIndex)
        .and()
        .deletedAtIsNull()
        .findAll();
    var max = 0;
    for (final e in rows) {
      if (e.sortOrder > max) max = e.sortOrder;
    }
    return max + 10;
  }

  Future<int> _nextPartSortOrder(
    String shopId,
    int garmentTypeIndex,
  ) async {
    final rows = await _isar.stylePartEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .and()
        .garmentTypeIndexEqualTo(garmentTypeIndex)
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
    int garmentTypeIndex = 0,
    int? sortOrder,
  }) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) throw ArgumentError.value(name, 'name');
    final now = DateTime.now();
    final so = sortOrder ?? await _nextNameSortOrder(shopId, garmentTypeIndex);
    final id = _uuid.v4();
    final e = StyleNameEntity()
      ..internalId = id
      ..shopId = shopId
      ..garmentTypeIndex = garmentTypeIndex
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
    int garmentTypeIndex = 0,
    int? sortOrder,
  }) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) throw ArgumentError.value(name, 'name');
    final now = DateTime.now();
    final so = sortOrder ?? await _nextPartSortOrder(shopId, garmentTypeIndex);
    final id = _uuid.v4();
    final e = StylePartEntity()
      ..internalId = id
      ..shopId = shopId
      ..garmentTypeIndex = garmentTypeIndex
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
    final part = await _isar.stylePartEntitys.getByInternalId(partInternalId);
    final garmentTypeIndex =
        part?.garmentTypeIndex ?? GarmentType.perahanTunban.code;
    final now = DateTime.now();
    final so =
        sortOrder ?? await _nextFigureSortOrder(shopId, partInternalId);
    final id = _uuid.v4();
    final e = StyleFigureEntity()
      ..internalId = id
      ..shopId = shopId
      ..partInternalId = partInternalId
      ..garmentTypeIndex = garmentTypeIndex
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
    final figure = await _isar.styleFigureEntitys.getByInternalId(internalId);
    if (figure == null || figure.deletedAt != null) return;
    if (StyleFigureImageRef.isBundledAssetRef(figure.imageRef)) return;
    await _softDelete(
      () => _isar.styleFigureEntitys.getByInternalId(internalId),
      (e) => _isar.styleFigureEntitys.putByInternalId(e as StyleFigureEntity),
    );
  }

  @override
  Stream<List<StyleFigureTextOptionSummary>> watchTextOptionsForFigure(
    String shopId,
    String styleFigureInternalId,
  ) {
    return _isar.styleFigureTextOptionEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .and()
        .styleFigureInternalIdEqualTo(styleFigureInternalId)
        .and()
        .deletedAtIsNull()
        .watch(fireImmediately: true)
        .map(_mapTextOptions);
  }

  @override
  Stream<List<StyleFigureSizeOptionSummary>> watchSizeOptionsForFigure(
    String shopId,
    String styleFigureInternalId,
  ) {
    return _isar.styleFigureSizeOptionEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .and()
        .styleFigureInternalIdEqualTo(styleFigureInternalId)
        .and()
        .deletedAtIsNull()
        .watch(fireImmediately: true)
        .map(_mapSizeOptions);
  }

  @override
  Future<Map<String, StyleFigureConfigSummary>> loadAllFigureConfigs(
    String shopId, {
    bool activeFiguresOnly = false,
    int? garmentTypeIndex,
  }) async {
    final query = _isar.styleFigureEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .and()
        .deletedAtIsNull();
    final figureRows = garmentTypeIndex == null
        ? await query.findAll()
        : await query
            .and()
            .garmentTypeIndexEqualTo(garmentTypeIndex)
            .findAll();
    final figures = _mapFigures(figureRows);
    final filtered =
        activeFiguresOnly ? figures.where((f) => f.isActive) : figures;

    final textRows = await _isar.styleFigureTextOptionEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .and()
        .deletedAtIsNull()
        .findAll();
    final sizeRows = await _isar.styleFigureSizeOptionEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .and()
        .deletedAtIsNull()
        .findAll();
    final textByFigure = _groupTextOptions(textRows);
    final sizeByFigure = _groupSizeOptions(sizeRows);

    final result = <String, StyleFigureConfigSummary>{};
    for (final figure in filtered) {
      result[figure.internalId] = StyleFigureConfigSummary(
        figure: figure,
        textOptions: textByFigure[figure.internalId] ?? const [],
        sizeOptions: sizeByFigure[figure.internalId] ?? const [],
      );
    }
    return result;
  }

  List<StyleFigureTextOptionSummary> _mapTextOptions(
    List<StyleFigureTextOptionEntity> rows,
  ) {
    final list = rows
        .map(
          (e) => StyleFigureTextOptionSummary(
            internalId: e.internalId,
            shopId: e.shopId,
            styleFigureInternalId: e.styleFigureInternalId,
            label: e.label,
            sortOrder: e.sortOrder,
            isActive: e.isActive,
          ),
        )
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return list;
  }

  List<StyleFigureSizeOptionSummary> _mapSizeOptions(
    List<StyleFigureSizeOptionEntity> rows,
  ) {
    final list = rows
        .map(
          (e) => StyleFigureSizeOptionSummary(
            internalId: e.internalId,
            shopId: e.shopId,
            styleFigureInternalId: e.styleFigureInternalId,
            label: e.label,
            valueInches: e.valueInches,
            unitCode: e.unitCode,
            sortOrder: e.sortOrder,
            isActive: e.isActive,
          ),
        )
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return list;
  }

  Map<String, List<StyleFigureTextOptionSummary>> _groupTextOptions(
    List<StyleFigureTextOptionEntity> rows,
  ) {
    final map = <String, List<StyleFigureTextOptionSummary>>{};
    for (final row in _mapTextOptions(rows)) {
      map.putIfAbsent(row.styleFigureInternalId, () => []).add(row);
    }
    for (final list in map.values) {
      list.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    }
    return map;
  }

  Map<String, List<StyleFigureSizeOptionSummary>> _groupSizeOptions(
    List<StyleFigureSizeOptionEntity> rows,
  ) {
    final map = <String, List<StyleFigureSizeOptionSummary>>{};
    for (final row in _mapSizeOptions(rows)) {
      map.putIfAbsent(row.styleFigureInternalId, () => []).add(row);
    }
    for (final list in map.values) {
      list.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    }
    return map;
  }

  Future<int> _nextTextOptionSortOrder(
    String shopId,
    String styleFigureInternalId,
  ) async {
    final rows = await _isar.styleFigureTextOptionEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .and()
        .styleFigureInternalIdEqualTo(styleFigureInternalId)
        .and()
        .deletedAtIsNull()
        .findAll();
    return _maxSortOrder(rows, (e) => e.sortOrder) + 10;
  }

  Future<int> _nextSizeOptionSortOrder(
    String shopId,
    String styleFigureInternalId,
  ) async {
    final rows = await _isar.styleFigureSizeOptionEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .and()
        .styleFigureInternalIdEqualTo(styleFigureInternalId)
        .and()
        .deletedAtIsNull()
        .findAll();
    return _maxSortOrder(rows, (e) => e.sortOrder) + 10;
  }

  int _maxSortOrder<T>(List<T> rows, int Function(T) read) {
    var max = 0;
    for (final e in rows) {
      final value = read(e);
      if (value > max) max = value;
    }
    return max;
  }

  @override
  Future<String> createStyleFigureTextOption({
    required String shopId,
    required String styleFigureInternalId,
    required String label,
    int? sortOrder,
  }) async {
    final trimmed = label.trim();
    if (trimmed.isEmpty) throw ArgumentError.value(label, 'label');
    final now = DateTime.now();
    final so = sortOrder ??
        await _nextTextOptionSortOrder(shopId, styleFigureInternalId);
    final id = _uuid.v4();
    final e = StyleFigureTextOptionEntity()
      ..internalId = id
      ..shopId = shopId
      ..styleFigureInternalId = styleFigureInternalId
      ..label = trimmed
      ..sortOrder = so
      ..isActive = true
      ..createdAt = now
      ..updatedAt = now;
    await _isar.writeTxn(() async {
      await _isar.styleFigureTextOptionEntitys.putByInternalId(e);
    });
    return id;
  }

  @override
  Future<void> updateStyleFigureTextOption({
    required String internalId,
    String? label,
    int? sortOrder,
    bool? isActive,
  }) async {
    await _isar.writeTxn(() async {
      final e =
          await _isar.styleFigureTextOptionEntitys.getByInternalId(internalId);
      if (e == null || e.deletedAt != null) return;
      if (label != null) {
        final trimmed = label.trim();
        if (trimmed.isNotEmpty) e.label = trimmed;
      }
      if (sortOrder != null) e.sortOrder = sortOrder;
      if (isActive != null) e.isActive = isActive;
      e.updatedAt = DateTime.now();
      await _isar.styleFigureTextOptionEntitys.putByInternalId(e);
    });
  }

  @override
  Future<void> softDeleteStyleFigureTextOption(String internalId) async {
    await _softDelete(
      () => _isar.styleFigureTextOptionEntitys.getByInternalId(internalId),
      (e) =>
          _isar.styleFigureTextOptionEntitys.putByInternalId(e as StyleFigureTextOptionEntity),
    );
  }

  @override
  Future<String> createStyleFigureSizeOption({
    required String shopId,
    required String styleFigureInternalId,
    required String label,
    required double valueInches,
    int? unitCode,
    int? sortOrder,
  }) async {
    final trimmed = label.trim();
    if (trimmed.isEmpty) throw ArgumentError.value(label, 'label');
    final now = DateTime.now();
    final so = sortOrder ??
        await _nextSizeOptionSortOrder(shopId, styleFigureInternalId);
    final id = _uuid.v4();
    final e = StyleFigureSizeOptionEntity()
      ..internalId = id
      ..shopId = shopId
      ..styleFigureInternalId = styleFigureInternalId
      ..label = trimmed
      ..valueInches = valueInches
      ..unitCode = unitCode ?? MeasurementUnitCodes.inch
      ..sortOrder = so
      ..isActive = true
      ..createdAt = now
      ..updatedAt = now;
    await _isar.writeTxn(() async {
      await _isar.styleFigureSizeOptionEntitys.putByInternalId(e);
    });
    return id;
  }

  @override
  Future<void> updateStyleFigureSizeOption({
    required String internalId,
    String? label,
    double? valueInches,
    int? unitCode,
    int? sortOrder,
    bool? isActive,
  }) async {
    await _isar.writeTxn(() async {
      final e =
          await _isar.styleFigureSizeOptionEntitys.getByInternalId(internalId);
      if (e == null || e.deletedAt != null) return;
      if (label != null) {
        final trimmed = label.trim();
        if (trimmed.isNotEmpty) e.label = trimmed;
      }
      if (valueInches != null) e.valueInches = valueInches;
      if (unitCode != null) e.unitCode = unitCode;
      if (sortOrder != null) e.sortOrder = sortOrder;
      if (isActive != null) e.isActive = isActive;
      e.updatedAt = DateTime.now();
      await _isar.styleFigureSizeOptionEntitys.putByInternalId(e);
    });
  }

  @override
  Future<void> softDeleteStyleFigureSizeOption(String internalId) async {
    await _softDelete(
      () => _isar.styleFigureSizeOptionEntitys.getByInternalId(internalId),
      (e) =>
          _isar.styleFigureSizeOptionEntitys.putByInternalId(e as StyleFigureSizeOptionEntity),
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
    final garmentTypeIndex = syncPullInt(
          m,
          const ['garment_type_index', 'garmentTypeIndex'],
        ) ??
        GarmentType.perahanTunban.code;
    final isActive = syncPullBool(m, const ['is_active', 'isActive']) ?? true;
    final now = DateTime.now();
    final created =
        syncPullDateTime(m, const ['created_at', 'createdAt']) ?? now;
    final updated =
        syncPullDateTime(m, const ['updated_at', 'updatedAt']) ?? now;
    await _isar.writeTxn(() async {
      final existing = await _isar.styleNameEntitys.getByInternalId(internalId);
      if (existing == null) {
        final so =
            sortOrder ?? await _nextNameSortOrder(shopId, garmentTypeIndex);
        final e = StyleNameEntity()
          ..internalId = internalId
          ..shopId = shopId
          ..garmentTypeIndex = garmentTypeIndex
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
        ..garmentTypeIndex = garmentTypeIndex
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
    final garmentTypeIndex = syncPullInt(
          m,
          const ['garment_type_index', 'garmentTypeIndex'],
        ) ??
        GarmentType.perahanTunban.code;
    final isActive = syncPullBool(m, const ['is_active', 'isActive']) ?? true;
    final now = DateTime.now();
    final created =
        syncPullDateTime(m, const ['created_at', 'createdAt']) ?? now;
    final updated =
        syncPullDateTime(m, const ['updated_at', 'updatedAt']) ?? now;
    await _isar.writeTxn(() async {
      final existing = await _isar.stylePartEntitys.getByInternalId(internalId);
      if (existing == null) {
        final so =
            sortOrder ?? await _nextPartSortOrder(shopId, garmentTypeIndex);
        final e = StylePartEntity()
          ..internalId = internalId
          ..shopId = shopId
          ..garmentTypeIndex = garmentTypeIndex
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
        ..garmentTypeIndex = garmentTypeIndex
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
    final garmentTypeIndex = syncPullInt(
          m,
          const ['garment_type_index', 'garmentTypeIndex'],
        ) ??
        GarmentType.perahanTunban.code;
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
          ..garmentTypeIndex = garmentTypeIndex
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
        ..garmentTypeIndex = garmentTypeIndex
        ..name = name.trim()
        ..imageRef = imageRef.trim()
        ..sortOrder = sortOrder ?? existing.sortOrder
        ..isActive = isActive
        ..updatedAt = updated
        ..deletedAt = null;
      await _isar.styleFigureEntitys.putByInternalId(existing);
    });
  }

  @override
  Future<void> mergeRemoteStyleFigureTextOption({
    required String shopId,
    required String internalId,
    required String operation,
    Object? data,
  }) async {
    if (operation == 'delete') {
      await softDeleteStyleFigureTextOption(internalId);
      return;
    }
    final m = syncPullDataMap(data);
    final figureId = syncPullString(
      m,
      const ['style_figure_internal_id', 'styleFigureInternalId'],
    );
    final label = syncPullString(m, const ['label']);
    if (figureId == null ||
        figureId.isEmpty ||
        label == null ||
        label.trim().isEmpty) {
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
      final existing = await _isar.styleFigureTextOptionEntitys
          .getByInternalId(internalId);
      if (existing == null) {
        final so = sortOrder ??
            await _nextTextOptionSortOrder(shopId, figureId);
        final e = StyleFigureTextOptionEntity()
          ..internalId = internalId
          ..shopId = shopId
          ..styleFigureInternalId = figureId
          ..label = label.trim()
          ..sortOrder = so
          ..isActive = isActive
          ..createdAt = created
          ..updatedAt = updated;
        await _isar.styleFigureTextOptionEntitys.putByInternalId(e);
        return;
      }
      existing
        ..shopId = shopId
        ..styleFigureInternalId = figureId
        ..label = label.trim()
        ..sortOrder = sortOrder ?? existing.sortOrder
        ..isActive = isActive
        ..updatedAt = updated
        ..deletedAt = null;
      await _isar.styleFigureTextOptionEntitys.putByInternalId(existing);
    });
  }

  @override
  Future<void> mergeRemoteStyleFigureSizeOption({
    required String shopId,
    required String internalId,
    required String operation,
    Object? data,
  }) async {
    if (operation == 'delete') {
      await softDeleteStyleFigureSizeOption(internalId);
      return;
    }
    final m = syncPullDataMap(data);
    final figureId = syncPullString(
      m,
      const ['style_figure_internal_id', 'styleFigureInternalId'],
    );
    final label = syncPullString(m, const ['label']);
    final valueInches = syncPullDouble(
      m,
      const ['value_inches', 'valueInches'],
    );
    if (figureId == null ||
        figureId.isEmpty ||
        label == null ||
        label.trim().isEmpty ||
        valueInches == null) {
      return;
    }
    final unitCode = syncPullInt(m, const ['unit_code', 'unitCode']) ??
        MeasurementUnitCodes.inch;
    final sortOrder = syncPullInt(m, const ['sort_order', 'sortOrder']);
    final isActive = syncPullBool(m, const ['is_active', 'isActive']) ?? true;
    final now = DateTime.now();
    final created =
        syncPullDateTime(m, const ['created_at', 'createdAt']) ?? now;
    final updated =
        syncPullDateTime(m, const ['updated_at', 'updatedAt']) ?? now;
    await _isar.writeTxn(() async {
      final existing = await _isar.styleFigureSizeOptionEntitys
          .getByInternalId(internalId);
      if (existing == null) {
        final so = sortOrder ??
            await _nextSizeOptionSortOrder(shopId, figureId);
        final e = StyleFigureSizeOptionEntity()
          ..internalId = internalId
          ..shopId = shopId
          ..styleFigureInternalId = figureId
          ..label = label.trim()
          ..valueInches = valueInches
          ..unitCode = unitCode
          ..sortOrder = so
          ..isActive = isActive
          ..createdAt = created
          ..updatedAt = updated;
        await _isar.styleFigureSizeOptionEntitys.putByInternalId(e);
        return;
      }
      existing
        ..shopId = shopId
        ..styleFigureInternalId = figureId
        ..label = label.trim()
        ..valueInches = valueInches
        ..unitCode = unitCode
        ..sortOrder = sortOrder ?? existing.sortOrder
        ..isActive = isActive
        ..updatedAt = updated
        ..deletedAt = null;
      await _isar.styleFigureSizeOptionEntitys.putByInternalId(existing);
    });
  }

}
