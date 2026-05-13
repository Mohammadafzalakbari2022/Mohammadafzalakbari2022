import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pride_v3/app/afghan_pride_app.dart';

void main() {
  testWidgets('Login screen shows sign-in form', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: AfghanPrideApp()),
    );
    await tester.pumpAndSettle();
    expect(find.widgetWithText(FilledButton, 'Sign in'), findsOneWidget);
    expect(find.text('Username'), findsOneWidget);
  });
}
