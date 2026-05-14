import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../auth/auth_providers.dart';
import '../../data/providers/local_data_providers.dart';

/// Local-device counts for developer diagnostics (plan-18); works offline.
class DeveloperPortalDiagnosticsTab extends ConsumerWidget {
  const DeveloperPortalDiagnosticsTab({super.key});

  static String? _listLen<T>(AsyncValue<List<T>> async) {
    return async.maybeWhen(
      data: (l) => '${l.length}',
      orElse: () => null,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final shopId = ref.watch(effectiveShopIdProvider);
    final orders = ref.watch(ordersListStreamProvider);
    final customers = ref.watch(customersListStreamProvider);
    final payments = ref.watch(paymentsForShopProvider(shopId));
    final tasks = ref.watch(tasksForShopProvider(shopId));
    final notifications = ref.watch(appNotificationsStreamProvider);
    final unread = ref.watch(unreadAppNotificationCountProvider);
    final outbox = ref.watch(syncPendingOutboxCountProvider);

    final loading = l10n.devPortalDiagCountLoading;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          l10n.devPortalDiagLocalTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        Text(
          l10n.devPortalDiagLocalSubtitle,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: [
              ListTile(
                title: Text(l10n.settingsSyncLocalOrders),
                trailing: Text(_listLen(orders) ?? loading),
              ),
              const Divider(height: 1),
              ListTile(
                title: Text(l10n.settingsSyncLocalCustomers),
                trailing: Text(_listLen(customers) ?? loading),
              ),
              const Divider(height: 1),
              ListTile(
                title: Text(l10n.settingsSyncLocalPayments),
                trailing: Text(_listLen(payments) ?? loading),
              ),
              const Divider(height: 1),
              ListTile(
                title: Text(l10n.settingsSyncLocalTasks),
                trailing: Text(_listLen(tasks) ?? loading),
              ),
              const Divider(height: 1),
              ListTile(
                title: Text(l10n.settingsSyncLocalNotifications),
                trailing: Text(_listLen(notifications) ?? loading),
              ),
              const Divider(height: 1),
              ListTile(
                title: Text(l10n.settingsSyncLocalUnread),
                trailing: Text('$unread'),
              ),
              const Divider(height: 1),
              ListTile(
                title: Text(l10n.settingsSyncQueuedTitle),
                trailing: Text(
                  outbox.maybeWhen(
                    data: (n) => '$n',
                    orElse: () => loading,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.devPortalDiagStub,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
