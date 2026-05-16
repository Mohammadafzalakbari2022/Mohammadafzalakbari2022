import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'customers_list_body.dart';

/// Customers tab (`/app/customers`): searchable directory of all customers.
class CustomersTabScreen extends ConsumerWidget {
  const CustomersTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const CustomersListBody(showTopAddCustomerButton: true);
  }
}
