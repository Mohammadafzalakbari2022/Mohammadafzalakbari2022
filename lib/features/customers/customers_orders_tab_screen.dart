import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../orders/orders_filtered_list_body.dart';
import 'customers_list_body.dart';

/// Customers tab: customer directory + full orders list (merged browsing).
class CustomersOrdersTabScreen extends ConsumerStatefulWidget {
  const CustomersOrdersTabScreen({super.key});

  @override
  ConsumerState<CustomersOrdersTabScreen> createState() =>
      _CustomersOrdersTabScreenState();
}

class _CustomersOrdersTabScreenState
    extends ConsumerState<CustomersOrdersTabScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  String? _lastOrdersDeepLinkSignature;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  bool _routeWantsOrdersListTab(Uri uri) {
    final qp = uri.queryParameters;
    return qp.containsKey('q') ||
        qp.containsKey('status') ||
        qp.containsKey('customer') ||
        qp['overdue'] == '1' ||
        qp['deliveredToday'] == '1' ||
        qp['unpaid'] == '1';
  }

  void _syncTabFromRoute() {
    final uri = GoRouterState.of(context).uri;
    if (uri.path != '/app/customers') return;
    if (!_routeWantsOrdersListTab(uri)) return;
    final sig = uri.query;
    if (sig == _lastOrdersDeepLinkSignature) return;
    _lastOrdersDeepLinkSignature = sig;
    if (_tabController.index != 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _tabController.animateTo(1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _syncTabFromRoute();
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: l10n.tabCustomers),
              Tab(text: l10n.tabOrdersList),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              const CustomersListBody(showTopAddCustomerButton: true),
              OrdersFilteredListBody(
                shellPathForCustomerChipClear: '/app/customers',
                showTopNewOrderButton: true,
                listDensity: OrdersFilteredListDensity.detailed,
                enableStatusActions: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
