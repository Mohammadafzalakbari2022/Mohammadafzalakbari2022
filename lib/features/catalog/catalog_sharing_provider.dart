import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/pride_api_catalog.dart';

/// One-shot fetch of `GET /catalog/public` (Nest).
final catalogPublicProvider = FutureProvider<CatalogPublicDto>((ref) async {
  return fetchCatalogPublic();
});

/// User toggle + API default: starts from [catalogPublicProvider], updates when API loads.
class CatalogSharingNotifier extends Notifier<bool> {
  @override
  bool build() {
    ref.listen<AsyncValue<CatalogPublicDto>>(
      catalogPublicProvider,
      (prev, next) {
        next.whenData((d) => state = d.catalogSharingDefault);
      },
      fireImmediately: true,
    );
    return true;
  }

  void set(bool value) => state = value;
}

final catalogSharingEnabledProvider =
    NotifierProvider<CatalogSharingNotifier, bool>(CatalogSharingNotifier.new);
