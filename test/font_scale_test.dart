import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pride_v3/app/responsive_text_scale.dart';
import 'package:pride_v3/features/settings/settings_providers.dart';

void main() {
  group('fontScaleFromPreset', () {
    test('uses Small=1.0, Medium=1.08, Large=1.20', () {
      expect(fontScaleFromPreset(PrideFontSizePreset.small), 1.0);
      expect(fontScaleFromPreset(PrideFontSizePreset.medium), 1.08);
      expect(fontScaleFromPreset(PrideFontSizePreset.large), 1.20);
    });
  });

  group('prideResponsiveTextScaleFactor', () {
    test('returns breakpoint factors', () {
      expect(prideResponsiveTextScaleFactor(359), 0.94);
      expect(prideResponsiveTextScaleFactor(360), 1.00);
      expect(prideResponsiveTextScaleFactor(430), 1.02);
      expect(prideResponsiveTextScaleFactor(600), 1.06);
      expect(prideResponsiveTextScaleFactor(840), 1.10);
    });
  });

  group('prideEffectiveTextScale', () {
    test('clamps floor for Small on narrow phone', () {
      expect(
        prideEffectiveTextScale(
          userScale: fontScaleFromPreset(PrideFontSizePreset.small),
          width: 320,
        ),
        0.95,
      );
    });

    test('Large on wide screen stays below ceiling', () {
      expect(
        prideEffectiveTextScale(
          userScale: fontScaleFromPreset(PrideFontSizePreset.large),
          width: 1200,
        ),
        closeTo(1.32, 0.001),
      );
    });

    test('clamps ceiling when product exceeds maxScale', () {
      expect(
        prideEffectiveTextScale(
          userScale: 1.25,
          width: 1200,
        ),
        1.35,
      );
    });

    test('preserves Small < Medium < Large at fixed width', () {
      const width = 400.0;
      final small = prideEffectiveTextScale(
        userScale: fontScaleFromPreset(PrideFontSizePreset.small),
        width: width,
      );
      final medium = prideEffectiveTextScale(
        userScale: fontScaleFromPreset(PrideFontSizePreset.medium),
        width: width,
      );
      final large = prideEffectiveTextScale(
        userScale: fontScaleFromPreset(PrideFontSizePreset.large),
        width: width,
      );
      expect(small, lessThan(medium));
      expect(medium, lessThan(large));
    });

    test('Medium at normal phone width stays 1.08', () {
      expect(
        prideEffectiveTextScale(
          userScale: fontScaleFromPreset(PrideFontSizePreset.medium),
          width: 390,
        ),
        1.08,
      );
    });

    test('Medium on small phone is slightly reduced', () {
      expect(
        prideEffectiveTextScale(
          userScale: fontScaleFromPreset(PrideFontSizePreset.medium),
          width: 320,
        ),
        closeTo(1.0152, 0.001),
      );
    });

    test('Medium on tablet scales up subtly', () {
      expect(
        prideEffectiveTextScale(
          userScale: fontScaleFromPreset(PrideFontSizePreset.medium),
          width: 700,
        ),
        closeTo(1.1448, 0.001),
      );
    });
  });

  group('MaterialApp textScaler wiring', () {
    Future<void> pumpWithPresetAndWidth(
      WidgetTester tester, {
      required PrideFontSizePreset preset,
      required double width,
    }) async {
      final userScale = fontScaleFromPreset(preset);
      final effectiveScale = prideEffectiveTextScale(
        userScale: userScale,
        width: width,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            fontSizePresetProvider.overrideWith((ref) => preset),
          ],
          child: MediaQuery(
            data: MediaQueryData(size: Size(width, 800)),
            child: MaterialApp(
              builder: (context, child) {
                final mq = MediaQuery.of(context);
                final scale = prideEffectiveTextScale(
                  userScale: fontScaleFromPreset(preset),
                  width: mq.size.width,
                );
                return MediaQuery(
                  data: mq.copyWith(
                    textScaler: TextScaler.linear(scale),
                  ),
                  child: child ?? const SizedBox.shrink(),
                );
              },
              home: Builder(
                builder: (context) {
                  final scaler = MediaQuery.textScalerOf(context);
                  return Text('scale=${scaler.scale(10).toStringAsFixed(2)}');
                },
              ),
            ),
          ),
        ),
      );

      expect(
        effectiveScale,
        prideEffectiveTextScale(userScale: userScale, width: width),
      );
    }

    testWidgets('font size preset changes effective text scale at normal width',
        (tester) async {
      await pumpWithPresetAndWidth(
        tester,
        preset: PrideFontSizePreset.small,
        width: 390,
      );
      expect(find.text('scale=10.00'), findsOneWidget);

      await pumpWithPresetAndWidth(
        tester,
        preset: PrideFontSizePreset.medium,
        width: 390,
      );
      expect(find.text('scale=10.80'), findsOneWidget);

      await pumpWithPresetAndWidth(
        tester,
        preset: PrideFontSizePreset.large,
        width: 390,
      );
      expect(find.text('scale=12.00'), findsOneWidget);
    });

    testWidgets('narrow width reduces effective scale for Medium',
        (tester) async {
      await pumpWithPresetAndWidth(
        tester,
        preset: PrideFontSizePreset.medium,
        width: 320,
      );
      // 1.08 * 0.94 = 1.0152 → displayed as 10.15
      expect(find.text('scale=10.15'), findsOneWidget);
    });

    testWidgets('wide width increases effective scale for Medium',
        (tester) async {
      await pumpWithPresetAndWidth(
        tester,
        preset: PrideFontSizePreset.medium,
        width: 900,
      );
      // 1.08 * 1.10 = 1.188 → displayed as 11.88
      expect(find.text('scale=11.88'), findsOneWidget);
    });
  });
}
