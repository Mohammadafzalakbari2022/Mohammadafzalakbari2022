import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pride_v3/core/calendar/app_calendar_format.dart';
import 'package:pride_v3/core/calendar/date_calendar_notifier.dart';
import 'package:pride_v3/core/calendar/report_month_period.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../data/local/dev_shop_constants.dart';
import '../data/local/entities/order_status.dart';
import '../data/providers/local_data_providers.dart';
import '../features/orders/order_status_label.dart';
import '../features/settings/settings_providers.dart';
import '../licensing/license_providers.dart';

/// Edge drawer: live KPIs + shortcuts (plan-09). Read-only navigation; no CRUD here.
class DashboardDrawer extends ConsumerStatefulWidget {
  const DashboardDrawer({super.key});

  @override
  ConsumerState<DashboardDrawer> createState() => _DashboardDrawerState();
}

class _DashboardDrawerState extends ConsumerState<DashboardDrawer> {
  final _orderSearchController = TextEditingController();

  @override
  void dispose() {
    _orderSearchController.dispose();
    super.dispose();
  }

  void _closeDrawerThen(BuildContext context, void Function() action) {
    Scaffold.maybeOf(context)?.closeDrawer();
    WidgetsBinding.instance.addPostFrameCallback((_) => action());
  }

  void _submitOrdersSearch(BuildContext context) {
    final q = _orderSearchController.text.trim();
    if (q.isEmpty) return;
    final encoded = Uri.encodeQueryComponent(q);
    _closeDrawerThen(context, () => context.go('/app/orders?q=$encoded'));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final calendar = ref.watch(dateCalendarSystemProvider);
    final moneyFmt = NumberFormat.decimalPattern(locale);
    final width = MediaQuery.sizeOf(context).width * 0.88;
    final license = ref.watch(licenseNotifierProvider);
    final ordersAsync = ref.watch(ordersListStreamProvider);
    final paymentsAsync = ref.watch(paymentsForShopProvider(kDevShopId));
    final notifAsync = ref.watch(appNotificationsStreamProvider);
    final notificationsMuted = ref.watch(notificationsMutedProvider);

    return Drawer(
      width: width,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            Text(
              l10n.dashboardTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.dashboardSubtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _orderSearchController,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: l10n.dashboardSearchOrdersHint,
                border: const OutlineInputBorder(),
                isDense: true,
                suffixIcon: IconButton(
                  tooltip: l10n.dashboardSearchOrdersTooltip,
                  icon: const Icon(Icons.search),
                  onPressed: () => _submitOrdersSearch(context),
                ),
              ),
              onSubmitted: (_) => _submitOrdersSearch(context),
            ),
            if (license.isExpired) ...[
              const SizedBox(height: 12),
              MaterialBanner(
                content: Text(l10n.dashboardLicenseExpiredBanner),
                actions: [
                  TextButton(
                    onPressed: () {
                      _closeDrawerThen(
                        context,
                        () => context.push('/app/settings/subscription'),
                      );
                    },
                    child: Text(l10n.subscriptionTitle),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            Text(
              l10n.dashboardNotificationsPreviewTitle,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            if (notificationsMuted)
              Text(
                l10n.dashboardNotificationsMutedHint,
                style: Theme.of(context).textTheme.bodyMedium,
              )
            else
              notifAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (Object e, StackTrace st) => const SizedBox.shrink(),
                data: (items) {
                  if (items.isEmpty) {
                    return Text(
                      l10n.dashboardNotificationsPreviewEmpty,
                      style: Theme.of(context).textTheme.bodyMedium,
                    );
                  }
                  final preview = items.take(3).toList();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ...preview.map(
                        (n) => ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            n.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            n.body,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: n.isRead
                              ? null
                              : Icon(
                                  Icons.circle,
                                  size: 10,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          onTap: () {
                            final oid = n.relatedOrderInternalId;
                            _closeDrawerThen(
                              context,
                              () {
                                if (oid != null && oid.isNotEmpty) {
                                  context.push('/app/orders/$oid');
                                } else {
                                  context.push('/app/settings/notifications');
                                }
                              },
                            );
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () => _closeDrawerThen(
                            context,
                            () => context.push('/app/settings/notifications'),
                          ),
                          child: Text(l10n.dashboardNotificationsViewAll),
                        ),
                      ),
                    ],
                  );
                },
              ),
            const SizedBox(height: 16),
            Text(
              l10n.dashboardKpisSectionTitle,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            ordersAsync.when(
              data: (orders) {
                return paymentsAsync.when(
                  data: (payments) {
                    final now = DateTime.now();
                    final monthStart = startOfMonthContaining(now, calendar);
                    final monthEnd = endExclusiveForMonthStart(monthStart, calendar);
                    final monthIncome = payments
                        .where(
                          (p) =>
                              !p.createdAt.isBefore(monthStart) &&
                              p.createdAt.isBefore(monthEnd),
                        )
                        .fold<int>(0, (s, p) => s + p.amountMinor);

                    final unpaidTotal = orders.fold<int>(
                      0,
                      (sum, o) =>
                          sum +
                          (o.remainingAmountMinor > 0
                              ? o.remainingAmountMinor
                              : 0),
                    );

                    int count(OrderLocalStatus s) =>
                        orders.where((o) => o.status == s).length;

                    final newCount = count(OrderLocalStatus.newOrder);
                    final inProg = count(OrderLocalStatus.inProgress);
                    final ready = count(OrderLocalStatus.ready);

                    final todayStart =
                        DateTime(now.year, now.month, now.day);
                    final todayEnd = todayStart.add(const Duration(days: 1));
                    final todayDeliveries = orders
                        .where(
                          (o) =>
                              o.status == OrderLocalStatus.delivered &&
                              !o.deliveryDate.isBefore(todayStart) &&
                              o.deliveryDate.isBefore(todayEnd),
                        )
                        .take(5)
                        .toList();

                    final overdueOrders = orders
                        .where(
                          (o) =>
                              o.status != OrderLocalStatus.delivered &&
                              o.status != OrderLocalStatus.cancelled &&
                              o.deliveryDate.isBefore(todayStart),
                        )
                        .take(5)
                        .toList();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _KpiGrid(
                          children: [
                            _KpiTile(
                              title: l10n.dashboardKpiNewOrders,
                              value: '$newCount',
                              onTap: () => _closeDrawerThen(
                                context,
                                () => context.go('/app/orders?status=newOrder'),
                              ),
                            ),
                            _KpiTile(
                              title: l10n.dashboardKpiInProgress,
                              value: '$inProg',
                              onTap: () => _closeDrawerThen(
                                context,
                                () =>
                                    context.go('/app/orders?status=inProgress'),
                              ),
                            ),
                            _KpiTile(
                              title: l10n.dashboardKpiReady,
                              value: '$ready',
                              onTap: () => _closeDrawerThen(
                                context,
                                () => context.go('/app/orders?status=ready'),
                              ),
                            ),
                            _KpiTile(
                              title: l10n.dashboardKpiUnpaid,
                              value: l10n.moneyAfn(
                                moneyFmt.format(unpaidTotal),
                              ),
                              onTap: () => _closeDrawerThen(
                                context,
                                () => context.push('/app/reports/unpaid'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Card(
                          child: ListTile(
                            leading: const Icon(Icons.payments_outlined),
                            title: Text(l10n.dashboardThisMonthIncomeTitle),
                            subtitle: Text(
                              l10n.moneyAfn(
                                moneyFmt.format(monthIncome),
                              ),
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => _closeDrawerThen(
                              context,
                              () =>
                                  context.push('/app/reports/monthly-income'),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.dashboardQuickLinksTitle,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            ActionChip(
                              label: Text(l10n.reportsUnpaidCardTitle),
                              onPressed: () => _closeDrawerThen(
                                context,
                                () => context.push('/app/reports/unpaid'),
                              ),
                            ),
                            ActionChip(
                              label: Text(l10n.reportsPaymentsLedgerTitle),
                              onPressed: () => _closeDrawerThen(
                                context,
                                () => context.push('/app/reports/payments'),
                              ),
                            ),
                            ActionChip(
                              label: Text(l10n.dashboardQuickLinkOverdue),
                              onPressed: () => _closeDrawerThen(
                                context,
                                () => context.go('/app/orders?overdue=1'),
                              ),
                            ),
                            ActionChip(
                              label: Text(l10n.dashboardQuickLinkDeliveredToday),
                              onPressed: () => _closeDrawerThen(
                                context,
                                () => context.go('/app/orders?deliveredToday=1'),
                              ),
                            ),
                            ActionChip(
                              label: Text(l10n.tabReports),
                              onPressed: () => _closeDrawerThen(
                                context,
                                () => context.go('/app/reports'),
                              ),
                            ),
                            ActionChip(
                              label: Text(l10n.tabCustomers),
                              onPressed: () => _closeDrawerThen(
                                context,
                                () => context.go('/app/customers'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.dashboardOverdueTitle,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        if (overdueOrders.isEmpty)
                          Text(
                            l10n.dashboardOverdueEmpty,
                            style: Theme.of(context).textTheme.bodyMedium,
                          )
                        else
                          ...overdueOrders.map(
                            (o) => ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                l10n.ordersNumberPrefix(o.displayOrderNo),
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
                                  orderStatusLabel(o.status, l10n),
                                ),
                                visualDensity: VisualDensity.compact,
                              ),
                              onTap: () => _closeDrawerThen(
                                context,
                                () => context.push('/app/orders/${o.internalId}'),
                              ),
                            ),
                          ),
                        TextButton(
                          onPressed: () => _closeDrawerThen(
                            context,
                            () => context.go('/app/orders?overdue=1'),
                          ),
                          child: Text(l10n.dashboardOverdueViewAll),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.dashboardTodayDeliveriesTitle,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        if (todayDeliveries.isEmpty)
                          Text(
                            l10n.dashboardTodayDeliveriesEmpty,
                            style: Theme.of(context).textTheme.bodyMedium,
                          )
                        else
                          ...todayDeliveries.map(
                            (o) => ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                l10n.ordersNumberPrefix(o.displayOrderNo),
                              ),
                              subtitle: Text(o.customerName),
                              trailing: Chip(
                                label: Text(
                                  orderStatusLabel(o.status, l10n),
                                ),
                                visualDensity: VisualDensity.compact,
                              ),
                              onTap: () => _closeDrawerThen(
                                context,
                                () => context.push('/app/orders/${o.internalId}'),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (e, _) => Text('$e'),
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (e, _) => Text('$e'),
            ),
          ],
        ),
      ),
    );
  }
}

class _KpiGrid extends StatelessWidget {
  const _KpiGrid({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 1.35,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: children,
    );
  }
}

class _KpiTile extends StatelessWidget {
  const _KpiTile({
    required this.title,
    required this.value,
    required this.onTap,
  });

  final String title;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.labelMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
