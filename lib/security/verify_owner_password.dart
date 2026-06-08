import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth_providers.dart';
import '../auth/offline_credential_storage.dart';
import '../core/api/pride_api_auth.dart';
import '../core/api/pride_api_config.dart';
import '../core/persistence/shared_preferences_provider.dart';
import 'owner_password_verify.dart';
import 'owner_password_verify_result.dart';

/// Confirms the shop **owner login password** for backup/restore and similar gates.
Future<OwnerPasswordVerifyResult> verifyOwnerPasswordForBackupDetailed(
  WidgetRef ref,
  String password,
) async {
  final trimmed = password.trim();
  if (trimmed.isEmpty) return OwnerPasswordVerifyResult.wrongPassword;

  final prefs = ref.read(sharedPreferencesProvider);
  final auth = ref.read(authSessionProvider);
  final shopId = auth.shopId?.trim() ?? '';

  if (shopId.isNotEmpty &&
      OfflineCredentialStorage.verifyOwnerPasswordForShop(
        prefs: prefs,
        shopId: shopId,
        password: trimmed,
      )) {
    return OwnerPasswordVerifyResult.success;
  }

  // Logged-in owner re-entering password on this device.
  if (auth.isShopOwner &&
      shopId.isNotEmpty &&
      (auth.username?.trim().isNotEmpty ?? false)) {
    final ownerRow = OfflineCredentialStorage.verify(
      prefs: prefs,
      username: auth.username!.trim(),
      password: trimmed,
      shopId: shopId,
    );
    if (ownerRow is OfflineVerifyOk && ownerRow.isShopOwner) {
      return OwnerPasswordVerifyResult.success;
    }
  }

  if (verifyOwnerPasswordForLocalActions(trimmed)) {
    return OwnerPasswordVerifyResult.success;
  }

  if (!PrideApiConfig.isConfigured || shopId.isEmpty) {
    return OwnerPasswordVerifyResult.offlineUnavailable;
  }

  final ownerUsername = OfflineCredentialStorage.ownerUsernameForShop(
        prefs,
        shopId,
      ) ??
      (auth.isShopOwner ? auth.username?.trim() : null);
  if (ownerUsername == null || ownerUsername.isEmpty) {
    return OwnerPasswordVerifyResult.ownerCredentialMissing;
  }

  final result = await postPrideApiLogin(
    username: ownerUsername,
    password: trimmed,
    shopId: shopId,
  );
  if (result is! PrideApiLoginOk || !result.isShopOwner) {
    return OwnerPasswordVerifyResult.wrongPassword;
  }

  await OfflineCredentialStorage.upsertFromLogin(
    prefs,
    shopId: result.shopId,
    username: result.username,
    userId: result.userId,
    isShopOwner: true,
    password: trimmed,
    accessToken: result.accessToken,
    licenseStatusApi:
        (result.licenseSnapshot['status'] as String?) ?? 'trial_active',
    licenseExpiresAtIso: result.licenseSnapshot['expires_at'] as String?,
    licenseLastSuccessfulCheckAtIso:
        result.licenseSnapshot['last_successful_check_at'] as String?,
  );
  return OwnerPasswordVerifyResult.success;
}

/// Backward-compatible bool wrapper.
Future<bool> verifyOwnerPasswordForBackup(
  WidgetRef ref,
  String password,
) async {
  final r = await verifyOwnerPasswordForBackupDetailed(ref, password);
  return r == OwnerPasswordVerifyResult.success;
}
