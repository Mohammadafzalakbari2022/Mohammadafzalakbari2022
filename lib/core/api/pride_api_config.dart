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
}
