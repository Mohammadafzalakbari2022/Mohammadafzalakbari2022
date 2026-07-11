import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';

import 'package:pride_v3/app/responsive_breakpoints.dart';

import 'package:pride_v3/core/widgets/app_back_button.dart';

import 'package:pride_v3/l10n/app_localizations.dart';

import '../core/navigation/app_exit_confirm.dart';
import '../core/shop_finance/rent_due_checker.dart';

import '../dashboard/dashboard_drawer.dart';

import '../data/providers/local_data_providers.dart';

import 'shell_app_bar_title.dart';

import 'shell_nav_destinations.dart';

import 'shell_primary_tab.dart';

/// App shell: bottom nav on phone, [NavigationRail] on web / wide layouts (plan-30).
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

  void _onShellTabSelected(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final path = GoRouterState.of(context).uri.path;
    final title = shellAppBarTitle(path, l10n);
    final canPop = GoRouter.of(context).canPop();
    final primaryTab = shellPathIsPrimaryTab(path);
    final useRail = prideUseShellRail(context);
    final railExtended =
        MediaQuery.sizeOf(context).width >= kPrideWideDesktopMinWidth;
    final isDesktop = prideIsDesktopPlatform();

    final openDrawer = !canPop && primaryTab
        ? () => _scaffoldKey.currentState?.openDrawer()
        : null;

    final titleWidget = Text(title);

    final navRail = NavigationRail(
      extended: railExtended,
      selectedIndex: widget.navigationShell.currentIndex,
      onDestinationSelected: _onShellTabSelected,
      labelType: NavigationRailLabelType.all,
      minExtendedWidth: isDesktop ? 200 : 256,
      leading: isDesktop
          ? Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 4),
              child: Center(
                child: Tooltip(
                  message: l10n.dashboardOpenMenuTooltip,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: IconButton(
                      icon: Icon(
                        Icons.space_dashboard_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: openDrawer ?? () {},
                    ),
                  ),
                ),
              ),
            )
          : null,
      trailing: isDesktop ? const SizedBox(height: 16) : null,
      destinations: shellNavigationRailDestinations(l10n),
    );

    final shellBody = useRail
        ? Row(
            children: [
              navRail,
              const VerticalDivider(width: 1),
              Expanded(child: widget.navigationShell),
            ],
          )
        : widget.navigationShell;

    final scaffold = Scaffold(
      key: _scaffoldKey,
      drawer: const DashboardDrawer(),
      drawerEdgeDragWidth: isDesktop ? 0 : 56,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: openDrawer != null
            ? Tooltip(
                message: l10n.appShellTapTitleForMenu,
                child: InkWell(
                  onTap: openDrawer,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: titleWidget,
                  ),
                ),
              )
            : titleWidget,
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
      ),
      body: shellBody,
      bottomNavigationBar: useRail
          ? null
          : NavigationBar(
              selectedIndex: widget.navigationShell.currentIndex,
              onDestinationSelected: _onShellTabSelected,
              destinations: shellNavigationDestinations(l10n),
            ),
    );

    if (!canPop && primaryTab) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          await handleAppExitBack(context, l10n);
        },
        child: scaffold,
      );
    }

    return scaffold;
  }
}
