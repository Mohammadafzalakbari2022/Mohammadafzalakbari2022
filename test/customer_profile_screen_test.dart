import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/core/persistence/shared_preferences_provider.dart';
import 'package:pride_v3/data/local/customer_summary.dart';
import 'package:pride_v3/data/local/dev_shop_constants.dart';
import 'package:pride_v3/data/providers/local_data_providers.dart';
import 'package:pride_v3/features/customers/customer_profile_screen.dart';
import 'package:pride_v3/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late AppLocalizations l10nEn;

  setUp(() {
    l10nEn = lookupAppLocalizations(const Locale('en'));
  });

  test('customer profile screen source omits measurement profiles UI', () {
    final source = File(
      'lib/features/customers/customer_profile_screen.dart',
    ).readAsStringSync();
    expect(source.contains('measurementProfilesForCustomerProvider'), isFalse);
    expect(source.contains('customerMeasurementProfilesSection'), isFalse);
  });

  CustomerSummary sampleCustomer() {
    return CustomerSummary(
      shopId: kDevShopId,
      internalId: 'cust-profile-1',
      name: 'Ahmad Khan',
      phone: '0700123456',
      createdAt: DateTime(2026, 1, 15),
    );
  }

  testWidgets('does not show measurement profiles section', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final customer = sampleCustomer();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          customersListStreamProvider.overrideWith(
            (ref) => Stream.value([customer]),
          ),
          ordersListStreamProvider.overrideWith(
            (ref) => Stream.value(const []),
          ),
          paymentsForShopProvider.overrideWith(
            (ref, shopId) => Stream.value(const []),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: CustomerProfileScreen(customerId: customer.internalId),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    tester.takeException();

    expect(find.text(l10nEn.customerMeasurementProfilesSection), findsNothing);
    expect(find.text(l10nEn.customerOrderHistoryTitle), findsOneWidget);
    expect(find.text(l10nEn.customersNewOrderCta), findsOneWidget);
  });
}
