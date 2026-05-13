import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/core/calendar/app_calendar_format.dart';
import 'package:pride_v3/core/calendar/date_calendar_notifier.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/local/order_summary.dart';
import '../../data/providers/local_data_providers.dart';
import 'report_money_format.dart';

enum _UnpaidDeliveryFilter { all, overdue, dueWithin7Days }

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

class UnpaidReportScreen extends ConsumerStatefulWidget {
  const UnpaidReportScreen({super.key});

  @override
  ConsumerState<UnpaidReportScreen> createState() => _UnpaidReportScreenState();
}

class _UnpaidReportScreenState extends ConsumerState<UnpaidReportScreen> {
  _UnpaidDeliveryFilter _deliveryFilter = _UnpaidDeliveryFilter.all;
  bool _sortByAmountDesc = true;

  List<OrderSummary> _filterUnpaid(
    List<OrderSummary> unpaid,
    DateTime now,
  ) {
    final today = _dateOnly(now);
    switch (_deliveryFilter) {
      case _UnpaidDeliveryFilter.all:
        return unpaid;
      case _UnpaidDeliveryFilter.overdue:
        return unpaid
            .where((o) => _dateOnly(o.deliveryDate).isBefore(today))
            .toList();
      case _UnpaidDeliveryFilter.dueWithin7Days:
        final end = today.add(const Duration(days: 7));
        return unpaid.where((o) {
          final d = _dateOnly(o.deliveryDate);
          return !d.isBefore(today) && !d.isAfter(end);
        }).toList();
    }
  }

  void _applySort(List<OrderSummary> list) {
    if (_sortByAmountDesc) {
      list.sort(
        (a, b) =>
            b.remainingAmountMinor.compareTo(a.remainingAmountMinor),
      );
    } else {
      list.sort((a, b) => a.deliveryDate.compareTo(b.deliveryDate));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final calendar = ref.watch(dateCalendarSystemProvider);

    final asyncOrders = ref.watch(ordersListStreamProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.reportsUnpaidCardTitle),
      ),
      body: asyncOrders.when(
        data: (orders) {
          final unpaidBase =
              orders.where((o) => o.remainingAmountMinor > 0).toList();
          final filtered = _filterUnpaid(unpaidBase, DateTime.now());
          _applySort(filtered);
          final totalRemaining =
              filtered.fold<int>(0, (s, o) => s + o.remainingAmountMinor);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(l10n.reportsUnpaidTotalLabel),
                      ),
                      Text(
                        reportFormatMoney(l10n, totalRemaining),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.reportsUnpaidFilterSection,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              SegmentedButton<_UnpaidDeliveryFilter>(
                segments: [
                  ButtonSegment(
                    value: _UnpaidDeliveryFilter.all,
                    label: Text(l10n.reportsUnpaidFilterAll),
                  ),
                  ButtonSegment(
                    value: _UnpaidDeliveryFilter.overdue,
                    label: Text(l10n.reportsUnpaidFilterOverdue),
                  ),
                  ButtonSegment(
                    value: _UnpaidDeliveryFilter.dueWithin7Days,
                    label: Text(l10n.reportsUnpaidFilterDueSoon),
                  ),
                ],
                selected: {_deliveryFilter},
                onSelectionChanged: (s) {
                  setState(() => _deliveryFilter = s.first);
                },
              ),
              const SizedBox(height: 16),
              Text(
                l10n.reportsUnpaidSortSection,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              SegmentedButton<bool>(
                segments: [
                  ButtonSegment(
                    value: true,
                    label: Text(l10n.reportsUnpaidSortAmount),
                  ),
                  ButtonSegment(
                    value: false,
                    label: Text(l10n.reportsUnpaidSortDueDate),
                  ),
                ],
                selected: {_sortByAmountDesc},
                onSelectionChanged: (s) {
                  setState(() => _sortByAmountDesc = s.first);
                },
              ),
              const SizedBox(height: 16),
              if (unpaidBase.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Text(
                      l10n.reportsUnpaidEmpty,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else if (filtered.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Text(
                      l10n.reportsUnpaidFilteredEmpty,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else
                ...filtered.map(
                  (o) => Card(
                    child: ListTile(
                      title: Text(
                        '${l10n.ordersNumberPrefix(o.displayOrderNo)} · ${o.customerName}',
                      ),
                      subtitle: Text(
                        l10n.ordersDeliveryOn(
                          AppCalendarFormat.mediumDate(
                            l10n,
                            calendar,
                            o.deliveryDate,
                            locale,
                          ),
                        ),
                      ),
                      trailing: Chip(
                        label: Text(
                          reportFormatMoney(l10n, o.remainingAmountMinor),
                        ),
                      ),
                      onTap: () => context.push('/app/orders/${o.internalId}'),
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
