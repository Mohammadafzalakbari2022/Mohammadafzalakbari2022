import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/core/persistence/shared_preferences_provider.dart';
import 'package:pride_v3/data/local/measurement_unit_codes.dart';
import 'package:pride_v3/features/settings/settings_measurement_types_screen.dart';
import 'package:pride_v3/features/settings/settings_providers.dart';
import 'package:pride_v3/l10n/app_localizations.dart';
import 'package:pride_v3/licensing/license_providers.dart';
import 'package:pride_v3/licensing/license_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pride_v3/data/providers/local_data_providers.dart';

void main() {
  testWidgets('selecting Inches on measurement types screen does not throw',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final license = LicenseNotifier()..setStatus(LicenseStatus.trialActive);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          licenseNotifierProvider.overrideWith((ref) => license),
          defaultMeasurementUnitProvider.overrideWith(
            (ref) => MeasurementUnitCodes.cm,
          ),
          measurementTypesAdminStreamProvider.overrideWith(
            (ref) => Stream.value(const []),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: const SettingsMeasurementTypesScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Inches'));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(prefs.getInt(prideMeasurementUnitKey), MeasurementUnitCodes.inch);
  });
}
