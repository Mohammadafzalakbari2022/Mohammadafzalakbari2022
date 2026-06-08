import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/core/calendar/date_calendar_system.dart';
import 'package:pride_v3/data/local/entities/order_status.dart';
import 'package:pride_v3/data/local/order_summary.dart';
import 'package:pride_v3/features/orders/order_list_tile.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

void main() {
  group('OrderListTile', () {
    testWidgets('shows 5-digit order badge and customer name', (tester) async {
      final order = OrderSummary(
        internalId: 'ord-1',
        shopId: 'shop-1',
        displayOrderNo: '00000042',
        customerInternalId: 'cust-1',
        customerName: 'Ahmad Khan',
        customerPhone: '0700123456',
        status: OrderLocalStatus.inProgress,
        deliveryDate: DateTime(2026, 6, 15),
        totalAmountMinor: 500000,
        paidAmountMinor: 200000,
        createdAt: DateTime(2026, 6, 1, 10, 30),
        updatedAt: DateTime(2026, 6, 1, 10, 30),
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              final l10n = AppLocalizations.of(context)!;
              return OrderListTile(
                order: order,
                l10n: l10n,
                locale: 'fa',
                calendar: DateCalendarSystem.gregorian,
                detailed: false,
                onTap: () {},
                formatMoney: (_) => '500',
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('00042'), findsOneWidget);
      expect(find.text('Ahmad Khan'), findsOneWidget);
      expect(find.text('0700123456'), findsOneWidget);
    });
  });
}
