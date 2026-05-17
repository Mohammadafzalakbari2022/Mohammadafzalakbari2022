import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/app/app_theme.dart';
import 'package:pride_v3/core/widgets/pride_action_buttons.dart';
import 'package:pride_v3/core/widgets/pride_alert_dialog.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../core/cache/app_cache_manager.dart';
import '../core/persistence/shared_preferences_provider.dart';
import '../core/persistence/sync_cursor_storage.dart';
import '../core/persistence/sync_diagnostics_storage.dart';
import '../features/settings/shop_profile_provider.dart';
import '../licensing/license_providers.dart';
import '../router/app_router.dart';
import '../shell/shell_sync_providers.dart';
import 'admin_me_provider.dart';
import 'auth_providers.dart';
import 'auth_session_storage.dart';

/// Confirms sign-out, then runs [performSignOut].
Future<void> showSignOutConfirmation(
  BuildContext context,
  WidgetRef ref,
) async {
  final dialogContext = appRootNavigatorKey.currentContext ?? context;
  final l10n = AppLocalizations.of(dialogContext)!;
  final confirmed = await showPrideAlertDialog<bool>(
    context: dialogContext,
    icon: Icons.logout,
    iconColor: Theme.of(dialogContext).extension<PrideActionColors>()!.delete,
    title: l10n.settingsSignOutDialogTitle,
    content: Text(l10n.settingsSignOutDialogBody),
    actions: prideDialogCancelDelete(
      context: dialogContext,
      onCancel: () => Navigator.pop(dialogContext, false),
      onConfirm: () => Navigator.pop(dialogContext, true),
      deleteLabel: l10n.settingsSignOutConfirm,
    ),
  );
  if (confirmed == true) {
    await performSignOut(ref: ref);
  }
}

/// Clears session and navigates to login via the root [GoRouter] only.
///
/// Never call [BuildContext.pop] on a tab-branch context — that empties the
/// Settings stack and leaves a blank screen (sign-out from Settings fails).
Future<void> performSignOut({required WidgetRef ref}) async {
  final router = ref.read(goRouterProvider);
  final rootContext = appRootNavigatorKey.currentContext;

  final scaffold = rootContext != null
      ? Scaffold.maybeOf(rootContext)
      : null;
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
  await AppCacheManager.clearNonEssentialCaches();
  ref.read(lastSuccessfulSyncAtProvider.notifier).state = null;
  ref.read(licenseNotifierProvider).clearForSignOut();
  ref.invalidate(adminMeProvider);
  ref.invalidate(shopProfileProvider);

  ref.read(authSessionProvider).signOut();
  router.go('/auth/login');

  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (router.routeInformationProvider.value.uri.path != '/auth/login') {
      router.go('/auth/login');
    }
  });
}
