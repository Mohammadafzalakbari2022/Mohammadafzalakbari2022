import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth_providers.dart';
import '../auth/offline_credential_storage.dart';
import '../core/api/pride_api_auth.dart';
import '../core/api/pride_api_config.dart';
import '../core/persistence/shared_preferences_provider.dart';
import 'owner_password_verify.dart';

/// Confirms the shop **owner login password** for backup/restore and similar gates.
///
/// Checks, in order: cached owner credential on device, dev/default digest,
/// then live API login when online.
Future<bool> verifyOwnerPasswordForBackup(
  WidgetRef ref,
  String password,
) async {
  final trimmed = password.trim();
  if (trimmed.isEmpty) return false;

  final prefs = ref.read(sharedPreferencesProvider);
  final auth = ref.read(authSessionProvider);
  final shopId = auth.shopId?.trim() ?? '';

  if (shopId.isNotEmpty &&
      OfflineCredentialStorage.verifyOwnerPasswordForShop(
        prefs: prefs,
        shopId: shopId,
        password: trimmed,
      )) {
    return true;
  }

  if (verifyOwnerPasswordForLocalActions(trimmed)) {
    return true;
  }

  if (!PrideApiConfig.isConfigured || shopId.isEmpty) {
    return false;
  }

  final ownerUsername = OfflineCredentialStorage.ownerUsernameForShop(
        prefs,
        shopId,
      ) ??
      (auth.isShopOwner ? auth.username?.trim() : null);
  if (ownerUsername == null || ownerUsername.isEmpty) {
    return false;
  }

  final result = await postPrideApiLogin(
    username: ownerUsername,
    password: trimmed,
    shopId: shopId,
  );
  if (result is! PrideApiLoginOk || !result.isShopOwner) {
    return false;
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
  return true;
}
