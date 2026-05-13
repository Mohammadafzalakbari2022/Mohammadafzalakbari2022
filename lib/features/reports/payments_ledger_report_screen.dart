import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/core/calendar/app_calendar_format.dart';
import 'package:pride_v3/core/calendar/date_calendar_notifier.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/local/dev_shop_constants.dart';
import '../../data/local/order_summary.dart';
import '../../data/local/payment_summary.dart';
import '../../data/providers/local_data_providers.dart';
import 'report_money_format.dart';

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

class PaymentsLedgerReportScreen extends ConsumerStatefulWidget {
  const PaymentsLedgerReportScreen({super.key});

  @override
  ConsumerState<PaymentsLedgerReportScreen> createState() =>
      _PaymentsLedgerReportScreenState();
}

class _PaymentsLedgerReportScreenState
    extends ConsumerState<PaymentsLedgerReportScreen> {
  DateTimeRange? _range;

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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final calendar = ref.watch(dateCalendarSystemProvider);
    final range = _effectiveRange();

    final asyncPayments = ref.watch(paymentsForShopProvider(kDevShopId));
    final asyncOrders = ref.watch(ordersListStreamProvider);

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
          return asyncOrders.when(
            data: (orders) {
              final byOrderId = <String, OrderSummary>{};
              for (final o in orders) {
                byOrderId[o.internalId] = o;
              }

              final list = _filterPayments(payments, range);
              final totalMinor = list.fold<int>(0, (s, p) => s + p.amountMinor);

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
                    ...list.map((p) {
                      final o = byOrderId[p.orderInternalId];
                      final line1 = o == null
                          ? l10n.reportsPaymentsUnknownOrder
                          : '${l10n.ordersNumberPrefix(o.displayOrderNo)} · ${o.customerName}';
                      final dateLine = AppCalendarFormat.mediumDate(
                        l10n,
                        calendar,
                        p.createdAt,
                        locale,
                      );
                      final subtitleParts = <String>[
                        dateLine,
                        if (p.method.isNotEmpty) p.method,
                        if (p.isAdjustment) l10n.reportsPaymentsAdjustmentChip,
                      ];
                      return Card(
                        child: ListTile(
                          title: Text(line1),
                          subtitle: Text(subtitleParts.join(' · ')),
                          trailing: Chip(
                            label: Text(reportFormatMoneyDelta(l10n, p.amountMinor)),
                          ),
                          onTap: o == null
                              ? null
                              : () => context.push('/app/orders/${o.internalId}'),
                        ),
                      );
                    }),
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

