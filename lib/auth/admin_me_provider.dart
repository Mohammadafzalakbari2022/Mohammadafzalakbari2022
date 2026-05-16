import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/api/pride_api_admin.dart';
import '../core/api/pride_api_config.dart';
import 'auth_providers.dart';

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
  return switch (result) {
    PrideApiAdminMeOk(:final isDeveloper) =>
      AdminMeCheckResult.ok(isDeveloper: isDeveloper),
    PrideApiAdminMeFailure(:final message) => AdminMeCheckResult.failed(message),
  };
});
