import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'shop_profile.dart';

Future<File> _file() async {
  final dir = await getApplicationDocumentsDirectory();
  return File('${dir.path}${Platform.pathSeparator}shop_profile.json');
}

Future<ShopProfile> loadShopProfile() async {
  try {
    final f = await _file();
    if (!await f.exists()) return const ShopProfile(name: '');
    final raw = await f.readAsString();
    if (raw.trim().isEmpty) return const ShopProfile(name: '');
    final map = jsonDecode(raw) as Map<String, dynamic>;
    return ShopProfile(
      name: map['name'] as String? ?? '',
      address: map['address'] as String?,
      phone: map['phone'] as String?,
      notes: map['notes'] as String?,
    );
  } on Object {
    return const ShopProfile(name: '');
  }
}

Future<void> saveShopProfile(ShopProfile profile) async {
  final f = await _file();
  final map = <String, dynamic>{
    'name': profile.name,
    'address': profile.address,
    'phone': profile.phone,
    'notes': profile.notes,
  };
  await f.writeAsString(jsonEncode(map));
}
