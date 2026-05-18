import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/features/settings/settings_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('themeModeFromPrefs', () {
    test('returns saved mode', () async {
      SharedPreferences.setMockInitialValues({
        prideThemeModeKey: ThemeMode.dark.name,
      });
      final prefs = await SharedPreferences.getInstance();
      expect(themeModeFromPrefs(prefs), ThemeMode.dark);
    });

    test('defaults to system when missing or invalid', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      expect(themeModeFromPrefs(prefs), ThemeMode.system);

      await prefs.setString(prideThemeModeKey, 'invalid');
      expect(themeModeFromPrefs(prefs), ThemeMode.system);
    });
  });

  group('notificationsMutedFromPrefs', () {
    test('defaults to false', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      expect(notificationsMutedFromPrefs(prefs), isFalse);
    });

    test('reads saved value', () async {
      SharedPreferences.setMockInitialValues({prideNotificationsMutedKey: true});
      final prefs = await SharedPreferences.getInstance();
      expect(notificationsMutedFromPrefs(prefs), isTrue);
    });
  });
}
