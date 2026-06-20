import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth_providers.dart';
import '../auth/developer_account.dart';
import '../core/api/pride_api_config.dart';
import '../l10n/app_localizations.dart';
import '../shell/shell_sync_providers.dart';
import 'license_notifier.dart';

final licenseNotifierProvider =
    ChangeNotifierProvider<LicenseNotifier>((ref) => LicenseNotifier());

/// True when the app must behave read-only for business data (`plan-06`).
///
/// Local mock sign-in (no API session) is never blocked so Android/Web/iOS UI
/// testing works without a live license endpoint.
final licenseEditingBlockedProvider = Provider<bool>((ref) {
  if (!PrideApiConfig.isConfigured) return false;
  if (!ref.watch(authSessionProvider).hasApiSession) return false;
  if (ref.watch(isDeveloperAccountProvider)) return false;
  final online = ref.watch(connectivityOnlineProvider);
  return ref.watch(licenseNotifierProvider).isEditingBlocked(online: online);
});

/// Snackbar / short copy when a write action is refused (`plan-06`).
String licenseWriteBlockedMessage(LicenseNotifier n, AppLocalizations l10n) {
  if (n.suspectedTimeTamper) {
    return l10n.licenseClockTamperSnack;
  }
  return n.isExpired ? l10n.licenseExpiredReadOnly : l10n.licenseGraceReadOnlySnack;
}
