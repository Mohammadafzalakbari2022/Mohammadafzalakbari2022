import 'shop_profile.dart';

ShopProfile? _memory;

Future<ShopProfile> loadShopProfile() async {
  return _memory ?? const ShopProfile(name: '');
}

Future<void> saveShopProfile(ShopProfile profile) async {
  _memory = profile;
}
