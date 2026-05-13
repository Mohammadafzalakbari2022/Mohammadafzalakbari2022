import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/core/calendar/app_calendar_format.dart';
import 'package:pride_v3/core/calendar/app_date_picker.dart';
import 'package:pride_v3/core/calendar/date_calendar_notifier.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/local/customer_summary.dart';
import '../../data/local/entities/order_status.dart';
import '../../data/providers/local_data_providers.dart';
import 'order_status_label.dart';
import 'orders_list_filter.dart';
import 'orders_list_filter_provider.dart';

/// Orders tab: list from local repository (Isar on native, memory on Web).
class OrdersTabScreen extends ConsumerStatefulWidget {
  const OrdersTabScreen({super.key});

  @override
  ConsumerState<OrdersTabScreen> createState() => _OrdersTabScreenState();
}

class _OrdersTabScreenState extends ConsumerState<OrdersTabScreen> {
  late final TextEditingController _searchController;
  String? _lastOrdersDeepLinkSignature;
  String _formatMoney(int minor) => minor.toString();

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

  void _toggleOverdue() {
    ref.read(ordersListFilterProvider.notifier).update((f) {
      final on = !f.onlyOverdue;
      return f.copyWith(
        onlyOverdue: on,
        onlyDeliveredToday: on ? false : f.onlyDeliveredToday,
      );
    });
  }

  void _toggleDeliveredToday() {
    ref.read(ordersListFilterProvider.notifier).update((f) {
      final on = !f.onlyDeliveredToday;
      return f.copyWith(
        onlyDeliveredToday: on,
        onlyOverdue: on ? false : f.onlyOverdue,
      );
    });
  }

  void _toggleStatus(OrderLocalStatus status) {
    ref.read(ordersListFilterProvider.notifier).update((f) {
      final next = Set<OrderLocalStatus>.from(f.statusFilter);
      if (next.contains(status)) {
        next.remove(status);
      } else {
        next.add(status);
      }
      return f.copyWith(statusFilter: next);
    });
  }

  void _toggleOnlyUnpaid() {
    ref.read(ordersListFilterProvider.notifier).update(
          (f) => f.copyWith(onlyUnpaid: !f.onlyUnpaid),
        );
  }

  void _setDeliveryDatePreset(OrdersDeliveryDatePreset preset) {
    ref.read(ordersListFilterProvider.notifier).update(
          (f) => f.copyWith(
            deliveryDatePreset: preset,
            clearCustomRange: preset != OrdersDeliveryDatePreset.custom,
          ),
        );
  }

  Future<void> _pickCustomDeliveryRange(AppLocalizations l10n) async {
    final now = DateTime.now();
    final initial = ref.read(ordersListFilterProvider);
    final calendar = ref.read(dateCalendarSystemProvider);
    final range = await showAppDateRangePicker(
      context: context,
      l10n: l10n,
      system: calendar,
      helpText: l10n.ordersDateCustomPickerHelp,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 3),
      initialDateRange: initial.customRangeStart != null &&
              initial.customRangeEnd != null
          ? DateTimeRange(
              start: initial.customRangeStart!,
              end: initial.customRangeEnd!,
            )
          : DateTimeRange(
              start: _dateOnly(now),
              end: _dateOnly(now).add(const Duration(days: 7)),
            ),
    );
    if (range == null) return;
    if (!mounted) return;
    ref.read(ordersListFilterProvider.notifier).update(
          (f) => f.copyWith(
            deliveryDatePreset: OrdersDeliveryDatePreset.custom,
            customRangeStart: range.start,
            customRangeEnd: range.end,
          ),
        );
  }

  static DateTime _dateOnly(DateTime d) =>
      DateTime(d.year, d.month, d.day);

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
    final asyncCustomers = ref.watch(customersListStreamProvider);
    final filter = ref.watch(ordersListFilterProvider);
    final customers = asyncCustomers.maybeWhen(
      data: (c) => c,
      orElse: () => const <CustomerSummary>[],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (kIsWeb)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
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
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: SearchBar(
            hintText: l10n.ordersSearchHint,
            controller: _searchController,
            leading: const Icon(Icons.search),
            trailing: [
              if (_searchController.text.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _syncSearchToProvider('');
                    setState(() {});
                  },
                ),
            ],
            onChanged: (value) {
              _syncSearchToProvider(value);
              setState(() {});
            },
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(l10n.ordersFilterOverdueChip),
                  selected: filter.onlyOverdue,
                  onSelected: (_) => _toggleOverdue(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(l10n.ordersFilterDeliveredTodayChip),
                  selected: filter.onlyDeliveredToday,
                  onSelected: (_) => _toggleDeliveredToday(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(l10n.ordersDateChipAny),
                  selected: filter.deliveryDatePreset ==
                      OrdersDeliveryDatePreset.any,
                  onSelected: (_) =>
                      _setDeliveryDatePreset(OrdersDeliveryDatePreset.any),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(l10n.ordersDateChipToday),
                  selected: filter.deliveryDatePreset ==
                      OrdersDeliveryDatePreset.today,
                  onSelected: (_) =>
                      _setDeliveryDatePreset(OrdersDeliveryDatePreset.today),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(l10n.ordersDateChipThisWeek),
                  selected: filter.deliveryDatePreset ==
                      OrdersDeliveryDatePreset.thisWeek,
                  onSelected: (_) =>
                      _setDeliveryDatePreset(OrdersDeliveryDatePreset.thisWeek),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(l10n.ordersDateChipCustom),
                  selected: filter.deliveryDatePreset ==
                      OrdersDeliveryDatePreset.custom,
                  onSelected: (_) => _pickCustomDeliveryRange(l10n),
                ),
              ),
            ],
          ),
        ),
        if (filter.customerInternalId != null &&
            filter.customerInternalId!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
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
                  context.go('/app/orders');
                },
              ),
            ),
          ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(l10n.ordersOnlyUnpaidChip),
                  selected: filter.onlyUnpaid,
                  onSelected: (_) => _toggleOnlyUnpaid(),
                ),
              ),
              for (final status in OrderLocalStatus.values)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(orderStatusLabel(status, l10n)),
                    selected: filter.statusFilter.contains(status),
                    onSelected: (_) => _toggleStatus(status),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: asyncOrders.when(
            data: (orders) {
              final filtered = filter.apply(orders);
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
                          onPressed: () => context.push('/app/orders/new'),
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
              return ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: filtered.length,
                separatorBuilder: (context, index) =>
                    const Divider(height: 1),
                itemBuilder: (context, i) {
                  final o = filtered[i];
                  return ListTile(
                    title: Text(
                      '${l10n.ordersNumberPrefix(o.displayOrderNo)} · ${o.customerName}',
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
                    trailing: Wrap(
                      spacing: 8,
                      children: [
                        Chip(
                          label: Text(orderStatusLabel(o.status, l10n)),
                          visualDensity: VisualDensity.compact,
                        ),
                        if (o.isUnpaid)
                          Chip(
                            label: Text(
                              l10n.ordersRemainingChip(
                                _formatMoney(o.remainingAmountMinor),
                              ),
                            ),
                            visualDensity: VisualDensity.compact,
                          ),
                      ],
                    ),
                    onTap: () => context.push('/app/orders/${o.internalId}'),
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
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: FilledButton.icon(
            onPressed: () => context.push('/app/orders/new'),
            icon: const Icon(Icons.add),
            label: Text(l10n.ordersNewCta),
          ),
        ),
      ],
    );
  }
}
