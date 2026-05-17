import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/core/sync/manual_sync_ui.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import 'shell_sync_providers.dart';

/// Prominent sync control on primary tab app bars (dashboard shortcut).
class ShellAppBarSyncIconButton extends ConsumerStatefulWidget {
  const ShellAppBarSyncIconButton({super.key});

  @override
  ConsumerState<ShellAppBarSyncIconButton> createState() =>
      _ShellAppBarSyncIconButtonState();
}

class _ShellAppBarSyncIconButtonState
    extends ConsumerState<ShellAppBarSyncIconButton> {
  var _busy = false;

  Future<void> _runSync() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await runManualSyncWithFeedback(context: context, ref: ref);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final online = ref.watch(connectivityOnlineProvider);

    return IconButton(
      tooltip: l10n.shellAppBarSyncA11y,
      onPressed: _busy || !online ? null : _runSync,
      icon: _busy
          ? SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Theme.of(context).colorScheme.primary,
              ),
            )
          : Icon(
              Icons.sync,
              color: online
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outline,
            ),
    );
  }
}
