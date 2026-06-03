import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/backup/backup_merge_result.dart';
import '../../data/backup/backup_platform.dart';
import '../../data/providers/local_data_providers.dart';
import '../../security/verify_owner_password.dart';
import 'settings_owner_password_dialog.dart';

void _invalidateAfterBackupRestore(WidgetRef ref) {
  ref.invalidate(orderListRepositoryProvider);
  ref.invalidate(customerListRepositoryProvider);
  ref.invalidate(paymentRepositoryProvider);
  ref.invalidate(appNotificationRepositoryProvider);
  ref.invalidate(syncOutboxRepositoryProvider);
  ref.invalidate(catalogRepositoryProvider);
  ref.invalidate(measurementProfileRepositoryProvider);
  ref.invalidate(measurementTypesStreamProvider);
  ref.invalidate(measurementTypesAdminStreamProvider);
}

String _restoreSummaryLines(AppLocalizations l10n, BackupMergeResult r) {
  return [
    l10n.settingsBackupSummaryLineCustomers(
      r.customersInserted,
      r.customersUpdated,
    ),
    l10n.settingsBackupSummaryLineMeasurements(
      r.measurementTypesUpserted,
      r.measurementProfilesUpserted,
      r.measurementProfileItemsWritten,
    ),
    l10n.settingsBackupSummaryLineOrders(r.ordersUpserted),
    l10n.settingsBackupSummaryLinePayments(
      r.paymentsInserted,
      r.paymentsSkippedExisting,
    ),
    l10n.settingsBackupSummaryLineSnapshots(
      r.snapshotsUpserted,
      r.snapshotItemsWritten,
    ),
    l10n.settingsBackupSummaryLineNotifications(
      r.notificationsInserted,
      r.notificationsSkippedExisting,
    ),
  ].join('\n');
}

/// Backup & restore (plan-15). Data-only JSON (v2 export, v1–v2 import); IO only.
class SettingsBackupRestoreScreen extends ConsumerStatefulWidget {
  const SettingsBackupRestoreScreen({super.key});

  @override
  ConsumerState<SettingsBackupRestoreScreen> createState() =>
      _SettingsBackupRestoreScreenState();
}

class _SettingsBackupRestoreScreenState
    extends ConsumerState<SettingsBackupRestoreScreen> {
  bool _busy = false;

  Future<void> _runExport(BuildContext context, AppLocalizations l10n) async {
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.settingsBackupWebNotSupported)),
      );
      return;
    }
    final pw = await promptOwnerPasswordForSettings(context);
    if (!context.mounted) return;
    if (pw == null) return;
    if (!await verifyOwnerPasswordForBackup(ref, pw)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.ownerPasswordMismatch)),
      );
      return;
    }
    setState(() => _busy = true);
    try {
      final ok = await BackupPlatformActions.exportWithSaveDialog(ref);
      if (!context.mounted) return;
      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.settingsBackupExportDone)),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _runRestore(BuildContext context, AppLocalizations l10n) async {
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.settingsBackupWebNotSupported)),
      );
      return;
    }
    final pw = await promptOwnerPasswordForSettings(context);
    if (!context.mounted) return;
    if (pw == null) return;
    if (!await verifyOwnerPasswordForBackup(ref, pw)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.ownerPasswordMismatch)),
      );
      return;
    }
    setState(() => _busy = true);
    try {
      BackupMergeResult? result;
      try {
        result = await BackupPlatformActions.restoreWithPickDialog(ref);
      } on FormatException {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.settingsBackupInvalidFile)),
        );
        return;
      }
      if (!context.mounted) return;
      if (result == null) return;
      final summary = result;
      _invalidateAfterBackupRestore(ref);
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.settingsBackupRestoreSummaryTitle),
          content: SingleChildScrollView(
            child: Text(_restoreSummaryLines(l10n, summary)),
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(MaterialLocalizations.of(ctx).okButtonLabel),
            ),
          ],
        ),
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.settingsBackupRestoreDone)),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsBackupRestoreTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            l10n.settingsBackupOwnerPasswordNote,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (kIsWeb) ...[
            const SizedBox(height: 12),
            Text(
              l10n.settingsBackupWebNotSupported,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ],
          const SizedBox(height: 24),
          Text(
            l10n.settingsBackupSectionTitle,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.table_rows_outlined),
                  title: Text(l10n.settingsBackupOptionDataOnly),
                  subtitle: Text(l10n.settingsBackupOptionDataOnlySubtitle),
                  trailing: const Icon(Icons.check_circle_outline),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined),
                  title: Text(l10n.settingsBackupOptionDataAndImages),
                  subtitle: Text(l10n.settingsBackupOptionDataAndImagesSubtitle),
                  trailing: Icon(
                    Icons.circle_outlined,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _busy ? null : () => _runExport(context, l10n),
            icon: _busy
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.backup_outlined),
            label: Text(l10n.settingsBackupCreateCta),
          ),
          const SizedBox(height: 32),
          Text(
            l10n.settingsRestoreSectionTitle,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Text(l10n.settingsRestoreMergeNote),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _busy ? null : () => _runRestore(context, l10n),
            icon: const Icon(Icons.restore_outlined),
            label: Text(l10n.settingsRestorePickCta),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.settingsBackupRestoreComingSoon,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
