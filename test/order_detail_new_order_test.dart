import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/app/app_theme.dart';
import 'package:pride_v3/core/calendar/date_calendar_system.dart';
import 'package:pride_v3/data/local/entities/order_status.dart';
import 'package:pride_v3/data/local/order_summary.dart';
import 'package:pride_v3/features/orders/order_composer_screen.dart';
import 'package:pride_v3/features/orders/order_detail_hero_card.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

void main() {
  late AppLocalizations l10nEn;

  setUp(() {
    l10nEn = lookupAppLocalizations(const Locale('en'));
  });

  OrderSummary sampleOrder() {
    return OrderSummary(
      shopId: 'shop-1',
      internalId: 'ord-detail-1',
      displayOrderNo: '00000042',
      customerInternalId: 'cust-abc',
      customerName: 'Ahmad Khan',
      customerPhone: '0700123456',
      status: OrderLocalStatus.inProgress,
      deliveryDate: DateTime(2026, 6, 15),
      totalAmountMinor: 500000,
      paidAmountMinor: 200000,
      createdAt: DateTime(2026, 6, 1, 10, 30),
      updatedAt: DateTime(2026, 6, 1, 10, 30),
    );
  }

  group('orderComposerRoute referenceOrderId', () {
    test('includes customerId and referenceOrderId query params', () {
      expect(
        orderComposerRoute(
          customerId: 'cust-abc',
          referenceOrderId: 'ord-detail-1',
        ),
        '/app/orders?customerId=cust-abc&referenceOrderId=ord-detail-1',
      );
    });

    test('includes orderId for edit mode', () {
      expect(
        orderComposerRoute(orderId: 'ord-detail-1'),
        '/app/orders?orderId=ord-detail-1',
      );
    });
  });

  group('resolveInitialReferenceOrderId', () {
    test('returns id when order belongs to customer', () {
      final orders = [
        sampleOrder(),
        OrderSummary(
          shopId: 'shop-1',
          internalId: 'ord-other',
          displayOrderNo: '00000043',
          customerInternalId: 'cust-other',
          customerName: 'Other',
          status: OrderLocalStatus.newOrder,
          deliveryDate: DateTime(2026, 6, 20),
          totalAmountMinor: 100000,
          paidAmountMinor: 0,
          createdAt: DateTime(2026, 6, 2),
          updatedAt: DateTime(2026, 6, 2),
        ),
      ];
      expect(
        resolveInitialReferenceOrderId(
          allOrders: orders,
          customerId: 'cust-abc',
          referenceOrderId: 'ord-detail-1',
        ),
        'ord-detail-1',
      );
    });

    test('ignores reference order for a different customer', () {
      expect(
        resolveInitialReferenceOrderId(
          allOrders: [sampleOrder()],
          customerId: 'cust-abc',
          referenceOrderId: 'ord-other',
        ),
        isNull,
      );
    });
  });

  group('OrderDetailHeroCard', () {
    testWidgets('shows New order button when onNewOrder is provided',
        (tester) async {
      String? pushedLocation;

      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) {
              return Scaffold(
                body: Builder(
                  builder: (context) {
                    return OrderDetailHeroCard(
                      order: sampleOrder(),
                      paidAmountMinor: 200000,
                      remainingAmountMinor: 300000,
                      l10n: l10nEn,
                      locale: 'en',
                      calendar: DateCalendarSystem.gregorian,
                      formatMoney: (_) => '500',
                      onNewOrder: () => context.push(
                        orderComposerRoute(
                          customerId: 'cust-abc',
                          referenceOrderId: 'ord-detail-1',
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          GoRoute(
            path: '/app/orders',
            builder: (context, state) {
              pushedLocation = state.uri.toString();
              return const Scaffold(body: Text('composer'));
            },
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp.router(
          theme: buildPrideLightTheme(),
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(l10nEn.customersNewOrderCta), findsOneWidget);
      await tester.tap(find.text(l10nEn.customersNewOrderCta));
      await tester.pumpAndSettle();

      expect(pushedLocation, contains('customerId=cust-abc'));
      expect(pushedLocation, contains('referenceOrderId=ord-detail-1'));
      expect(find.text('composer'), findsOneWidget);
    });
  });
}
