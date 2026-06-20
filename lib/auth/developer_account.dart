import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/api/pride_api_config.dart';
import '../core/persistence/shared_preferences_provider.dart';
import '../features/settings/settings_providers.dart';
import 'admin_me_provider.dart';
import 'auth_providers.dart';
import 'auth_session.dart';
import 'developer_portal_gate.dart';

/// Whether the signed-in session is a developer / portal-admin account.
///
/// Developer accounts are never license-blocked and may see Developer Portal
/// when [showDeveloperPortalInSettings] also passes.
bool isDeveloperAccountSession({
  required AuthSession auth,
  required bool devSimulated,
  AdminMeCheckResult? adminCheck,
  required SharedPreferences prefs,
}) {
  if (kDebugMode && devSimulated) return true;
  if (!auth.authenticated || !auth.hasApiSession) return false;

  if (PrideApiConfig.isDeveloperLogin(
    shopId: auth.shopId,
    username: auth.username,
  )) {
    return true;
  }
  if (adminCheck?.isDeveloper == true) return true;

  return isPersistedDeveloperForSession(
    prefs,
    shopId: auth.shopId ?? '',
    username: auth.username ?? '',
  );
}

/// Riverpod helper for license gates and settings.
final isDeveloperAccountProvider = Provider<bool>((ref) {
  return isDeveloperAccountSession(
    auth: ref.watch(authSessionProvider),
    devSimulated: ref.watch(isDeveloperProvider),
    adminCheck: ref.watch(adminMeProvider).valueOrNull,
    prefs: ref.watch(sharedPreferencesProvider),
  );
});
