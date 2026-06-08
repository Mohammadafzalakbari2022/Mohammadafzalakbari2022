import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/data/local/customer_summary.dart';
import 'package:pride_v3/features/orders/order_composer_customer_picker.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

void main() {
  late AppLocalizations l10nEn;

  setUp(() {
    l10nEn = lookupAppLocalizations(const Locale('en'));
  });

  CustomerSummary customer({
    required String internalId,
    required String name,
    String? phone,
  }) {
    return CustomerSummary(
      shopId: 'shop-1',
      internalId: internalId,
      name: name,
      phone: phone,
      createdAt: DateTime(2026, 1, 1),
    );
  }

  Future<CustomerSummary?> openPicker(
    WidgetTester tester, {
    String initialQuery = '',
    List<CustomerSummary>? customers,
  }) async {
    CustomerSummary? picked;
    final list = customers ??
        [
          customer(internalId: '1', name: 'Zara Noor', phone: '0700111111'),
          customer(internalId: '2', name: 'Ahmad Khan', phone: '0700222222'),
        ];

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: Center(
                child: FilledButton(
                  onPressed: () async {
                    picked = await showOrderComposerCustomerPicker(
                      context: context,
                      customers: list,
                      l10n: l10nEn,
                      initialQuery: initialQuery,
                    );
                  },
                  child: const Text('Open'),
                ),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    return picked;
  }

  group('showOrderComposerCustomerPicker', () {
    testWidgets('shows all customers when query is empty', (tester) async {
      await openPicker(tester);
      expect(find.text('Zara Noor'), findsOneWidget);
      expect(find.text('Ahmad Khan'), findsOneWidget);
    });

    testWidgets('filters by name as user types', (tester) async {
      await openPicker(tester);
      await tester.enterText(find.byType(SearchBar), 'ahmad');
      await tester.pump();
      expect(find.text('Ahmad Khan'), findsOneWidget);
      expect(find.text('Zara Noor'), findsNothing);
    });

    testWidgets('selecting a filtered customer returns it', (tester) async {
      CustomerSummary? picked;
      final list = [
        customer(internalId: '1', name: 'Zara Noor', phone: '0700111111'),
        customer(internalId: '2', name: 'Ahmad Khan', phone: '0700222222'),
      ];

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: Center(
                  child: FilledButton(
                    onPressed: () async {
                      picked = await showOrderComposerCustomerPicker(
                        context: context,
                        customers: list,
                        l10n: l10nEn,
                      );
                    },
                    child: const Text('Open'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(SearchBar), '0700222222');
      await tester.pump();
      await tester.tap(find.text('Ahmad Khan'));
      await tester.pumpAndSettle();
      expect(picked?.internalId, '2');
    });

    testWidgets('clear button resets list', (tester) async {
      await openPicker(tester, initialQuery: 'ahmad');
      expect(find.text('Zara Noor'), findsNothing);
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pump();
      expect(find.text('Zara Noor'), findsOneWidget);
      expect(find.text('Ahmad Khan'), findsOneWidget);
    });
  });
}
