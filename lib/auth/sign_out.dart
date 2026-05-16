import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/app/app_theme.dart';
import 'package:pride_v3/core/widgets/pride_action_buttons.dart';
import 'package:pride_v3/core/widgets/pride_alert_dialog.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

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
  final l10n = AppLocalizations.of(context)!;
  final confirmed = await showPrideAlertDialog<bool>(
    context: context,
    icon: Icons.logout,
    iconColor: Theme.of(context).extension<PrideActionColors>()!.delete,
    title: l10n.settingsSignOutDialogTitle,
    content: Text(l10n.settingsSignOutDialogBody),
    actions: prideDialogCancelDelete(
      context: context,
      onCancel: () => Navigator.pop(context, false),
      onConfirm: () => Navigator.pop(context, true),
      deleteLabel: l10n.settingsSignOutConfirm,
    ),
  );
  if (confirmed == true && context.mounted) {
    await performSignOut(ref: ref, context: context);
  }
}

/// Clears persisted session data, in-memory auth/license, and returns to login.
///
/// With [StatefulShellRoute.indexedStack], redirect-only sign-out can leave a
/// blank shell on screen. We must [GoRouter.go] to `/auth/login` on the root
/// stack (and once more on the next frame if the shell is still matched).
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
  ref.invalidate(adminMeProvider);
  ref.invalidate(shopProfileProvider);

  final router = ref.read(goRouterProvider);

  // Close root-pushed routes (order detail, settings sub-screens, etc.).
  if (context.mounted) {
    while (context.canPop()) {
      context.pop();
    }
  }

  ref.read(authSessionProvider).signOut();

  if (context.mounted) {
    context.go('/auth/login');
  } else {
    router.go('/auth/login');
  }

  // Indexed shell can still match for one frame after redirect; force login.
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final path = router.routeInformationProvider.value.uri.path;
    if (path != '/auth/login') {
      router.go('/auth/login');
    }
    final rootContext = appRootNavigatorKey.currentContext;
    if (rootContext != null && rootContext.mounted) {
      final rootRouter = GoRouter.of(rootContext);
      if (rootRouter.routeInformationProvider.value.uri.path != '/auth/login') {
        rootRouter.go('/auth/login');
      }
    }
  });
}
