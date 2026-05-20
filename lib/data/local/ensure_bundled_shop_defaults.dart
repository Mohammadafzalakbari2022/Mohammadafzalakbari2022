import 'package:isar/isar.dart';

import 'catalog_bundle_seed_isar.dart';
import 'style/style_catalog_seed.dart';

/// Seeds 15 bundled style figures + 4 catalog designs for [shopId] (`plan-07` / `plan-14`).
Future<void> ensureBundledShopDefaults(Isar isar, String shopId) async {
  final sid = shopId.trim();
  if (sid.isEmpty) return;
  await seedStyleCatalogIfEmpty(isar, sid);
  await seedCatalogBundleIfMissing(isar, sid);
}
