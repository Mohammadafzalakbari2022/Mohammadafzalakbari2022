import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/core/calendar/app_calendar_format.dart';
import 'package:pride_v3/core/calendar/date_calendar_notifier.dart';
import 'package:pride_v3/core/calendar/date_calendar_system.dart';
import 'package:pride_v3/core/calendar/report_month_period.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/local/entities/order_status.dart';
import '../../data/local/order_summary.dart';
import '../../data/providers/local_data_providers.dart';
import 'report_order_row.dart';

class DeliveredReportScreen extends ConsumerStatefulWidget {
  const DeliveredReportScreen({super.key});

  @override
  ConsumerState<DeliveredReportScreen> createState() =>
      _DeliveredReportScreenState();
}

class _DeliveredReportScreenState extends ConsumerState<DeliveredReportScreen> {
  DateTime? _periodStart;

  DateTime _monthStart(DateCalendarSystem sys) =>
      _periodStart ??= startOfMonthContaining(DateTime.now(), sys);

  List<OrderSummary> _deliveredInMonth(
    List<OrderSummary> orders,
    DateTime start,
    DateTime end,
  ) {
    final list = orders
        .where(
          (o) =>
              o.status == OrderLocalStatus.delivered &&
              !o.deliveryDate.isBefore(start) &&
              o.deliveryDate.isBefore(end),
        )
        .toList()
      ..sort((a, b) => b.deliveryDate.compareTo(a.deliveryDate));
    return list;
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
    final canNext = canAdvanceReportMonth(start, sys);

    final asyncOrders = ref.watch(ordersListStreamProvider);
    final customerDisplayNoById = ref
            .watch(customersListStreamProvider)
            .maybeWhen(
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
        title: Text(l10n.reportsDeliveredReportTitle),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Row(
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
                      style: Theme.of(context).textTheme.titleMedium,
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
          ),
          Expanded(
            child: asyncOrders.when(
              data: (orders) {
                final delivered = _deliveredInMonth(orders, start, end);
                if (delivered.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        l10n.reportsDeliveredEmpty,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: delivered.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    final o = delivered[i];
                    return ReportOrderRow(
                      order: o,
                      l10n: l10n,
                      locale: locale,
                      calendar: sys,
                      trailingMoneyMinor: o.totalAmountMinor,
                      customerDisplayNo:
                          customerDisplayNoById[o.customerInternalId] ?? '',
                    );
                  },
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
          ),
        ],
      ),
    );
  }
}
