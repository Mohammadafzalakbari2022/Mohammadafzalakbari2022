import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/data/local/catalog/catalog_image_ref.dart';
import 'package:pride_v3/data/local/catalog_item_summary.dart';
import 'package:pride_v3/features/orders/order_composer_catalog_picker.dart';

void main() {
  test('catalog asset ref round-trip', () {
    const ref = 'asset:catalog_seed/design_1.jpeg';
    expect(isCatalogAssetImageRef(ref), isTrue);
    expect(catalogBundleAssetPath(ref), 'design_1.jpeg');
    expect(
      catalogAssetRefFromBundleFile('design_2.jpeg'),
      'asset:catalog_seed/design_2.jpeg',
    );
  });

  test('applyCatalogSort orders by name', () {
    final now = DateTime(2024, 1, 1);
    final items = [
      CatalogItemSummary(
        internalId: 'b',
        shopId: 's',
        designName: 'Bravo',
        designerShopName: 'Shop',
        createdAt: now,
        isSharedPublic: false,
      ),
      CatalogItemSummary(
        internalId: 'a',
        shopId: 's',
        designName: 'Alpha',
        designerShopName: 'Shop',
        createdAt: now.add(const Duration(days: 1)),
        isSharedPublic: false,
      ),
    ];
    final sorted = applyCatalogSort(items, CatalogSort.nameAsc);
    expect(sorted.map((e) => e.designName).toList(), ['Alpha', 'Bravo']);
  });
}
