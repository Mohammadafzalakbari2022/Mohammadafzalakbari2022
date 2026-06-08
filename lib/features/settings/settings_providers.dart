import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pride_v3/data/local/measurement_unit_codes.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

const prideLocaleLanguageCodeKey = 'pride_locale_language_code';
const prideThemeModeKey = 'pride_theme_mode';
const prideUiSoundsKey = 'pride_ui_sounds_enabled';
const prideUiHapticsKey = 'pride_ui_haptics_enabled';
const prideMeasurementUnitKey = 'pride_measurement_unit_code';
const prideNotificationsMutedKey = 'pride_notifications_muted';
const prideFontSizePresetKey = 'pride_font_size_preset';
const prideFontFamilyPresetKey = 'pride_font_family_preset';

const kFontFamilyVazirmatn = 'Vazirmatn';
const kFontFamilyNotoNaskh = 'Noto Naskh Arabic';

enum PrideFontSizePreset { small, medium, large }

enum PrideFontFamilyPreset { vazirmatn, notoNaskh }

double fontScaleFromPreset(PrideFontSizePreset preset) {
  return switch (preset) {
    PrideFontSizePreset.small => 1.0,
    PrideFontSizePreset.medium => 1.08,
    PrideFontSizePreset.large => 1.20,
  };
}

String fontFamilyFromPreset(PrideFontFamilyPreset preset) {
  return switch (preset) {
    PrideFontFamilyPreset.vazirmatn => kFontFamilyVazirmatn,
    PrideFontFamilyPreset.notoNaskh => kFontFamilyNotoNaskh,
  };
}

PrideFontSizePreset fontSizePresetFromPrefs(SharedPreferences prefs) {
  if (!prefs.containsKey(prideFontSizePresetKey)) {
    return PrideFontSizePreset.medium;
  }
  final raw = prefs.getString(prideFontSizePresetKey);
  return switch (raw) {
    'small' => PrideFontSizePreset.small,
    'large' => PrideFontSizePreset.large,
    _ => PrideFontSizePreset.medium,
  };
}

PrideFontFamilyPreset fontFamilyPresetFromPrefs(SharedPreferences prefs) {
  if (!prefs.containsKey(prideFontFamilyPresetKey)) {
    return PrideFontFamilyPreset.notoNaskh;
  }
  final raw = prefs.getString(prideFontFamilyPresetKey);
  return switch (raw) {
    'vazirmatn' => PrideFontFamilyPreset.vazirmatn,
    _ => PrideFontFamilyPreset.notoNaskh,
  };
}

Future<void> persistFontSizePreset(
  SharedPreferences prefs,
  PrideFontSizePreset preset,
) async {
  await prefs.setString(
    prideFontSizePresetKey,
    switch (preset) {
      PrideFontSizePreset.medium => 'medium',
      PrideFontSizePreset.large => 'large',
      PrideFontSizePreset.small => 'small',
    },
  );
}

Future<void> persistFontFamilyPreset(
  SharedPreferences prefs,
  PrideFontFamilyPreset preset,
) async {
  await prefs.setString(
    prideFontFamilyPresetKey,
    switch (preset) {
      PrideFontFamilyPreset.notoNaskh => 'notoNaskh',
      PrideFontFamilyPreset.vazirmatn => 'vazirmatn',
    },
  );
}

/// Reads saved app language (`en` / `fa` / `ps`). Defaults to Dari on first launch.
Locale localeFromPrefs(SharedPreferences prefs) {
  final code = prefs.getString(prideLocaleLanguageCodeKey);
  if (code == null || code.isEmpty) return const Locale('fa');
  return Locale(code);
}

/// Legacy alias — always returns a concrete locale (default `fa`).
Locale? localeOverrideFromPrefs(SharedPreferences prefs) => localeFromPrefs(prefs);

/// Persists default Dari when no language has been chosen yet.
Future<void> ensureDefaultLocalePrefs(SharedPreferences prefs) async {
  if (!prefs.containsKey(prideLocaleLanguageCodeKey)) {
    await prefs.setString(prideLocaleLanguageCodeKey, 'fa');
  }
}

Future<void> persistLocaleOverride(
  SharedPreferences prefs,
  Locale locale,
) async {
  await prefs.setString(prideLocaleLanguageCodeKey, locale.languageCode);
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

int measurementUnitFromPrefs(SharedPreferences prefs) {
  final code = prefs.getInt(prideMeasurementUnitKey);
  if (code == MeasurementUnitCodes.inch) return MeasurementUnitCodes.inch;
  return MeasurementUnitCodes.cm;
}

Future<void> persistMeasurementUnit(SharedPreferences prefs, int unitCode) async {
  await prefs.setInt(prideMeasurementUnitKey, unitCode);
}

ThemeMode themeModeFromPrefs(SharedPreferences prefs) {
  final raw = prefs.getString(prideThemeModeKey);
  for (final mode in ThemeMode.values) {
    if (mode.name == raw) return mode;
  }
  return ThemeMode.system;
}

Future<void> persistThemeMode(SharedPreferences prefs, ThemeMode mode) async {
  await prefs.setString(prideThemeModeKey, mode.name);
}

bool notificationsMutedFromPrefs(SharedPreferences prefs) =>
    prefs.getBool(prideNotificationsMutedKey) ?? false;

Future<void> persistNotificationsMuted(
  SharedPreferences prefs,
  bool value,
) async {
  await prefs.setBool(prideNotificationsMutedKey, value);
}

/// Short success sounds (SystemSound); persisted locally.
final uiSoundsEnabledProvider = StateProvider<bool>((ref) => true);

/// Light haptics on successful actions; persisted locally.
final uiHapticsEnabledProvider = StateProvider<bool>((ref) => true);

/// App theme mode (System/Light/Dark).
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

/// App locale (default Dari / `fa`).
final localeOverrideProvider = StateProvider<Locale>((ref) => const Locale('fa'));

/// Mute notifications toggle (local-only for now; plan-15).
final notificationsMutedProvider = StateProvider<bool>((ref) => false);

final fontSizePresetProvider =
    StateProvider<PrideFontSizePreset>((ref) => PrideFontSizePreset.medium);

final fontFamilyPresetProvider =
    StateProvider<PrideFontFamilyPreset>((ref) => PrideFontFamilyPreset.notoNaskh);

/// Default unit for new order measurements and profiles (inch or cm).
final defaultMeasurementUnitProvider =
    StateProvider<int>((ref) => MeasurementUnitCodes.cm);

/// Dev stub: current user role. In production, this comes from auth/session.
final isOwnerProvider = StateProvider<bool>((ref) => true);

/// Dev stub: whether developer portal is enabled.
final isDeveloperProvider = StateProvider<bool>((ref) => false);

/// App-level locale list (avoid repeating across screens).
List<Locale> supportedLocales() => AppLocalizations.supportedLocales;

