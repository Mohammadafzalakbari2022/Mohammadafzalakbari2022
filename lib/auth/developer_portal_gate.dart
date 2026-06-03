import '../core/api/pride_api_config.dart';
import 'admin_me_provider.dart';
import 'auth_session.dart';

/// Whether Settings should show the in-app Developer Portal entry.
bool showDeveloperPortalInSettings({
  required AuthSession auth,
  required AdminMeCheckResult? adminCheck,
  required bool devSimulated,
  required bool persistedDeveloperFlag,
}) {
  if (devSimulated || persistedDeveloperFlag) return true;
  if (adminCheck?.isDeveloper == true) return true;
  if (!auth.authenticated) return false;
  return PrideApiConfig.isDeveloperLogin(
    shopId: auth.shopId,
    username: auth.username,
  );
}

/// Whether Settings should show sync diagnostics, conflicts, and lab tooling.
bool showDeveloperDiagnosticsInSettings({
  required AuthSession auth,
  required AdminMeCheckResult? adminCheck,
  required bool devSimulated,
  required bool persistedDeveloperFlag,
}) =>
    showDeveloperPortalInSettings(
      auth: auth,
      adminCheck: adminCheck,
      devSimulated: devSimulated,
      persistedDeveloperFlag: persistedDeveloperFlag,
    );

const pridePersistedDeveloperFlagKey = 'pride_persisted_developer_portal';
