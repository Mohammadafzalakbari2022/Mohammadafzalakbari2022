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

const pridePersistedDeveloperFlagKey = 'pride_persisted_developer_portal';
