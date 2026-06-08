import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/core/calendar/app_calendar_format.dart';
import 'package:pride_v3/core/calendar/date_calendar_notifier.dart';
import 'package:pride_v3/core/calendar/date_calendar_system.dart';
import 'package:pride_v3/core/calendar/report_month_period.dart';
import 'package:pride_v3/core/widgets/customer_id_badge.dart';
import 'package:pride_v3/core/widgets/order_id_label.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../auth/auth_providers.dart';
import '../../data/local/customer_display_no.dart';
import '../../data/local/order_internal_ids_lookup_key.dart';
import '../../data/local/order_summary.dart';
import '../../data/local/payment_summary.dart';
import '../../data/providers/local_data_providers.dart';
import 'report_money_format.dart';

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// Monday-start week bucket (local time), for ledger grouping.
DateTime _mondayWeekStart(DateTime d) {
  final day = _dateOnly(d);
  return day.subtract(Duration(days: day.weekday - 1));
}

enum _LedgerGroupMode { day, week, month }

class PaymentsLedgerReportScreen extends ConsumerStatefulWidget {
  const PaymentsLedgerReportScreen({super.key});

  @override
  ConsumerState<PaymentsLedgerReportScreen> createState() =>
      _PaymentsLedgerReportScreenState();
}

class _PaymentsLedgerReportScreenState
    extends ConsumerState<PaymentsLedgerReportScreen> {
  DateTimeRange? _range;
  _LedgerGroupMode _groupMode = _LedgerGroupMode.day;

  DateTimeRange _defaultRange() {
    final now = DateTime.now();
    final end = _dateOnly(now).add(const Duration(days: 1));
    final start = _dateOnly(now.subtract(const Duration(days: 30)));
    return DateTimeRange(start: start, end: end);
  }

  DateTimeRange _effectiveRange() => _range ??= _defaultRange();

  Future<void> _pickRange(AppLocalizations l10n) async {
    final cur = _effectiveRange();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: cur,
      helpText: l10n.reportsPaymentsPickRange,
      saveText: l10n.reportsPaymentsApplyRange,
    );
    if (picked == null) return;
    setState(() => _range = picked);
  }

  List<PaymentSummary> _filterPayments(
    List<PaymentSummary> all,
    DateTimeRange range,
  ) {
    return all
        .where(
          (p) => !p.createdAt.isBefore(range.start) && p.createdAt.isBefore(
                range.end,
              ),
        )
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Widget _paymentTile(
    BuildContext context,
    AppLocalizations l10n,
    String locale,
    DateCalendarSystem calendar,
    PaymentSummary p,
    Map<String, OrderSummary> byOrderId,
    Map<String, String> customerDisplayNoById,
  ) {
    final o = byOrderId[p.orderInternalId];
    final customerNo =
        o == null ? '' : (customerDisplayNoById[o.customerInternalId] ?? '');
    final title = o == null
        ? Text(l10n.reportsPaymentsUnknownOrder)
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (parseStoredDisplayCustomerNo(customerNo) > 0) ...[
                CustomerIdBadge(
                  storedCustomerNo: customerNo,
                  compact: true,
                ),
                const SizedBox(height: 6),
              ],
              Text(
                o.customerName,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 2),
              OrderIdLabel(storedOrderNo: o.displayOrderNo),
            ],
          );
    final dateLineRow = AppCalendarFormat.mediumDate(
      l10n,
      calendar,
      p.createdAt,
      locale,
    );
    final subtitleParts = <String>[
      dateLineRow,
      if (p.method.isNotEmpty) p.method,
      if (p.isAdjustment) l10n.reportsPaymentsAdjustmentChip,
    ];
    return Card(
      child: ListTile(
        title: title,
        subtitle: Text(subtitleParts.join(' · ')),
        trailing: Chip(
          label: Text(reportFormatMoneyDelta(l10n, p.amountMinor)),
        ),
        onTap: o == null
            ? null
            : () => context.push('/app/orders/${o.internalId}'),
      ),
    );
  }

  List<Widget> _ledgerGroupedSections(
    BuildContext context,
    AppLocalizations l10n,
    String locale,
    DateCalendarSystem calendar,
    _LedgerGroupMode mode,
    List<PaymentSummary> list,
    Map<String, OrderSummary> byOrderId,
    Map<String, String> customerDisplayNoById,
  ) {
    final theme = Theme.of(context);
    final byBucket = <DateTime, List<PaymentSummary>>{};
    for (final p in list) {
      final key = switch (mode) {
        _LedgerGroupMode.day => _dateOnly(p.createdAt),
        _LedgerGroupMode.week => _mondayWeekStart(p.createdAt),
        _LedgerGroupMode.month =>
          startOfMonthContaining(p.createdAt, calendar),
      };
      byBucket.putIfAbsent(key, () => []).add(p);
    }
    final keys = byBucket.keys.toList()..sort((a, b) => b.compareTo(a));
    final out = <Widget>[];
    for (final key in keys) {
      final group = byBucket[key]!
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      final sum = group.fold<int>(0, (s, p) => s + p.amountMinor);
      final title = switch (mode) {
        _LedgerGroupMode.day => AppCalendarFormat.mediumDate(
            l10n,
            calendar,
            key,
            locale,
          ),
        _LedgerGroupMode.week => l10n.reportsPaymentsWeekOfLabel(
            AppCalendarFormat.mediumDate(l10n, calendar, key, locale),
          ),
        _LedgerGroupMode.month => AppCalendarFormat.monthYearHeading(
            l10n,
            calendar,
            key,
            locale,
          ),
      };
      out.add(
        Padding(
          padding: const EdgeInsets.only(left: 4, right: 4, top: 8, bottom: 4),
          child: Text(
            l10n.reportsPaymentsSectionHeader(
              title,
              reportFormatMoneyDelta(l10n, sum),
            ),
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      );
      for (final p in group) {
        out.add(
          _paymentTile(
            context,
            l10n,
            locale,
            calendar,
            p,
            byOrderId,
            customerDisplayNoById,
          ),
        );
      }
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final calendar = ref.watch(dateCalendarSystemProvider);
    final range = _effectiveRange();

    final shopId = ref.watch(effectiveShopIdProvider);
    final asyncPayments = ref.watch(paymentsForShopProvider(shopId));
    final asyncCustomers = ref.watch(customersListStreamProvider);

    final orderLookupKey = asyncPayments.maybeWhen(
      data: (payments) => orderInternalIdsLookupKey(
        payments.map((p) => p.orderInternalId),
      ),
      orElse: () => '',
    );
    final asyncOrderLookup = ref.watch(
      ordersByInternalIdsProvider(orderLookupKey),
    );

    final customerDisplayNoById = asyncCustomers.maybeWhen(
      data: (customers) => <String, String>{
        for (final c in customers) c.internalId: c.displayCustomerNo,
      },
      orElse: () => const <String, String>{},
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.reportsPaymentsLedgerTitle),
        actions: [
          IconButton(
            tooltip: l10n.reportsPaymentsPickRange,
            icon: const Icon(Icons.date_range),
            onPressed: () => _pickRange(l10n),
          ),
        ],
      ),
      body: asyncPayments.when(
        data: (payments) {
          return asyncOrderLookup.when(
            data: (byOrderId) {
              final list = _filterPayments(payments, range);
              final totalMinor =
                  list.fold<int>(0, (s, p) => s + p.amountMinor);

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            l10n.reportsPaymentsSelectedRangeLabel,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 6),
                          FilledButton.tonalIcon(
                            onPressed: () => _pickRange(l10n),
                            icon: const Icon(Icons.date_range),
                            label: Text(
                              l10n.reportsPaymentsRangeValue(
                                AppCalendarFormat.mediumDate(
                                  l10n,
                                  calendar,
                                  range.start,
                                  locale,
                                ),
                                AppCalendarFormat.mediumDate(
                                  l10n,
                                  calendar,
                                  range.end.subtract(const Duration(days: 1)),
                                  locale,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: Text(l10n.reportsPaymentsTotalLabel),
                              ),
                              Text(
                                reportFormatMoneyDelta(l10n, totalMinor),
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            l10n.reportsPaymentsGroupByLabel,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 8),
                          SegmentedButton<_LedgerGroupMode>(
                            segments: [
                              ButtonSegment(
                                value: _LedgerGroupMode.day,
                                label: Text(l10n.reportsPaymentsGroupByDay),
                              ),
                              ButtonSegment(
                                value: _LedgerGroupMode.week,
                                label: Text(l10n.reportsPaymentsGroupByWeek),
                              ),
                              ButtonSegment(
                                value: _LedgerGroupMode.month,
                                label: Text(l10n.reportsPaymentsGroupByMonth),
                              ),
                            ],
                            selected: {_groupMode},
                            onSelectionChanged: (s) {
                              setState(() => _groupMode = s.first);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (list.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: Text(
                          l10n.reportsPaymentsEmpty,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  else
                    ..._ledgerGroupedSections(
                      context,
                      l10n,
                      locale,
                      calendar,
                      _groupMode,
                      list,
                      byOrderId,
                      customerDisplayNoById,
                    ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  l10n.reportsPaymentsLoadError,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              l10n.reportsPaymentsLoadError,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

