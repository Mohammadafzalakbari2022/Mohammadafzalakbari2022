import 'dart:convert';

import 'package:http/http.dart' as http;

import 'pride_api_config.dart';

class CatalogPublicItemDto {
  const CatalogPublicItemDto({
    required this.internalId,
    required this.shopId,
    required this.designName,
    required this.designerShopName,
    required this.sharedAt,
    this.notes,
  });

  final String internalId;
  final String shopId;
  final String designName;
  final String designerShopName;
  final DateTime sharedAt;
  final String? notes;

  static CatalogPublicItemDto fromJson(Map<String, dynamic> m) {
    final sharedRaw = m['shared_at'] ?? m['sharedAt'];
    return CatalogPublicItemDto(
      internalId: '${m['internal_id'] ?? m['internalId'] ?? ''}',
      shopId: '${m['shop_id'] ?? m['shopId'] ?? ''}',
      designName: '${m['design_name'] ?? m['designName'] ?? ''}',
      designerShopName:
          '${m['designer_shop_name'] ?? m['designerShopName'] ?? ''}',
      notes: m['notes'] as String?,
      sharedAt: DateTime.tryParse('$sharedRaw') ?? DateTime.now(),
    );
  }
}

class CatalogPublicFeedDto {
  const CatalogPublicFeedDto({
    required this.items,
    required this.sharingEnabled,
  });

  final List<CatalogPublicItemDto> items;
  final bool sharingEnabled;

  static CatalogPublicFeedDto fromJson(Map<String, dynamic> m) {
    final raw = m['items'];
    final items = raw is List
        ? raw
            .whereType<Map<String, dynamic>>()
            .map(CatalogPublicItemDto.fromJson)
            .toList()
        : <CatalogPublicItemDto>[];
    return CatalogPublicFeedDto(
      items: items,
      sharingEnabled: m['catalog_sharing_default'] is bool
          ? m['catalog_sharing_default'] as bool
          : true,
    );
  }
}

/// Fetches public catalog metadata (no JWT). Used for default sharing flag.
Future<CatalogPublicDto> fetchCatalogPublic({
  Duration timeout = const Duration(seconds: 15),
}) async {
  final base = PrideApiConfig.normalizedBase;
  if (base == null) {
    return const CatalogPublicDto(catalogSharingDefault: true);
  }
  final uri = Uri.parse('$base/catalog/public');
  try {
    final response = await http
        .get(
          uri,
          headers: {'Accept': 'application/json'},
        )
        .timeout(timeout);
    if (response.statusCode != 200) {
      return const CatalogPublicDto(catalogSharingDefault: true);
    }
    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      return const CatalogPublicDto(catalogSharingDefault: true);
    }
    return CatalogPublicDto.fromJson(decoded);
  } on Exception {
    return const CatalogPublicDto(catalogSharingDefault: true);
  }
}

/// Authenticated public directory feed (`GET /catalog/public/feed`).
Future<CatalogPublicFeedDto?> fetchCatalogPublicFeed({
  required String accessToken,
  Duration timeout = const Duration(seconds: 20),
}) async {
  final base = PrideApiConfig.normalizedBase;
  if (base == null) return null;
  final uri = Uri.parse('$base/catalog/public/feed');
  try {
    final response = await http
        .get(
          uri,
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        )
        .timeout(timeout);
    if (response.statusCode != 200) return null;
    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) return null;
    return CatalogPublicFeedDto.fromJson(decoded);
  } on Exception {
    return null;
  }
}

Future<bool> postCatalogShareSettings({
  required String accessToken,
  required bool sharingEnabled,
}) async {
  final base = PrideApiConfig.normalizedBase;
  if (base == null) return false;
  final uri = Uri.parse('$base/catalog/share-settings');
  try {
    final response = await http
        .post(
          uri,
          headers: {
            'Content-Type': 'application/json; charset=utf-8',
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
          body: jsonEncode({'sharing_enabled': sharingEnabled}),
        )
        .timeout(const Duration(seconds: 15));
    return response.statusCode == 200;
  } on Exception {
    return false;
  }
}

Future<bool> postCatalogItemShare({
  required String accessToken,
  required String internalId,
  required bool shared,
  required String designName,
  required String designerShopName,
  String? notes,
}) async {
  final base = PrideApiConfig.normalizedBase;
  if (base == null) return false;
  final uri = Uri.parse('$base/catalog/items/$internalId/share');
  try {
    final response = await http
        .post(
          uri,
          headers: {
            'Content-Type': 'application/json; charset=utf-8',
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
          body: jsonEncode({
            'shared': shared,
            'design_name': designName,
            'designer_shop_name': designerShopName,
            'notes': ?notes,
          }),
        )
        .timeout(const Duration(seconds: 15));
    return response.statusCode == 200;
  } on Exception {
    return false;
  }
}

/// Response from `GET /catalog/public` (Nest stub).
class CatalogPublicDto {
  const CatalogPublicDto({required this.catalogSharingDefault});

  final bool catalogSharingDefault;

  static CatalogPublicDto fromJson(Map<String, dynamic> m) {
    final raw = m['catalog_sharing_default'];
    final sharing = raw is bool ? raw : true;
    return CatalogPublicDto(catalogSharingDefault: sharing);
  }
}
