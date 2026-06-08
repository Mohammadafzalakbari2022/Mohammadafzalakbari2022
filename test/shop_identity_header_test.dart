import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pride_v3/core/widgets/default_shop_banner.dart';
import 'package:pride_v3/core/widgets/shop_identity_header.dart';

void main() {
  group('ShopIdentityBannerStrip', () {
    testWidgets('shows default banner when no upload path', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShopIdentityBannerStrip(
              shopName: 'Khayat Tailors',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(DefaultShopBanner), findsOneWidget);
      expect(find.text('Khayat Tailors'), findsOneWidget);
    });

    testWidgets('falls back to default when upload path is missing on disk',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShopIdentityBannerStrip(
              shopName: 'Test Shop',
              bannerRelativePath: 'shop/missing_banner_${DateTime.now().millisecondsSinceEpoch}.jpg',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(DefaultShopBanner), findsOneWidget);
      expect(find.text('Test Shop'), findsOneWidget);
    });

    testWidgets('respects RTL text direction', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: ShopIdentityBannerStrip(
                shopName: 'دوختگاه افتخار',
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('دوختگاه افتخار'), findsOneWidget);
      expect(
        Directionality.of(tester.element(find.text('دوختگاه افتخار'))),
        TextDirection.rtl,
      );
    });
  });

  group('ShopIdentityHeader compact', () {
    testWidgets('shows logo and shop name compact strip', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShopIdentityHeader(
              variant: ShopIdentityVariant.compact,
              shopName: 'Compact Shop',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Compact Shop'), findsOneWidget);
    });
  });
}
