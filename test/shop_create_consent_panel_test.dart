import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pride_v3/auth/shop_create_consent_panel.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

void main() {
  testWidgets('ShopCreateConsentPanel requires checkbox acceptance', (tester) async {
    var accepted = false;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: ShopCreateConsentPanel(
            accepted: accepted,
            enabled: true,
            onAcceptedChanged: (value) => accepted = value ?? false,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(CheckboxListTile), findsOneWidget);
    expect(accepted, isFalse);

    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();

    expect(accepted, isTrue);
  });
}
