import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'shop_profile.dart';
import 'shop_profile_storage.dart';

class ShopProfileNotifier extends AsyncNotifier<ShopProfile> {
  @override
  Future<ShopProfile> build() => loadShopProfile();

  Future<void> save(ShopProfile profile) async {
    final name = profile.name.trim();
    final address = profile.address?.trim();
    final phone = profile.phone?.trim();
    final notes = profile.notes?.trim();

    final next = ShopProfile(
      name: name,
      address: (address == null || address.isEmpty) ? null : address,
      phone: (phone == null || phone.isEmpty) ? null : phone,
      notes: (notes == null || notes.isEmpty) ? null : notes,
    );

    await saveShopProfile(next);
    state = AsyncData(next);
  }
}

final shopProfileProvider =
    AsyncNotifierProvider<ShopProfileNotifier, ShopProfile>(
  ShopProfileNotifier.new,
);

/// Resolved label for “designer / shop” watermark (catalog, etc.).
final shopDisplayNameProvider = Provider<String>((ref) {
  final async = ref.watch(shopProfileProvider);
  return async.maybeWhen(
    data: (s) {
      final n = s.name.trim();
      return n.isNotEmpty ? n : '';
    },
    orElse: () => '',
  );
});
