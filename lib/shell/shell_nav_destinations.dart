import 'package:flutter/material.dart';
import 'package:pride_v3/app/app_theme.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

/// Shared shell tab icons + labels for bottom nav and navigation rail.
List<(IconData outlined, IconData filled, String label)> shellNavTabItems(
  AppLocalizations l10n,
) {
  return [
    (Icons.receipt_long_outlined, Icons.receipt_long, l10n.tabOrders),
    (Icons.people_outline, Icons.people, l10n.tabCustomers),
    (Icons.grid_view_outlined, Icons.grid_view, l10n.tabCatalog),
    (Icons.bar_chart_outlined, Icons.bar_chart, l10n.tabReports),
    (Icons.settings_outlined, Icons.settings, l10n.tabSettings),
  ];
}

List<NavigationDestination> shellNavigationDestinations(AppLocalizations l10n) {
  final items = shellNavTabItems(l10n);
  return [
    for (var i = 0; i < items.length; i++)
      NavigationDestination(
        icon: Icon(
          items[i].$1,
          color: prideNavTabColor(i).withValues(alpha: 0.72),
        ),
        selectedIcon: Icon(items[i].$2, color: prideNavTabColor(i)),
        label: items[i].$3,
      ),
  ];
}

List<NavigationRailDestination> shellNavigationRailDestinations(
  AppLocalizations l10n,
) {
  final items = shellNavTabItems(l10n);
  return [
    for (var i = 0; i < items.length; i++)
      NavigationRailDestination(
        icon: Icon(
          items[i].$1,
          color: prideNavTabColor(i).withValues(alpha: 0.72),
        ),
        selectedIcon: Icon(items[i].$2, color: prideNavTabColor(i)),
        label: Text(items[i].$3),
      ),
  ];
}
