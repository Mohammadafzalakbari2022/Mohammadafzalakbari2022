import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/core/calendar/date_calendar_notifier.dart';
import 'package:pride_v3/core/calendar/report_month_period.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../auth/auth_providers.dart';
import '../../data/local/entities/order_status.dart';
import '../../data/local/order_summary.dart';
import '../../data/providers/local_data_providers.dart';
import '../orders/order_status_label.dart';
import 'report_money_format.dart';

bool _isOpenOrderStatus(OrderLocalStatus s) {
  return s == OrderLocalStatus.newOrder ||
      s == OrderLocalStatus.inProgress ||
      s == OrderLocalStatus.ready;
}

int _openOrdersUnpaidTotal(List<OrderSummary> orders) {
  return orders
      .where(
        (o) => _isOpenOrderStatus(o.status) && o.remainingAmountMinor > 0,
      )
      .fold<int>(0, (s, o) => s + o.remainingAmountMinor);
}

String? _ordersStatusSummaryLine(
  AppLocalizations l10n,
  List<OrderSummary> orders,
) {
  if (orders.isEmpty) return null;
  final parts = <String>[];
  for (final st in OrderLocalStatus.values) {
    final n = orders.where((o) => o.status == st).length;
    if (n == 0) continue;
    parts.add('${orderStatusLabel(st, l10n)}: $n');
  }
  if (parts.isEmpty) return null;
  return parts.join(' · ');
}

class ReportsTabScreen extends ConsumerWidget {
  const ReportsTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final shopId = ref.watch(effectiveShopIdProvider);
    final asyncOrders = ref.watch(ordersListStreamProvider);
    final asyncPayments = ref.watch(paymentsForShopProvider(shopId));
    final calendar = ref.watch(dateCalendarSystemProvider);

    return asyncOrders.when(
      data: (orders) {
        final unpaidTotal = orders.fold<int>(
          0,
          (sum, o) =>
              sum + (o.remainingAmountMinor > 0 ? o.remainingAmountMinor : 0),
        );
        final openUnpaid = _openOrdersUnpaidTotal(orders);
        final statusLine = _ordersStatusSummaryLine(l10n, orders);

        return asyncPayments.when(
          data: (payments) {
            final now = DateTime.now();
            final start = startOfMonthContaining(now, calendar);
            final end = endExclusiveForMonthStart(start, calendar);
            final monthIncome = payments
                .where(
                  (p) =>
                      !p.createdAt.isBefore(start) && p.createdAt.isBefore(end),
                )
                .fold<int>(0, (s, p) => s + p.amountMinor);

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  l10n.reportsOverviewTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.payments_outlined),
                    title: Text(l10n.reportsThisMonthIncomeTitle),
                    subtitle: Text(
                      l10n.reportsThisMonthIncomeSubtitle(
                        reportFormatMoney(l10n, monthIncome),
                      ),
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.pending_actions_outlined),
                    title: Text(l10n.reportsThisMonthOpenUnpaidTitle),
                    subtitle: Text(
                      l10n.reportsThisMonthOpenUnpaidSubtitle(
                        reportFormatMoney(l10n, openUnpaid),
                      ),
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.pie_chart_outline),
                    title: Text(l10n.reportsOrdersSummaryTitle),
                    subtitle: Text(
                      statusLine ?? l10n.reportsOrdersSummaryEmpty,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.warning_amber_outlined),
                    title: Text(l10n.reportsUnpaidCardTitle),
                    subtitle: Text(
                      l10n.reportsUnpaidCardSubtitle(
                        reportFormatMoney(l10n, unpaidTotal),
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/app/reports/unpaid'),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.calendar_month_outlined),
                    title: Text(l10n.reportsMonthlyIncomeTitle),
                    subtitle: Text(l10n.reportsMonthlyIncomeSubtitle),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/app/reports/monthly-income'),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.local_shipping_outlined),
                    title: Text(l10n.reportsDeliveredCardTitle),
                    subtitle: Text(l10n.reportsDeliveredCardSubtitle),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/app/reports/delivered'),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.receipt_long_outlined),
                    title: Text(l10n.reportsPaymentsLedgerTitle),
                    subtitle: Text(l10n.reportsPaymentsLedgerSubtitle),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/app/reports/payments'),
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
  }
}
