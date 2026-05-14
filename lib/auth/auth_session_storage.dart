import 'package:shared_preferences/shared_preferences.dart';

import '../core/api/pride_api_config.dart';
import '../licensing/license_notifier.dart';
import 'auth_session.dart';

/// Persists API login fields for cold start (`IMPLEMENTATION_TODO.md` P0).
abstract final class AuthSessionStorage {
  static const _accessToken = 'pride_auth_api_access_token';
  static const _userId = 'pride_auth_api_user_id';
  static const _shopId = 'pride_auth_api_shop_id';
  static const _username = 'pride_auth_api_username';
  static const _isOwner = 'pride_auth_api_is_shop_owner';
  static const _licenseStatus = 'pride_auth_api_license_status';

  static Future<void> persist(
    SharedPreferences prefs, {
    required String accessToken,
    required String userId,
    required String shopId,
    required String username,
    required bool isShopOwner,
    required String licenseStatusApi,
  }) async {
    await prefs.setString(_accessToken, accessToken);
    await prefs.setString(_userId, userId);
    await prefs.setString(_shopId, shopId);
    await prefs.setString(_username, username);
    await prefs.setBool(_isOwner, isShopOwner);
    await prefs.setString(_licenseStatus, licenseStatusApi);
  }

  static Future<void> clear(SharedPreferences prefs) async {
    await prefs.remove(_accessToken);
    await prefs.remove(_userId);
    await prefs.remove(_shopId);
    await prefs.remove(_username);
    await prefs.remove(_isOwner);
    await prefs.remove(_licenseStatus);
  }

  /// Updates stored license status when a persisted API session exists.
  static Future<void> updatePersistedLicenseStatus(
    SharedPreferences prefs,
    String licenseStatusApi,
  ) async {
    final token = prefs.getString(_accessToken);
    if (token == null || token.isEmpty) return;
    await prefs.setString(_licenseStatus, licenseStatusApi);
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
    final owner = prefs.getBool(_isOwner);
    final lic = prefs.getString(_licenseStatus);

    if (userId == null ||
        shopId == null ||
        username == null ||
        owner == null ||
        lic == null) {
      await clear(prefs);
      return false;
    }

    session.signInFromApi(
      accessToken: token,
      userId: userId,
      username: username,
      shopId: shopId,
      isShopOwner: owner,
    );
    license.applyLicenseSnapshotMap({'status': lic});
    return true;
  }
}
