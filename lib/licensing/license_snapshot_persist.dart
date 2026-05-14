import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth_providers.dart';
import '../auth/auth_session_storage.dart';
import '../core/persistence/shared_preferences_provider.dart';
import 'license_providers.dart';

/// Applies a server license snapshot to the client and mirrors `status` into prefs
/// when an API session exists (same as Subscription screen).
Future<void> persistLicenseSnapshotFromApi(
  WidgetRef ref,
  Map<String, dynamic> snapshot,
) async {
  ref.read(licenseNotifierProvider).applyLicenseSnapshotMap(snapshot);
  final session = ref.read(authSessionProvider);
  if (session.hasApiSession) {
    final raw = snapshot['status'];
    if (raw is String && raw.isNotEmpty) {
      await AuthSessionStorage.updatePersistedLicenseStatus(
        ref.read(sharedPreferencesProvider),
        raw,
      );
    }
  }
}
