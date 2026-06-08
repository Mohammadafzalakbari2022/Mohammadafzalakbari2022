import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/data/local/catalog_item_summary.dart';
import 'package:pride_v3/features/catalog/catalog_fullscreen_viewer.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

void main() {
  List<CatalogItemSummary> sampleItems() {
    return [
      CatalogItemSummary(
        shopId: 'shop-1',
        internalId: 'item-a',
        designName: 'Design A',
        designerShopName: 'Shop',
        imagePath: null,
        thumbnailPath: null,
        isSharedPublic: false,
        createdAt: DateTime(2026, 1, 1),
      ),
      CatalogItemSummary(
        shopId: 'shop-1',
        internalId: 'item-b',
        designName: 'Design B',
        designerShopName: 'Shop',
        imagePath: null,
        thumbnailPath: null,
        isSharedPublic: false,
        createdAt: DateTime(2026, 1, 2),
      ),
    ];
  }

  testWidgets('opens gallery at tapped initial index', (tester) async {
    final items = sampleItems();
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () => CatalogFullscreenViewer.openGallery(
                context,
                items: items,
                initialIndex: 1,
              ),
              child: const Text('open'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Design B'), findsOneWidget);
    expect(find.text('2/2'), findsOneWidget);
  });
}
