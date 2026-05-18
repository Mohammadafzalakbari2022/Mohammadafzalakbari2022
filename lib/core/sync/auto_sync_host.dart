import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/auth_providers.dart';
import '../../licensing/license_providers.dart';
import '../api/pride_api_config.dart';
import '../crash/pride_error_collector.dart';
import '../../shell/shell_sync_providers.dart';
import 'manual_sync_controller.dart';

/// Background sync on app open, resume, connectivity restore, and every 15 min
/// while foreground (`plan-03`). Silent — no snackbars.
class AutoSyncHost extends ConsumerStatefulWidget {
  const AutoSyncHost({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<AutoSyncHost> createState() => _AutoSyncHostState();
}

class _AutoSyncHostState extends ConsumerState<AutoSyncHost>
    with WidgetsBindingObserver {
  static const _interval = Duration(minutes: 15);
  static const _minGapBetweenRuns = Duration(seconds: 60);

  Timer? _timer;
  DateTime? _lastRunAt;
  bool? _wasOnline;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _wasOnline = ref.read(connectivityOnlineProvider);
      _restartTimer();
      unawaited(_runSync(bypassMinGap: true));
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _timer?.cancel();
      _timer = null;
      return;
    }
    if (state == AppLifecycleState.resumed) {
      _restartTimer();
      unawaited(_runSync(bypassMinGap: true));
    }
  }

  bool _shouldSync() {
    if (!PrideApiConfig.isConfigured) return false;
    final auth = ref.read(authSessionProvider);
    if (!auth.hasApiSession) return false;
    final token = auth.accessToken;
    if (token == null || token.isEmpty) return false;
    if (!ref.read(connectivityOnlineProvider)) return false;
    if (ref.read(licenseEditingBlockedProvider)) return false;
    return true;
  }

  void _restartTimer() {
    _timer?.cancel();
    _timer = null;
    if (!_shouldSync()) return;
    _timer = Timer.periodic(_interval, (_) {
      unawaited(_runSync(bypassMinGap: false));
    });
  }

  Future<void> _runSync({required bool bypassMinGap}) async {
    if (!_shouldSync()) return;
    final now = DateTime.now();
    if (!bypassMinGap &&
        _lastRunAt != null &&
        now.difference(_lastRunAt!) < _minGapBetweenRuns) {
      return;
    }
    _lastRunAt = now;

    final outcome = await runManualSyncFromRef(ref);
    if (!mounted) return;

    switch (outcome) {
      case ManualSyncUiSuccess():
        break;
      case ManualSyncUiFailure(:final messageKey, :final detail):
        if (messageKey == 'busy') return;
        unawaited(
          PrideErrorCollector.record(
            Exception('auto_sync: $messageKey'),
            source: 'auto_sync',
            context: detail,
          ),
        );
    }
  }

  void _onConnectivityChanged(List<ConnectivityResult>? previous, List<ConnectivityResult> next) {
    final online = next.any((r) => r != ConnectivityResult.none);
    final was = _wasOnline;
    _wasOnline = online;
    if (online && was == false) {
      unawaited(_runSync(bypassMinGap: true));
    }
    _restartTimer();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authSessionProvider, (previous, next) {
      _restartTimer();
      if (next.hasApiSession && (previous?.hasApiSession != true)) {
        unawaited(_runSync(bypassMinGap: true));
      }
    });
    ref.listen(licenseEditingBlockedProvider, (previous, next) {
      if (previous != next) _restartTimer();
    });
    ref.listen(connectivityListProvider, (previous, next) {
      next.whenData((list) {
        _onConnectivityChanged(
          previous?.maybeWhen(data: (v) => v, orElse: () => null),
          list,
        );
      });
    });
    return widget.child;
  }
}
