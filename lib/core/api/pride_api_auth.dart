import 'dart:convert';

import 'package:http/http.dart' as http;

import 'pride_api_config.dart';

/// Result of `POST {API_BASE_URL}/auth/login` (`plan-04`).
sealed class PrideApiLoginResult {
  const PrideApiLoginResult();
}

final class PrideApiLoginOk extends PrideApiLoginResult {
  const PrideApiLoginOk({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.shopId,
    required this.username,
    required this.isShopOwner,
    required this.licenseSnapshot,
  });

  final String accessToken;
  final String? refreshToken;
  final String userId;
  final String shopId;
  final String username;
  final bool isShopOwner;
  final Map<String, dynamic> licenseSnapshot;
}

final class PrideApiLoginFailure extends PrideApiLoginResult {
  const PrideApiLoginFailure(this.message, {this.statusCode});

  final String message;
  final int? statusCode;
}

/// `POST /auth/login` — shop_id optional (`plan-04`).
Future<PrideApiLoginResult> postPrideApiLogin({
  required String username,
  required String password,
  String? shopId,
  Duration timeout = const Duration(seconds: 25),
}) =>
    _postPrideApiAuthSession(
      path: 'auth/login',
      username: username,
      password: password,
      shopId: shopId,
      timeout: timeout,
    );

/// `POST /shop/join` — same body/response as login; use when joining a known shop (`plan-04`).
Future<PrideApiLoginResult> postPrideApiShopJoin({
  required String username,
  required String password,
  required String shopId,
  Duration timeout = const Duration(seconds: 25),
}) =>
    _postPrideApiAuthSession(
      path: 'shop/join',
      username: username,
      password: password,
      shopId: shopId,
      timeout: timeout,
    );

Future<PrideApiLoginResult> _postPrideApiAuthSession({
  required String path,
  required String username,
  required String password,
  String? shopId,
  Duration timeout = const Duration(seconds: 25),
}) async {
  final base = PrideApiConfig.normalizedBase;
  if (base == null) {
    return const PrideApiLoginFailure('API_BASE_URL not set');
  }

  final uri = Uri.parse('$base/$path');
  final body = <String, dynamic>{
    'username': username,
    'password': password,
    if (shopId != null && shopId.trim().isNotEmpty) 'shop_id': shopId.trim(),
  };

  try {
    final response = await http
        .post(
          uri,
          headers: const {'Content-Type': 'application/json; charset=utf-8'},
          body: jsonEncode(body),
        )
        .timeout(timeout);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        return PrideApiLoginFailure(
          'Unexpected response',
          statusCode: response.statusCode,
        );
      }
      final access = decoded['access_token'];
      final user = decoded['user'];
      final snap = decoded['license_snapshot'];
      if (access is! String ||
          user is! Map<String, dynamic> ||
          snap is! Map<String, dynamic>) {
        return PrideApiLoginFailure(
          'Malformed login response',
          statusCode: response.statusCode,
        );
      }
      final id = user['id'];
      final sid = user['shop_id'];
      final un = user['username'];
      final owner = user['is_shop_owner'];
      if (id is! String ||
          sid is! String ||
          un is! String ||
          owner is! bool) {
        return PrideApiLoginFailure(
          'Malformed user object',
          statusCode: response.statusCode,
        );
      }
      final refresh = decoded['refresh_token'];
      return PrideApiLoginOk(
        accessToken: access,
        refreshToken: refresh is String ? refresh : null,
        userId: id,
        shopId: sid,
        username: un,
        isShopOwner: owner,
        licenseSnapshot: snap,
      );
    }

    return PrideApiLoginFailure(
      _extractErrorMessage(response.body) ??
          'HTTP ${response.statusCode}',
      statusCode: response.statusCode,
    );
  } on Exception catch (e) {
    return PrideApiLoginFailure(e.toString());
  }
}

String? _extractErrorMessage(String body) {
  final t = body.trim();
  if (t.isEmpty) return null;
  try {
    final decoded = jsonDecode(t);
    if (decoded is Map<String, dynamic>) {
      final msg = decoded['message'];
      if (msg is String && msg.isNotEmpty) return msg;
      if (msg is List && msg.isNotEmpty) {
        final first = msg.first;
        if (first is String) return first;
      }
    }
  } catch (_) {}
  return t.length > 160 ? '${t.substring(0, 160)}…' : t;
}
