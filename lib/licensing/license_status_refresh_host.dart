import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth_providers.dart';
import '../core/api/pride_api_config.dart';
import '../core/api/pride_api_license.dart';
import '../core/persistence/shared_preferences_provider.dart';
import 'license_clock_guard.dart';
import 'license_providers.dart';
import 'license_snapshot_persist.dart';

/// Periodically calls `GET /license/status` while an API session is active (plan-06).
///
/// Pauses the timer while the app is not in the foreground to reduce background work.
class LicenseStatusRefreshHost extends ConsumerStatefulWidget {
  const LicenseStatusRefreshHost({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<LicenseStatusRefreshHost> createState() =>
      _LicenseStatusRefreshHostState();
}

class _LicenseStatusRefreshHostState extends ConsumerState<LicenseStatusRefreshHost>
    with WidgetsBindingObserver {
  static const _interval = Duration(minutes: 15);
  static const _minGapBetweenPulls = Duration(seconds: 45);

  Timer? _timer;
  DateTime? _lastPullAt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _restartTimer();
      unawaited(_pull(bypassMinGap: true));
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
      unawaited(_onResumed());
    }
  }

  Future<void> _onResumed() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await LicenseClockGuard.onResumeWallClock(prefs);
    if (!mounted) return;
    ref.read(licenseNotifierProvider).setSuspectedTimeTamper(
          LicenseClockGuard.readTamperFlag(prefs),
        );
    _restartTimer();
    await _pull(bypassMinGap: true);
  }

  bool _shouldPoll() {
    if (!PrideApiConfig.isConfigured) return false;
    final auth = ref.read(authSessionProvider);
    if (!auth.hasApiSession) return false;
    final t = auth.accessToken;
    return t != null && t.isNotEmpty;
  }

  void _restartTimer() {
    _timer?.cancel();
    _timer = null;
    if (!_shouldPoll()) return;
    _timer = Timer.periodic(_interval, (_) {
      unawaited(_pull(bypassMinGap: false));
    });
  }

  Future<void> _pull({required bool bypassMinGap}) async {
    if (!_shouldPoll()) return;
    final now = DateTime.now();
    if (!bypassMinGap &&
        _lastPullAt != null &&
        now.difference(_lastPullAt!) < _minGapBetweenPulls) {
      return;
    }
    final auth = ref.read(authSessionProvider);
    final result = await fetchPrideApiLicenseStatus(
      accessToken: auth.accessToken,
    );
    if (!mounted) return;
    if (result is PrideApiLicenseOk) {
      _lastPullAt = DateTime.now();
      await persistLicenseSnapshotFromApi(ref, result.snapshot);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authSessionProvider, (previous, next) {
      _restartTimer();
      unawaited(_pull(bypassMinGap: true));
    });
    return widget.child;
  }
}
