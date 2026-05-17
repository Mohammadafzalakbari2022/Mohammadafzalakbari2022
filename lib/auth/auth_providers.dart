import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/persistence/shared_preferences_provider.dart';
import '../data/local/dev_shop_constants.dart';
import 'auth_session.dart';
import 'developer_portal_gate.dart';

final authSessionProvider = ChangeNotifierProvider<AuthSession>((ref) {
  return AuthSession();
});

/// Local data + sync shop scope: JWT `shop_id` when set, else [kDevShopId].
final effectiveShopIdProvider = Provider<String>((ref) {
  return effectiveShopIdFromAuth(ref.watch(authSessionProvider).shopId);
});

/// Set after a successful developer login or `GET /admin/me` with `is_developer`.
final persistedDeveloperPortalProvider = Provider<bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return prefs.getBool(pridePersistedDeveloperFlagKey) ?? false;
});
