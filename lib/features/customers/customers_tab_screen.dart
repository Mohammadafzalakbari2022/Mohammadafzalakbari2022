import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/local/customer_summary.dart';
import '../../data/local/order_summary.dart';
import '../../data/providers/local_data_providers.dart';

enum CustomersSort { recentActivity, nameAsc, nameDesc, mostOrders }

enum CustomersActivityFilter { all, hasOrders, noOrders }

enum CustomersCreatedFilter { all, today, thisWeek }

enum CustomersFinancialFilter { all, hasUnpaidBalance }

DateTime _customersDateOnly(DateTime d) =>
    DateTime(d.year, d.month, d.day);

DateTime _customersStartOfWeekMonday(DateTime d) {
  final day = _customersDateOnly(d);
  return day.subtract(Duration(days: day.weekday - DateTime.monday));
}

int _orderCountForCustomer(String customerId, List<OrderSummary> orders) {
  var n = 0;
  for (final o in orders) {
    if (o.customerInternalId == customerId) n++;
  }
  return n;
}

int _unpaidTotalForCustomer(String customerId, List<OrderSummary> orders) {
  var sum = 0;
  for (final o in orders) {
    if (o.customerInternalId == customerId) {
      sum += o.remainingAmountMinor;
    }
  }
  return sum;
}

int _lastOrderActivityMs(CustomerSummary c, List<OrderSummary> orders) {
  var maxMs = 0;
  for (final o in orders) {
    if (o.customerInternalId != c.internalId) continue;
    final ms = o.deliveryDate.millisecondsSinceEpoch;
    if (ms > maxMs) maxMs = ms;
  }
  return maxMs;
}

class CustomersTabScreen extends ConsumerStatefulWidget {
  const CustomersTabScreen({super.key});

  @override
  ConsumerState<CustomersTabScreen> createState() => _CustomersTabScreenState();
}

class _CustomersTabScreenState extends ConsumerState<CustomersTabScreen> {
  final _search = TextEditingController();
  bool _cardView = false;
  CustomersSort _sort = CustomersSort.recentActivity;
  CustomersActivityFilter _activity = CustomersActivityFilter.all;
  CustomersCreatedFilter _created = CustomersCreatedFilter.all;
  CustomersFinancialFilter _financial = CustomersFinancialFilter.all;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<CustomerSummary> _applySearch(List<CustomerSummary> customers) {
    final q = _search.text.trim().toLowerCase();
    if (q.isEmpty) return customers;
    return customers.where((c) {
      final phone = (c.phone ?? '').toLowerCase();
      final addr = (c.address ?? '').toLowerCase();
      final notes = (c.notes ?? '').toLowerCase();
      return c.name.toLowerCase().contains(q) ||
          phone.contains(q) ||
          addr.contains(q) ||
          notes.contains(q);
    }).toList();
  }

  List<CustomerSummary> _applyFiltersAndSort({
    required List<CustomerSummary> customers,
    required List<OrderSummary> orders,
  }) {
    final searched = _applySearch(customers);
    final idsWithOrders =
        orders.map((o) => o.customerInternalId).toSet();

    var list = switch (_activity) {
      CustomersActivityFilter.all => searched,
      CustomersActivityFilter.hasOrders => searched
          .where((c) => idsWithOrders.contains(c.internalId))
          .toList(),
      CustomersActivityFilter.noOrders => searched
          .where((c) => !idsWithOrders.contains(c.internalId))
          .toList(),
    };

    final now = DateTime.now();
    final todayStart = _customersDateOnly(now);
    switch (_created) {
      case CustomersCreatedFilter.all:
        break;
      case CustomersCreatedFilter.today:
        list = list
            .where((c) => _customersDateOnly(c.createdAt) == todayStart)
            .toList();
      case CustomersCreatedFilter.thisWeek:
        final wk = _customersStartOfWeekMonday(now);
        final weekEnd = wk.add(const Duration(days: 7));
        list = list
            .where(
              (c) =>
                  !c.createdAt.isBefore(wk) && c.createdAt.isBefore(weekEnd),
            )
            .toList();
    }

    switch (_financial) {
      case CustomersFinancialFilter.all:
        break;
      case CustomersFinancialFilter.hasUnpaidBalance:
        list = list
            .where(
              (c) => _unpaidTotalForCustomer(c.internalId, orders) > 0,
            )
            .toList();
    }

    list = [...list];
    switch (_sort) {
      case CustomersSort.recentActivity:
        list.sort((a, b) {
          final cmp = _lastOrderActivityMs(b, orders)
              .compareTo(_lastOrderActivityMs(a, orders));
          if (cmp != 0) return cmp;
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
      case CustomersSort.nameAsc:
        list.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
      case CustomersSort.nameDesc:
        list.sort(
          (a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()),
        );
      case CustomersSort.mostOrders:
        list.sort((a, b) {
          final cmp = _orderCountForCustomer(b.internalId, orders)
              .compareTo(_orderCountForCustomer(a.internalId, orders));
          if (cmp != 0) return cmp;
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
    }
    return list;
  }

  String _customerRowMeta(
    AppLocalizations l10n,
    CustomerSummary c,
    List<OrderSummary> orders,
  ) {
    final n = _orderCountForCustomer(c.internalId, orders);
    if (n == 0) return l10n.customersRowNoOrdersYet;
    final unpaid = _unpaidTotalForCustomer(c.internalId, orders);
    final fmt = NumberFormat.decimalPattern();
    return l10n.customersRowMeta(n, l10n.moneyAfn(fmt.format(unpaid)));
  }

  void _openFilterSheet(AppLocalizations l10n) {
    var sort = _sort;
    var activity = _activity;
    var created = _created;
    var financial = _financial;

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModal) {
            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l10n.customersFilterSheetTitle,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.customersSortSectionTitle,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    ListTile(
                      title: Text(l10n.customersSortRecentActivity),
                      trailing: sort == CustomersSort.recentActivity
                          ? const Icon(Icons.check)
                          : null,
                      onTap: () =>
                          setModal(() => sort = CustomersSort.recentActivity),
                    ),
                    ListTile(
                      title: Text(l10n.customersSortNameAsc),
                      trailing: sort == CustomersSort.nameAsc
                          ? const Icon(Icons.check)
                          : null,
                      onTap: () =>
                          setModal(() => sort = CustomersSort.nameAsc),
                    ),
                    ListTile(
                      title: Text(l10n.customersSortNameDesc),
                      trailing: sort == CustomersSort.nameDesc
                          ? const Icon(Icons.check)
                          : null,
                      onTap: () =>
                          setModal(() => sort = CustomersSort.nameDesc),
                    ),
                    ListTile(
                      title: Text(l10n.customersSortMostOrders),
                      trailing: sort == CustomersSort.mostOrders
                          ? const Icon(Icons.check)
                          : null,
                      onTap: () =>
                          setModal(() => sort = CustomersSort.mostOrders),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.customersCreatedSectionTitle,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    ListTile(
                      title: Text(l10n.customersCreatedFilterAll),
                      trailing: created == CustomersCreatedFilter.all
                          ? const Icon(Icons.check)
                          : null,
                      onTap: () =>
                          setModal(() => created = CustomersCreatedFilter.all),
                    ),
                    ListTile(
                      title: Text(l10n.customersCreatedFilterToday),
                      trailing: created == CustomersCreatedFilter.today
                          ? const Icon(Icons.check)
                          : null,
                      onTap: () =>
                          setModal(() => created = CustomersCreatedFilter.today),
                    ),
                    ListTile(
                      title: Text(l10n.customersCreatedFilterThisWeek),
                      trailing: created == CustomersCreatedFilter.thisWeek
                          ? const Icon(Icons.check)
                          : null,
                      onTap: () => setModal(
                        () => created = CustomersCreatedFilter.thisWeek,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.customersActivitySectionTitle,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    ListTile(
                      title: Text(l10n.customersFilterAll),
                      trailing: activity == CustomersActivityFilter.all
                          ? const Icon(Icons.check)
                          : null,
                      onTap: () =>
                          setModal(() => activity = CustomersActivityFilter.all),
                    ),
                    ListTile(
                      title: Text(l10n.customersFilterHasOrders),
                      trailing: activity == CustomersActivityFilter.hasOrders
                          ? const Icon(Icons.check)
                          : null,
                      onTap: () => setModal(
                        () => activity = CustomersActivityFilter.hasOrders,
                      ),
                    ),
                    ListTile(
                      title: Text(l10n.customersFilterNoOrders),
                      trailing: activity == CustomersActivityFilter.noOrders
                          ? const Icon(Icons.check)
                          : null,
                      onTap: () => setModal(
                        () => activity = CustomersActivityFilter.noOrders,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.customersFinancialSectionTitle,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    ListTile(
                      title: Text(l10n.customersFinancialFilterAll),
                      trailing: financial == CustomersFinancialFilter.all
                          ? const Icon(Icons.check)
                          : null,
                      onTap: () =>
                          setModal(() => financial = CustomersFinancialFilter.all),
                    ),
                    ListTile(
                      title: Text(l10n.customersFilterHasUnpaid),
                      trailing:
                          financial == CustomersFinancialFilter.hasUnpaidBalance
                              ? const Icon(Icons.check)
                              : null,
                      onTap: () => setModal(
                        () => financial =
                            CustomersFinancialFilter.hasUnpaidBalance,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            setModal(() {
                              sort = CustomersSort.recentActivity;
                              activity = CustomersActivityFilter.all;
                              created = CustomersCreatedFilter.all;
                              financial = CustomersFinancialFilter.all;
                            });
                          },
                          child: Text(l10n.customersResetFilters),
                        ),
                        const Spacer(),
                        FilledButton(
                          onPressed: () {
                            setState(() {
                              _sort = sort;
                              _activity = activity;
                              _created = created;
                              _financial = financial;
                            });
                            Navigator.of(sheetContext).pop();
                          },
                          child: Text(l10n.customersApplyFilters),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final asyncCustomers = ref.watch(customersListStreamProvider);
    final asyncOrders = ref.watch(ordersListStreamProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: Row(
            children: [
              Expanded(
                child: SearchBar(
                  hintText: l10n.customersSearchHint,
                  controller: _search,
                  leading: const Icon(Icons.search),
                  trailing: [
                    if (_search.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => _search.clear()),
                      ),
                  ],
                  onChanged: (_) => setState(() {}),
                ),
              ),
              IconButton(
                onPressed: () => _openFilterSheet(l10n),
                icon: const Icon(Icons.filter_list),
                tooltip: l10n.customersFilterTooltip,
              ),
              IconButton(
                onPressed: () => setState(() => _cardView = !_cardView),
                icon: Icon(_cardView ? Icons.view_list : Icons.grid_view),
                tooltip: _cardView ? l10n.customersListView : l10n.customersCardView,
              ),
            ],
          ),
        ),
        Expanded(
          child: asyncCustomers.when(
            data: (customers) {
              return asyncOrders.when(
                data: (orders) {
                  if (customers.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              l10n.customersEmptyTitle,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 16),
                            FilledButton.icon(
                              onPressed: () =>
                                  context.push('/app/customers/new'),
                              icon: const Icon(Icons.person_add_alt_1),
                              label: Text(l10n.customersAddCta),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final filtered = _applyFiltersAndSort(
                    customers: customers,
                    orders: orders,
                  );
                  if (filtered.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          l10n.customersFilteredEmpty,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    );
                  }

                  if (_cardView) {
                    return GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.05,
                      ),
                      itemCount: filtered.length,
                      itemBuilder: (context, i) {
                        final c = filtered[i];
                        return InkWell(
                          onTap: () =>
                              context.push('/app/customers/${c.internalId}'),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const CircleAvatar(
                                    child: Icon(Icons.person),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    c.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    c.phone ?? l10n.customersPhoneMissing,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _customerRowMeta(l10n, c, orders),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: filtered.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final c = filtered[i];
                      return ListTile(
                        leading:
                            const CircleAvatar(child: Icon(Icons.person)),
                        title: Text(c.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(c.phone ?? l10n.customersPhoneMissing),
                            const SizedBox(height: 2),
                            Text(
                              _customerRowMeta(l10n, c, orders),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                        isThreeLine: true,
                        onTap: () =>
                            context.push('/app/customers/${c.internalId}'),
                      );
                    },
                  );
                },
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
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
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: FilledButton.icon(
            onPressed: () => context.push('/app/customers/new'),
            icon: const Icon(Icons.person_add_alt_1),
            label: Text(l10n.customersAddCta),
          ),
        ),
      ],
    );
  }
}
