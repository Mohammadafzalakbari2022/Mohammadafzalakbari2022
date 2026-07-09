import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/app/app_theme.dart';
import 'package:pride_v3/app/responsive_breakpoints.dart';
import 'package:pride_v3/core/calendar/date_calendar_notifier.dart';
import 'package:pride_v3/core/calendar/date_calendar_system.dart';
import 'package:pride_v3/core/formatting/app_number_format.dart';
import 'package:pride_v3/core/widgets/compact_search_toolbar.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../auth/auth_providers.dart';
import '../../data/local/customer_summary.dart';
import '../../data/local/entities/order_status.dart';
import '../../data/local/order_summary.dart';
import '../../data/providers/local_data_providers.dart';
import '../orders/order_composer_screen.dart';
import '../orders/orders_list_filter.dart';
import '../orders/orders_list_filter_provider.dart';
import '../orders/orders_list_filter_sheet.dart';
import '../reports/report_calculations.dart';
import 'customer_list_tile.dart';
import 'customer_search_filter.dart';

/// Merged Customers tab: customers grouped with nested orders (recent first).
class CustomersWithOrdersListBody extends ConsumerStatefulWidget {
  const CustomersWithOrdersListBody({super.key});

  @override
  ConsumerState<CustomersWithOrdersListBody> createState() =>
      _CustomersWithOrdersListBodyState();
}

class _CustomerOrdersGroup {
  const _CustomerOrdersGroup({
    required this.customer,
    required this.orders,
    required this.unpaidMinor,
    required this.sortKey,
  });

  final CustomerSummary customer;
  final List<OrderSummary> orders;
  final int unpaidMinor;
  final DateTime sortKey;
}

class _CustomersWithOrdersListBodyState
    extends ConsumerState<CustomersWithOrdersListBody> {
  final _searchController = TextEditingController();
  var _customerQuery = '';
  String? _lastDeepLinkSignature;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatMoney(AppLocalizations l10n, int minor) =>
      AppNumberFormat.formatMoney(l10n, minor);

  OrderLocalStatus? _parseStatusQuery(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    for (final s in OrderLocalStatus.values) {
      if (s.name == raw) return s;
    }
    return null;
  }

  void _syncRouteDeepLink() {
    final uri = GoRouterState.of(context).uri;
    if (uri.path != '/app/customers') return;

    final qp = uri.queryParameters;
    final hasDeepLink = qp.containsKey('q') ||
        qp.containsKey('status') ||
        qp.containsKey('customer') ||
        qp['overdue'] == '1' ||
        qp['deliveredToday'] == '1' ||
        qp['unpaid'] == '1';

    if (!hasDeepLink) {
      _lastDeepLinkSignature = null;
      return;
    }

    final sig = uri.query;
    if (sig == _lastDeepLinkSignature) return;
    _lastDeepLinkSignature = sig;

    final status = _parseStatusQuery(qp['status']);
    final next = OrdersListFilter(
      query: qp['q'] ?? '',
      statusFilter: status != null ? {status} : {},
      onlyUnpaid: qp['unpaid'] == '1',
      onlyOverdue: qp['overdue'] == '1',
      onlyDeliveredToday: qp['deliveredToday'] == '1',
      customerInternalId: qp['customer'],
      deliveryDatePreset: OrdersDeliveryDatePreset.any,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(ordersListFilterProvider.notifier).state = next;
      if (next.query.isNotEmpty) {
        _searchController.text = next.query;
        _customerQuery = next.query;
      }
      final customerId = qp['customer'];
      if (customerId != null && customerId.isNotEmpty) {
        context.push('/app/customers/$customerId');
      }
      setState(() {});
    });
  }

  List<_CustomerOrdersGroup> _buildGroups({
    required List<CustomerSummary> customers,
    required List<OrderSummary> orders,
    required OrdersListFilter filter,
    required Map<String, int> paidByOrderId,
    required bool paymentsLedgerLoaded,
  }) {
    final customerDisplayNoById = {
      for (final c in customers) c.internalId: c.displayCustomerNo,
    };

    final filteredOrders = filter.apply(
      orders,
      customerDisplayNoById: customerDisplayNoById,
    );

    final ordersByCustomer = <String, List<OrderSummary>>{};
    for (final o in filteredOrders) {
      ordersByCustomer.putIfAbsent(o.customerInternalId, () => []).add(o);
    }
    for (final list in ordersByCustomer.values) {
      list.sort((a, b) {
        final byUpdated = b.updatedAt.compareTo(a.updatedAt);
        if (byUpdated != 0) return byUpdated;
        return b.createdAt.compareTo(a.createdAt);
      });
    }

    final seenIds = <String>{};
    final groups = <_CustomerOrdersGroup>[];

    void addGroup(CustomerSummary customer, List<OrderSummary> custOrders) {
      if (seenIds.contains(customer.internalId)) return;
      seenIds.add(customer.internalId);

      var unpaid = 0;
      for (final o in custOrders) {
        final remaining = ReportCalculations.effectiveRemainingMinor(
          order: o,
          paidByOrderId: paidByOrderId,
          paymentsLedgerLoaded: paymentsLedgerLoaded,
        );
        if (remaining > 0) unpaid += remaining;
      }

      final sortKey = custOrders.isNotEmpty
          ? custOrders.first.updatedAt
          : customer.createdAt;

      groups.add(
        _CustomerOrdersGroup(
          customer: customer,
          orders: custOrders,
          unpaidMinor: unpaid,
          sortKey: sortKey,
        ),
      );
    }

    for (final c in customers) {
      final custOrders = ordersByCustomer[c.internalId] ?? const [];
      if (filter.hasActiveFilters && custOrders.isEmpty) continue;
      addGroup(c, custOrders);
    }

    for (final entry in ordersByCustomer.entries) {
      if (seenIds.contains(entry.key)) continue;
      final first = entry.value.first;
      addGroup(
        CustomerSummary(
          shopId: first.shopId,
          internalId: entry.key,
          name: first.customerName,
          displayCustomerNo: customerDisplayNoById[entry.key] ?? '',
          phone: first.customerPhone,
          createdAt: first.createdAt,
        ),
        entry.value,
      );
    }

    groups.sort((a, b) => b.sortKey.compareTo(a.sortKey));

    if (_customerQuery.trim().isEmpty) return groups;

    return groups.where((g) {
      if (filterCustomersBySearchQuery([g.customer], _customerQuery).isNotEmpty) {
        return true;
      }
      final q = _customerQuery.trim().toLowerCase();
      for (final o in g.orders) {
        if (o.displayOrderNo.toLowerCase().contains(q) ||
            o.customerName.toLowerCase().contains(q)) {
          return true;
        }
      }
      return false;
    }).toList();
  }

  Widget _customerRow(
    _CustomerOrdersGroup g,
    AppLocalizations l10n,
    String locale,
    DateCalendarSystem calendar,
  ) {
    return CustomerListTile(
      customer: g.customer,
      l10n: l10n,
      locale: locale,
      calendar: calendar,
      isSelected: false,
      orderCount: g.orders.length,
      unpaidMinor: g.unpaidMinor,
      formatMoney: (minor) => _formatMoney(l10n, minor),
      onNewOrder: () => context.go(
        orderComposerRoute(
          customerId: g.customer.internalId,
        ),
      ),
      onTap: () => context.push('/app/customers/${g.customer.internalId}'),
    );
  }

  Widget _addCustomerButton(AppLocalizations l10n) {
    return Padding(
      padding: prideListScreenPadding(context),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: () => context.push('/app/customers/new'),
          style: prideButtonStyle(context, PrideButtonVariant.add),
          icon: const Icon(Icons.person_add_outlined),
          label: Text(l10n.customersAddCta),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _syncRouteDeepLink();
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final calendar = ref.watch(dateCalendarSystemProvider);
    final filter = ref.watch(ordersListFilterProvider);
    final asyncCustomers = ref.watch(customersListStreamProvider);
    final asyncOrders = ref.watch(ordersListStreamProvider);
    final shopId = ref.watch(effectiveShopIdProvider);
    final asyncPayments = ref.watch(paymentsForShopProvider(shopId));

    return asyncCustomers.when(
      data: (customers) {
        return asyncOrders.when(
          data: (orders) {
            return asyncPayments.when(
              data: (payments) {
                final paidByOrderId =
                    ReportCalculations.paidByOrderIdFromPayments(payments);
                const ledgerLoaded = true;
                final groups = _buildGroups(
                  customers: customers,
                  orders: orders,
                  filter: filter,
                  paidByOrderId: paidByOrderId,
                  paymentsLedgerLoaded: ledgerLoaded,
                );

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _addCustomerButton(l10n),
                    CompactSearchToolbar(
                      searchController: _searchController,
                      searchHint: l10n.customersSearchHint,
                      searchTooltip: l10n.customersSearchHint,
                      filterTooltip: l10n.listToolbarFilterTooltip,
                      filterActive: filter.hasActiveFilters,
                      onSearchChanged: () => setState(
                        () => _customerQuery = _searchController.text,
                      ),
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
                          prideContentHorizontalPadding(
                            MediaQuery.sizeOf(context).width,
                          ),
                          0,
                          prideContentHorizontalPadding(
                            MediaQuery.sizeOf(context).width,
                          ),
                          4,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: InputChip(
                            label: Text(
                              l10n.ordersCustomerFilterChip(
                                groups
                                        .where(
                                          (g) =>
                                              g.customer.internalId ==
                                              filter.customerInternalId,
                                        )
                                        .map((g) => g.customer.name)
                                        .firstOrNull ??
                                    l10n.ordersCustomerFilterUnknown,
                              ),
                            ),
                            deleteIcon: const Icon(Icons.close, size: 18),
                            onDeleted: () {
                              ref
                                  .read(ordersListFilterProvider.notifier)
                                  .update(
                                    (f) =>
                                        f.copyWith(clearCustomerInternalId: true),
                                  );
                              context.go('/app/customers');
                            },
                          ),
                        ),
                      ),
                    Expanded(
                      child: groups.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Text(
                                  customers.isEmpty
                                      ? l10n.customersEmptyTitle
                                      : (filter.hasActiveFilters
                                          ? l10n.ordersFilteredEmpty
                                          : l10n.customersFilteredEmpty),
                                  textAlign: TextAlign.center,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                            )
                          : ListView.builder(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8),
                              itemCount: groups.length,
                              itemBuilder: (context, i) {
                                return _customerRow(
                                  groups[i],
                                  l10n,
                                  locale,
                                  calendar,
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('$e')),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
    );
  }
}
