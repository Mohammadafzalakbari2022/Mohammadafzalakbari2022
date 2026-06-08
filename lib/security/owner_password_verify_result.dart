import 'package:pride_v3/l10n/app_localizations.dart';

/// Result of owner-password verification for backup/restore.
enum OwnerPasswordVerifyResult {
  success,
  wrongPassword,
  offlineUnavailable,
  ownerCredentialMissing,
}

String ownerPasswordVerifyMessage(
  AppLocalizations l10n,
  OwnerPasswordVerifyResult result,
) {
  return switch (result) {
    OwnerPasswordVerifyResult.success => '',
    OwnerPasswordVerifyResult.wrongPassword => l10n.ownerPasswordWrong,
    OwnerPasswordVerifyResult.offlineUnavailable =>
      l10n.ownerPasswordOfflineUnavailable,
    OwnerPasswordVerifyResult.ownerCredentialMissing =>
      l10n.ownerPasswordOwnerMissing,
  };
}
