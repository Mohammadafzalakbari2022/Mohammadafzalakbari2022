import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/data/local/entities/order_status.dart';
import 'package:pride_v3/features/orders/order_list_status_actions.dart';
import 'package:pride_v3/features/orders/order_status_label.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

void main() {
  group('showOrderListStatusPicker', () {
    testWidgets('lists every status except the current one', (tester) async {
      const current = OrderLocalStatus.inProgress;
      late AppLocalizations l10n;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              l10n = AppLocalizations.of(context)!;
              return Scaffold(
                body: Center(
                  child: FilledButton(
                    onPressed: () => showOrderListStatusPicker(
                      context: context,
                      l10n: l10n,
                      current: current,
                    ),
                    child: const Text('Open'),
                  ),
                ),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text(orderStatusLabel(current, l10n)), findsNothing);
      for (final status in OrderLocalStatus.values) {
        if (status == current) continue;
        expect(find.text(orderStatusLabel(status, l10n)), findsOneWidget);
      }
    });
  });
}
