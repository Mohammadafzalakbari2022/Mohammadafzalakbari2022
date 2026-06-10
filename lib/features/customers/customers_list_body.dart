import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/core/formatting/app_number_format.dart';
import 'package:pride_v3/app/app_theme.dart';
import 'package:pride_v3/core/calendar/date_calendar_notifier.dart';
import 'package:pride_v3/core/widgets/compact_search_toolbar.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/local/customer_summary.dart';
import 'customer_search_filter.dart';
import '../orders/order_composer_screen.dart';
import '../../auth/auth_providers.dart';
import '../../data/local/order_summary.dart';
import '../../data/providers/local_data_providers.dart';
import '../reports/report_calculations.dart';
import 'customer_list_tile.dart';

/// Searchable customer directory for the Customers tab (`/app/customers`).
class CustomersListBody extends ConsumerStatefulWidget {
  const CustomersListBody({
    super.key,
    this.showTopAddCustomerButton = false,
  });

  final bool showTopAddCustomerButton;

  @override
  ConsumerState<CustomersListBody> createState() => _CustomersListBodyState();
}

class _CustomersListBodyState extends ConsumerState<CustomersListBody> {
  final _searchController = TextEditingController();
  var _query = '';
  String? _selectedCustomerInternalId;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatMoney(AppLocalizations l10n, int minor) =>
      AppNumberFormat.formatMoney(l10n, minor);

  List<CustomerSummary> _filterCustomers(List<CustomerSummary> customers) =>
      filterCustomersBySearchQuery(customers, _query);

  Map<String, _CustomerOrderStats> _statsForOrders(
    List<OrderSummary> orders, {
    Map<String, int> paidByOrderId = const {},
    bool paymentsLedgerLoaded = false,
  }) {
    final map = <String, _CustomerOrderStats>{};
    for (final o in orders) {
      final id = o.customerInternalId;
      final prev = map[id];
      final remaining = ReportCalculations.effectiveRemainingMinor(
        order: o,
        paidByOrderId: paidByOrderId,
        paymentsLedgerLoaded: paymentsLedgerLoaded,
      );
      final unpaid = remaining > 0 ? remaining : 0;
      map[id] = _CustomerOrderStats(
        orderCount: (prev?.orderCount ?? 0) + 1,
        unpaidMinor: (prev?.unpaidMinor ?? 0) + unpaid,
      );
    }
    return map;
  }

  Widget _primaryAddCustomerButton(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
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
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final calendar = ref.watch(dateCalendarSystemProvider);
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
                final stats = _statsForOrders(
                  orders,
                  paidByOrderId: paidByOrderId,
                  paymentsLedgerLoaded: ledgerLoaded,
                );
                final filtered = _filterCustomers(customers);
                final selectedId = _selectedCustomerInternalId != null &&
                        filtered.any(
                          (c) => c.internalId == _selectedCustomerInternalId,
                        )
                    ? _selectedCustomerInternalId
                    : null;

                return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (widget.showTopAddCustomerButton)
                  _primaryAddCustomerButton(l10n),
                CompactSearchToolbar(
                  searchController: _searchController,
                  searchHint: l10n.customersSearchHint,
                  searchTooltip: l10n.customersSearchHint,
                  onSearchChanged: () =>
                      setState(() => _query = _searchController.text),
                ),
                Expanded(
                  child: filtered.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  customers.isEmpty
                                      ? l10n.customersEmptyTitle
                                      : l10n.customersFilteredEmpty,
                                  textAlign: TextAlign.center,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                if (customers.isEmpty) ...[
                                  const SizedBox(height: 16),
                                  FilledButton.icon(
                                    onPressed: () =>
                                        context.push('/app/customers/new'),
                                    style: prideButtonStyle(
                                      context,
                                      PrideButtonVariant.add,
                                    ),
                                    icon: const Icon(Icons.person_add_outlined),
                                    label: Text(l10n.customersAddCta),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: filtered.length,
                          itemBuilder: (context, i) {
                            final c = filtered[i];
                            final s = stats[c.internalId];
                            final isSelected = selectedId == c.internalId;
                            return CustomerListTile(
                              customer: c,
                              l10n: l10n,
                              locale: locale,
                              calendar: calendar,
                              isSelected: isSelected,
                              orderCount: s?.orderCount ?? 0,
                              unpaidMinor: s?.unpaidMinor ?? 0,
                              formatMoney: (minor) =>
                                  _formatMoney(l10n, minor),
                              onNewOrder: () => context.push(
                                orderComposerRoute(customerId: c.internalId),
                              ),
                              onTap: () {
                                if (isSelected) {
                                  context.push('/app/customers/${c.internalId}');
                                  return;
                                }
                                setState(
                                  () => _selectedCustomerInternalId = c.internalId,
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
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

class _CustomerOrderStats {
  const _CustomerOrderStats({
    required this.orderCount,
    required this.unpaidMinor,
  });

  final int orderCount;
  final int unpaidMinor;
}
