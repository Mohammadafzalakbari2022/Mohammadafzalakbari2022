import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/core/bootstrap/pride_bootstrap_shell.dart';

void main() {
  testWidgets('PrideBootstrapLoadingView paints spinner on first frame', (
    tester,
  ) async {
    await tester.pumpWidget(
      const PrideBootstrapMaterialHost(
        child: PrideBootstrapLoadingView(),
      ),
    );
    await tester.pump();

    expect(find.byType(PrideBootstrapLoadingView), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byIcon(Icons.storefront_rounded), findsOneWidget);
  });
}
