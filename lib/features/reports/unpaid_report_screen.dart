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

enum _UnpaidAmountFilter { any, under5000, band5000to20000, over20000 }

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

class UnpaidReportScreen extends ConsumerStatefulWidget {
  const UnpaidReportScreen({super.key});

  @override
  ConsumerState<UnpaidReportScreen> createState() => _UnpaidReportScreenState();
}

class _UnpaidReportScreenState extends ConsumerState<UnpaidReportScreen> {
  _UnpaidDeliveryFilter _deliveryFilter = _UnpaidDeliveryFilter.all;
  _UnpaidAmountFilter _amountFilter = _UnpaidAmountFilter.any;
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

  List<OrderSummary> _filterAmount(List<OrderSummary> list) {
    switch (_amountFilter) {
      case _UnpaidAmountFilter.any:
        return list;
      case _UnpaidAmountFilter.under5000:
        return list.where((o) => o.remainingAmountMinor < 5000).toList();
      case _UnpaidAmountFilter.band5000to20000:
        return list
            .where(
              (o) =>
                  o.remainingAmountMinor >= 5000 &&
                  o.remainingAmountMinor <= 20000,
            )
            .toList();
      case _UnpaidAmountFilter.over20000:
        return list.where((o) => o.remainingAmountMinor > 20000).toList();
    }
  }

  String _amountFilterLabel(AppLocalizations l10n, _UnpaidAmountFilter f) {
    switch (f) {
      case _UnpaidAmountFilter.any:
        return l10n.reportsUnpaidAmountAny;
      case _UnpaidAmountFilter.under5000:
        return l10n.reportsUnpaidAmountUnder5000;
      case _UnpaidAmountFilter.band5000to20000:
        return l10n.reportsUnpaidAmount5000to20000;
      case _UnpaidAmountFilter.over20000:
        return l10n.reportsUnpaidAmountOver20000;
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
          final filtered =
              _filterAmount(_filterUnpaid(unpaidBase, DateTime.now()));
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
                l10n.reportsUnpaidAmountSection,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final f in _UnpaidAmountFilter.values)
                    FilterChip(
                      label: Text(_amountFilterLabel(l10n, f)),
                      selected: _amountFilter == f,
                      onSelected: (_) {
                        setState(() => _amountFilter = f);
                      },
                    ),
                ],
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
