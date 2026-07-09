import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/core/calendar/app_calendar_format.dart';
import 'package:pride_v3/core/calendar/date_calendar_notifier.dart';
import 'package:pride_v3/core/calendar/date_calendar_system.dart';
import 'package:pride_v3/core/calendar/report_month_period.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/local/entities/garment_type.dart';
import '../../data/providers/local_data_providers.dart';
import '../orders/order_composer_item_card.dart';
import 'report_cloth_calculations.dart';
import 'report_cloth_daily_bars.dart';
import 'report_money_format.dart';

class ClothFinancingReportScreen extends ConsumerStatefulWidget {
  const ClothFinancingReportScreen({super.key});

  @override
  ConsumerState<ClothFinancingReportScreen> createState() =>
      _ClothFinancingReportScreenState();
}

class _ClothFinancingReportScreenState
    extends ConsumerState<ClothFinancingReportScreen> {
  DateTime? _periodStart;
  bool _compareWithPrevious = false;

  DateTime _monthStart(DateCalendarSystem sys) =>
      _periodStart ??= startOfMonthContaining(DateTime.now(), sys);

  bool _canGoNext(DateTime start, DateCalendarSystem sys) =>
      canAdvanceReportMonth(start, sys);

  String _garmentLabel(AppLocalizations l10n, GarmentType type) =>
      composerGarmentLabel(l10n, type);

  String _formatMeters(double meters) {
    if (meters == meters.roundToDouble()) {
      return meters.toInt().toString();
    }
    return meters.toStringAsFixed(1);
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
    final prevStart = subtractOneCalendarMonth(start, sys);

    final asyncOrders = ref.watch(ordersListStreamProvider);
    final purchases = ref.watch(clothPurchasesStreamProvider).valueOrNull ?? [];
    final payments =
        ref.watch(clothPurchasePaymentsStreamProvider).valueOrNull ?? [];
    final skus = ref.watch(clothStockSkusStreamProvider).valueOrNull ?? [];
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.reportsClothFinancingTitle),
      ),
      body: asyncOrders.when(
        data: (orders) {
          final monthLines = ReportClothCalculations.linesInMonth(
            orders: orders,
            monthStart: start,
            monthEndExclusive: end,
          );
          final prevLines = ReportClothCalculations.linesInMonth(
            orders: orders,
            monthStart: prevStart,
            monthEndExclusive: start,
          );

          final revenueMinor =
              ReportClothCalculations.sumRevenueMinor(monthLines);
          final cogsMinor = ReportClothCalculations.sumCogsMinor(monthLines);
          final marginMinor = ReportClothCalculations.sumMarginMinor(monthLines);
          final purchasesMinor = ReportClothCalculations.sumPurchasesInMonth(
            purchases: purchases,
            monthStart: start,
            monthEndExclusive: end,
          );
          final payablesMinor = ReportClothCalculations.sumPayablesMinor(
            purchases: purchases,
            payments: payments,
          );
          final stockMeters = ReportClothCalculations.sumStockMeters(skus);
          final prevRevenueMinor =
              ReportClothCalculations.sumRevenueMinor(prevLines);
          final meters = ReportClothCalculations.sumMeters(monthLines);
          final orderCount =
              ReportClothCalculations.countDistinctOrders(monthLines);
          final revenueByGarment =
              ReportClothCalculations.revenueByGarment(monthLines);
          final metersByGarment =
              ReportClothCalculations.metersByGarment(monthLines);
          final dailyBuckets = ReportClothCalculations.dailyRevenueBuckets(
            monthStart: DateTime(start.year, start.month, start.day),
            monthEndExclusive: end,
            lines: monthLines,
          );
          final delta = revenueMinor - prevRevenueMinor;

          if (monthLines.isEmpty) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _MonthPicker(
                  l10n: l10n,
                  sys: sys,
                  locale: locale,
                  start: start,
                  canNext: canNext,
                  onPrev: () => setState(() {
                    _periodStart = subtractOneCalendarMonth(start, sys);
                  }),
                  onNext: canNext
                      ? () => setState(() {
                            _periodStart = addOneCalendarMonth(start, sys);
                          })
                      : null,
                ),
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    l10n.reportsClothFinancingEmpty,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _MonthPicker(
                l10n: l10n,
                sys: sys,
                locale: locale,
                start: start,
                canNext: canNext,
                onPrev: () => setState(() {
                  _periodStart = subtractOneCalendarMonth(start, sys);
                }),
                onNext: canNext
                    ? () => setState(() {
                          _periodStart = addOneCalendarMonth(start, sys);
                        })
                    : null,
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _MetricRow(
                        label: l10n.reportsClothRevenueLabel,
                        value: reportFormatMoney(l10n, revenueMinor),
                        valueStyle: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      _MetricRow(
                        label: l10n.reportsClothCogsLabel,
                        value: reportFormatMoney(l10n, cogsMinor),
                      ),
                      const SizedBox(height: 8),
                      _MetricRow(
                        label: l10n.reportsClothMarginLabel,
                        value: reportFormatMoney(l10n, marginMinor),
                      ),
                      const Divider(height: 24),
                      _MetricRow(
                        label: l10n.reportsClothMetersLabel,
                        value: l10n.reportsClothMetersValue(
                          _formatMeters(meters),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _MetricRow(
                        label: l10n.reportsClothOrdersWithClothLabel,
                        value: '$orderCount',
                      ),
                      const Divider(height: 24),
                      _MetricRow(
                        label: l10n.reportsClothPurchasesLabel,
                        value: reportFormatMoney(l10n, purchasesMinor),
                      ),
                      const SizedBox(height: 8),
                      _MetricRow(
                        label: l10n.reportsClothPayablesLabel,
                        value: reportFormatMoney(l10n, payablesMinor),
                      ),
                      const SizedBox(height: 8),
                      _MetricRow(
                        label: l10n.reportsClothStockSummaryLabel,
                        value: l10n.reportsClothMetersValue(
                          _formatMeters(stockMeters),
                        ),
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(l10n.reportsMonthlyCompareToggle),
                        value: _compareWithPrevious,
                        onChanged: (v) =>
                            setState(() => _compareWithPrevious = v),
                      ),
                      if (_compareWithPrevious) ...[
                        const Divider(height: 16),
                        _MetricRow(
                          label: l10n.reportsClothPreviousRevenueLabel,
                          value: reportFormatMoney(l10n, prevRevenueMinor),
                        ),
                        const SizedBox(height: 8),
                        _MetricRow(
                          label: l10n.reportsMonthlyDeltaLabel,
                          value: delta == 0
                              ? l10n.reportsMonthlyDeltaSame
                              : reportFormatMoneyDelta(l10n, delta),
                          valueColor: delta == 0
                              ? scheme.onSurfaceVariant
                              : (delta > 0 ? scheme.primary : scheme.error),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.reportsClothDailyTrendLabel,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              ReportClothDailyBars(buckets: dailyBuckets),
              if (revenueByGarment.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text(
                  l10n.reportsClothRevenueByGarmentLabel,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 180,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        for (final entry in revenueByGarment.entries)
                          if (entry.value > 0)
                            PieChartSectionData(
                              value: entry.value.toDouble(),
                              title: _garmentLabel(l10n, entry.key),
                              color: entry.key == GarmentType.perahanTunban
                                  ? scheme.primary
                                  : scheme.secondary,
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
              const SizedBox(height: 16),
              Text(
                l10n.reportsClothBreakdownTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              for (final type in GarmentType.values)
                if ((revenueByGarment[type] ?? 0) > 0 ||
                    (metersByGarment[type] ?? 0) > 0)
                  Card(
                    child: ListTile(
                      title: Text(_garmentLabel(l10n, type)),
                      subtitle: Text(
                        l10n.reportsClothGarmentBreakdownSubtitle(
                          reportFormatMoney(l10n, revenueByGarment[type] ?? 0),
                          l10n.reportsClothMetersValue(
                            _formatMeters(metersByGarment[type] ?? 0),
                          ),
                        ),
                      ),
                    ),
                  ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('$e', textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}

class _MonthPicker extends StatelessWidget {
  const _MonthPicker({
    required this.l10n,
    required this.sys,
    required this.locale,
    required this.start,
    required this.canNext,
    required this.onPrev,
    required this.onNext,
  });

  final AppLocalizations l10n;
  final DateCalendarSystem sys;
  final String locale;
  final DateTime start;
  final bool canNext;
  final VoidCallback onPrev;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onPrev,
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
          onPressed: canNext ? onNext : null,
          icon: const Icon(Icons.chevron_right),
          tooltip: l10n.reportsNextMonth,
        ),
      ],
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({
    required this.label,
    required this.value,
    this.valueStyle,
    this.valueColor,
  });

  final String label;
  final String value;
  final TextStyle? valueStyle;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        Text(
          value,
          style: (valueStyle ?? Theme.of(context).textTheme.titleMedium)
              ?.copyWith(color: valueColor),
        ),
      ],
    );
  }
}
