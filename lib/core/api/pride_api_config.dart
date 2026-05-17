/// Compile-time API root from `--dart-define=API_BASE_URL=...` (plan-20).
abstract final class PrideApiConfig {
  static const String _raw = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  /// Trims and removes a single trailing `/`. Empty input yields `null`.
  static String? get normalizedBase {
    final s = _raw.trim();
    if (s.isEmpty) return null;
    if (s.endsWith('/')) {
      return s.substring(0, s.length - 1);
    }
    return s;
  }

  static bool get isConfigured => normalizedBase != null;

  /// Mirrors server `PRIDE_DEVELOPER_USERS` (`shop_id|username`, comma-separated).
  static const String _developerUsersRaw = String.fromEnvironment(
    'PRIDE_DEVELOPER_USERS',
    defaultValue: '',
  );

  /// Client-side gate for showing Developer Portal (server still enforces API).
  static bool isDeveloperLogin({String? shopId, String? username}) {
    final entries = _parseDeveloperUsers(_developerUsersRaw);
    if (entries.isEmpty) return false;
    final sid = (shopId ?? '').trim().toLowerCase();
    final user = (username ?? '').trim().toLowerCase();
    if (user.isEmpty) return false;
    for (final e in entries) {
      if (e.$2 == user && (e.$1.isEmpty || e.$1 == sid)) return true;
    }
    return false;
  }

  static List<(String shopId, String username)> _parseDeveloperUsers(String raw) {
    final out = <(String, String)>[];
    for (final part in raw.split(',')) {
      final t = part.trim();
      if (t.isEmpty) continue;
      final pipe = t.indexOf('|');
      if (pipe < 0) {
        out.add(('', t.toLowerCase()));
      } else {
        out.add((
          t.substring(0, pipe).trim().toLowerCase(),
          t.substring(pipe + 1).trim().toLowerCase(),
        ));
      }
    }
    return out;
  }
}
