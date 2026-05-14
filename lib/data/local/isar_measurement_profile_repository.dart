import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

import 'dev_shop_constants.dart';
import 'entities/measurement_profile_entity.dart';
import 'entities/measurement_profile_item_entity.dart';
import 'entities/measurement_type_entity.dart';
import 'measurement_profile_item_input.dart';
import 'measurement_profile_line.dart';
import 'measurement_profile_repository.dart';
import 'measurement_profile_summary.dart';
import 'measurement_type_summary.dart';
import 'measurement_unit_codes.dart';
import 'seed_data.dart';
import 'sync_pull_payload.dart';

class IsarMeasurementProfileRepository implements MeasurementProfileRepository {
  IsarMeasurementProfileRepository(this._isar);

  final Isar _isar;
  final _uuid = const Uuid();

  @override
  Future<void> seedIfEmpty() async {
    await _seedTypesIfEmpty();
    await _seedProfilesIfEmpty();
  }

  Future<void> _seedTypesIfEmpty() async {
    if (await _isar.measurementTypeEntitys.count() > 0) return;
    final now = DateTime.now();
    final types = [
      (DevSeedIds.mtChest, 'Chest', 10),
      (DevSeedIds.mtWaist, 'Waist', 20),
      (DevSeedIds.mtLength, 'Length', 30),
      (DevSeedIds.mtShoulder, 'Shoulder', 40),
      (DevSeedIds.mtNeck, 'Neck', 50),
      (DevSeedIds.mtSleeve, 'Sleeve', 60),
    ];
    final entities = <MeasurementTypeEntity>[];
    for (final t in types) {
      entities.add(
        MeasurementTypeEntity()
          ..internalId = t.$1
          ..shopId = kDevShopId
          ..name = t.$2
          ..sortOrder = t.$3
          ..isActive = true
          ..createdAt = now
          ..updatedAt = now,
      );
    }
    await _isar.writeTxn(() async {
      await _isar.measurementTypeEntitys.putAll(entities);
    });
  }

  Future<void> _seedProfilesIfEmpty() async {
    if (await _isar.measurementProfileEntitys.count() > 0) return;
    final now = DateTime.now();
    final profiles = [
      MeasurementProfileEntity()
        ..internalId = DevSeedIds.measurementProfile1
        ..shopId = kDevShopId
        ..customerInternalId = DevSeedIds.customer1
        ..label = 'Default'
        ..body = ''
        ..unitCode = MeasurementUnitCodes.cm
        ..createdAt = now
        ..updatedAt = now,
      MeasurementProfileEntity()
        ..internalId = DevSeedIds.measurementProfile2
        ..shopId = kDevShopId
        ..customerInternalId = DevSeedIds.customer2
        ..label = 'Default'
        ..body = ''
        ..unitCode = MeasurementUnitCodes.cm
        ..createdAt = now
        ..updatedAt = now,
    ];

    final items = <MeasurementProfileItemEntity>[
      _item(
        profileId: DevSeedIds.measurementProfile1,
        typeId: DevSeedIds.mtChest,
        value: '98',
      ),
      _item(
        profileId: DevSeedIds.measurementProfile1,
        typeId: DevSeedIds.mtWaist,
        value: '84',
      ),
      _item(
        profileId: DevSeedIds.measurementProfile1,
        typeId: DevSeedIds.mtLength,
        value: '112',
      ),
      _item(
        profileId: DevSeedIds.measurementProfile2,
        typeId: DevSeedIds.mtShoulder,
        value: '46',
      ),
      _item(
        profileId: DevSeedIds.measurementProfile2,
        typeId: DevSeedIds.mtSleeve,
        value: '62',
      ),
    ];

    await _isar.writeTxn(() async {
      await _isar.measurementProfileEntitys.putAll(profiles);
      await _isar.measurementProfileItemEntitys.putAll(items);
    });
  }

  MeasurementProfileItemEntity _item({
    required String profileId,
    required String typeId,
    required String value,
  }) {
    return MeasurementProfileItemEntity()
      ..profileInternalId = profileId
      ..shopId = kDevShopId
      ..measurementTypeInternalId = typeId
      ..value = value
      ..unitCode = MeasurementUnitCodes.cm;
  }

  @override
  Stream<List<MeasurementTypeSummary>> watchActiveMeasurementTypes(
    String shopId,
  ) {
    return _isar.measurementTypeEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .and()
        .deletedAtIsNull()
        .and()
        .isActiveEqualTo(true)
        .watch(fireImmediately: true)
        .map((rows) {
      final list = rows
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
      return list;
    });
  }

  @override
  Stream<List<MeasurementTypeSummary>> watchMeasurementTypesAdmin(
    String shopId,
  ) {
    return _isar.measurementTypeEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .and()
        .deletedAtIsNull()
        .watch(fireImmediately: true)
        .map((rows) {
      final list = rows
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
      return list;
    });
  }

  @override
  Future<String> createMeasurementType({
    required String shopId,
    required String name,
  }) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError.value(name, 'name', 'must not be empty');
    }
    final now = DateTime.now();
    final existing = await _isar.measurementTypeEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .and()
        .deletedAtIsNull()
        .findAll();
    var maxOrder = 0;
    for (final e in existing) {
      if (e.sortOrder > maxOrder) maxOrder = e.sortOrder;
    }
    final id = _uuid.v4();
    final entity = MeasurementTypeEntity()
      ..internalId = id
      ..shopId = shopId
      ..name = trimmed
      ..sortOrder = maxOrder + 10
      ..isActive = true
      ..createdAt = now
      ..updatedAt = now;
    await _isar.writeTxn(() async {
      await _isar.measurementTypeEntitys.putByInternalId(entity);
    });
    return id;
  }

  @override
  Future<void> updateMeasurementType({
    required String internalId,
    required String name,
    required int sortOrder,
    required bool isActive,
  }) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError.value(name, 'name', 'must not be empty');
    }
    await _isar.writeTxn(() async {
      final e =
          await _isar.measurementTypeEntitys.getByInternalId(internalId);
      if (e == null || e.deletedAt != null) return;
      e.name = trimmed;
      e.sortOrder = sortOrder;
      e.isActive = isActive;
      e.updatedAt = DateTime.now();
      await _isar.measurementTypeEntitys.putByInternalId(e);
    });
  }

  @override
  Future<void> softDeleteMeasurementType(String internalId) async {
    await _isar.writeTxn(() async {
      final e =
          await _isar.measurementTypeEntitys.getByInternalId(internalId);
      if (e == null || e.deletedAt != null) return;
      e.deletedAt = DateTime.now();
      e.updatedAt = DateTime.now();
      await _isar.measurementTypeEntitys.putByInternalId(e);
    });
  }

  @override
  Future<void> mergeRemoteMeasurementType({
    required String shopId,
    required String internalId,
    required String operation,
    Object? data,
  }) async {
    if (operation == 'delete') {
      await softDeleteMeasurementType(internalId);
      return;
    }
    final m = syncPullDataMap(data);
    final name = syncPullString(m, const ['name']);
    if (name == null || name.trim().isEmpty) return;
    final sortOrderIn = syncPullInt(m, const ['sort_order', 'sortOrder']);
    final isActive = syncPullBool(m, const ['is_active', 'isActive']) ?? true;
    final now = DateTime.now();
    final createdRemote =
        syncPullDateTime(m, const ['created_at', 'createdAt']) ?? now;
    final updatedRemote =
        syncPullDateTime(m, const ['updated_at', 'updatedAt']) ?? now;

    await _isar.writeTxn(() async {
      final existing =
          await _isar.measurementTypeEntitys.getByInternalId(internalId);
      if (existing == null) {
        final list = await _isar.measurementTypeEntitys
            .filter()
            .shopIdEqualTo(shopId)
            .and()
            .deletedAtIsNull()
            .findAll();
        var maxOrder = 0;
        for (final e in list) {
          if (e.sortOrder > maxOrder) maxOrder = e.sortOrder;
        }
        final so = sortOrderIn ?? maxOrder + 10;
        final e = MeasurementTypeEntity()
          ..internalId = internalId
          ..shopId = shopId
          ..name = name.trim()
          ..sortOrder = so
          ..isActive = isActive
          ..createdAt = createdRemote
          ..updatedAt = updatedRemote
          ..deletedAt = null;
        await _isar.measurementTypeEntitys.putByInternalId(e);
        return;
      }
      existing
        ..shopId = shopId
        ..name = name.trim()
        ..sortOrder = sortOrderIn ?? existing.sortOrder
        ..isActive = isActive
        ..updatedAt = updatedRemote
        ..deletedAt = null;
      await _isar.measurementTypeEntitys.putByInternalId(existing);
    });
  }

  @override
  Stream<List<MeasurementProfileSummary>> watchForCustomer({
    required String shopId,
    required String customerInternalId,
  }) {
    return _isar.measurementProfileEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .and()
        .customerInternalIdEqualTo(customerInternalId)
        .and()
        .deletedAtIsNull()
        .watch(fireImmediately: true)
        .asyncMap((rows) => _hydrateProfiles(rows));
  }

  Future<List<MeasurementProfileSummary>> _hydrateProfiles(
    List<MeasurementProfileEntity> profiles,
  ) async {
    final out = <MeasurementProfileSummary>[];
    for (final e in profiles) {
      final lines = await _linesForProfile(e.internalId);
      out.add(
        MeasurementProfileSummary(
          internalId: e.internalId,
          shopId: e.shopId,
          customerInternalId: e.customerInternalId,
          label: e.label,
          lines: lines,
          notes: e.body,
          unitCode: e.unitCode,
          createdAt: e.createdAt,
          updatedAt: e.updatedAt,
        ),
      );
    }
    out.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return out;
  }

  Future<List<MeasurementProfileLine>> _linesForProfile(
    String profileInternalId,
  ) async {
    final raw = await _isar.measurementProfileItemEntitys
        .filter()
        .profileInternalIdEqualTo(profileInternalId)
        .and()
        .deletedAtIsNull()
        .findAll();
    final withOrder = <({MeasurementProfileLine line, int order})>[];
    for (final it in raw) {
      final t = await _isar.measurementTypeEntitys
          .getByInternalId(it.measurementTypeInternalId);
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

  Future<void> _replaceItemsInTxn({
    required Isar isar,
    required String shopId,
    required String profileInternalId,
    required List<MeasurementProfileItemInput> items,
  }) async {
    await isar.measurementProfileItemEntitys
        .filter()
        .profileInternalIdEqualTo(profileInternalId)
        .deleteAll();
    for (final input in items) {
      if (input.value.trim().isEmpty) continue;
      final row = MeasurementProfileItemEntity()
        ..profileInternalId = profileInternalId
        ..shopId = shopId
        ..measurementTypeInternalId = input.measurementTypeInternalId
        ..value = input.value.trim()
        ..unitCode = input.unitCode;
      await isar.measurementProfileItemEntitys.put(row);
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
    final now = DateTime.now();
    final id = _uuid.v4();
    final e = MeasurementProfileEntity()
      ..internalId = id
      ..shopId = shopId
      ..customerInternalId = customerInternalId
      ..label = label.trim().isEmpty ? '—' : label.trim()
      ..body = notes
      ..unitCode = unitCode
      ..createdAt = now
      ..updatedAt = now;

    await _isar.writeTxn(() async {
      await _isar.measurementProfileEntitys.putByInternalId(e);
      await _replaceItemsInTxn(
        isar: _isar,
        shopId: shopId,
        profileInternalId: id,
        items: items,
      );
    });
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
    await _isar.writeTxn(() async {
      final existing =
          await _isar.measurementProfileEntitys.getByInternalId(internalId);
      if (existing == null) return;
      existing.label = label.trim().isEmpty ? '—' : label.trim();
      existing.body = notes;
      existing.unitCode = unitCode;
      existing.updatedAt = DateTime.now();
      await _isar.measurementProfileEntitys.putByInternalId(existing);
      await _replaceItemsInTxn(
        isar: _isar,
        shopId: existing.shopId,
        profileInternalId: internalId,
        items: items,
      );
    });
  }

  @override
  Future<void> mergeRemoteMeasurementProfile({
    required String shopId,
    required String internalId,
    required String operation,
    Object? data,
  }) async {
    if (operation == 'delete') {
      await _isar.writeTxn(() async {
        final existing =
            await _isar.measurementProfileEntitys.getByInternalId(internalId);
        if (existing == null) return;
        existing
          ..deletedAt = DateTime.now()
          ..updatedAt = DateTime.now();
        await _isar.measurementProfileEntitys.putByInternalId(existing);
        await _isar.measurementProfileItemEntitys
            .filter()
            .profileInternalIdEqualTo(internalId)
            .deleteAll();
      });
      return;
    }
    final m = syncPullDataMap(data);
    final customerId = syncPullString(m, const [
      'customer_internal_id',
      'customerInternalId',
    ]);
    final label = syncPullString(m, const ['label']);
    if (customerId == null || label == null) return;
    final notes = syncPullString(m, const ['notes', 'body']) ?? '';
    final unitCode =
        syncPullInt(m, const ['unit_code', 'unitCode']) ?? MeasurementUnitCodes.cm;
    final created =
        syncPullDateTime(m, const ['created_at', 'createdAt']) ?? DateTime.now();
    final updated =
        syncPullDateTime(m, const ['updated_at', 'updatedAt']) ?? DateTime.now();
    final itemsRaw = m['items'];
    final inputs = <MeasurementProfileItemInput>[];
    if (itemsRaw is List) {
      for (final el in itemsRaw) {
        if (el is! Map) continue;
        final em = Map<String, dynamic>.from(el);
        final tid = syncPullString(em, const [
          'measurement_type_internal_id',
          'measurementTypeInternalId',
        ]);
        final val = syncPullString(em, const ['value']);
        final uc = syncPullInt(em, const ['unit_code', 'unitCode']) ?? unitCode;
        if (tid == null || val == null || val.trim().isEmpty) continue;
        inputs.add(
          MeasurementProfileItemInput(
            measurementTypeInternalId: tid,
            value: val.trim(),
            unitCode: uc,
          ),
        );
      }
    }

    await _isar.writeTxn(() async {
      final existing =
          await _isar.measurementProfileEntitys.getByInternalId(internalId);
      if (existing == null) {
        final e = MeasurementProfileEntity()
          ..internalId = internalId
          ..shopId = shopId
          ..customerInternalId = customerId
          ..label = label.trim().isEmpty ? '—' : label.trim()
          ..body = notes
          ..unitCode = unitCode
          ..createdAt = created
          ..updatedAt = updated
          ..deletedAt = null;
        await _isar.measurementProfileEntitys.putByInternalId(e);
        await _replaceItemsInTxn(
          isar: _isar,
          shopId: shopId,
          profileInternalId: internalId,
          items: inputs,
        );
        return;
      }
      existing
        ..shopId = shopId
        ..customerInternalId = customerId
        ..label = label.trim().isEmpty ? '—' : label.trim()
        ..body = notes
        ..unitCode = unitCode
        ..updatedAt = updated
        ..deletedAt = null;
      await _isar.measurementProfileEntitys.putByInternalId(existing);
      await _replaceItemsInTxn(
        isar: _isar,
        shopId: shopId,
        profileInternalId: internalId,
        items: inputs,
      );
    });
  }
}
