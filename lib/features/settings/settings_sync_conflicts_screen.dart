import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../auth/admin_me_provider.dart';
import '../../auth/auth_providers.dart';
import '../../auth/developer_portal_gate.dart';
import '../../core/sync/sync_conflict_helpers.dart';
import '../../core/sync/sync_conflict_recorder.dart';
import '../../core/sync/sync_conflict_record.dart';
import '../../data/providers/local_data_providers.dart';
import 'settings_providers.dart';

/// Owner-facing sync conflict inspector (`plan-03`).
class SettingsSyncConflictsScreen extends ConsumerWidget {
  const SettingsSyncConflictsScreen({super.key});

  Future<void> _keepMine(
    BuildContext context,
    WidgetRef ref,
    SyncConflictRecord record,
  ) async {
    final shopId = ref.read(effectiveShopIdProvider);
    final recorder = SyncConflictRecorder(
      ref.read(syncConflictStorageProvider),
      shopId,
    );
    await recorder.dismiss(record.internalId);
    ref.invalidate(syncConflictsForShopProvider(shopId));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.syncConflictKeepMine),
        ),
      );
    }
  }

  Future<void> _useServer(
    BuildContext context,
    WidgetRef ref,
    SyncConflictRecord record,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final shopId = ref.read(effectiveShopIdProvider);
    final orders = await ref.read(orderListRepositoryProvider.future);
    final remote = decodeSyncConflictSnapshot(record.remoteSnapshotJson);
    await orders.mergeRemoteOrder(
      shopId: shopId,
      internalId: record.internalId,
      operation: 'upsert',
      data: remote,
      serverUpdatedAt: DateTime.now().toUtc(),
    );
    final recorder = SyncConflictRecorder(
      ref.read(syncConflictStorageProvider),
      shopId,
    );
    await recorder.dismiss(record.internalId);
    ref.invalidate(syncConflictsForShopProvider(shopId));
    ref.invalidate(ordersListStreamProvider);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.syncConflictUseServer)),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final auth = ref.watch(authSessionProvider);
    final adminAsync = ref.watch(adminMeProvider);
    final adminCheck = adminAsync.valueOrNull;
    final persistedDev = ref.watch(persistedDeveloperPortalProvider);
    final showDeveloperDiagnostics = showDeveloperDiagnosticsInSettings(
      auth: auth,
      adminCheck: adminCheck,
      devSimulated: ref.watch(isDeveloperProvider),
      persistedDeveloperFlag: persistedDev,
    );
    if (!showDeveloperDiagnostics) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted && context.canPop()) {
          context.pop();
        }
      });
      return Scaffold(
        appBar: AppBar(title: Text(l10n.syncConflictsTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final shopId = ref.watch(effectiveShopIdProvider);
    final asyncConflicts = ref.watch(syncConflictsForShopProvider(shopId));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.syncConflictsTitle)),
      body: asyncConflicts.when(
        data: (rows) {
          if (rows.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  l10n.syncConflictsEmpty,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: rows.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final r = rows[i];
              final reason = r.direction == 'pull_skipped'
                  ? l10n.syncConflictPullSkipped
                  : l10n.syncConflictPushRejected;
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        r.displayLabel ?? r.internalId,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(reason),
                      const SizedBox(height: 12),
                      Text(
                        l10n.syncConflictLocalLabel,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      Text(formatConflictSnapshotForDisplay(r.localSnapshotJson)),
                      const SizedBox(height: 8),
                      Text(
                        l10n.syncConflictRemoteLabel,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      Text(formatConflictSnapshotForDisplay(r.remoteSnapshotJson)),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          OutlinedButton(
                            onPressed: () => _keepMine(context, ref, r),
                            child: Text(l10n.syncConflictKeepMine),
                          ),
                          if (r.direction == 'pull_skipped')
                            FilledButton(
                              onPressed: () => _useServer(context, ref, r),
                              child: Text(l10n.syncConflictUseServer),
                            ),
                          TextButton(
                            onPressed: () => _keepMine(context, ref, r),
                            child: Text(l10n.syncConflictDismiss),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
      ),
    );
  }
}
