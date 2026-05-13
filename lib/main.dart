import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/afghan_pride_app.dart';
import 'core/persistence/shared_preferences_provider.dart';
import 'features/settings/settings_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final initialLocale = localeOverrideFromPrefs(prefs);
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        localeOverrideProvider.overrideWith((ref) => initialLocale),
      ],
      child: const AfghanPrideApp(),
    ),
  );
}
