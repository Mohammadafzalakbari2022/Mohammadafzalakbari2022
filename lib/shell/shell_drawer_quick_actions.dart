import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/core/calendar/app_calendar_format.dart';
import 'package:pride_v3/core/calendar/date_calendar_notifier.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../data/providers/local_data_providers.dart';
import '../features/settings/settings_providers.dart';
import 'shell_sync_providers.dart';

/// Sync + notifications shortcuts for the dashboard drawer (moved off the app bar).
class ShellDrawerQuickActions extends ConsumerWidget {
  const ShellDrawerQuickActions({super.key});

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

    final syncSubtitle = !online
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Badge(
            isLabelVisible: queue > 0,
            label: Text(queue > 99 ? '99+' : '$queue'),
            child: Icon(
              Icons.sync_alt,
              color: online
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outline,
            ),
          ),
          title: Text(l10n.shellAppBarSyncA11y),
          subtitle: Text(syncSubtitle),
          trailing: !online
              ? Chip(
                  label: Text(l10n.shellSyncStatusOfflineChip),
                  visualDensity: VisualDensity.compact,
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.of(context).pop();
            context.push('/app/settings/sync-diagnostics');
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Badge(
            isLabelVisible: !muted && badgeCount > 0,
            label: Text(badgeCount > 99 ? '99+' : '$badgeCount'),
            child: Icon(
              muted
                  ? Icons.notifications_off_outlined
                  : Icons.notifications_outlined,
            ),
          ),
          title: Text(
            muted
                ? l10n.shellAppBarNotificationsMutedA11y
                : l10n.shellAppBarNotificationsA11y,
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.of(context).pop();
            context.push('/app/settings/notifications');
          },
        ),
      ],
    );
  }
}
