import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/local_data_providers_io.dart';
import 'ensure_bundled_shop_defaults.dart';

Future<void> seedBundledDefaultsForShop(WidgetRef ref, String shopId) async {
  final isar = await ref.read(isarProvider.future);
  await ensureBundledShopDefaults(isar, shopId);
}
