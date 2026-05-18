import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pride_v3/l10n/app_localizations.dart';
import 'package:pride_v3/core/sync/auto_sync_host.dart';
import 'package:pride_v3/licensing/license_status_refresh_host.dart';

import 'app_theme.dart';
import '../features/settings/settings_providers.dart';
import '../router/app_router.dart';

class AfghanPrideApp extends ConsumerWidget {
  const AfghanPrideApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    final themeMode = ref.watch(themeModeProvider);
    final localeOverride = ref.watch(localeOverrideProvider);
    return LicenseStatusRefreshHost(
      child: AutoSyncHost(
        child: MaterialApp.router(
          routerConfig: router,
          onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          localeListResolutionCallback: (deviceLocales, supported) {
            if (deviceLocales != null) {
              for (final device in deviceLocales) {
                for (final s in supported) {
                  if (s.languageCode == device.languageCode) return s;
                }
              }
            }
            return const Locale('fa');
          },
          locale: localeOverride,
          theme: buildPrideLightTheme(),
          darkTheme: buildPrideDarkTheme(),
          themeMode: themeMode,
        ),
      ),
    );
  }
}
