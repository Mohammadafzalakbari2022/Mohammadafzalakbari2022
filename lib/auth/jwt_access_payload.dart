import 'dart:convert';

/// Reads `is_shop_owner` from a Nest JWT access token payload (`plan-04`).
bool? isShopOwnerClaimFromAccessToken(String accessToken) {
  final map = _decodeJwtPayload(accessToken);
  if (map == null) return null;
  final v = map['is_shop_owner'];
  return v is bool ? v : null;
}

Map<String, dynamic>? _decodeJwtPayload(String accessToken) {
  final parts = accessToken.split('.');
  if (parts.length != 3) return null;
  var segment = parts[1];
  final mod = segment.length % 4;
  if (mod > 0) {
    segment += '=' * (4 - mod);
  }
  try {
    final normalized = segment.replaceAll('-', '+').replaceAll('_', '/');
    final decoded = jsonDecode(utf8.decode(base64.decode(normalized)));
    if (decoded is Map<String, dynamic>) return decoded;
  } catch (_) {}
  return null;
}
