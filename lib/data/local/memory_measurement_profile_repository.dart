import 'dart:async';

import 'package:uuid/uuid.dart';

import 'dev_shop_constants.dart';
import 'measurement_profile_item_input.dart';
import 'measurement_profile_line.dart';
import 'measurement_profile_repository.dart';
import 'measurement_profile_summary.dart';
import 'measurement_type_summary.dart';
import 'measurement_unit_codes.dart';
import 'seed_data.dart';
import 'sync_pull_payload.dart';

class _TypeRow {
  _TypeRow({
    required this.internalId,
    required this.shopId,
    required this.name,
    required this.sortOrder,
    required this.isActive,
  });

  final String internalId;
  final String shopId;
  String name;
  int sortOrder;
  bool isActive;
  DateTime? deletedAt;
}

class _ProfileMeta {
  _ProfileMeta({
    required this.internalId,
    required this.shopId,
    required this.customerInternalId,
    required this.label,
    required this.notes,
    required this.unitCode,
    required this.createdAt,
    required this.updatedAt,
  });

  final String internalId;
  final String shopId;
  final String customerInternalId;
  String label;
  String notes;
  int unitCode;
  final DateTime createdAt;
  DateTime updatedAt;
}

class _ItemRow {
  _ItemRow({
    required this.profileInternalId,
    required this.shopId,
    required this.measurementTypeInternalId,
    required this.value,
    required this.unitCode,
  });

  final String profileInternalId;
  final String shopId;
  final String measurementTypeInternalId;
  final String value;
  final int unitCode;
}

class MemoryMeasurementProfileRepository
    implements MeasurementProfileRepository {
  MemoryMeasurementProfileRepository();

  final List<_TypeRow> _types = [];
  final List<_ProfileMeta> _metas = [];
  final List<_ItemRow> _items = [];
  final _controller = StreamController<void>.broadcast();
  final _uuid = const Uuid();

  void _emit() => _controller.add(null);

  List<MeasurementTypeSummary> _activeTypesForShop(String shopId) {
    return _types
        .where(
          (t) =>
              t.shopId == shopId &&
              t.isActive &&
              t.deletedAt == null,
        )
        .map(
          (e) => MeasurementTypeSummary(
            internalId: e.internalId,
            name: e.name,
            sortOrder: e.sortOrder,
            isActive: true,
          ),
        )
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  List<MeasurementTypeSummary> _adminTypesForShop(String shopId) {
    return _types
        .where((t) => t.shopId == shopId && t.deletedAt == null)
        .map(
          (e) => MeasurementTypeSummary(
            internalId: e.internalId,
            name: e.name,
            sortOrder: e.sortOrder,
            isActive: e.isActive,
          ),
        )
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  _TypeRow? _typeByInternalId(String id) {
    for (final t in _types) {
      if (t.internalId == id) return t;
    }
    return null;
  }

  List<MeasurementProfileLine> _linesForProfile(String profileInternalId) {
    final withOrder = <({MeasurementProfileLine line, int order})>[];
    for (final it in _items) {
      if (it.profileInternalId != profileInternalId) continue;
      final t = _typeByInternalId(it.measurementTypeInternalId);
      if (t == null || t.deletedAt != null || !t.isActive) continue;
      withOrder.add((
        line: MeasurementProfileLine(
          measurementTypeInternalId: it.measurementTypeInternalId,
          typeName: t.name,
          value: it.value,
          unitCode: it.unitCode,
        ),
        order: t.sortOrder,
      ));
    }
    withOrder.sort((a, b) => a.order.compareTo(b.order));
    return withOrder.map((x) => x.line).toList();
  }

  MeasurementProfileSummary _summaryFor(_ProfileMeta m) {
    return MeasurementProfileSummary(
      internalId: m.internalId,
      shopId: m.shopId,
      customerInternalId: m.customerInternalId,
      label: m.label,
      lines: _linesForProfile(m.internalId),
      notes: m.notes,
      unitCode: m.unitCode,
      createdAt: m.createdAt,
      updatedAt: m.updatedAt,
    );
  }

  List<MeasurementProfileSummary> _profilesForCustomer({
    required String shopId,
    required String customerInternalId,
  }) {
    return _metas
        .where(
          (m) =>
              m.shopId == shopId && m.customerInternalId == customerInternalId,
        )
        .map(_summaryFor)
        .toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  void _seedTypesIfEmpty() {
    if (_types.isNotEmpty) return;
    final types = [
      (DevSeedIds.mtChest, 'Chest', 10),
      (DevSeedIds.mtWaist, 'Waist', 20),
      (DevSeedIds.mtLength, 'Length', 30),
      (DevSeedIds.mtShoulder, 'Shoulder', 40),
      (DevSeedIds.mtNeck, 'Neck', 50),
      (DevSeedIds.mtSleeve, 'Sleeve', 60),
    ];
    for (final t in types) {
      _types.add(
        _TypeRow(
          internalId: t.$1,
          shopId: kDevShopId,
          name: t.$2,
          sortOrder: t.$3,
          isActive: true,
        ),
      );
    }
  }

  void _seedProfilesIfEmpty() {
    if (_metas.isNotEmpty) return;
    final now = DateTime.now();
    _metas.addAll([
      _ProfileMeta(
        internalId: DevSeedIds.measurementProfile1,
        shopId: kDevShopId,
        customerInternalId: DevSeedIds.customer1,
        label: 'Default',
        notes: '',
        unitCode: MeasurementUnitCodes.cm,
        createdAt: now,
        updatedAt: now,
      ),
      _ProfileMeta(
        internalId: DevSeedIds.measurementProfile2,
        shopId: kDevShopId,
        customerInternalId: DevSeedIds.customer2,
        label: 'Default',
        notes: '',
        unitCode: MeasurementUnitCodes.cm,
        createdAt: now,
        updatedAt: now,
      ),
    ]);
    _items.addAll([
      _ItemRow(
        profileInternalId: DevSeedIds.measurementProfile1,
        shopId: kDevShopId,
        measurementTypeInternalId: DevSeedIds.mtChest,
        value: '98',
        unitCode: MeasurementUnitCodes.cm,
      ),
      _ItemRow(
        profileInternalId: DevSeedIds.measurementProfile1,
        shopId: kDevShopId,
        measurementTypeInternalId: DevSeedIds.mtWaist,
        value: '84',
        unitCode: MeasurementUnitCodes.cm,
      ),
      _ItemRow(
        profileInternalId: DevSeedIds.measurementProfile1,
        shopId: kDevShopId,
        measurementTypeInternalId: DevSeedIds.mtLength,
        value: '112',
        unitCode: MeasurementUnitCodes.cm,
      ),
      _ItemRow(
        profileInternalId: DevSeedIds.measurementProfile2,
        shopId: kDevShopId,
        measurementTypeInternalId: DevSeedIds.mtShoulder,
        value: '46',
        unitCode: MeasurementUnitCodes.cm,
      ),
      _ItemRow(
        profileInternalId: DevSeedIds.measurementProfile2,
        shopId: kDevShopId,
        measurementTypeInternalId: DevSeedIds.mtSleeve,
        value: '62',
        unitCode: MeasurementUnitCodes.cm,
      ),
    ]);
  }

  @override
  Future<void> seedIfEmpty() async {
    var seeded = false;
    if (_types.isEmpty) {
      _seedTypesIfEmpty();
      seeded = true;
    }
    if (_metas.isEmpty) {
      _seedProfilesIfEmpty();
      seeded = true;
    }
    if (seeded) _emit();
  }

  @override
  Stream<List<MeasurementTypeSummary>> watchActiveMeasurementTypes(
    String shopId,
  ) async* {
    await seedIfEmpty();
    yield _activeTypesForShop(shopId);
    await for (final _ in _controller.stream) {
      yield _activeTypesForShop(shopId);
    }
  }

  @override
  Stream<List<MeasurementTypeSummary>> watchMeasurementTypesAdmin(
    String shopId,
  ) async* {
    await seedIfEmpty();
    yield _adminTypesForShop(shopId);
    await for (final _ in _controller.stream) {
      yield _adminTypesForShop(shopId);
    }
  }

  @override
  Future<String> createMeasurementType({
    required String shopId,
    required String name,
  }) async {
    await seedIfEmpty();
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError.value(name, 'name', 'must not be empty');
    }
    var maxOrder = 0;
    for (final t in _types) {
      if (t.shopId != shopId || t.deletedAt != null) continue;
      if (t.sortOrder > maxOrder) maxOrder = t.sortOrder;
    }
    final id = _uuid.v4();
    _types.add(
      _TypeRow(
        internalId: id,
        shopId: shopId,
        name: trimmed,
        sortOrder: maxOrder + 10,
        isActive: true,
      ),
    );
    _emit();
    return id;
  }

  @override
  Future<void> updateMeasurementType({
    required String internalId,
    required String name,
    required int sortOrder,
    required bool isActive,
  }) async {
    await seedIfEmpty();
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError.value(name, 'name', 'must not be empty');
    }
    final t = _typeByInternalId(internalId);
    if (t == null || t.deletedAt != null) return;
    t.name = trimmed;
    t.sortOrder = sortOrder;
    t.isActive = isActive;
    _emit();
  }

  @override
  Future<void> softDeleteMeasurementType(String internalId) async {
    await seedIfEmpty();
    final t = _typeByInternalId(internalId);
    if (t == null || t.deletedAt != null) return;
    t.deletedAt = DateTime.now();
    _emit();
  }

  @override
  Future<void> mergeRemoteMeasurementType({
    required String shopId,
    required String internalId,
    required String operation,
    Object? data,
  }) async {
    await seedIfEmpty();
    if (operation == 'delete') {
      await softDeleteMeasurementType(internalId);
      return;
    }
    final m = syncPullDataMap(data);
    final name = syncPullString(m, const ['name']);
    if (name == null || name.trim().isEmpty) return;
    final sortOrderIn = syncPullInt(m, const ['sort_order', 'sortOrder']);
    final isActive = syncPullBool(m, const ['is_active', 'isActive']) ?? true;

    final existing = _typeByInternalId(internalId);
    if (existing == null) {
      var maxOrder = 0;
      for (final t in _types) {
        if (t.shopId != shopId || t.deletedAt != null) continue;
        if (t.sortOrder > maxOrder) maxOrder = t.sortOrder;
      }
      _types.add(
        _TypeRow(
          internalId: internalId,
          shopId: shopId,
          name: name.trim(),
          sortOrder: sortOrderIn ?? maxOrder + 10,
          isActive: isActive,
        ),
      );
      _emit();
      return;
    }
    existing.name = name.trim();
    if (sortOrderIn != null) existing.sortOrder = sortOrderIn;
    existing.isActive = isActive;
    existing.deletedAt = null;
    _emit();
  }

  @override
  Stream<List<MeasurementProfileSummary>> watchForCustomer({
    required String shopId,
    required String customerInternalId,
  }) async* {
    await seedIfEmpty();
    yield _profilesForCustomer(
      shopId: shopId,
      customerInternalId: customerInternalId,
    );
    await for (final _ in _controller.stream) {
      yield _profilesForCustomer(
        shopId: shopId,
        customerInternalId: customerInternalId,
      );
    }
  }

  void _replaceItems({
    required String shopId,
    required String profileInternalId,
    required List<MeasurementProfileItemInput> items,
  }) {
    _items.removeWhere((i) => i.profileInternalId == profileInternalId);
    for (final input in items) {
      if (input.value.trim().isEmpty) continue;
      _items.add(
        _ItemRow(
          profileInternalId: profileInternalId,
          shopId: shopId,
          measurementTypeInternalId: input.measurementTypeInternalId,
          value: input.value.trim(),
          unitCode: input.unitCode,
        ),
      );
    }
  }

  @override
  Future<String> createProfile({
    required String shopId,
    required String customerInternalId,
    required String label,
    required String notes,
    required int unitCode,
    required List<MeasurementProfileItemInput> items,
  }) async {
    await seedIfEmpty();
    final now = DateTime.now();
    final id = _uuid.v4();
    _metas.add(
      _ProfileMeta(
        internalId: id,
        shopId: shopId,
        customerInternalId: customerInternalId,
        label: label.trim().isEmpty ? '—' : label.trim(),
        notes: notes,
        unitCode: unitCode,
        createdAt: now,
        updatedAt: now,
      ),
    );
    _replaceItems(
      shopId: shopId,
      profileInternalId: id,
      items: items,
    );
    _emit();
    return id;
  }

  @override
  Future<void> updateProfile({
    required String internalId,
    required String label,
    required String notes,
    required int unitCode,
    required List<MeasurementProfileItemInput> items,
  }) async {
    await seedIfEmpty();
    for (final m in _metas) {
      if (m.internalId != internalId) continue;
      m.label = label.trim().isEmpty ? '—' : label.trim();
      m.notes = notes;
      m.unitCode = unitCode;
      m.updatedAt = DateTime.now();
      _replaceItems(
        shopId: m.shopId,
        profileInternalId: internalId,
        items: items,
      );
      _emit();
      return;
    }
  }
}
