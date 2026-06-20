import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth_providers.dart';
import '../auth/auth_session_storage.dart';
import '../auth/offline_credential_storage.dart';
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
    final licRaw = snapshot['status'];
    final licStr =
        licRaw is String && licRaw.isNotEmpty ? licRaw : 'trial_active';
    final expRaw = snapshot['expires_at'];
    final expStr = expRaw is String && expRaw.isNotEmpty ? expRaw : null;
    final lastRaw = snapshot['last_successful_check_at'] ?? snapshot['server_now'];
    final lastStr = lastRaw is String && lastRaw.isNotEmpty ? lastRaw : null;
    final shopId = session.shopId;
    final username = session.username;
    if (shopId != null &&
        shopId.isNotEmpty &&
        username != null &&
        username.isNotEmpty) {
      await OfflineCredentialStorage.updateLicenseSnapshot(
        prefs,
        shopId: shopId,
        username: username,
        licenseStatusApi: licStr,
        licenseExpiresAtIso: expStr,
        licenseLastSuccessfulCheckAtIso: lastStr,
      );
    }
  }
}
