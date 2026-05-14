import 'dart:convert';

import 'package:http/http.dart' as http;

import 'pride_api_config.dart';

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
