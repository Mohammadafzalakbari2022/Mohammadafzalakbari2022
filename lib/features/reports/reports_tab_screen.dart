import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/core/calendar/date_calendar_notifier.dart';
import 'package:pride_v3/core/widgets/pride_nav_card_tile.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../auth/auth_providers.dart';
import '../../data/local/entities/order_status.dart';
import '../../data/local/order_summary.dart';
import '../../data/providers/local_data_providers.dart';
import '../orders/order_status_label.dart';
import 'report_money_format.dart';
import 'report_calculations.dart';
import 'reports_open_orders.dart';

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
        return asyncPayments.when(
          data: (payments) {
            final paidByOrderId =
                ReportCalculations.paidByOrderIdFromPayments(payments);
            const ledgerLoaded = true;
            final unpaidTotal = ReportCalculations.sumAllUnpaidTotal(
              orders: orders,
              paidByOrderId: paidByOrderId,
              paymentsLedgerLoaded: ledgerLoaded,
            );
            final openUnpaid = ReportCalculations.sumOpenUnpaidTotal(
              orders: orders,
              paidByOrderId: paidByOrderId,
              paymentsLedgerLoaded: ledgerLoaded,
            );
            final statusLine = _ordersStatusSummaryLine(l10n, orders);

            final now = DateTime.now();
            final monthIncome = ReportCalculations.monthPaymentIncome(
              payments: payments,
              now: now,
              calendar: calendar,
            );

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  l10n.reportsOverviewTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                PrideNavCardTile(
                  icon: Icons.account_balance_wallet_outlined,
                  colorIndex: 5,
                  title: l10n.shopFinanceTitle,
                  subtitle: l10n.shopFinanceSubtitle,
                  onTap: () => context.push('/app/reports/shop-finance'),
                ),
                PrideNavCardTile(
                  icon: Icons.payments_outlined,
                  colorIndex: 0,
                  title: l10n.reportsThisMonthIncomeTitle,
                  subtitle: l10n.reportsThisMonthIncomeSubtitle(
                    reportFormatMoney(l10n, monthIncome),
                  ),
                  onTap: () => context.push('/app/reports/this-month-income'),
                ),
                PrideNavCardTile(
                  icon: Icons.pending_actions_outlined,
                  colorIndex: 1,
                  title: l10n.reportsThisMonthOpenUnpaidTitle,
                  subtitle: l10n.reportsThisMonthOpenUnpaidSubtitle(
                    reportFormatMoney(l10n, openUnpaid),
                  ),
                  onTap: () => context.push('/app/reports/open-unpaid'),
                ),
                PrideNavCardTile(
                  icon: Icons.pie_chart_outline,
                  colorIndex: 2,
                  title: l10n.reportsOrdersSummaryTitle,
                  subtitle: statusLine ?? l10n.reportsOrdersSummaryEmpty,
                  onTap: () => context.push('/app/reports/orders-by-status'),
                ),
                PrideNavCardTile(
                  icon: Icons.warning_amber_outlined,
                  colorIndex: 3,
                  title: l10n.reportsUnpaidCardTitle,
                  subtitle: l10n.reportsUnpaidCardSubtitle(
                    reportFormatMoney(l10n, unpaidTotal),
                  ),
                  onTap: () => context.push('/app/reports/unpaid'),
                ),
                PrideNavCardTile(
                  icon: Icons.calendar_month_outlined,
                  colorIndex: 4,
                  title: l10n.reportsMonthlyIncomeTitle,
                  subtitle: l10n.reportsMonthlyIncomeSubtitle,
                  onTap: () => context.push('/app/reports/monthly-income'),
                ),
                PrideNavCardTile(
                  icon: Icons.local_shipping_outlined,
                  colorIndex: 5,
                  title: l10n.reportsDeliveredCardTitle,
                  subtitle: l10n.reportsDeliveredCardSubtitle,
                  onTap: () => context.push('/app/reports/delivered'),
                ),
                PrideNavCardTile(
                  icon: Icons.receipt_long_outlined,
                  colorIndex: 6,
                  title: l10n.reportsPaymentsLedgerTitle,
                  subtitle: l10n.reportsPaymentsLedgerSubtitle,
                  onTap: () => context.push('/app/reports/payments'),
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
