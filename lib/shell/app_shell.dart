import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/app/app_theme.dart';
import 'package:pride_v3/core/widgets/app_back_button.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../core/shop_finance/rent_due_checker.dart';
import '../dashboard/dashboard_drawer.dart';
import '../data/providers/local_data_providers.dart';
import '../features/settings/shop_profile_provider.dart';
import 'shell_app_bar_sync_button.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _seedWelcomeNotification();
      _checkRentDue();
    });
  }

  Future<void> _checkRentDue() async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    try {
      await checkRentDueNotifications(ref, l10n);
    } catch (_) {
      // Finance repo may still be initializing.
    }
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

    final openDrawer = !canPop && primaryTab
        ? () => _scaffoldKey.currentState?.openDrawer()
        : null;

    return Scaffold(
      key: _scaffoldKey,
      drawer: const DashboardDrawer(),
      drawerEdgeDragWidth: 56,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: openDrawer == null
            ? Text(title)
            : Tooltip(
                message: l10n.appShellTapTitleForMenu,
                child: InkWell(
                  onTap: openDrawer,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(title),
                  ),
                ),
              ),
        leading: canPop
            ? AppBackButton(onPressed: () => context.pop())
            : openDrawer != null
                ? IconButton(
                    icon: Icon(
                      Icons.space_dashboard_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    tooltip: l10n.dashboardOpenMenuTooltip,
                    onPressed: openDrawer,
                  )
                : null,
        actions: [
          if (openDrawer != null) const ShellAppBarSyncIconButton(),
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
            icon: Icon(
              Icons.receipt_long_outlined,
              color: prideNavTabColor(0).withValues(alpha: 0.72),
            ),
            selectedIcon: Icon(Icons.receipt_long, color: prideNavTabColor(0)),
            label: l10n.tabOrders,
          ),
          NavigationDestination(
            icon: Icon(
              Icons.people_outline,
              color: prideNavTabColor(1).withValues(alpha: 0.72),
            ),
            selectedIcon: Icon(Icons.people, color: prideNavTabColor(1)),
            label: l10n.tabCustomers,
          ),
          NavigationDestination(
            icon: Icon(
              Icons.grid_view_outlined,
              color: prideNavTabColor(2).withValues(alpha: 0.72),
            ),
            selectedIcon: Icon(Icons.grid_view, color: prideNavTabColor(2)),
            label: l10n.tabCatalog,
          ),
          NavigationDestination(
            icon: Icon(
              Icons.bar_chart_outlined,
              color: prideNavTabColor(3).withValues(alpha: 0.72),
            ),
            selectedIcon: Icon(Icons.bar_chart, color: prideNavTabColor(3)),
            label: l10n.tabReports,
          ),
          NavigationDestination(
            icon: Icon(
              Icons.settings_outlined,
              color: prideNavTabColor(4).withValues(alpha: 0.72),
            ),
            selectedIcon: Icon(Icons.settings, color: prideNavTabColor(4)),
            label: l10n.tabSettings,
          ),
        ],
      ),
    );
  }
}
