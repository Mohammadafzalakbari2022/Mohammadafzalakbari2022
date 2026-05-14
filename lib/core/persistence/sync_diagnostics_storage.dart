import 'package:shared_preferences/shared_preferences.dart';

/// Persists sync diagnostics that should survive app restarts (plan-03 / plan-15).
abstract final class SyncDiagnosticsStorage {
  static const _lastSuccessfulSyncEpochMs = 'pride_sync_last_success_epoch_ms';

  /// Last successful manual (or future automatic) server sync instant, if any.
  static DateTime? readLastSuccessfulSync(SharedPreferences prefs) {
    final ms = prefs.getInt(_lastSuccessfulSyncEpochMs);
    if (ms == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true).toLocal();
  }

  static Future<void> recordSuccessfulSync(
    SharedPreferences prefs,
    DateTime at,
  ) async {
    await prefs.setInt(
      _lastSuccessfulSyncEpochMs,
      at.toUtc().millisecondsSinceEpoch,
    );
  }

  static Future<void> clear(SharedPreferences prefs) async {
    await prefs.remove(_lastSuccessfulSyncEpochMs);
  }
}
