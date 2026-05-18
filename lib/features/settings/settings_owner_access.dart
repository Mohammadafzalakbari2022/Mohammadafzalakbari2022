import 'package:flutter/foundation.dart';

import '../../auth/admin_me_provider.dart';
import '../../auth/auth_session.dart';

/// Whether owner-only Settings entries (e.g. backup/restore) are unlocked (`plan-15`).
///
/// Shop owners always qualify. Without an API session, the debug owner simulator applies.
/// With an API session, developer portal users and the debug owner simulator (debug builds
/// only) also qualify — the previous `hasApiSession ? isShopOwner` rule hid the dev toggle
/// and blocked developer accounts that are not `is_shop_owner`.
bool settingsEffectiveShopOwner({
  required AuthSession auth,
  required bool devOwnerSimulated,
  required bool devDeveloperSimulated,
  AdminMeCheckResult? adminCheck,
  bool clientDeveloperLoginMatch = false,
}) {
  if (auth.isShopOwner) return true;
  if (!auth.hasApiSession) return devOwnerSimulated;

  if (adminCheck?.isDeveloper == true ||
      devDeveloperSimulated ||
      clientDeveloperLoginMatch) {
    return true;
  }
  if (kDebugMode && devOwnerSimulated) return true;
  return false;
}
