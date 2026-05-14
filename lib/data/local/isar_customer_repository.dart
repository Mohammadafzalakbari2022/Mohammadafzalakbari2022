import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

import 'customer_list_repository.dart';
import 'customer_summary.dart';
import 'dev_shop_constants.dart';
import 'entities/customer_entity.dart';
import 'sync_pull_payload.dart';

class IsarCustomerRepository implements CustomerListRepository {
  IsarCustomerRepository(this._isar);

  final Isar _isar;
  final _uuid = const Uuid();

  static String? _opt(String? v) {
    if (v == null || v.trim().isEmpty) return null;
    return v.trim();
  }

  @override
  Future<void> seedIfEmpty() async {
    // Seed happens in IsarOrderRepository so customers exist together with orders.
    // Keep this no-op so callers can always invoke seedIfEmpty() safely.
    if (await _isar.customerEntitys.count() == 0) {
      // no-op
    }
  }

  @override
  Stream<List<CustomerSummary>> watchCustomers([String shopId = kDevShopId]) {
    final query = _isar.customerEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .and()
        .deletedAtIsNull()
        .sortByName()
        .watch(fireImmediately: true);

    return query.map(
      (rows) => rows
          .map(
            (c) => CustomerSummary(
              shopId: c.shopId,
              internalId: c.internalId,
              name: c.name,
              phone: c.phone,
              address: c.address,
              notes: c.notes,
              createdAt: c.createdAt,
            ),
          )
          .toList(),
    );
  }

  @override
  Future<String> createCustomer({
    required String shopId,
    required String name,
    String? phone,
    String? address,
    String? notes,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now();
    final e = CustomerEntity()
      ..internalId = id
      ..shopId = shopId
      ..name = name.trim()
      ..phone = _opt(phone)
      ..address = _opt(address)
      ..notes = _opt(notes)
      ..createdAt = now;

    await _isar.writeTxn(() async {
      await _isar.customerEntitys.putByInternalId(e);
    });
    return id;
  }

  Future<CustomerEntity?> getByInternalId(String id) {
    return _isar.customerEntitys.getByInternalId(id);
  }

  @override
  Future<void> updateCustomer({
    required String internalId,
    required String name,
    String? phone,
    String? address,
    String? notes,
  }) async {
    await _isar.writeTxn(() async {
      final existing = await _isar.customerEntitys.getByInternalId(internalId);
      if (existing == null || existing.deletedAt != null) return;
      existing.name = name.trim();
      existing.phone = _opt(phone);
      existing.address = _opt(address);
      existing.notes = _opt(notes);
      await _isar.customerEntitys.putByInternalId(existing);
    });
  }

  @override
  Future<void> softDeleteCustomer(String internalId) async {
    await _isar.writeTxn(() async {
      final existing = await _isar.customerEntitys.getByInternalId(internalId);
      if (existing == null || existing.deletedAt != null) return;
      existing.deletedAt = DateTime.now();
      await _isar.customerEntitys.putByInternalId(existing);
    });
  }

  @override
  Future<void> mergeRemoteCustomer({
    required String shopId,
    required String internalId,
    required String operation,
    Object? data,
  }) async {
    if (operation == 'delete') {
      await softDeleteCustomer(internalId);
      return;
    }
    final m = syncPullDataMap(data);
    final name = syncPullString(m, const ['name']);
    if (name == null || name.trim().isEmpty) return;
    final createdAt =
        syncPullDateTime(m, const ['created_at', 'createdAt']) ?? DateTime.now();
    await _isar.writeTxn(() async {
      final existing = await _isar.customerEntitys.getByInternalId(internalId);
      if (existing == null) {
        final e = CustomerEntity()
          ..internalId = internalId
          ..shopId = shopId
          ..name = name.trim()
          ..phone = _opt(syncPullString(m, const ['phone']))
          ..address = _opt(syncPullString(m, const ['address']))
          ..notes = _opt(syncPullString(m, const ['notes']))
          ..createdAt = createdAt
          ..deletedAt = null;
        await _isar.customerEntitys.putByInternalId(e);
        return;
      }
      existing
        ..shopId = shopId
        ..name = name.trim()
        ..phone = _opt(syncPullString(m, const ['phone']))
        ..address = _opt(syncPullString(m, const ['address']))
        ..notes = _opt(syncPullString(m, const ['notes']))
        ..deletedAt = null;
      await _isar.customerEntitys.putByInternalId(existing);
    });
  }
}
