import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/auth/jwt_access_payload.dart';

void main() {
  test('isShopOwnerClaimFromAccessToken reads boolean claim', () {
    final payload = base64Url.encode(
      utf8.encode(jsonEncode({'is_shop_owner': true, 'sub': 'u'})),
    );
    final token = 'hdr.$payload.sig';
    expect(isShopOwnerClaimFromAccessToken(token), isTrue);
  });

  test('returns null for malformed token', () {
    expect(isShopOwnerClaimFromAccessToken('not-a-jwt'), isNull);
  });
}
