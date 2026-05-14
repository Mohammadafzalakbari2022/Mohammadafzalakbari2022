import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/api/pride_api_admin.dart';
import '../core/api/pride_api_config.dart';
import 'auth_providers.dart';

/// Snapshot from `GET /admin/me` when API session is active (`plan-18`).
class AdminMeDto {
  const AdminMeDto({required this.isDeveloper});

  final bool isDeveloper;
}

/// Server-backed developer flag; null when no API session or request failed.
final adminMeProvider = FutureProvider<AdminMeDto?>((ref) async {
  ref.watch(authSessionProvider);
  final auth = ref.read(authSessionProvider);
  if (!PrideApiConfig.isConfigured || !auth.hasApiSession) {
    return null;
  }
  final token = auth.accessToken;
  if (token == null) return null;
  final result = await getPrideApiAdminMe(accessToken: token);
  return switch (result) {
    PrideApiAdminMeOk(:final isDeveloper) => AdminMeDto(isDeveloper: isDeveloper),
    PrideApiAdminMeFailure() => null,
  };
});
