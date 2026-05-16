import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import 'customers_list_body.dart';

/// Customers tab (`/app/customers`): searchable directory of all customers.
class CustomersTabScreen extends ConsumerWidget {
  const CustomersTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: const CustomersListBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/app/customers/new'),
        icon: const Icon(Icons.person_add_outlined),
        label: Text(l10n.customersAddCta),
      ),
    );
  }
}
