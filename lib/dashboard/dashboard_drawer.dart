import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/app/app_theme.dart';
import 'package:pride_v3/core/calendar/app_calendar_format.dart';
import 'package:pride_v3/core/calendar/date_calendar_notifier.dart';
import 'package:pride_v3/core/formatting/display_order_no_format.dart';
import 'package:pride_v3/core/widgets/pride_nav_card_tile.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../auth/auth_providers.dart';
import '../auth/sign_out.dart';
import '../data/local/app_notification_summary.dart';
import '../data/local/entities/order_status.dart';
import '../data/local/order_summary.dart';
import '../data/providers/local_data_providers.dart';
import '../features/orders/order_status_label.dart';
import '../features/reports/report_calculations.dart';
import '../features/reports/report_money_format.dart';
import '../features/settings/settings_providers.dart';
import '../features/settings/shop_profile_provider.dart';
import '../features/settings/support_guide_launcher.dart';
import 'package:pride_v3/core/defaults/effective_shop_profile.dart';
import 'package:pride_v3/core/widgets/shop_identity_header.dart';

import '../licensing/license_providers.dart';
import '../shell/shell_drawer_quick_actions.dart';
import 'dashboard_widgets.dart';

/// Edge drawer: live KPIs + shortcuts (plan-09). Read-only navigation; no CRUD here.
class DashboardDrawer extends ConsumerStatefulWidget {
  const DashboardDrawer({super.key});

  @override
  ConsumerState<DashboardDrawer> createState() => _DashboardDrawerState();
}

class _DashboardDrawerState extends ConsumerState<DashboardDrawer> {
  final _orderSearchController = TextEditingController();
  var _showGuideLink = false;

  @override
  void initState() {
    super.initState();
    _loadGuideLink();
  }

  Future<void> _loadGuideLink() async {
    final url = await readPublishedHelpVideoUrl();
    if (mounted) setState(() => _showGuideLink = url != null);
  }

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
    final scheme = Theme.of(context).colorScheme;
    final actions = Theme.of(context).extension<PrideActionColors>()!;
    final width = MediaQuery.sizeOf(context).width * 0.92;
    final license = ref.watch(licenseNotifierProvider);
    final editingBlocked = ref.watch(licenseEditingBlockedProvider);
    final shopId = ref.watch(effectiveShopIdProvider);
    final ordersAsync = ref.watch(ordersListStreamProvider);
    final paymentsAsync = ref.watch(paymentsForShopProvider(shopId));
    final notifAsync = ref.watch(appNotificationsStreamProvider);
    final notificationsMuted = ref.watch(notificationsMutedProvider);

    final shopAsync = ref.watch(shopProfileProvider);

    return Drawer(
      width: width,
      backgroundColor: scheme.surface,
      child: Column(
        children: [
          shopAsync.when(
            data: (shop) {
              final effective = effectiveShopProfile(shop, l10n);
              return ShopIdentityHeader(
                variant: ShopIdentityVariant.dashboard,
                shopName: effective.name,
                logoRelativePath: shop.logoRelativePath,
                bannerRelativePath: shop.bannerRelativePath,
                onClose: () => Navigator.of(context).pop(),
              );
            },
            loading: () => ShopIdentityHeader(
              variant: ShopIdentityVariant.dashboard,
              shopName: l10n.defaultShopName,
              onClose: () => Navigator.of(context).pop(),
            ),
            error: (_, _) => ShopIdentityHeader(
              variant: ShopIdentityVariant.dashboard,
              shopName: l10n.defaultShopName,
              onClose: () => Navigator.of(context).pop(),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                DashboardSection(
                  title: l10n.dashboardSearchOrdersTooltip,
                  icon: Icons.search,
                  colorIndex: 4,
                  child: TextField(
                    controller: _orderSearchController,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: l10n.dashboardSearchOrdersHint,
                      filled: true,
                      fillColor: scheme.surfaceContainerLow,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: scheme.outlineVariant),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: scheme.outlineVariant),
                      ),
                      isDense: true,
                      suffixIcon: IconButton(
                        tooltip: l10n.dashboardSearchOrdersTooltip,
                        icon: Icon(Icons.search, color: scheme.primary),
                        onPressed: () => _submitOrdersSearch(context),
                      ),
                    ),
                    onSubmitted: (_) => _submitOrdersSearch(context),
                  ),
                ),
                if (editingBlocked) ...[
                  const SizedBox(height: 12),
                  Material(
                    color: scheme.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                    child: ListTile(
                      leading: Icon(Icons.warning_amber_rounded,
                          color: scheme.onErrorContainer),
                      title: Text(
                        license.suspectedTimeTamper
                            ? l10n.dashboardLicenseClockTamperBanner
                            : license.isExpired
                                ? l10n.dashboardLicenseExpiredBanner
                                : l10n.dashboardLicenseGraceBanner,
                        style: TextStyle(color: scheme.onErrorContainer),
                      ),
                      trailing: TextButton(
                        onPressed: () {
                          _closeDrawerThen(
                            context,
                            () => context.push('/app/settings/subscription'),
                          );
                        },
                        child: Text(l10n.subscriptionTitle),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                DashboardSection(
                  title: l10n.dashboardActivitySectionTitle,
                  icon: Icons.tune_outlined,
                  colorIndex: 7,
                  child: const ShellDrawerQuickActions(),
                ),
                const SizedBox(height: 12),
                DashboardSection(
                  title: l10n.dashboardNotificationsPreviewTitle,
                  icon: Icons.notifications_outlined,
                  colorIndex: 5,
                  child: _NotificationsPreview(
                    muted: notificationsMuted,
                    notifAsync: notifAsync,
                    onOpenOrder: (oid) => _closeDrawerThen(
                      context,
                      () {
                        if (oid != null && oid.isNotEmpty) {
                          context.push('/app/orders/$oid');
                        } else {
                          context.push('/app/settings/notifications');
                        }
                      },
                    ),
                    onViewAll: () => _closeDrawerThen(
                      context,
                      () => context.push('/app/settings/notifications'),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ordersAsync.when(
                  data: (orders) {
                    return paymentsAsync.when(
                      data: (payments) {
                        final now = DateTime.now();
                        final monthIncome = ReportCalculations.monthPaymentIncome(
                          payments: payments,
                          now: now,
                          calendar: calendar,
                        );

                        final paidByOrderId =
                            ReportCalculations.paidByOrderIdFromPayments(
                          payments,
                        );
                        const ledgerLoaded = true;
                        final unpaidTotal = ReportCalculations.sumAllUnpaidTotal(
                          orders: orders,
                          paidByOrderId: paidByOrderId,
                          paymentsLedgerLoaded: ledgerLoaded,
                        );

                        int count(OrderLocalStatus s) =>
                            orders.where((o) => o.status == s).length;

                        final newCount = count(OrderLocalStatus.newOrder);
                        final inProg = count(OrderLocalStatus.inProgress);
                        final ready = count(OrderLocalStatus.ready);

                        final todayStart =
                            DateTime(now.year, now.month, now.day);
                        final todayEnd =
                            todayStart.add(const Duration(days: 1));
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
                            DashboardSection(
                              title: l10n.dashboardKpisSectionTitle,
                              icon: Icons.insights_outlined,
                              colorIndex: 0,
                              child: GridView.count(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 1.2,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  DashboardKpiTile(
                                    title: l10n.dashboardKpiNewOrders,
                                    value: '$newCount',
                                    icon: Icons.fiber_new_outlined,
                                    color: prideNavTabColor(0),
                                    onTap: () => _closeDrawerThen(
                                      context,
                                      () => context.go(
                                        '/app/orders?status=newOrder',
                                      ),
                                    ),
                                  ),
                                  DashboardKpiTile(
                                    title: l10n.dashboardKpiInProgress,
                                    value: '$inProg',
                                    icon: Icons.pending_outlined,
                                    color: prideNavTabColor(1),
                                    onTap: () => _closeDrawerThen(
                                      context,
                                      () => context.go(
                                        '/app/orders?status=inProgress',
                                      ),
                                    ),
                                  ),
                                  DashboardKpiTile(
                                    title: l10n.dashboardKpiReady,
                                    value: '$ready',
                                    icon: Icons.check_circle_outline,
                                    color: actions.add,
                                    onTap: () => _closeDrawerThen(
                                      context,
                                      () => context.go(
                                        '/app/orders?status=ready',
                                      ),
                                    ),
                                  ),
                                  DashboardKpiTile(
                                    title: l10n.dashboardKpiUnpaid,
                                    value: reportFormatMoney(l10n, unpaidTotal),
                                    icon: Icons.account_balance_wallet_outlined,
                                    color: scheme.tertiary,
                                    onTap: () => _closeDrawerThen(
                                      context,
                                      () => context.push('/app/reports/unpaid'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            DashboardSection(
                              title: l10n.dashboardOrdersPipelineTitle,
                              icon: Icons.stacked_bar_chart,
                              colorIndex: 2,
                              child: DashboardOrderPipelineChart(
                                newCount: newCount,
                                inProgressCount: inProg,
                                readyCount: ready,
                                newLabel: l10n.dashboardKpiNewOrders,
                                inProgressLabel: l10n.dashboardKpiInProgress,
                                readyLabel: l10n.dashboardKpiReady,
                              ),
                            ),
                            const SizedBox(height: 12),
                            DashboardSection(
                              title: l10n.dashboardThisMonthIncomeTitle,
                              icon: Icons.payments_outlined,
                              colorIndex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  PrideNavCardTile(
                                    icon: Icons.trending_up,
                                    colorIndex: 3,
                                    title: l10n.dashboardThisMonthIncomeTitle,
                                    subtitle: reportFormatMoney(
                                      l10n,
                                      monthIncome,
                                    ),
                                    showChevron: true,
                                    onTap: () => _closeDrawerThen(
                                      context,
                                      () => context.push(
                                        '/app/reports/monthly-income',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    l10n.dashboardRecentIncomeTitle,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                  const SizedBox(height: 8),
                                  DashboardRecentIncomeBars(
                                    payments: payments,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            DashboardSection(
                              title: l10n.dashboardQuickLinksTitle,
                              icon: Icons.bolt_outlined,
                              colorIndex: 1,
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  DashboardQuickLinkChip(
                                    label: l10n.reportsUnpaidCardTitle,
                                    icon: Icons.warning_amber_outlined,
                                    color: scheme.tertiary,
                                    onPressed: () => _closeDrawerThen(
                                      context,
                                      () => context.push('/app/reports/unpaid'),
                                    ),
                                  ),
                                  DashboardQuickLinkChip(
                                    label: l10n.reportsPaymentsLedgerTitle,
                                    icon: Icons.receipt_long_outlined,
                                    color: actions.payment,
                                    onPressed: () => _closeDrawerThen(
                                      context,
                                      () =>
                                          context.push('/app/reports/payments'),
                                    ),
                                  ),
                                  DashboardQuickLinkChip(
                                    label: l10n.dashboardQuickLinkOverdue,
                                    icon: Icons.schedule_outlined,
                                    color: actions.warning,
                                    onPressed: () => _closeDrawerThen(
                                      context,
                                      () => context.go('/app/orders?overdue=1'),
                                    ),
                                  ),
                                  DashboardQuickLinkChip(
                                    label: l10n.dashboardQuickLinkDeliveredToday,
                                    icon: Icons.local_shipping_outlined,
                                    color: actions.add,
                                    onPressed: () => _closeDrawerThen(
                                      context,
                                      () => context.go(
                                        '/app/orders?deliveredToday=1',
                                      ),
                                    ),
                                  ),
                                  DashboardQuickLinkChip(
                                    label: l10n.tabReports,
                                    icon: Icons.bar_chart,
                                    color: prideNavTabColor(3),
                                    onPressed: () => _closeDrawerThen(
                                      context,
                                      () => context.go('/app/reports'),
                                    ),
                                  ),
                                  DashboardQuickLinkChip(
                                    label: l10n.tasksTitle,
                                    icon: Icons.task_alt_outlined,
                                    color: prideNavTabColor(4),
                                    onPressed: () => _closeDrawerThen(
                                      context,
                                      () => context.push('/app/settings/tasks'),
                                    ),
                                  ),
                                  DashboardQuickLinkChip(
                                    label: l10n.tabCustomers,
                                    icon: Icons.people_outline,
                                    color: prideNavTabColor(1),
                                    onPressed: () => _closeDrawerThen(
                                      context,
                                      () => context.go('/app/customers'),
                                    ),
                                  ),
                                  if (_showGuideLink)
                                    DashboardQuickLinkChip(
                                      label: l10n.dashboardQuickLinkSystemGuide,
                                      icon: Icons.ondemand_video_outlined,
                                      color: scheme.primary,
                                      onPressed: () => _closeDrawerThen(
                                        context,
                                        () => openSupportGuideVideo(context),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            DashboardSection(
                              title: l10n.dashboardOverdueTitle,
                              icon: Icons.event_busy_outlined,
                              colorIndex: 6,
                              child: _OrderPreviewList(
                                orders: overdueOrders,
                                emptyText: l10n.dashboardOverdueEmpty,
                                calendar: calendar,
                                locale: locale,
                                l10n: l10n,
                                onTapOrder: (id) => _closeDrawerThen(
                                  context,
                                  () => context.push('/app/orders/$id'),
                                ),
                                viewAllLabel: l10n.dashboardOverdueViewAll,
                                onViewAll: () => _closeDrawerThen(
                                  context,
                                  () => context.go('/app/orders?overdue=1'),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            DashboardSection(
                              title: l10n.dashboardTodayDeliveriesTitle,
                              icon: Icons.local_shipping_outlined,
                              colorIndex: 3,
                              child: _OrderPreviewList(
                                orders: todayDeliveries,
                                emptyText: l10n.dashboardTodayDeliveriesEmpty,
                                calendar: calendar,
                                locale: locale,
                                l10n: l10n,
                                showCustomerName: true,
                                onTapOrder: (id) => _closeDrawerThen(
                                  context,
                                  () => context.push('/app/orders/$id'),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      loading: () => const _DashboardLoading(),
                      error: (e, _) => Text('$e'),
                    );
                  },
                  loading: () => const _DashboardLoading(),
                  error: (e, _) => Text('$e'),
                ),
                const SizedBox(height: 12),
                Consumer(
                  builder: (context, ref, _) {
                    final tasksAsync =
                        ref.watch(tasksForShopProvider(shopId));
                    return tasksAsync.when(
                      data: (tasks) {
                        final open =
                            tasks.where((t) => !t.isDone).length;
                        return DashboardSection(
                          title: l10n.dashboardTasksSectionTitle,
                          icon: Icons.task_alt_outlined,
                          colorIndex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                l10n.dashboardTasksOpenCount(open),
                                style:
                                    Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: FilledButton.tonal(
                                  onPressed: () => _closeDrawerThen(
                                    context,
                                    () => context.push('/app/settings/tasks'),
                                  ),
                                  child: Text(l10n.dashboardTasksViewAll),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      loading: () => const SizedBox.shrink(),
                      error: (e, st) => const SizedBox.shrink(),
                    );
                  },
                ),
                const SizedBox(height: 16),
                DashboardSection(
                  title: l10n.settingsSignOutTitle,
                  icon: Icons.logout,
                  colorIndex: 6,
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: FilledButton.tonalIcon(
                      onPressed: () => showSignOutConfirmation(context, ref),
                      icon: Icon(
                        Icons.logout,
                        color: actions.delete,
                      ),
                      label: Text(l10n.settingsSignOutTitle),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardLoading extends StatelessWidget {
  const _DashboardLoading();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 32),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _NotificationsPreview extends StatelessWidget {
  const _NotificationsPreview({
    required this.muted,
    required this.notifAsync,
    required this.onOpenOrder,
    required this.onViewAll,
  });

  final bool muted;
  final AsyncValue<List<AppNotificationSummary>> notifAsync;
  final void Function(String? oid) onOpenOrder;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    if (muted) {
      return Text(
        l10n.dashboardNotificationsMutedHint,
        style: Theme.of(context).textTheme.bodyMedium,
      );
    }

    return notifAsync.when(
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
              (n) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: scheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
                child: ListTile(
                  dense: true,
                  title: Text(
                    n.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    n.body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: n.isRead
                      ? null
                      : Icon(Icons.circle, size: 10, color: scheme.primary),
                  onTap: () => onOpenOrder(n.relatedOrderInternalId),
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton.icon(
                onPressed: onViewAll,
                icon: const Icon(Icons.arrow_forward, size: 18),
                label: Text(l10n.dashboardNotificationsViewAll),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _OrderPreviewList extends StatelessWidget {
  const _OrderPreviewList({
    required this.orders,
    required this.emptyText,
    required this.calendar,
    required this.locale,
    required this.l10n,
    required this.onTapOrder,
    this.showCustomerName = false,
    this.viewAllLabel,
    this.onViewAll,
  });

  final List<OrderSummary> orders;
  final String emptyText;
  final dynamic calendar;
  final String locale;
  final AppLocalizations l10n;
  final void Function(String id) onTapOrder;
  final bool showCustomerName;
  final String? viewAllLabel;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (orders.isEmpty) {
      return Text(
        emptyText,
        style: Theme.of(context).textTheme.bodyMedium,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...orders.map(
          (o) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: scheme.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
            child: ListTile(
              dense: true,
              title: Text(
                displayOrderNumberLabel(l10n, o.displayOrderNo),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                showCustomerName
                    ? o.customerName
                    : l10n.ordersDeliveryOn(
                        AppCalendarFormat.mediumDate(
                          l10n,
                          calendar,
                          o.deliveryDate,
                          locale,
                        ),
                      ),
              ),
              trailing: Chip(
                label: Text(orderStatusLabel(o.status, l10n)),
                visualDensity: VisualDensity.compact,
                backgroundColor: scheme.primaryContainer.withValues(alpha: 0.5),
              ),
              onTap: () => onTapOrder(o.internalId),
            ),
          ),
        ),
        if (viewAllLabel != null && onViewAll != null)
          TextButton(
            onPressed: onViewAll,
            child: Text(viewAllLabel!),
          ),
      ],
    );
  }
}
