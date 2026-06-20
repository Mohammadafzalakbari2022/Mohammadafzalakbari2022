import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/api/pride_api_admin.dart';
import '../core/api/pride_api_config.dart';
import '../core/persistence/shared_preferences_provider.dart';
import 'auth_providers.dart';
import 'auth_session_storage.dart';

/// Result of `GET /admin/me` when API session is active (`plan-18`).
class AdminMeCheckResult {
  const AdminMeCheckResult._({
    required this.isDeveloper,
    this.checkFailed = false,
    this.errorMessage,
  });

  const AdminMeCheckResult.ok({required bool isDeveloper})
      : this._(isDeveloper: isDeveloper);

  const AdminMeCheckResult.failed(String message)
      : this._(
          isDeveloper: false,
          checkFailed: true,
          errorMessage: message,
        );

  const AdminMeCheckResult.unavailable()
      : this._(isDeveloper: false);

  final bool isDeveloper;
  final bool checkFailed;
  final String? errorMessage;
}

/// Server-backed developer flag; unavailable when no API session.
final adminMeProvider = FutureProvider<AdminMeCheckResult>((ref) async {
  ref.watch(authSessionProvider);
  final auth = ref.read(authSessionProvider);
  if (!PrideApiConfig.isConfigured || !auth.hasApiSession) {
    return const AdminMeCheckResult.unavailable();
  }
  final token = auth.accessToken;
  if (token == null) return const AdminMeCheckResult.unavailable();
  final result = await getPrideApiAdminMe(accessToken: token);
  switch (result) {
    case PrideApiAdminMeOk(:final isDeveloper):
      if (isDeveloper) {
        await AuthSessionStorage.markDeveloperPortalUnlocked(
          ref.read(sharedPreferencesProvider),
          shopId: auth.shopId ?? '',
          username: auth.username ?? '',
        );
      }
      return AdminMeCheckResult.ok(isDeveloper: isDeveloper);
    case PrideApiAdminMeFailure(:final message):
      return AdminMeCheckResult.failed(message);
  }
});
