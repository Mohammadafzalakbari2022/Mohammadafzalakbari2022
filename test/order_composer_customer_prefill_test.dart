import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/core/calendar/date_calendar_system.dart';
import 'package:pride_v3/data/local/customer_summary.dart';
import 'package:pride_v3/features/customers/customer_list_tile.dart';
import 'package:pride_v3/features/orders/order_composer_screen.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

void main() {
  late AppLocalizations l10nEn;

  setUp(() {
    l10nEn = lookupAppLocalizations(const Locale('en'));
  });

  CustomerSummary sampleCustomer() {
    return CustomerSummary(
      shopId: 'shop-1',
      internalId: 'cust-abc',
      name: 'Ahmad Khan',
      phone: '0700123456',
      createdAt: DateTime(2026, 1, 15),
    );
  }

  group('orderComposerRoute', () {
    test('returns base route without customerId', () {
      expect(orderComposerRoute(), '/app/orders/new');
      expect(orderComposerRoute(customerId: null), '/app/orders/new');
      expect(orderComposerRoute(customerId: '  '), '/app/orders/new');
    });

    test('includes encoded customerId query param', () {
      expect(
        orderComposerRoute(customerId: 'cust-abc'),
        '/app/orders/new?customerId=cust-abc',
      );
    });

    test('includes referenceOrderId when provided', () {
      expect(
        orderComposerRoute(
          customerId: 'cust-abc',
          referenceOrderId: 'ord-1',
        ),
        '/app/orders/new?customerId=cust-abc&referenceOrderId=ord-1',
      );
    });
  });

  group('resolveComposerPrefillCustomer', () {
    test('finds customer by internal id', () {
      final customers = [sampleCustomer()];
      final match = resolveComposerPrefillCustomer(customers, 'cust-abc');
      expect(match?.name, 'Ahmad Khan');
    });

    test('returns null when id missing or unknown', () {
      final customers = [sampleCustomer()];
      expect(resolveComposerPrefillCustomer(customers, null), isNull);
      expect(resolveComposerPrefillCustomer(customers, ''), isNull);
      expect(resolveComposerPrefillCustomer(customers, 'missing'), isNull);
    });
  });

  group('CustomerListTile', () {
    testWidgets('shows New Order action when onNewOrder is provided',
        (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: Scaffold(
            body: CustomerListTile(
              customer: sampleCustomer(),
              l10n: l10nEn,
              locale: 'en',
              calendar: DateCalendarSystem.gregorian,
              isSelected: false,
              orderCount: 2,
              unpaidMinor: 0,
              formatMoney: (_) => '0',
              onTap: () {},
              onNewOrder: () => tapped = true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.note_add_outlined), findsOneWidget);
      await tester.tap(find.byIcon(Icons.note_add_outlined));
      expect(tapped, isTrue);
    });
  });
}
