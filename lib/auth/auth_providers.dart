import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_session.dart';

final authSessionProvider = ChangeNotifierProvider<AuthSession>((ref) {
  return AuthSession();
});
