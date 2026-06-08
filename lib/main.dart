import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/afghan_pride_app.dart';
import 'auth/auth_providers.dart';
import 'auth/auth_session.dart';
import 'auth/auth_session_storage.dart';
import 'core/crash/pride_app_bootstrap.dart';
import 'core/guide/app_guide_storage.dart';
import 'core/feedback/notification_sound_bridge.dart';
import 'core/persistence/shared_preferences_provider.dart';
import 'core/persistence/sync_diagnostics_storage.dart';
import 'shell/shell_sync_providers.dart';
import 'features/settings/settings_providers.dart';
import 'licensing/license_clock_guard.dart';
import 'licensing/license_notifier.dart';
import 'licensing/license_providers.dart';

Future<void> main() async {
  await bootstrapPrideApp(() async {
    final prefs = await SharedPreferences.getInstance();
    await ensureGuideFirstLaunchRecorded(prefs);
    await ensureDefaultLocalePrefs(prefs);
    final initialLocale = localeFromPrefs(prefs);
    final initialUiSounds = uiSoundsFromPrefs(prefs);
    final initialUiHaptics = uiHapticsFromPrefs(prefs);
    final initialMeasurementUnit = measurementUnitFromPrefs(prefs);
    final initialThemeMode = themeModeFromPrefs(prefs);
    final initialNotificationsMuted = notificationsMutedFromPrefs(prefs);
    final initialFontSize = fontSizePresetFromPrefs(prefs);
    final initialFontFamily = fontFamilyPresetFromPrefs(prefs);
    NotificationSoundBridge.configure(
      soundsEnabled: initialUiSounds,
      muted: initialNotificationsMuted,
    );

    final authSession = AuthSession();
    final licenseNotifier = LicenseNotifier();
    await LicenseClockGuard.bootstrapIfNeeded(prefs);
    final restoredApi = await AuthSessionStorage.restoreInto(
      prefs,
      authSession,
      licenseNotifier,
    );
    if (!restoredApi) {
      final restoredMock =
          await AuthSessionStorage.restoreMockInto(prefs, authSession);
      if (restoredMock) {
        licenseNotifier
          ..setStatus(LicenseStatus.trialActive)
          ..setSuspectedTimeTamper(false);
      }
    }
    final initialLastSync =
        SyncDiagnosticsStorage.readLastSuccessfulSync(prefs);

    runApp(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          authSessionProvider.overrideWith((ref) => authSession),
          licenseNotifierProvider.overrideWith((ref) => licenseNotifier),
          localeOverrideProvider.overrideWith((ref) => initialLocale),
          themeModeProvider.overrideWith((ref) => initialThemeMode),
          notificationsMutedProvider.overrideWith(
            (ref) => initialNotificationsMuted,
          ),
          uiSoundsEnabledProvider.overrideWith((ref) => initialUiSounds),
          uiHapticsEnabledProvider.overrideWith((ref) => initialUiHaptics),
          defaultMeasurementUnitProvider.overrideWith(
            (ref) => initialMeasurementUnit,
          ),
          fontSizePresetProvider.overrideWith((ref) => initialFontSize),
          fontFamilyPresetProvider.overrideWith((ref) => initialFontFamily),
          lastSuccessfulSyncAtProvider.overrideWith((_) => initialLastSync),
        ],
        child: const AfghanPrideApp(),
      ),
    );
  });
}
