import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Device-local login verifier after a successful online session (`plan-04`).
///
/// Survives sign-out; not cleared by [AuthSessionStorage.clear].
abstract final class OfflineCredentialStorage {
  static const _prefsKey = 'pride_offline_credentials_v1';

  /// SHA-256 hex digest — matches [ShopRegistryService] on the API.
  static String sha256PasswordHex(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  static Future<void> upsertFromLogin(
    SharedPreferences prefs, {
    required String shopId,
    required String username,
    required String userId,
    required bool isShopOwner,
    required String password,
    required String accessToken,
    required String licenseStatusApi,
    String? licenseExpiresAtIso,
    String? licenseLastSuccessfulCheckAtIso,
  }) async {
    final sid = shopId.trim();
    final user = username.trim();
    if (sid.isEmpty || user.isEmpty || password.isEmpty) return;

    final list = _readList(prefs);
    final hash = sha256PasswordHex(password);
    final key = _entryKey(sid, user);
    final next = list.where((e) => _entryKeyFromMap(e) != key).toList();
    next.add({
      'shop_id': sid,
      'username': user,
      'user_id': userId,
      'is_shop_owner': isShopOwner,
      'password_hash': hash,
      'access_token': accessToken,
      'license_status': licenseStatusApi,
      if (licenseExpiresAtIso != null && licenseExpiresAtIso.isNotEmpty)
        'license_expires_at': licenseExpiresAtIso,
      if (licenseLastSuccessfulCheckAtIso != null &&
          licenseLastSuccessfulCheckAtIso.isNotEmpty)
        'license_last_check_at': licenseLastSuccessfulCheckAtIso,
    });
    await prefs.setString(_prefsKey, jsonEncode(next));
  }

  static Future<void> updatePasswordHash(
    SharedPreferences prefs, {
    required String shopId,
    required String username,
    required String newPassword,
  }) async {
    final sid = shopId.trim();
    final user = username.trim();
    if (sid.isEmpty || user.isEmpty || newPassword.isEmpty) return;

    final list = _readList(prefs);
    final key = _entryKey(sid, user);
    var changed = false;
    for (final e in list) {
      if (_entryKeyFromMap(e) == key) {
        e['password_hash'] = sha256PasswordHex(newPassword);
        changed = true;
        break;
      }
    }
    if (changed) {
      await prefs.setString(_prefsKey, jsonEncode(list));
    }
  }

  /// Verifies password against a cached credential (`plan-04`).
  static OfflineVerifyResult verify({
    required SharedPreferences prefs,
    required String username,
    required String password,
    String? shopId,
  }) {
    final user = username.trim();
    if (user.isEmpty || password.isEmpty) {
      return const OfflineVerifyNotFound();
    }

    final hash = sha256PasswordHex(password);
    final list = _readList(prefs);
    final sid = shopId?.trim() ?? '';

    var candidates = list.where(
      (e) => (e['username'] as String? ?? '').trim() == user,
    );
    if (sid.isNotEmpty) {
      candidates = candidates.where(
        (e) => (e['shop_id'] as String? ?? '').trim() == sid,
      );
    }

    final rows = candidates.toList();
    if (rows.isEmpty) return const OfflineVerifyNotFound();
    if (sid.isEmpty && rows.length > 1) {
      return const OfflineVerifyRequiresShopId();
    }

    final m = rows.first;
    if ((m['password_hash'] as String? ?? '') != hash) {
      return const OfflineVerifyWrongPassword();
    }

    final token = m['access_token'] as String?;
    if (token == null || token.isEmpty) return const OfflineVerifyNotFound();

    return OfflineVerifyOk(
      shopId: (m['shop_id'] as String).trim(),
      username: user,
      userId: (m['user_id'] as String).trim(),
      isShopOwner: m['is_shop_owner'] == true,
      accessToken: token,
      licenseStatusApi: (m['license_status'] as String?) ?? 'trial_active',
      licenseExpiresAtIso: m['license_expires_at'] as String?,
      licenseLastSuccessfulCheckAtIso: m['license_last_check_at'] as String?,
    );
  }

  static List<Map<String, dynamic>> _readList(SharedPreferences prefs) {
    final raw = prefs.getString(_prefsKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return [];
      return decoded
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static String _entryKey(String shopId, String username) =>
      '${shopId.trim()}\u0000${username.trim()}';

  static String _entryKeyFromMap(Map<String, dynamic> e) => _entryKey(
        e['shop_id'] as String? ?? '',
        e['username'] as String? ?? '',
      );
}

sealed class OfflineVerifyResult {
  const OfflineVerifyResult();
}

final class OfflineVerifyOk extends OfflineVerifyResult {
  const OfflineVerifyOk({
    required this.shopId,
    required this.username,
    required this.userId,
    required this.isShopOwner,
    required this.accessToken,
    required this.licenseStatusApi,
    this.licenseExpiresAtIso,
    this.licenseLastSuccessfulCheckAtIso,
  });

  final String shopId;
  final String username;
  final String userId;
  final bool isShopOwner;
  final String accessToken;
  final String licenseStatusApi;
  final String? licenseExpiresAtIso;
  final String? licenseLastSuccessfulCheckAtIso;
}

final class OfflineVerifyWrongPassword extends OfflineVerifyResult {
  const OfflineVerifyWrongPassword();
}

final class OfflineVerifyNotFound extends OfflineVerifyResult {
  const OfflineVerifyNotFound();
}

final class OfflineVerifyRequiresShopId extends OfflineVerifyResult {
  const OfflineVerifyRequiresShopId();
}
