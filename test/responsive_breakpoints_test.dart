import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/app/responsive_breakpoints.dart';

void main() {
  group('prideContentHorizontalPadding', () {
    test('uses 12 on phone', () {
      expect(prideContentHorizontalPadding(400), 12);
    });

    test('uses 8 on tablet', () {
      expect(prideContentHorizontalPadding(600), 8);
      expect(prideContentHorizontalPadding(899), 8);
    });

    test('uses 12 on desktop width', () {
      expect(prideContentHorizontalPadding(900), 12);
    });
  });

  group('prideIsTabletOrWider', () {
    test('is false below 600', () {
      expect(prideIsTabletOrWider(599), isFalse);
    });

    test('is true at 600 and above', () {
      expect(prideIsTabletOrWider(600), isTrue);
      expect(prideIsTabletOrWider(1200), isTrue);
    });
  });

  group('prideUseShellRail', () {
    testWidgets('is false on narrow mobile', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      late bool useRail;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              useRail = prideUseShellRail(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(useRail, isFalse);
    });

    testWidgets('is true at desktop breakpoint', (tester) async {
      late bool useRail;
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(1024, 768)),
            child: Builder(
              builder: (context) {
                useRail = prideUseShellRail(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
      expect(useRail, isTrue);
    });
  });
}
