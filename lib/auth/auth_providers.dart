import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local/dev_shop_constants.dart';
import 'auth_session.dart';

final authSessionProvider = ChangeNotifierProvider<AuthSession>((ref) {
  return AuthSession();
});

/// Local data + sync shop scope: JWT `shop_id` when set, else [kDevShopId].
final effectiveShopIdProvider = Provider<String>((ref) {
  return effectiveShopIdFromAuth(ref.watch(authSessionProvider).shopId);
});
