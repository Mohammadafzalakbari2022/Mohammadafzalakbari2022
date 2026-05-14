import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// Optional crash reporting via [Sentry](https://sentry.io).
///
/// Enable with `--dart-define=PRIDE_SENTRY_DSN=https://...@.../...`
/// (never commit a production DSN in source).
///
/// Optional:
/// - `PRIDE_SENTRY_ENV` (default `development`)
/// - `PRIDE_SENTRY_TRACES_SAMPLE_RATE` (default `0.2`)
Future<void> runWithOptionalSentry(Future<void> Function() appRunner) async {
  const dsn = String.fromEnvironment('PRIDE_SENTRY_DSN', defaultValue: '');
  if (dsn.isEmpty) {
    await appRunner();
    return;
  }

  const env =
      String.fromEnvironment('PRIDE_SENTRY_ENV', defaultValue: 'development');
  final tracesRaw = const String.fromEnvironment(
    'PRIDE_SENTRY_TRACES_SAMPLE_RATE',
    defaultValue: '0.2',
  );
  final traces = double.tryParse(tracesRaw) ?? 0.2;

  await SentryFlutter.init(
    (options) {
      options.dsn = dsn;
      options.environment = env;
      options.tracesSampleRate = traces;
      options.sendDefaultPii = false;
      if (kDebugMode) {
        options.debug = false;
      }
    },
    appRunner: appRunner,
  );
}
