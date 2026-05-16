import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

const prideLocaleLanguageCodeKey = 'pride_locale_language_code';
const prideUiSoundsKey = 'pride_ui_sounds_enabled';
const prideUiHapticsKey = 'pride_ui_haptics_enabled';

/// Reads saved app language (`en` / `fa` / `ps`), or null for system default.
Locale? localeOverrideFromPrefs(SharedPreferences prefs) {
  final code = prefs.getString(prideLocaleLanguageCodeKey);
  if (code == null || code.isEmpty) return null;
  return Locale(code);
}

Future<void> persistLocaleOverride(
  SharedPreferences prefs,
  Locale? locale,
) async {
  if (locale == null) {
    await prefs.remove(prideLocaleLanguageCodeKey);
  } else {
    await prefs.setString(prideLocaleLanguageCodeKey, locale.languageCode);
  }
}

bool uiSoundsFromPrefs(SharedPreferences prefs) =>
    prefs.getBool(prideUiSoundsKey) ?? true;

bool uiHapticsFromPrefs(SharedPreferences prefs) =>
    prefs.getBool(prideUiHapticsKey) ?? true;

Future<void> persistUiSounds(SharedPreferences prefs, bool value) async {
  await prefs.setBool(prideUiSoundsKey, value);
}

Future<void> persistUiHaptics(SharedPreferences prefs, bool value) async {
  await prefs.setBool(prideUiHapticsKey, value);
}

/// Short success sounds (SystemSound); persisted locally.
final uiSoundsEnabledProvider = StateProvider<bool>((ref) => true);

/// Light haptics on successful actions; persisted locally.
final uiHapticsEnabledProvider = StateProvider<bool>((ref) => true);

/// App theme mode (System/Light/Dark).
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

/// App locale override (null = follow system).
final localeOverrideProvider = StateProvider<Locale?>((ref) => null);

/// Mute notifications toggle (local-only for now; plan-15).
final notificationsMutedProvider = StateProvider<bool>((ref) => false);

/// Dev stub: current user role. In production, this comes from auth/session.
final isOwnerProvider = StateProvider<bool>((ref) => true);

/// Dev stub: whether developer portal is enabled.
final isDeveloperProvider = StateProvider<bool>((ref) => false);

/// App-level locale list (avoid repeating across screens).
List<Locale> supportedLocales() => AppLocalizations.supportedLocales;

