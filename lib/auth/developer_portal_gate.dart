import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/api/pride_api_config.dart';
import 'admin_me_provider.dart';
import 'auth_session.dart';

const pridePersistedDeveloperFlagKey = 'pride_persisted_developer_portal';
const pridePersistedDeveloperIdentityKey = 'pride_persisted_developer_identity';

String developerSessionIdentityKey({required String shopId, required String username}) {
  return '${shopId.trim().toLowerCase()}|${username.trim().toLowerCase()}';
}

/// Whether [prefs] holds a developer unlock for this exact shop user.
bool isPersistedDeveloperForSession(
  SharedPreferences prefs, {
  required String shopId,
  required String username,
}) {
  if (!(prefs.getBool(pridePersistedDeveloperFlagKey) ?? false)) return false;
  final stored = prefs.getString(pridePersistedDeveloperIdentityKey)?.trim();
  if (stored == null || stored.isEmpty) return false;
  return stored == developerSessionIdentityKey(shopId: shopId, username: username);
}

/// Whether Settings should show the in-app Developer Portal entry.
bool showDeveloperPortalInSettings({
  required AuthSession auth,
  required AdminMeCheckResult? adminCheck,
  required bool devSimulated,
  required bool persistedDeveloperFlag,
  required SharedPreferences prefs,
}) {
  if (kDebugMode && devSimulated) return true;
  if (!auth.authenticated || !auth.hasApiSession) return false;
  if (adminCheck?.isDeveloper == true) return true;
  if (PrideApiConfig.isDeveloperLogin(
    shopId: auth.shopId,
    username: auth.username,
  )) {
    return true;
  }
  if (persistedDeveloperFlag) {
    return isPersistedDeveloperForSession(
      prefs,
      shopId: auth.shopId ?? '',
      username: auth.username ?? '',
    );
  }
  return false;
}

/// Whether Settings should show sync diagnostics, conflicts, and lab tooling.
bool showDeveloperDiagnosticsInSettings({
  required AuthSession auth,
  required AdminMeCheckResult? adminCheck,
  required bool devSimulated,
  required bool persistedDeveloperFlag,
  required SharedPreferences prefs,
}) =>
    showDeveloperPortalInSettings(
      auth: auth,
      adminCheck: adminCheck,
      devSimulated: devSimulated,
      persistedDeveloperFlag: persistedDeveloperFlag,
      prefs: prefs,
    );
