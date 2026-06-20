import 'package:shared_preferences/shared_preferences.dart';

import '../core/api/pride_api_config.dart';
import '../licensing/license_clock_guard.dart';
import '../licensing/license_notifier.dart';
import 'auth_session.dart';
import 'developer_portal_gate.dart';
import 'jwt_access_payload.dart';

/// Persists API login fields for cold start (`IMPLEMENTATION_TODO.md` P0).
abstract final class AuthSessionStorage {
  static const _accessToken = 'pride_auth_api_access_token';
  static const _userId = 'pride_auth_api_user_id';
  static const _shopId = 'pride_auth_api_shop_id';
  static const _username = 'pride_auth_api_username';
  static const _isOwner = 'pride_auth_api_is_shop_owner';
  static const _licenseStatus = 'pride_auth_api_license_status';
  static const _licenseExpiresAt = 'pride_auth_api_license_expires_at';
  static const _licenseLastCheckAt =
      'pride_auth_api_license_last_successful_check_at';
  static const _mockUsername = 'pride_auth_mock_username';
  static const _mockShopId = 'pride_auth_mock_shop_id';

  static Future<void> persist(
    SharedPreferences prefs, {
    required String accessToken,
    required String userId,
    required String shopId,
    required String username,
    required bool isShopOwner,
    required String licenseStatusApi,
    String? licenseExpiresAtIso,
    String? licenseLastSuccessfulCheckAtIso,
  }) async {
    await prefs.setString(_accessToken, accessToken);
    await prefs.setString(_userId, userId);
    await prefs.setString(_shopId, shopId);
    await prefs.setString(_username, username);
    await prefs.setBool(_isOwner, isShopOwner);
    await prefs.setString(_licenseStatus, licenseStatusApi);
    await _writeOptionalIso(
      prefs,
      _licenseExpiresAt,
      licenseExpiresAtIso,
    );
    await _writeOptionalIso(
      prefs,
      _licenseLastCheckAt,
      licenseLastSuccessfulCheckAtIso,
    );
  }

  static Future<void> _writeOptionalIso(
    SharedPreferences prefs,
    String key,
    String? iso,
  ) async {
    final t = iso?.trim();
    if (t == null || t.isEmpty) return;
    await prefs.setString(key, t);
  }

  static Future<void> clear(SharedPreferences prefs) async {
    await prefs.remove(_accessToken);
    await prefs.remove(_userId);
    await prefs.remove(_shopId);
    await prefs.remove(_username);
    await prefs.remove(_isOwner);
    await prefs.remove(_licenseStatus);
    await prefs.remove(_licenseExpiresAt);
    await prefs.remove(_licenseLastCheckAt);
    await prefs.remove(_mockUsername);
    await prefs.remove(_mockShopId);
    await prefs.remove(pridePersistedDeveloperFlagKey);
    await prefs.remove(pridePersistedDeveloperIdentityKey);
  }

  static Future<void> markDeveloperPortalUnlocked(
    SharedPreferences prefs, {
    required String shopId,
    required String username,
  }) async {
    await prefs.setBool(pridePersistedDeveloperFlagKey, true);
    await prefs.setString(
      pridePersistedDeveloperIdentityKey,
      developerSessionIdentityKey(shopId: shopId, username: username),
    );
  }

  /// Saves local-only sign-in for builds without `API_BASE_URL`.
  static Future<void> persistMock(
    SharedPreferences prefs, {
    required String username,
    String? shopId,
  }) async {
    final u = username.trim();
    if (u.isEmpty) return;
    await prefs.setString(_mockUsername, u);
    final s = shopId?.trim();
    if (s == null || s.isEmpty) {
      await prefs.remove(_mockShopId);
    } else {
      await prefs.setString(_mockShopId, s);
    }
  }

  /// Restores a saved local-only session when the API is not configured.
  static Future<bool> restoreMockInto(
    SharedPreferences prefs,
    AuthSession session,
  ) async {
    if (PrideApiConfig.isConfigured) return false;
    final username = prefs.getString(_mockUsername);
    if (username == null || username.trim().isEmpty) return false;
    session.restoreMockSession(
      username: username,
      shopId: prefs.getString(_mockShopId),
    );
    return true;
  }

  /// Updates stored license fields when a persisted API session exists.
  static Future<void> updatePersistedLicenseFromSnapshot(
    SharedPreferences prefs,
    Map<String, dynamic> snapshot,
  ) async {
    final token = prefs.getString(_accessToken);
    if (token == null || token.isEmpty) return;
    final raw = snapshot['status'];
    if (raw is String && raw.isNotEmpty) {
      await prefs.setString(_licenseStatus, raw);
    }
    final exp = snapshot['expires_at'];
    if (exp is String && exp.isNotEmpty) {
      await prefs.setString(_licenseExpiresAt, exp);
    }
    final last = snapshot['last_successful_check_at'] ?? snapshot['server_now'];
    if (last is String && last.isNotEmpty) {
      await prefs.setString(_licenseLastCheckAt, last);
    }
  }

  /// Restores [session] and [license] when `API_BASE_URL` is set and prefs are complete.
  static Future<bool> restoreInto(
    SharedPreferences prefs,
    AuthSession session,
    LicenseNotifier license,
  ) async {
    if (!PrideApiConfig.isConfigured) return false;

    final token = prefs.getString(_accessToken);
    if (token == null || token.isEmpty) return false;

    final userId = prefs.getString(_userId);
    final shopId = prefs.getString(_shopId);
    final username = prefs.getString(_username);
    var owner = prefs.getBool(_isOwner);
    final lic = prefs.getString(_licenseStatus);

    if (userId == null ||
        shopId == null ||
        username == null ||
        owner == null ||
        lic == null) {
      await clear(prefs);
      return false;
    }

    final ownerFromJwt = isShopOwnerClaimFromAccessToken(token);
    if (ownerFromJwt != null && ownerFromJwt != owner) {
      owner = ownerFromJwt;
      await prefs.setBool(_isOwner, ownerFromJwt);
    }

    session.signInFromApi(
      accessToken: token,
      userId: userId,
      username: username,
      shopId: shopId,
      isShopOwner: owner,
    );
    license.applyLicenseSnapshotMap({'status': lic});
    license.restoreTimingFromIso(
      expiresAtIso: prefs.getString(_licenseExpiresAt),
      lastSuccessfulCheckAtIso: prefs.getString(_licenseLastCheckAt),
    );
    license.setSuspectedTimeTamper(LicenseClockGuard.readTamperFlag(prefs));
    return true;
  }
}
