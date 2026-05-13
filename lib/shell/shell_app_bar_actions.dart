import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/core/calendar/app_calendar_format.dart';
import 'package:pride_v3/core/calendar/date_calendar_notifier.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../data/providers/local_data_providers.dart';
import '../features/settings/settings_providers.dart';
import 'shell_sync_providers.dart';

class ShellAppBarActions extends ConsumerWidget {
  const ShellAppBarActions({
    super.key,
    required this.scaffoldKey,
    required this.showDashboardShortcut,
  });

  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool showDashboardShortcut;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final calendar = ref.watch(dateCalendarSystemProvider);
    final online = ref.watch(connectivityOnlineProvider);
    final lastSync = ref.watch(lastSuccessfulSyncAtProvider);
    final queueAsync = ref.watch(syncPendingOutboxCountProvider);
    final queue = queueAsync.maybeWhen(data: (n) => n, orElse: () => 0);
    final badgeCount = ref.watch(unreadAppNotificationCountProvider);
    final muted = ref.watch(notificationsMutedProvider);

    final syncTooltip = !online
        ? l10n.shellSyncTooltipOffline
        : lastSync == null
            ? l10n.shellSyncTooltipNever
            : l10n.shellSyncTooltipLast(
                AppCalendarFormat.dateTimeMedium(
                  l10n,
                  calendar,
                  lastSync,
                  locale,
                ),
              );

    final syncIconColor = online
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.outline;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Tooltip(
          message: syncTooltip,
          child: Badge(
            isLabelVisible: queue > 0,
            label: Text(
              queue > 99 ? '99+' : '$queue',
              style: const TextStyle(fontSize: 10),
            ),
            child: IconButton(
              icon: Icon(
                Icons.sync_alt,
                color: syncIconColor,
              ),
              onPressed: () => context.push('/app/settings/sync-diagnostics'),
            ),
          ),
        ),
        if (!online)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Tooltip(
              message: l10n.shellSyncTooltipOffline,
              child: Text(
                l10n.shellSyncStatusOfflineChip,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
        Tooltip(
          message:
              muted ? l10n.shellAppBarNotificationsMutedA11y : l10n.shellAppBarNotificationsA11y,
          child: Badge(
            isLabelVisible: !muted && badgeCount > 0,
            label: Text(
              badgeCount > 99 ? '99+' : '$badgeCount',
              style: const TextStyle(fontSize: 10),
            ),
            child: IconButton(
              icon: Icon(
                muted ? Icons.notifications_off_outlined : Icons.notifications_outlined,
              ),
              onPressed: () => context.push('/app/settings/notifications'),
            ),
          ),
        ),
        if (showDashboardShortcut)
          IconButton(
            icon: const Icon(Icons.dashboard_outlined),
            tooltip: l10n.dashboardTitle,
            onPressed: () => scaffoldKey.currentState?.openDrawer(),
          ),
      ],
    );
  }
}
