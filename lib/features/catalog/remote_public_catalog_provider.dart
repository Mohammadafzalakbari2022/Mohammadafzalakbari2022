import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/auth_providers.dart';
import '../../core/api/pride_api_catalog.dart';
import '../../data/local/catalog_item_summary.dart';

/// Remote public catalog directory (`GET /catalog/public/feed`).
final remotePublicCatalogProvider =
    FutureProvider<List<CatalogItemSummary>>((ref) async {
  final auth = ref.watch(authSessionProvider);
  final token = auth.accessToken;
  if (!auth.hasApiSession || token == null) return const [];

  final feed = await fetchCatalogPublicFeed(accessToken: token);
  if (feed == null) return const [];

  return feed.items
      .map(
        (i) => CatalogItemSummary(
          internalId: i.internalId,
          shopId: i.shopId,
          designName: i.designName,
          designerShopName: i.designerShopName,
          createdAt: i.sharedAt,
          isSharedPublic: true,
          imagePath: null,
          thumbnailPath: null,
        ),
      )
      .toList();
});
