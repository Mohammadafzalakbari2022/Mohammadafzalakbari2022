import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import 'manual_sync_controller.dart';

/// Shows snackbars for [runManualSyncFromRef] outcomes.
Future<void> runManualSyncWithFeedback({
  required BuildContext context,
  required WidgetRef ref,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) return;

  final outcome = await runManualSyncFromRef(ref);
  if (!context.mounted) return;

  switch (outcome) {
    case ManualSyncUiSuccess(
        :final pushedMutationCount,
        :final remoteChangeCount,
      ):
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            l10n.settingsSyncRetrySuccess(
              pushedMutationCount,
              remoteChangeCount,
            ),
          ),
        ),
      );
    case ManualSyncUiFailure(:final messageKey, :final detail):
      final text = switch (messageKey) {
        'sign_in' => l10n.settingsSyncRetrySignIn,
        'offline' => l10n.shellSyncTooltipOffline,
        'license' => l10n.settingsSyncRetryLicenseExpired,
        'busy' => l10n.dashboardSyncRunning,
        _ => l10n.settingsSyncRetryFailed(detail ?? ''),
      };
      messenger.showSnackBar(SnackBar(content: Text(text)));
  }
}
