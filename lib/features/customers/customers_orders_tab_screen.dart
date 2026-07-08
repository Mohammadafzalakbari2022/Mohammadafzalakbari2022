import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'customers_with_orders_list_body.dart';

/// Customers tab: merged customer directory with nested orders per customer.
class CustomersOrdersTabScreen extends ConsumerWidget {
  const CustomersOrdersTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const CustomersWithOrdersListBody();
  }
}
