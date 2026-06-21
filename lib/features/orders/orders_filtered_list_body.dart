import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pride_v3/app/app_theme.dart';
import 'package:pride_v3/app/responsive_breakpoints.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/core/formatting/app_number_format.dart';
import 'package:pride_v3/core/calendar/date_calendar_notifier.dart';
import 'package:pride_v3/core/widgets/compact_search_toolbar.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../auth/auth_providers.dart';
import '../../data/local/customer_summary.dart';
import '../../data/local/entities/order_status.dart';
import '../../data/local/style/order_shape_selection_formatter.dart';
import '../../data/providers/local_data_providers.dart';
import 'order_list_tile.dart';
import 'order_payment_rules.dart';
import 'orders_list_filter.dart';
import 'orders_list_filter_provider.dart';
import 'orders_list_filter_sheet.dart';

/// Density of order rows ([OrdersFilteredListDensity.detailed] for the Orders list tab).
enum OrdersFilteredListDensity { standard, detailed }

/// Shared Orders list UI: search, [ordersListFilterProvider], chips, list.
///
/// Used from the Orders tab (`/app/orders`).
class OrdersFilteredListBody extends ConsumerStatefulWidget {
  const OrdersFilteredListBody({
    super.key,
    required this.shellPathForCustomerChipClear,
    this.showTopNewOrderButton = false,
    this.showBottomNewOrderButton = false,
    this.listDensity = OrdersFilteredListDensity.standard,
    this.enableStatusActions = false,
  });

  /// Base branch path when clearing the customer filter chip, e.g. `/app/orders`.
  final String shellPathForCustomerChipClear;

  final bool showTopNewOrderButton;
  final bool showBottomNewOrderButton;
  final OrdersFilteredListDensity listDensity;
  final bool enableStatusActions;

  @override
  ConsumerState<OrdersFilteredListBody> createState() =>
      _OrdersFilteredListBodyState();
}

class _OrdersFilteredListBodyState extends ConsumerState<OrdersFilteredListBody> {
  late final TextEditingController _searchController;
  String? _lastOrdersDeepLinkSignature;

  String _formatMoney(AppLocalizations l10n, int minor) =>
      AppNumberFormat.formatMoney(l10n, minor);

  @override
  void initState() {
    super.initState();
    final initial = ref.read(ordersListFilterProvider).query;
    _searchController = TextEditingController(text: initial);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _syncSearchToProvider(String value) {
    ref.read(ordersListFilterProvider.notifier).update(
          (f) => f.copyWith(query: value),
        );
  }

  void _syncRouteCustomerFilter(String? routeCustomerId) {
    final normalized = (routeCustomerId == null || routeCustomerId.isEmpty)
        ? null
        : routeCustomerId;
    final current = ref.read(ordersListFilterProvider).customerInternalId;
    if (normalized == current) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (normalized == null) {
        ref.read(ordersListFilterProvider.notifier).update(
              (f) => f.copyWith(clearCustomerInternalId: true),
            );
      } else {
        ref.read(ordersListFilterProvider.notifier).update(
              (f) => f.copyWith(customerInternalId: normalized),
            );
      }
    });
  }

  OrderLocalStatus? _parseStatusQuery(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    for (final s in OrderLocalStatus.values) {
      if (s.name == raw) return s;
    }
    return null;
  }

  void _syncRouteQueryLink() {
    final uri = GoRouterState.of(context).uri;
    final path = uri.path;
    if (path != '/app/customers') return;

    final qp = uri.queryParameters;
    final hasDeepLink = qp.containsKey('q') ||
        qp.containsKey('status') ||
        qp['overdue'] == '1' ||
        qp['deliveredToday'] == '1' ||
        qp['unpaid'] == '1';

    if (!hasDeepLink) {
      _lastOrdersDeepLinkSignature = null;
      return;
    }

    final sig = uri.query;
    if (sig == _lastOrdersDeepLinkSignature) return;
    _lastOrdersDeepLinkSignature = sig;

    final status = _parseStatusQuery(qp['status']);
    final next = OrdersListFilter(
      query: qp['q'] ?? '',
      statusFilter: status != null ? {status} : {},
      onlyUnpaid: qp['unpaid'] == '1',
      onlyOverdue: qp['overdue'] == '1',
      onlyDeliveredToday: qp['deliveredToday'] == '1',
      deliveryDatePreset: OrdersDeliveryDatePreset.any,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(ordersListFilterProvider.notifier).state = next;
      _searchController.text = next.query;
      setState(() {});
    });
  }

  String? _customerNameFor(
    String? internalId,
    List<CustomerSummary> customers,
  ) {
    if (internalId == null || internalId.isEmpty) return null;
    for (final c in customers) {
      if (c.internalId == internalId) return c.name;
    }
    return null;
  }

  Widget _primaryNewOrderButtons(AppLocalizations l10n) {
    return Padding(
      padding: prideListScreenPadding(context),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: () => context.go('/app/orders'),
          style: prideButtonStyle(context, PrideButtonVariant.add),
          icon: const Icon(Icons.add),
          label: Text(l10n.ordersNewCta),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final calendar = ref.watch(dateCalendarSystemProvider);
    _syncRouteQueryLink();
    _syncRouteCustomerFilter(
      GoRouterState.of(context).uri.queryParameters['customer'],
    );
    final asyncOrders = ref.watch(ordersListStreamProvider);
    final shopId = ref.watch(effectiveShopIdProvider);
    final asyncShopPayments = ref.watch(paymentsForShopProvider(shopId));
    final paidByOrderId = asyncShopPayments.hasValue
        ? OrderPaymentRules.sumPaidMinorByOrderId(
            (asyncShopPayments.value ?? const [])
                .map((p) => (orderInternalId: p.orderInternalId, amountMinor: p.amountMinor)),
          )
        : const <String, int>{};
    final paymentsLedgerLoaded = asyncShopPayments.hasValue;
    final asyncCustomers = ref.watch(customersListStreamProvider);
    final filter = ref.watch(ordersListFilterProvider);
    final customers = asyncCustomers.maybeWhen(
      data: (c) => c,
      orElse: () => const <CustomerSummary>[],
    );
    final customerDisplayNoById = <String, String>{
      for (final c in customers) c.internalId: c.displayCustomerNo,
    };
    final detailed = widget.listDensity == OrdersFilteredListDensity.detailed;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.showTopNewOrderButton) _primaryNewOrderButtons(l10n),
        if (kIsWeb)
          Padding(
            padding: EdgeInsets.fromLTRB(
              prideContentHorizontalPadding(MediaQuery.sizeOf(context).width),
              8,
              prideContentHorizontalPadding(MediaQuery.sizeOf(context).width),
              0,
            ),
            child: Card(
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  l10n.ordersWebDataHint,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          ),
        CompactSearchToolbar(
          searchController: _searchController,
          searchHint: l10n.ordersSearchHint,
          searchTooltip: l10n.listToolbarSearchTooltip,
          filterTooltip: l10n.listToolbarFilterTooltip,
          filterActive: filter.hasActiveFilters,
          onSearchChanged: () => _syncSearchToProvider(_searchController.text),
          onFilterTap: () => showOrdersListFilterSheet(
            context: context,
            ref: ref,
            l10n: l10n,
          ),
        ),
        if (filter.customerInternalId != null &&
            filter.customerInternalId!.isNotEmpty)
          Padding(
            padding: EdgeInsets.fromLTRB(
              prideContentHorizontalPadding(MediaQuery.sizeOf(context).width),
              0,
              prideContentHorizontalPadding(MediaQuery.sizeOf(context).width),
              4,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: InputChip(
                label: Text(
                  l10n.ordersCustomerFilterChip(
                    _customerNameFor(filter.customerInternalId, customers) ??
                        l10n.ordersCustomerFilterUnknown,
                  ),
                ),
                deleteIcon: const Icon(Icons.close, size: 18),
                onDeleted: () {
                  ref.read(ordersListFilterProvider.notifier).update(
                        (f) => f.copyWith(clearCustomerInternalId: true),
                      );
                  context.go(widget.shellPathForCustomerChipClear);
                },
              ),
            ),
          ),
        Expanded(
          child: asyncOrders.when(
            data: (orders) {
              final filtered = filter.apply(
                orders,
                customerDisplayNoById: customerDisplayNoById,
              );
              if (orders.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          l10n.ordersListEmpty,
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: () => context.go('/app/orders'),
                          style: prideButtonStyle(context, PrideButtonVariant.add),
                          icon: const Icon(Icons.add),
                          label: Text(l10n.ordersNewCta),
                        ),
                      ],
                    ),
                  ),
                );
              }
              if (filtered.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      l10n.ordersFilteredEmpty,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: filtered.length,
                itemBuilder: (context, i) {
                  final o = filtered[i];
                  final paidMinor = OrderPaymentRules.paidMinorForOrder(
                    orderSummaryPaidMinor: o.paidAmountMinor,
                    paidByOrderId: paidByOrderId,
                    orderInternalId: o.internalId,
                    paymentsLedgerLoaded: paymentsLedgerLoaded,
                  );
                  final remainingMinor = OrderPaymentRules.remainingMinor(
                    o.totalAmountMinor,
                    paidMinor,
                  );

                  return OrderListTile(
                    order: o,
                    customerDisplayNo:
                        customerDisplayNoById[o.customerInternalId] ?? '',
                    paidAmountMinor: paidMinor,
                    remainingAmountMinor: remainingMinor,
                    l10n: l10n,
                    locale: locale,
                    calendar: calendar,
                    detailed: detailed,
                    formatMoney: (minor) => _formatMoney(l10n, minor),
                    stylePreviewLine: detailed
                        ? formatOrderShapeSelectionDisplay(
                            styleName: o.styleName,
                            styleSelectionJson: o.styleSelectionJson,
                            styleSummary: o.styleSummary,
                          ).compactPreview
                        : null,
                    onTap: () => context.push('/app/orders/${o.internalId}'),
                    enableStatusActions: widget.enableStatusActions,
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
        if (widget.showBottomNewOrderButton)
          Padding(
            padding: prideListScreenPadding(context).copyWith(top: 8, bottom: 16),
            child: FilledButton.icon(
              onPressed: () => context.go('/app/orders'),
              style: prideButtonStyle(context, PrideButtonVariant.add),
              icon: const Icon(Icons.add),
              label: Text(l10n.ordersNewCta),
            ),
          ),
      ],
    );
  }
}
