import 'dart:convert';

import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

import 'entities/shop_expense_entity.dart';
import 'entities/shop_rent_entity.dart';
import 'entities/shop_rent_payment_entity.dart';
import 'shop_finance_models.dart';
import 'shop_finance_repository.dart';

class IsarShopFinanceRepository implements ShopFinanceRepository {
  IsarShopFinanceRepository(this._isar);

  final Isar _isar;
  final _uuid = const Uuid();

  ShopRentSummary _mapRent(ShopRentEntity e) => ShopRentSummary(
        internalId: e.internalId,
        shopId: e.shopId,
        amountMinor: e.amountMinor,
        dueDate: DateTime(e.dueDate.year, e.dueDate.month, e.dueDate.day),
        periodMonths: e.periodMonths,
        updatedAt: e.updatedAt,
      );

  ShopRentPaymentSummary _mapPay(ShopRentPaymentEntity e) =>
      ShopRentPaymentSummary(
        internalId: e.internalId,
        shopId: e.shopId,
        rentInternalId: e.rentInternalId,
        amountMinor: e.amountMinor,
        paidAt: e.paidAt,
        note: e.note,
      );

  ShopExpenseSummary _mapExpense(ShopExpenseEntity e) => ShopExpenseSummary(
        internalId: e.internalId,
        shopId: e.shopId,
        category: ShopExpenseCategory.fromCode(e.category),
        amountMinor: e.amountMinor,
        expenseDate:
            DateTime(e.expenseDate.year, e.expenseDate.month, e.expenseDate.day),
        note: e.note,
        updatedAt: e.updatedAt,
      );

  @override
  Stream<List<ShopRentSummary>> watchRents(String shopId) {
    return _isar.shopRentEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .deletedAtIsNull()
        .sortByDueDate()
        .watch(fireImmediately: true)
        .map((rows) => rows.map(_mapRent).toList());
  }

  @override
  Stream<List<ShopRentPaymentSummary>> watchRentPayments(String shopId) {
    return _isar.shopRentPaymentEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .sortByPaidAtDesc()
        .watch(fireImmediately: true)
        .map((rows) => rows.map(_mapPay).toList());
  }

  @override
  Stream<List<ShopExpenseSummary>> watchExpenses(String shopId) {
    return _isar.shopExpenseEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .deletedAtIsNull()
        .sortByExpenseDateDesc()
        .watch(fireImmediately: true)
        .map((rows) => rows.map(_mapExpense).toList());
  }

  @override
  Future<void> upsertRent({
    required String shopId,
    required String internalId,
    required int amountMinor,
    required DateTime dueDate,
    required int periodMonths,
  }) async {
    final now = DateTime.now();
    final due = DateTime(dueDate.year, dueDate.month, dueDate.day);
    await _isar.writeTxn(() async {
      final existing =
          await _isar.shopRentEntitys.getByInternalId(internalId);
      final e = existing ?? ShopRentEntity()
        ..internalId = internalId
        ..shopId = shopId
        ..createdAt = existing?.createdAt ?? now;
      e.amountMinor = amountMinor;
      e.dueDate = due;
      e.periodMonths = periodMonths < 1 ? 1 : periodMonths;
      e.updatedAt = now;
      e.deletedAt = null;
      await _isar.shopRentEntitys.putByInternalId(e);
    });
  }

  @override
  Future<void> appendRentPayment({
    required String shopId,
    required String rentInternalId,
    required int amountMinor,
    required DateTime paidAt,
    String note = '',
    String? internalId,
  }) async {
    final id = internalId ?? _uuid.v4();
    final e = ShopRentPaymentEntity()
      ..internalId = id
      ..shopId = shopId
      ..rentInternalId = rentInternalId
      ..amountMinor = amountMinor
      ..paidAt = paidAt
      ..note = note
      ..createdAt = DateTime.now();
    await _isar.writeTxn(() async {
      await _isar.shopRentPaymentEntitys.putByInternalId(e);
    });
  }

  @override
  Future<void> renewRentAfterPayment(String rentInternalId) async {
    await _isar.writeTxn(() async {
      final rent = await _isar.shopRentEntitys.getByInternalId(rentInternalId);
      if (rent == null) return;
      final months = rent.periodMonths < 1 ? 1 : rent.periodMonths;
      final next = DateTime(
        rent.dueDate.year,
        rent.dueDate.month + months,
        rent.dueDate.day,
      );
      rent.dueDate = next;
      rent.updatedAt = DateTime.now();
      await _isar.shopRentEntitys.putByInternalId(rent);
    });
  }

  @override
  Future<void> upsertExpense({
    required String shopId,
    required String internalId,
    required ShopExpenseCategory category,
    required int amountMinor,
    required DateTime expenseDate,
    String note = '',
  }) async {
    final now = DateTime.now();
    final day =
        DateTime(expenseDate.year, expenseDate.month, expenseDate.day);
    await _isar.writeTxn(() async {
      final existing =
          await _isar.shopExpenseEntitys.getByInternalId(internalId);
      final e = existing ?? ShopExpenseEntity()
        ..internalId = internalId
        ..shopId = shopId
        ..createdAt = existing?.createdAt ?? now;
      e.category = category.code;
      e.amountMinor = amountMinor;
      e.expenseDate = day;
      e.note = note;
      e.updatedAt = now;
      e.deletedAt = null;
      await _isar.shopExpenseEntitys.putByInternalId(e);
    });
  }

  @override
  Future<void> deleteExpense(String internalId) async {
    await _isar.writeTxn(() async {
      final e = await _isar.shopExpenseEntitys.getByInternalId(internalId);
      if (e == null) return;
      e.deletedAt = DateTime.now();
      e.updatedAt = DateTime.now();
      await _isar.shopExpenseEntitys.putByInternalId(e);
    });
  }

  @override
  Future<void> clearExpensesBefore(String shopId, DateTime before) async {
    await _isar.writeTxn(() async {
      final list = await _isar.shopExpenseEntitys
          .filter()
          .shopIdEqualTo(shopId)
          .expenseDateLessThan(before)
          .deletedAtIsNull()
          .findAll();
      final now = DateTime.now();
      for (final e in list) {
        e.deletedAt = now;
        e.updatedAt = now;
        await _isar.shopExpenseEntitys.putByInternalId(e);
      }
    });
  }

  @override
  int totalPaidForRent(
    String rentInternalId,
    List<ShopRentPaymentSummary> payments,
  ) {
    return payments
        .where((p) => p.rentInternalId == rentInternalId)
        .fold<int>(0, (s, p) => s + p.amountMinor);
  }

  @override
  Future<void> mergeRemoteRent({
    required String shopId,
    required String internalId,
    required String operation,
    Object? data,
  }) async {
    if (operation == 'delete') {
      await _isar.writeTxn(() async {
        final e = await _isar.shopRentEntitys.getByInternalId(internalId);
        if (e == null) return;
        e.deletedAt = DateTime.now();
        await _isar.shopRentEntitys.putByInternalId(e);
      });
      return;
    }
    if (operation != 'upsert' || data is! Map) return;
    final m = Map<String, dynamic>.from(data);
    final amount = m['amount_minor'];
    final dueRaw = m['due_date'];
    final period = m['period_months'];
    if (amount is! int || dueRaw is! String) return;
    final due = DateTime.tryParse(dueRaw);
    if (due == null) return;
    await upsertRent(
      shopId: shopId,
      internalId: internalId,
      amountMinor: amount,
      dueDate: due,
      periodMonths: period is int ? period : 1,
    );
  }

  @override
  Future<void> mergeRemoteRentPayment({
    required String shopId,
    required String internalId,
    required String operation,
    Object? data,
  }) async {
    if (operation != 'upsert' || data is! Map) return;
    final m = Map<String, dynamic>.from(data);
    final rentId = m['rent_internal_id'];
    final amount = m['amount_minor'];
    final paidRaw = m['paid_at'];
    if (rentId is! String || amount is! int || paidRaw is! String) return;
    final paidAt = DateTime.tryParse(paidRaw);
    if (paidAt == null) return;
    final existing =
        await _isar.shopRentPaymentEntitys.getByInternalId(internalId);
    if (existing != null) return;
    await appendRentPayment(
      shopId: shopId,
      rentInternalId: rentId,
      amountMinor: amount,
      paidAt: paidAt,
      note: m['note'] is String ? m['note'] as String : '',
      internalId: internalId,
    );
  }

  @override
  Future<void> mergeRemoteExpense({
    required String shopId,
    required String internalId,
    required String operation,
    Object? data,
  }) async {
    if (operation == 'delete') {
      await deleteExpense(internalId);
      return;
    }
    if (operation != 'upsert' || data is! Map) return;
    final m = Map<String, dynamic>.from(data);
    final amount = m['amount_minor'];
    final cat = m['category'];
    final dateRaw = m['expense_date'];
    if (amount is! int || cat is! int || dateRaw is! String) return;
    final expenseDate = DateTime.tryParse(dateRaw);
    if (expenseDate == null) return;
    await upsertExpense(
      shopId: shopId,
      internalId: internalId,
      category: ShopExpenseCategory.fromCode(cat),
      amountMinor: amount,
      expenseDate: expenseDate,
      note: m['note'] is String ? m['note'] as String : '',
    );
  }

  Map<String, dynamic> rentPayload(ShopRentEntity e) => {
        'amount_minor': e.amountMinor,
        'due_date': DateTime(e.dueDate.year, e.dueDate.month, e.dueDate.day)
            .toIso8601String(),
        'period_months': e.periodMonths,
      };

  Map<String, dynamic> rentPaymentPayload(ShopRentPaymentEntity e) => {
        'rent_internal_id': e.rentInternalId,
        'amount_minor': e.amountMinor,
        'paid_at': e.paidAt.toUtc().toIso8601String(),
        'note': e.note,
      };

  Map<String, dynamic> expensePayload(ShopExpenseEntity e) => {
        'category': e.category,
        'amount_minor': e.amountMinor,
        'expense_date': DateTime(
          e.expenseDate.year,
          e.expenseDate.month,
          e.expenseDate.day,
        ).toIso8601String(),
        'note': e.note,
      };

  String encodePayload(Map<String, dynamic> map) => jsonEncode(map);
}
