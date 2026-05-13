import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/core/calendar/app_calendar_format.dart';
import 'package:pride_v3/core/calendar/date_calendar_notifier.dart';
import 'package:pride_v3/core/calendar/date_calendar_system.dart';
import 'package:pride_v3/core/calendar/report_month_period.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/local/dev_shop_constants.dart';
import '../../data/local/order_summary.dart';
import '../../data/providers/local_data_providers.dart';
import 'report_money_format.dart';

class MonthlyIncomeReportScreen extends ConsumerStatefulWidget {
  const MonthlyIncomeReportScreen({super.key});

  @override
  ConsumerState<MonthlyIncomeReportScreen> createState() =>
      _MonthlyIncomeReportScreenState();
}

class _MonthlyIncomeReportScreenState
    extends ConsumerState<MonthlyIncomeReportScreen> {
  DateTime? _periodStart;
  bool _compareWithPrevious = false;

  DateTime _monthStart(DateCalendarSystem sys) =>
      _periodStart ??= startOfMonthContaining(DateTime.now(), sys);

  bool _canGoNext(DateTime start, DateCalendarSystem sys) =>
      canAdvanceReportMonth(start, sys);

  int _unpaidDueInMonth(
    List<OrderSummary> orders,
    DateTime start,
    DateTime end,
  ) {
    var sum = 0;
    for (final o in orders) {
      if (o.remainingAmountMinor <= 0) continue;
      if (o.deliveryDate.isBefore(start) || !o.deliveryDate.isBefore(end)) {
        continue;
      }
      sum += o.remainingAmountMinor;
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final sys = ref.watch(dateCalendarSystemProvider);
    ref.listen<DateCalendarSystem>(dateCalendarSystemProvider, (prev, next) {
      if (prev != null && prev != next) {
        setState(() {
          _periodStart = startOfMonthContaining(DateTime.now(), next);
        });
      }
    });

    final start = _monthStart(sys);
    final end = endExclusiveForMonthStart(start, sys);
    final canNext = _canGoNext(start, sys);

    final asyncPayments = ref.watch(paymentsForShopProvider(kDevShopId));
    final asyncOrders = ref.watch(ordersListStreamProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.reportsMonthlyIncomeTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => setState(() {
                  _periodStart = subtractOneCalendarMonth(start, sys);
                }),
                icon: const Icon(Icons.chevron_left),
                tooltip: l10n.reportsPrevMonth,
              ),
              Expanded(
                child: Center(
                  child: Text(
                    AppCalendarFormat.monthYearHeading(l10n, sys, start, locale),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
              IconButton(
                onPressed: canNext
                    ? () => setState(() {
                          _periodStart = addOneCalendarMonth(start, sys);
                        })
                    : null,
                icon: const Icon(Icons.chevron_right),
                tooltip: l10n.reportsNextMonth,
              ),
            ],
          ),
          const SizedBox(height: 12),
          asyncPayments.when(
            data: (payments) {
              final inMonth = payments.where((p) {
                return !p.createdAt.isBefore(start) && p.createdAt.isBefore(end);
              }).toList();
              final incomeMinor =
                  inMonth.fold<int>(0, (s, p) => s + p.amountMinor);

              final prevStart = subtractOneCalendarMonth(start, sys);
              final prevInMonth = payments.where((p) {
                return !p.createdAt.isBefore(prevStart) &&
                    p.createdAt.isBefore(start);
              }).toList();
              final prevIncomeMinor =
                  prevInMonth.fold<int>(0, (s, p) => s + p.amountMinor);
              final delta = incomeMinor - prevIncomeMinor;

              final scheme = Theme.of(context).colorScheme;
              final deltaStyle = Theme.of(context).textTheme.titleMedium;
              final deltaColor = delta == 0
                  ? scheme.onSurfaceVariant
                  : (delta > 0 ? scheme.primary : scheme.error);

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(l10n.reportsMonthlyIncomeCardLabel),
                          ),
                          Text(
                            reportFormatMoney(l10n, incomeMinor),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(l10n.reportsMonthlyCompareToggle),
                        value: _compareWithPrevious,
                        onChanged: (v) =>
                            setState(() => _compareWithPrevious = v),
                      ),
                      if (_compareWithPrevious) ...[
                        const Divider(height: 24),
                        Text(
                          l10n.reportsMonthlyPreviousPaymentsLabel,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          reportFormatMoney(l10n, prevIncomeMinor),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.reportsMonthlyDeltaLabel,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          delta == 0
                              ? l10n.reportsMonthlyDeltaSame
                              : reportFormatMoneyDelta(l10n, delta),
                          style: deltaStyle?.copyWith(color: deltaColor),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
            loading: () => const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
            error: (e, _) => Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('$e'),
              ),
            ),
          ),
          const SizedBox(height: 12),
          asyncOrders.when(
            data: (orders) {
              final unpaid = _unpaidDueInMonth(orders, start, end);
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.reportsMonthlyUnpaidDueTitle,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.reportsMonthlyUnpaidDueBody,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        reportFormatMoney(l10n, unpaid),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (e, st) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
