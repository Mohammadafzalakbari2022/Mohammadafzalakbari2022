import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/core/sync/manual_sync_ui.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../data/providers/local_data_providers.dart';
import '../features/settings/settings_providers.dart';
import 'shell_sync_providers.dart';

/// Drawer shortcuts: manual sync and notifications inbox.
class ShellDrawerQuickActions extends ConsumerStatefulWidget {
  const ShellDrawerQuickActions({super.key});

  @override
  ConsumerState<ShellDrawerQuickActions> createState() =>
      _ShellDrawerQuickActionsState();
}

class _ShellDrawerQuickActionsState
    extends ConsumerState<ShellDrawerQuickActions> {
  bool _syncBusy = false;

  Future<void> _runSync() async {
    if (_syncBusy) return;
    setState(() => _syncBusy = true);
    try {
      await runManualSyncWithFeedback(context: context, ref: ref);
    } finally {
      if (mounted) setState(() => _syncBusy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final online = ref.watch(connectivityOnlineProvider);
    final badgeCount = ref.watch(unreadAppNotificationCountProvider);
    final muted = ref.watch(notificationsMutedProvider);
    final syncInProgress = _syncBusy || ref.watch(syncInProgressProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: syncInProgress
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              : Icon(
                  Icons.sync_alt,
                  color: online
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outline,
                ),
          title: Text(l10n.shellAppBarSyncA11y),
          onTap: syncInProgress ? null : _runSync,
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
