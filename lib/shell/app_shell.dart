import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../dashboard/dashboard_drawer.dart';
import '../data/providers/local_data_providers.dart';
import '../features/settings/shop_profile_provider.dart';
import 'shell_app_bar_actions.dart';
import 'shell_app_bar_title.dart';
import 'shell_primary_tab.dart';

/// Bottom navigation shell (plan-19) + dashboard drawer (plan-09).
class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _welcomeSeeded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _seedWelcomeNotification());
  }

  Future<void> _seedWelcomeNotification() async {
    if (_welcomeSeeded || !mounted) return;
    _welcomeSeeded = true;
    final l10n = AppLocalizations.of(context)!;
    try {
      final repo = await ref.read(appNotificationRepositoryProvider.future);
      await repo.ensureWelcomeSeed(
        title: l10n.notifSeedWelcomeTitle,
        body: l10n.notifSeedWelcomeBody,
      );
    } catch (_) {
      // Ignore if repository not ready (e.g. hot restart edge cases).
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final path = GoRouterState.of(context).uri.path;
    final moduleTitle = shellAppBarTitle(path, l10n);
    final canPop = GoRouter.of(context).canPop();
    final shopName = ref.watch(shopDisplayNameProvider).trim();
    final primaryTab = shellPathIsPrimaryTab(path);
    final title = !canPop && primaryTab && shopName.isNotEmpty
        ? shopName
        : moduleTitle;

    return Scaffold(
      key: _scaffoldKey,
      drawer: const DashboardDrawer(),
      appBar: AppBar(
        title: Text(title),
        leading: canPop
            ? BackButton(onPressed: () => context.pop())
            : IconButton(
                icon: const Icon(Icons.menu),
                tooltip: l10n.dashboardOpenMenuTooltip,
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              ),
        actions: [
          ShellAppBarActions(
            scaffoldKey: _scaffoldKey,
            showDashboardShortcut: canPop,
          ),
        ],
      ),
      body: widget.navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.navigationShell.currentIndex,
        onDestinationSelected: (index) {
          widget.navigationShell.goBranch(
            index,
            initialLocation: index == widget.navigationShell.currentIndex,
          );
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.receipt_long_outlined),
            selectedIcon: const Icon(Icons.receipt_long),
            label: l10n.tabOrders,
          ),
          NavigationDestination(
            icon: const Icon(Icons.people_outline),
            selectedIcon: const Icon(Icons.people),
            label: l10n.tabCustomers,
          ),
          NavigationDestination(
            icon: const Icon(Icons.grid_view_outlined),
            selectedIcon: const Icon(Icons.grid_view),
            label: l10n.tabCatalog,
          ),
          NavigationDestination(
            icon: const Icon(Icons.bar_chart_outlined),
            selectedIcon: const Icon(Icons.bar_chart),
            label: l10n.tabReports,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: l10n.tabSettings,
          ),
        ],
      ),
    );
  }
}
