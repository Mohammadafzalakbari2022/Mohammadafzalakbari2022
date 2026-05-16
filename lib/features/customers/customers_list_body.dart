import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pride_v3/core/widgets/compact_search_toolbar.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/local/customer_summary.dart';
import '../../data/local/order_summary.dart';
import '../../data/providers/local_data_providers.dart';

/// Searchable customer directory for the Customers tab (`/app/customers`).
class CustomersListBody extends ConsumerStatefulWidget {
  const CustomersListBody({super.key});

  @override
  ConsumerState<CustomersListBody> createState() => _CustomersListBodyState();
}

class _CustomersListBodyState extends ConsumerState<CustomersListBody> {
  final _searchController = TextEditingController();
  var _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatMoney(AppLocalizations l10n, int minor) =>
      l10n.moneyAfn(NumberFormat.decimalPattern().format(minor));

  List<CustomerSummary> _filterCustomers(List<CustomerSummary> customers) {
    final q = _query.trim().toLowerCase();
    final list = customers.where((c) {
      if (q.isEmpty) return true;
      final phone = (c.phone ?? '').toLowerCase();
      return c.name.toLowerCase().contains(q) || phone.contains(q);
    }).toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    return list;
  }

  Map<String, _CustomerOrderStats> _statsForOrders(List<OrderSummary> orders) {
    final map = <String, _CustomerOrderStats>{};
    for (final o in orders) {
      final id = o.customerInternalId;
      final prev = map[id];
      final unpaid = o.isUnpaid ? o.remainingAmountMinor : 0;
      map[id] = _CustomerOrderStats(
        orderCount: (prev?.orderCount ?? 0) + 1,
        unpaidMinor: (prev?.unpaidMinor ?? 0) + unpaid,
      );
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final asyncCustomers = ref.watch(customersListStreamProvider);
    final asyncOrders = ref.watch(ordersListStreamProvider);

    return asyncCustomers.when(
      data: (customers) {
        return asyncOrders.when(
          data: (orders) {
            final stats = _statsForOrders(orders);
            final filtered = _filterCustomers(customers);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                            child: Text(
                              customers.isEmpty
                                  ? l10n.customersEmptyTitle
                                  : l10n.customersFilteredEmpty,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 88),
                          itemCount: filtered.length,
                          separatorBuilder: (context, index) =>
                              const Divider(height: 1),
                          itemBuilder: (context, i) {
                            final c = filtered[i];
                            final s = stats[c.internalId];
                            return _CustomerListTile(
                              customer: c,
                              l10n: l10n,
                              orderCount: s?.orderCount ?? 0,
                              unpaidMinor: s?.unpaidMinor ?? 0,
                              formatMoney: (minor) => _formatMoney(l10n, minor),
                              onTap: () => context.push(
                                '/app/customers/${c.internalId}',
                              ),
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

String _customerInitial(String name) {
  final t = name.trim();
  if (t.isEmpty) return '?';
  return t[0].toUpperCase();
}

class _CustomerListTile extends StatelessWidget {
  const _CustomerListTile({
    required this.customer,
    required this.l10n,
    required this.orderCount,
    required this.unpaidMinor,
    required this.formatMoney,
    required this.onTap,
  });

  final CustomerSummary customer;
  final AppLocalizations l10n;
  final int orderCount;
  final int unpaidMinor;
  final String Function(int minor) formatMoney;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final subtitle = customer.phone ?? l10n.customersPhoneMissing;
    final meta = orderCount == 0
        ? l10n.customersRowNoOrdersYet
        : l10n.customersRowMeta(
            orderCount,
            unpaidMinor > 0
                ? l10n.ordersRemainingChip(formatMoney(unpaidMinor))
                : formatMoney(0),
          );

    final scheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: scheme.primaryContainer.withValues(alpha: 0.55),
        foregroundColor: scheme.onPrimaryContainer,
        child: Text(_customerInitial(customer.name)),
      ),
      title: Text(
        customer.name,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subtitle),
          const SizedBox(height: 2),
          Text(
            meta,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
      isThreeLine: true,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
