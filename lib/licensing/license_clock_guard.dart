import 'package:shared_preferences/shared_preferences.dart';

/// Local device-clock sanity checks (`plan-06` offline anti-tamper, lightweight).
///
/// Uses a monotonically non-decreasing **wall clock watermark** persisted on disk.
/// If the device clock jumps backwards beyond [rewindTolerance], we set
/// `suspected_time_tamper` until a successful online license response clears it.
abstract final class LicenseClockGuard {
  static const maxSeenWallUtcKey = 'pride_clock_max_seen_device_utc';
  static const tamperKey = 'pride_clock_suspected_tamper';

  static bool readTamperFlag(SharedPreferences prefs) =>
      prefs.getBool(tamperKey) ?? false;

  static Future<void> writeTamperFlag(SharedPreferences prefs, bool value) =>
      prefs.setBool(tamperKey, value);

  /// First launch or after data wipe: establish baseline without flagging tamper.
  static Future<void> bootstrapIfNeeded(SharedPreferences prefs) async {
    final existing = prefs.getString(maxSeenWallUtcKey);
    if (existing != null && existing.isNotEmpty) return;
    final now = DateTime.now().toUtc();
    await prefs.setString(maxSeenWallUtcKey, now.toIso8601String());
  }

  /// Call on [AppLifecycleState.resumed] before relying on license grace.
  static Future<void> onResumeWallClock(SharedPreferences prefs) async {
    await bootstrapIfNeeded(prefs);
    final now = DateTime.now().toUtc();
    final maxSeen = DateTime.tryParse(prefs.getString(maxSeenWallUtcKey) ?? '')
        ?.toUtc();
    if (maxSeen == null) {
      await prefs.setString(maxSeenWallUtcKey, now.toIso8601String());
      return;
    }
    if (now.isBefore(maxSeen.subtract(const Duration(minutes: 5)))) {
      await prefs.setBool(tamperKey, true);
    }
    if (now.isAfter(maxSeen)) {
      await prefs.setString(maxSeenWallUtcKey, now.toIso8601String());
    }
  }

  /// After a trusted server license snapshot (login, refresh, periodic poll).
  static Future<void> onTrustedServerSnapshot(
    SharedPreferences prefs, {
    DateTime? serverNowUtc,
  }) async {
    final now = DateTime.now().toUtc();
    final server = serverNowUtc ?? now;
    final maxSeen = DateTime.tryParse(prefs.getString(maxSeenWallUtcKey) ?? '')
            ?.toUtc() ??
        now;
    var next = maxSeen;
    if (now.isAfter(next)) next = now;
    if (server.isAfter(next)) next = server;
    await prefs.setString(maxSeenWallUtcKey, next.toIso8601String());
    await prefs.setBool(tamperKey, false);
  }
}
