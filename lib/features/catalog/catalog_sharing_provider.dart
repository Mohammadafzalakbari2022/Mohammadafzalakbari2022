import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/pride_api_catalog.dart';
import '../../auth/auth_providers.dart';
import 'remote_public_catalog_provider.dart';

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

  Future<void> set(bool value) async {
    state = value;
    final auth = ref.read(authSessionProvider);
    final token = auth.accessToken;
    if (auth.hasApiSession && token != null) {
      await postCatalogShareSettings(
        accessToken: token,
        sharingEnabled: value,
      );
      ref.invalidate(remotePublicCatalogProvider);
    }
  }
}

final catalogSharingEnabledProvider =
    NotifierProvider<CatalogSharingNotifier, bool>(CatalogSharingNotifier.new);

/// One-shot fetch of `GET /catalog/public` (Nest).
final catalogPublicProvider = FutureProvider<CatalogPublicDto>((ref) async {
  return fetchCatalogPublic();
});
