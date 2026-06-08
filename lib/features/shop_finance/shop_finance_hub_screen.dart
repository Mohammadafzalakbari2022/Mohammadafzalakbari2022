import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/app/app_theme.dart';
import 'package:pride_v3/core/calendar/app_calendar_format.dart';
import 'package:pride_v3/core/calendar/app_date_picker.dart';
import 'package:pride_v3/core/calendar/date_calendar_notifier.dart';
import 'package:pride_v3/core/calendar/report_month_period.dart';
import 'package:pride_v3/core/calendar/date_calendar_system.dart';
import 'package:pride_v3/core/formatting/digit_normalizer.dart';
import 'package:pride_v3/core/widgets/pride_money_field.dart';
import 'package:pride_v3/core/widgets/pride_numeric_text_field.dart';
import 'package:pride_v3/l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

import '../../auth/auth_providers.dart';
import '../../data/local/shop_finance_models.dart';
import '../../data/local/sync_outbox_kinds.dart';
import '../../data/providers/local_data_providers.dart';
import '../../features/reports/report_money_format.dart';
import '../../licensing/license_providers.dart';
import '../../shell/shell_sync_providers.dart';

class ShopFinanceHubScreen extends ConsumerStatefulWidget {
  const ShopFinanceHubScreen({super.key});

  @override
  ConsumerState<ShopFinanceHubScreen> createState() =>
      _ShopFinanceHubScreenState();
}

class _ShopFinanceHubScreenState extends ConsumerState<ShopFinanceHubScreen> {
  final _uuid = const Uuid();

  bool _inCurrentMonth(DateTime d, DateTime now, DateCalendarSystem calendar) {
    final start = startOfMonthContaining(now, calendar);
    final end = endExclusiveForMonthStart(start, calendar);
    return !d.isBefore(start) && d.isBefore(end);
  }

  Future<void> _enqueue(
    String kind,
    String entityRef,
    Map<String, dynamic> payload,
  ) async {
    recordSyncOutboxMutation(
      ref,
      kind: kind,
      entityRef: entityRef,
      payloadJson: jsonEncode(payload),
    );
  }

  Future<void> _editRent(
    AppLocalizations l10n,
    ShopRentSummary? existing,
  ) async {
    if (ref.read(licenseEditingBlockedProvider)) return;
    final amountCtrl = TextEditingController(
      text: existing != null ? '${existing.amountMinor}' : '',
    );
    final periodCtrl = TextEditingController(
      text: '${existing?.periodMonths ?? 1}',
    );
    DateTime due = existing?.dueDate ?? DateTime.now().add(const Duration(days: 7));
    final calendar = ref.read(dateCalendarSystemProvider);

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) {
          return AlertDialog(
            title: Text(l10n.shopFinanceAddRent),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PrideMoneyField(
                    controller: amountCtrl,
                    labelText: l10n.shopFinanceAmountLabel,
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.shopFinanceDueDateLabel),
                    subtitle: Text(
                      AppCalendarFormat.mediumDate(
                        l10n,
                        calendar,
                        due,
                        Localizations.localeOf(context).toString(),
                      ),
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final picked = await showAppDatePicker(
                        context: ctx,
                        l10n: l10n,
                        system: calendar,
                        initialDate: due,
                        firstDate: DateTime(DateTime.now().year - 1),
                        lastDate: DateTime(DateTime.now().year + 5),
                      );
                      if (picked != null) {
                        setModal(() => due = picked);
                      }
                    },
                  ),
                  PrideNumericTextField(
                    controller: periodCtrl,
                    labelText: l10n.shopFinancePeriodMonthsLabel,
                    decimal: false,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(l10n.settingsSignOutCancel),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(l10n.shopFinanceSave),
              ),
            ],
          );
        },
      ),
    );
    if (ok != true || !mounted) return;

    final amount = tryParseMoneyAmount(amountCtrl.text);
    final months = int.tryParse(periodCtrl.text.trim()) ?? 1;
    if (amount == null || amount <= 0) return;

    final shopId = ref.read(effectiveShopIdProvider);
    final id = existing?.internalId ?? _uuid.v4();
    final repo = await ref.read(shopFinanceRepositoryProvider.future);
    await repo.upsertRent(
      shopId: shopId,
      internalId: id,
      amountMinor: amount,
      dueDate: due,
      periodMonths: months,
    );
    await _enqueue(
      SyncOutboxKinds.shopRentUpsert,
      id,
      {
        'amount_minor': amount,
        'due_date': DateTime(due.year, due.month, due.day).toIso8601String(),
        'period_months': months,
      },
    );
    amountCtrl.dispose();
    periodCtrl.dispose();
  }

  Future<void> _recordRentPayment(
    AppLocalizations l10n,
    ShopRentSummary rent,
  ) async {
    if (ref.read(licenseEditingBlockedProvider)) return;
    final amountCtrl = TextEditingController(text: '${rent.amountMinor}');
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.shopFinanceRecordRentPayment),
        content: PrideMoneyField(
          controller: amountCtrl,
          labelText: l10n.shopFinanceAmountLabel,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.settingsSignOutCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.shopFinanceSave),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    final amount = tryParseMoneyAmount(amountCtrl.text);
    if (amount == null || amount <= 0) return;

    final shopId = ref.read(effectiveShopIdProvider);
    final payId = _uuid.v4();
    final repo = await ref.read(shopFinanceRepositoryProvider.future);
    await repo.appendRentPayment(
      shopId: shopId,
      rentInternalId: rent.internalId,
      amountMinor: amount,
      paidAt: DateTime.now(),
    );
    await repo.renewRentAfterPayment(rent.internalId);
    await _enqueue(
      SyncOutboxKinds.shopRentPaymentAppend,
      payId,
      {
        'rent_internal_id': rent.internalId,
        'amount_minor': amount,
        'paid_at': DateTime.now().toUtc().toIso8601String(),
        'note': '',
      },
    );
    final updatedRent = await ref.read(shopRentsStreamProvider(shopId).future);
    final current = updatedRent.firstWhere((r) => r.internalId == rent.internalId);
    await _enqueue(
      SyncOutboxKinds.shopRentUpsert,
      rent.internalId,
      {
        'amount_minor': current.amountMinor,
        'due_date': current.dueDate.toIso8601String(),
        'period_months': current.periodMonths,
      },
    );
    amountCtrl.dispose();
  }

  Future<void> _addExpense(AppLocalizations l10n) async {
    if (ref.read(licenseEditingBlockedProvider)) return;
    var category = ShopExpenseCategory.daily;
    final amountCtrl = TextEditingController();
    final noteCtrl = TextEditingController();
    DateTime day = DateTime.now();
    final calendar = ref.read(dateCalendarSystemProvider);

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) {
          return AlertDialog(
            title: Text(l10n.shopFinanceAddExpense),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<ShopExpenseCategory>(
                    initialValue: category,
                    decoration: InputDecoration(
                      labelText: l10n.shopFinanceCategoryLabel,
                    ),
                    items: [
                      DropdownMenuItem(
                        value: ShopExpenseCategory.daily,
                        child: Text(l10n.shopFinanceExpenseDaily),
                      ),
                      DropdownMenuItem(
                        value: ShopExpenseCategory.foodDrinks,
                        child: Text(l10n.shopFinanceExpenseFood),
                      ),
                      DropdownMenuItem(
                        value: ShopExpenseCategory.other,
                        child: Text(l10n.shopFinanceExpenseOther),
                      ),
                    ],
                    onChanged: (v) {
                      if (v != null) setModal(() => category = v);
                    },
                  ),
                  PrideMoneyField(
                    controller: amountCtrl,
                    labelText: l10n.shopFinanceAmountLabel,
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.shopFinanceDateLabel),
                    subtitle: Text(
                      AppCalendarFormat.mediumDate(
                        l10n,
                        calendar,
                        day,
                        Localizations.localeOf(context).toString(),
                      ),
                    ),
                    onTap: () async {
                      final picked = await showAppDatePicker(
                        context: ctx,
                        l10n: l10n,
                        system: calendar,
                        initialDate: day,
                        firstDate: DateTime(DateTime.now().year - 2),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) setModal(() => day = picked);
                    },
                  ),
                  TextField(
                    controller: noteCtrl,
                    decoration: InputDecoration(
                      labelText: l10n.shopFinanceNoteLabel,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(l10n.settingsSignOutCancel),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(l10n.shopFinanceSave),
              ),
            ],
          );
        },
      ),
    );
    if (ok != true || !mounted) return;
    final amount = tryParseMoneyAmount(amountCtrl.text);
    if (amount == null || amount <= 0) return;

    final shopId = ref.read(effectiveShopIdProvider);
    final id = _uuid.v4();
    final repo = await ref.read(shopFinanceRepositoryProvider.future);
    await repo.upsertExpense(
      shopId: shopId,
      internalId: id,
      category: category,
      amountMinor: amount,
      expenseDate: day,
      note: noteCtrl.text.trim(),
    );
    await _enqueue(
      SyncOutboxKinds.shopExpenseUpsert,
      id,
      {
        'category': category.code,
        'amount_minor': amount,
        'expense_date': DateTime(day.year, day.month, day.day).toIso8601String(),
        'note': noteCtrl.text.trim(),
      },
    );
    amountCtrl.dispose();
    noteCtrl.dispose();
  }

  String _categoryLabel(AppLocalizations l10n, ShopExpenseCategory c) {
    return switch (c) {
      ShopExpenseCategory.daily => l10n.shopFinanceExpenseDaily,
      ShopExpenseCategory.foodDrinks => l10n.shopFinanceExpenseFood,
      ShopExpenseCategory.other => l10n.shopFinanceExpenseOther,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final shopId = ref.watch(effectiveShopIdProvider);
    final calendar = ref.watch(dateCalendarSystemProvider);
    final now = DateTime.now();
    final rentsAsync = ref.watch(shopRentsStreamProvider(shopId));
    final paymentsAsync = ref.watch(shopRentPaymentsStreamProvider(shopId));
    final expensesAsync = ref.watch(shopExpensesStreamProvider(shopId));
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.shopFinanceTitle)),
      body: rentsAsync.when(
        data: (rents) => paymentsAsync.when(
          data: (payments) => expensesAsync.when(
            data: (expenses) {
              var monthExpense = 0;
              final byCategory = <ShopExpenseCategory, int>{
                ShopExpenseCategory.daily: 0,
                ShopExpenseCategory.foodDrinks: 0,
                ShopExpenseCategory.other: 0,
              };
              for (final e in expenses) {
                if (_inCurrentMonth(e.expenseDate, now, calendar)) {
                  monthExpense += e.amountMinor;
                  byCategory[e.category] =
                      (byCategory[e.category] ?? 0) + e.amountMinor;
                }
              }

              var rentPaidMonth = 0;
              for (final p in payments) {
                if (_inCurrentMonth(p.paidAt, now, calendar)) {
                  rentPaidMonth += p.amountMinor;
                }
              }

              final primaryRent = rents.isNotEmpty ? rents.first : null;
              final rentPaidTotal = primaryRent == null
                  ? 0
                  : payments
                      .where((p) => p.rentInternalId == primaryRent.internalId)
                      .fold<int>(0, (s, p) => s + p.amountMinor);

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.shopFinanceMonthOutflow,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            reportFormatMoney(
                              l10n,
                              monthExpense + rentPaidMonth,
                            ),
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${l10n.shopFinanceRentPaid}: ${reportFormatMoney(l10n, rentPaidMonth)}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (monthExpense > 0) ...[
                    const SizedBox(height: 16),
                    Text(
                      l10n.shopFinanceChartsExpensesByCategory,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 180,
                      child: PieChart(
                        PieChartData(
                          sections: [
                            for (final cat in ShopExpenseCategory.values)
                              if ((byCategory[cat] ?? 0) > 0)
                                PieChartSectionData(
                                  value: (byCategory[cat] ?? 0).toDouble(),
                                  title: _categoryLabel(l10n, cat),
                                  color: switch (cat) {
                                    ShopExpenseCategory.daily =>
                                      scheme.primary,
                                    ShopExpenseCategory.foodDrinks =>
                                      scheme.secondary,
                                    ShopExpenseCategory.other =>
                                      scheme.tertiary,
                                  },
                                  radius: 48,
                                  titleStyle: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(color: Colors.white),
                                ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Text(
                    l10n.shopFinanceRentTitle,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  if (primaryRent == null)
                    Text(l10n.shopFinanceEmptyRent)
                  else ...[
                    ListTile(
                      title: Text(
                        reportFormatMoney(l10n, primaryRent.amountMinor),
                      ),
                      subtitle: Text(
                        '${l10n.shopFinanceDueDateLabel}: ${AppCalendarFormat.mediumDate(l10n, calendar, primaryRent.dueDate, Localizations.localeOf(context).toString())}',
                      ),
                      trailing: rentPaidTotal < primaryRent.amountMinor
                          ? Chip(
                              label: Text(l10n.shopFinanceRentDue),
                              backgroundColor: scheme.errorContainer,
                            )
                          : null,
                    ),
                    Wrap(
                      spacing: 8,
                      children: [
                        FilledButton(
                          onPressed: () => _editRent(l10n, primaryRent),
                          child: Text(l10n.shopFinanceAddRent),
                        ),
                        OutlinedButton(
                          onPressed: () =>
                              _recordRentPayment(l10n, primaryRent),
                          child: Text(l10n.shopFinanceRecordRentPayment),
                        ),
                      ],
                    ),
                  ],
                  if (primaryRent == null)
                    FilledButton(
                      onPressed: () => _editRent(l10n, null),
                      style: prideButtonStyle(context, PrideButtonVariant.add),
                      child: Text(l10n.shopFinanceAddRent),
                    ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.shopFinanceExpensesTitle,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      FilledButton.icon(
                        onPressed: () => _addExpense(l10n),
                        style: prideButtonStyle(context, PrideButtonVariant.add),
                        icon: const Icon(Icons.add, size: 20),
                        label: Text(l10n.shopFinanceAddExpense),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (expenses.isEmpty)
                    Text(l10n.shopFinanceEmptyExpenses)
                  else
                    ...expenses.take(40).map(
                          (e) => ListTile(
                            title: Text(reportFormatMoney(l10n, e.amountMinor)),
                            subtitle: Text(
                              '${_categoryLabel(l10n, e.category)} · ${AppCalendarFormat.mediumDate(l10n, calendar, e.expenseDate, Localizations.localeOf(context).toString())}',
                            ),
                          ),
                        ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('$e')),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
      ),
    );
  }
}
