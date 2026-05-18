import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/core/calendar/date_calendar_notifier.dart';
import 'package:pride_v3/core/calendar/date_calendar_system.dart';
import 'package:pride_v3/core/persistence/shared_preferences_provider.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import 'settings_providers.dart';
import 'settings_sound_feedback_tiles.dart';

class SettingsAppearanceLanguageScreen extends ConsumerWidget {
  const SettingsAppearanceLanguageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final themeMode = ref.watch(themeModeProvider);
    final localeOverride = ref.watch(localeOverrideProvider);
    final dateCalendar = ref.watch(dateCalendarSystemProvider);
    final locales = AppLocalizations.supportedLocales;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsAppearanceLanguageTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l10n.settingsThemeTitle,
              style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          SegmentedButton<ThemeMode>(
            segments: [
              ButtonSegment(value: ThemeMode.system, label: Text(l10n.themeSystem)),
              ButtonSegment(value: ThemeMode.light, label: Text(l10n.themeLight)),
              ButtonSegment(value: ThemeMode.dark, label: Text(l10n.themeDark)),
            ],
            selected: {themeMode},
            onSelectionChanged: (s) async {
              final mode = s.first;
              ref.read(themeModeProvider.notifier).state = mode;
              await persistThemeMode(
                ref.read(sharedPreferencesProvider),
                mode,
              );
            },
          ),
          const SizedBox(height: 16),
          Text(
            l10n.settingsSectionSoundFeedback,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Card(
            clipBehavior: Clip.antiAlias,
            child: const SettingsSoundFeedbackTiles(dense: true),
          ),
          const SizedBox(height: 24),
          Text(l10n.settingsDateCalendarTitle,
              style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Text(
            l10n.settingsDateCalendarSubtitle,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          SegmentedButton<DateCalendarSystem>(
            segments: [
              ButtonSegment(
                value: DateCalendarSystem.gregorian,
                label: Text(l10n.dateCalendarGregorian),
              ),
              ButtonSegment(
                value: DateCalendarSystem.solarHijri,
                label: Text(l10n.dateCalendarSolarHijri),
              ),
            ],
            selected: {dateCalendar},
            onSelectionChanged: (s) => ref
                .read(dateCalendarSystemProvider.notifier)
                .set(s.first),
          ),
          const SizedBox(height: 24),
          Text(l10n.settingsLanguageTitle,
              style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Card(
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              leading: const Icon(Icons.language_outlined),
              title: Text(l10n.settingsLanguageTitle),
              subtitle: Text(_localeLabel(l10n, localeOverride)),
              trailing: DropdownButtonHideUnderline(
                child: DropdownButton<Locale>(
                  value: localeOverride,
                  items: [
                    for (final locale in locales)
                      DropdownMenuItem<Locale>(
                        value: locale,
                        child: Text(_localeLabel(l10n, locale)),
                      ),
                  ],
                  onChanged: (v) async {
                    if (v == null) return;
                    ref.read(localeOverrideProvider.notifier).state = v;
                    await persistLocaleOverride(
                      ref.read(sharedPreferencesProvider),
                      v,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _localeLabel(AppLocalizations l10n, Locale locale) {
    return switch (locale.languageCode) {
      'en' => l10n.languageEnglish,
      'fa' => l10n.languageDari,
      'ps' => l10n.languagePashto,
      _ => locale.toLanguageTag(),
    };
  }
}

