import 'package:flutter/material.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

enum AppTab { orders, customers, catalog, reports, settings }

/// Body-only placeholder (shell provides [Scaffold] + app bar + drawer).
class PlaceholderTabPage extends StatelessWidget {
  const PlaceholderTabPage({super.key, required this.tab});

  final AppTab tab;

  String _moduleLabel(AppLocalizations l10n) {
    switch (tab) {
      case AppTab.orders:
        return l10n.tabOrders;
      case AppTab.customers:
        return l10n.tabCustomers;
      case AppTab.catalog:
        return l10n.tabCatalog;
      case AppTab.reports:
        return l10n.tabReports;
      case AppTab.settings:
        return l10n.tabSettings;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final label = _moduleLabel(l10n);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          l10n.modulePlaceholder(label),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
