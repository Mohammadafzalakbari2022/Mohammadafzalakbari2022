import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/persistence/shared_preferences_provider.dart';
import '../core/persistence/sync_cursor_storage.dart';
import '../core/persistence/sync_diagnostics_storage.dart';
import '../licensing/license_providers.dart';
import '../router/app_router.dart';
import '../shell/shell_sync_providers.dart';
import 'admin_me_provider.dart';
import 'auth_providers.dart';
import 'auth_session_storage.dart';

/// Clears persisted session data, in-memory auth/license, and returns to login.
///
/// [context.go] is required in addition to the router auth redirect: with
/// [StatefulShellRoute.indexedStack], redirect-only sign-out can leave a blank
/// shell route on screen.
Future<void> performSignOut({
  required WidgetRef ref,
  required BuildContext context,
}) async {
  final scaffold = Scaffold.maybeOf(context);
  if (scaffold?.isDrawerOpen ?? false) {
    scaffold!.closeDrawer();
  }

  final prefs = ref.read(sharedPreferencesProvider);
  final sid = ref.read(authSessionProvider).shopId?.trim();
  await AuthSessionStorage.clear(prefs);
  if (sid != null && sid.isNotEmpty) {
    await SyncCursorStorage.clearForShop(prefs, sid);
  }
  await SyncDiagnosticsStorage.clear(prefs);
  ref.read(lastSuccessfulSyncAtProvider.notifier).state = null;
  ref.read(licenseNotifierProvider).clearForSignOut();
  ref.read(authSessionProvider).signOut();
  ref.invalidate(adminMeProvider);

  final router = ref.read(goRouterProvider);
  WidgetsBinding.instance.addPostFrameCallback((_) {
    router.go('/auth/login');
  });
}
