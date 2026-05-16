import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'orders_filtered_list_body.dart';

/// Primary Orders tab (`/app/orders`).
class OrdersTabScreen extends ConsumerWidget {
  const OrdersTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const OrdersFilteredListBody(
      shellPathForCustomerChipClear: '/app/orders',
      showTopNewOrderButton: true,
      showBottomNewOrderButton: false,
      listDensity: OrdersFilteredListDensity.standard,
    );
  }
}
