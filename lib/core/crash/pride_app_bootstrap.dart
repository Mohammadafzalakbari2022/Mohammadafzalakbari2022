import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../cache/app_cache_manager.dart';
import 'pride_error_collector.dart';
import 'sentry_bootstrap.dart';

/// Initializes optional Sentry, error collection, and cache trim, then runs [appRunner].
Future<void> bootstrapPrideApp(Future<void> Function() appRunner) async {
  await runWithOptionalSentry(() async {
    WidgetsFlutterBinding.ensureInitialized();
    final prefs = await SharedPreferences.getInstance();
    await PrideErrorCollector.install(prefs);
    await AppCacheManager.trimTempFiles();
    await runZonedGuarded(
      appRunner,
      (error, stack) {
        unawaited(PrideErrorCollector.record(error, stack: stack, fatal: true));
      },
    );
  });
}
