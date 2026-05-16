import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth_providers.dart';
import '../auth/auth_session_storage.dart';
import '../core/persistence/shared_preferences_provider.dart';
import 'license_clock_guard.dart';
import 'license_providers.dart';

/// Best-effort server instant from a license snapshot (for clock anchoring).
DateTime? snapshotServerUtcFromLicenseJson(Map<String, dynamic> snapshot) {
  for (final k in ['server_now', 'last_successful_check_at']) {
    final v = snapshot[k];
    if (v is String && v.isNotEmpty) {
      final d = DateTime.tryParse(v);
      if (d != null) return d.toUtc();
    }
  }
  return null;
}

/// Applies a server license snapshot to the client and mirrors `status` into prefs
/// when an API session exists (same as Subscription screen).
Future<void> persistLicenseSnapshotFromApi(
  WidgetRef ref,
  Map<String, dynamic> snapshot,
) async {
  final license = ref.read(licenseNotifierProvider);
  license.applyLicenseSnapshotMap(snapshot);
  final prefs = ref.read(sharedPreferencesProvider);
  final serverUtc = snapshotServerUtcFromLicenseJson(snapshot);
  await LicenseClockGuard.onTrustedServerSnapshot(
    prefs,
    serverNowUtc: serverUtc,
  );
  license.setSuspectedTimeTamper(LicenseClockGuard.readTamperFlag(prefs));
  final session = ref.read(authSessionProvider);
  if (session.hasApiSession) {
    await AuthSessionStorage.updatePersistedLicenseFromSnapshot(
      prefs,
      snapshot,
    );
  }
}
