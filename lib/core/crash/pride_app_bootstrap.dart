import 'dart:async';

import 'package:flutter/material.dart';
import '../cache/app_cache_manager.dart';
import 'pride_error_collector.dart';
import 'pride_runtime_error_overlay.dart';
import 'sentry_bootstrap.dart';

/// Initializes optional Sentry and error hooks, then calls [runAppNow] immediately.
///
/// SharedPreferences and cache cleanup run **after** the first frame so Android
/// does not sit on a black native splash while disk I/O runs.
Future<void> bootstrapPrideApp(void Function() runAppNow) async {
  await runWithOptionalSentry(() async {
    WidgetsFlutterBinding.ensureInitialized();
    PrideErrorCollector.installEarlyHooks();
    ErrorWidget.builder = prideBuildFatalErrorWidget;
    runZonedGuarded(
      () {
        runAppNow();
        schedulePrideWarmUpFrame();
        unawaited(_deferredStartupSideEffects());
      },
      (error, stack) {
        unawaited(PrideErrorCollector.record(error, stack: stack, fatal: true));
      },
    );
  });
}

Future<void> _deferredStartupSideEffects() async {
  try {
    await Future<void>.delayed(const Duration(seconds: 2));
    await AppCacheManager.trimTempFiles();
  } on Object catch (e, stack) {
    await PrideErrorCollector.record(
      e,
      stack: stack,
      source: 'bootstrap_deferred',
      fatal: false,
    );
  }
}
