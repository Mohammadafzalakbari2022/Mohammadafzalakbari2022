import 'dart:async';

import 'package:uuid/uuid.dart';

import 'shop_finance_models.dart';
import 'shop_finance_repository.dart';

class MemoryShopFinanceRepository implements ShopFinanceRepository {
  final List<ShopRentSummary> _rents = [];
  final List<ShopRentPaymentSummary> _payments = [];
  final List<ShopExpenseSummary> _expenses = [];
  final _controller = StreamController<void>.broadcast();
  final _uuid = const Uuid();

  void _emit() => _controller.add(null);

  List<ShopRentSummary> _sortedRents(String shopId) {
    final list = _rents.where((r) => r.shopId == shopId).toList();
    list.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return list;
  }

  List<ShopRentPaymentSummary> _sortedPayments(String shopId) {
    final list = _payments.where((p) => p.shopId == shopId).toList();
    list.sort((a, b) => b.paidAt.compareTo(a.paidAt));
    return list;
  }

  List<ShopExpenseSummary> _sortedExpenses(String shopId) {
    final list = _expenses.where((e) => e.shopId == shopId).toList();
    list.sort((a, b) => b.expenseDate.compareTo(a.expenseDate));
    return list;
  }

  @override
  Stream<List<ShopRentSummary>> watchRents(String shopId) async* {
    yield _sortedRents(shopId);
    yield* _controller.stream.map((_) => _sortedRents(shopId));
  }

  @override
  Stream<List<ShopRentPaymentSummary>> watchRentPayments(String shopId) async* {
    yield _sortedPayments(shopId);
    yield* _controller.stream.map((_) => _sortedPayments(shopId));
  }

  @override
  Stream<List<ShopExpenseSummary>> watchExpenses(String shopId) async* {
    yield _sortedExpenses(shopId);
    yield* _controller.stream.map((_) => _sortedExpenses(shopId));
  }

  @override
  Future<void> upsertRent({
    required String shopId,
    required String internalId,
    required int amountMinor,
    required DateTime dueDate,
    required int periodMonths,
  }) async {
    final due = DateTime(dueDate.year, dueDate.month, dueDate.day);
    final idx = _rents.indexWhere((r) => r.internalId == internalId);
    final row = ShopRentSummary(
      internalId: internalId,
      shopId: shopId,
      amountMinor: amountMinor,
      dueDate: due,
      periodMonths: periodMonths < 1 ? 1 : periodMonths,
      updatedAt: DateTime.now(),
    );
    if (idx >= 0) {
      _rents[idx] = row;
    } else {
      _rents.add(row);
    }
    _emit();
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
    _payments.add(
      ShopRentPaymentSummary(
        internalId: internalId ?? _uuid.v4(),
        shopId: shopId,
        rentInternalId: rentInternalId,
        amountMinor: amountMinor,
        paidAt: paidAt,
        note: note,
      ),
    );
    _emit();
  }

  @override
  Future<void> renewRentAfterPayment(String rentInternalId) async {
    final idx = _rents.indexWhere((r) => r.internalId == rentInternalId);
    if (idx < 0) return;
    final rent = _rents[idx];
    final months = rent.periodMonths < 1 ? 1 : rent.periodMonths;
    _rents[idx] = ShopRentSummary(
      internalId: rent.internalId,
      shopId: rent.shopId,
      amountMinor: rent.amountMinor,
      dueDate: DateTime(
        rent.dueDate.year,
        rent.dueDate.month + months,
        rent.dueDate.day,
      ),
      periodMonths: rent.periodMonths,
      updatedAt: DateTime.now(),
    );
    _emit();
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
    final day =
        DateTime(expenseDate.year, expenseDate.month, expenseDate.day);
    final idx = _expenses.indexWhere((e) => e.internalId == internalId);
    final row = ShopExpenseSummary(
      internalId: internalId,
      shopId: shopId,
      category: category,
      amountMinor: amountMinor,
      expenseDate: day,
      note: note,
      updatedAt: DateTime.now(),
    );
    if (idx >= 0) {
      _expenses[idx] = row;
    } else {
      _expenses.add(row);
    }
    _emit();
  }

  @override
  Future<void> deleteExpense(String internalId) async {
    _expenses.removeWhere((e) => e.internalId == internalId);
    _emit();
  }

  @override
  Future<void> clearExpensesBefore(String shopId, DateTime before) async {
    _expenses.removeWhere(
      (e) => e.shopId == shopId && e.expenseDate.isBefore(before),
    );
    _emit();
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
      _rents.removeWhere((r) => r.internalId == internalId);
      _emit();
      return;
    }
    if (operation != 'upsert' || data is! Map) return;
    final m = Map<String, dynamic>.from(data);
    final amount = m['amount_minor'];
    final dueRaw = m['due_date'];
    if (amount is! int || dueRaw is! String) return;
    final due = DateTime.tryParse(dueRaw);
    if (due == null) return;
    await upsertRent(
      shopId: shopId,
      internalId: internalId,
      amountMinor: amount,
      dueDate: due,
      periodMonths: m['period_months'] is int ? m['period_months'] as int : 1,
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
    if (_payments.any((p) => p.internalId == internalId)) return;
    final m = Map<String, dynamic>.from(data);
    final rentId = m['rent_internal_id'];
    final amount = m['amount_minor'];
    final paidRaw = m['paid_at'];
    if (rentId is! String || amount is! int || paidRaw is! String) return;
    final paidAt = DateTime.tryParse(paidRaw);
    if (paidAt == null) return;
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
}
