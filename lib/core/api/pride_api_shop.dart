import 'dart:convert';

import 'package:http/http.dart' as http;

import 'pride_api_auth.dart';
import 'pride_api_config.dart';

Map<String, String> _jsonHeaders(String? bearer) {
  final h = <String, String>{
    'Content-Type': 'application/json; charset=utf-8',
  };
  if (bearer != null && bearer.isNotEmpty) {
    h['Authorization'] = 'Bearer $bearer';
  }
  return h;
}

/// `POST /shop/create` — same response shape as login (`plan-04`).
Future<PrideApiLoginResult> postPrideApiShopCreate({
  required String shopName,
  required String ownerUsername,
  required String ownerPassword,
  Duration timeout = const Duration(seconds: 25),
}) async {
  final base = PrideApiConfig.normalizedBase;
  if (base == null) {
    return const PrideApiLoginFailure('API_BASE_URL not set');
  }
  final uri = Uri.parse('$base/shop/create');
  try {
    final response = await http
        .post(
          uri,
          headers: _jsonHeaders(null),
          body: jsonEncode({
            'shop_name': shopName,
            'owner_username': ownerUsername,
            'owner_password': ownerPassword,
          }),
        )
        .timeout(timeout);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        return PrideApiLoginFailure(
          'Unexpected response',
          statusCode: response.statusCode,
        );
      }
      return _parseLoginLikeBody(decoded, response.statusCode);
    }
    return PrideApiLoginFailure(
      _extractErr(response.body) ?? 'HTTP ${response.statusCode}',
      statusCode: response.statusCode,
    );
  } on Exception catch (e) {
    return PrideApiLoginFailure(e.toString());
  }
}

PrideApiLoginResult _parseLoginLikeBody(
  Map<String, dynamic> decoded,
  int statusCode,
) {
  final access = decoded['access_token'];
  final user = decoded['user'];
  final snap = decoded['license_snapshot'];
  if (access is! String ||
      user is! Map<String, dynamic> ||
      snap is! Map<String, dynamic>) {
    return PrideApiLoginFailure(
      'Malformed response',
      statusCode: statusCode,
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
      statusCode: statusCode,
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

String? _extractErr(String body) {
  final t = body.trim();
  if (t.isEmpty) return null;
  try {
    final decoded = jsonDecode(t);
    if (decoded is Map<String, dynamic>) {
      final msg = decoded['message'];
      if (msg is String && msg.isNotEmpty) return msg;
      if (msg is List && msg.isNotEmpty && msg.first is String) {
        return msg.first as String;
      }
    }
  } catch (_) {}
  return t.length > 160 ? '${t.substring(0, 160)}…' : t;
}

sealed class PrideApiShopUsersResult {
  const PrideApiShopUsersResult();
}

final class PrideApiShopUsersOk extends PrideApiShopUsersResult {
  const PrideApiShopUsersOk(this.users);

  final List<Map<String, dynamic>> users;
}

final class PrideApiShopUsersFailure extends PrideApiShopUsersResult {
  const PrideApiShopUsersFailure(this.message, {this.statusCode});

  final String message;
  final int? statusCode;
}

sealed class PrideApiShopUserLimitsResult {
  const PrideApiShopUserLimitsResult();
}

final class PrideApiShopUserLimitsOk extends PrideApiShopUserLimitsResult {
  const PrideApiShopUserLimitsOk(this.limits);

  final Map<String, dynamic> limits;
}

final class PrideApiShopUserLimitsFailure extends PrideApiShopUserLimitsResult {
  const PrideApiShopUserLimitsFailure(this.message, {this.statusCode});

  final String message;
  final int? statusCode;
}

Future<PrideApiShopUserLimitsResult> fetchShopUserLimits({
  required String accessToken,
  Duration timeout = const Duration(seconds: 25),
}) async {
  final base = PrideApiConfig.normalizedBase;
  if (base == null) {
    return const PrideApiShopUserLimitsFailure('API_BASE_URL not set');
  }
  final uri = Uri.parse('$base/shop/user-limits');
  try {
    final response = await http
        .get(uri, headers: _jsonHeaders(accessToken))
        .timeout(timeout);
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        return PrideApiShopUserLimitsFailure(
          'Unexpected response',
          statusCode: response.statusCode,
        );
      }
      return PrideApiShopUserLimitsOk(decoded);
    }
    return PrideApiShopUserLimitsFailure(
      _extractErr(response.body) ?? 'HTTP ${response.statusCode}',
      statusCode: response.statusCode,
    );
  } on Exception catch (e) {
    return PrideApiShopUserLimitsFailure(e.toString());
  }
}

Future<PrideApiShopUsersResult> fetchShopUsers({
  required String accessToken,
  Duration timeout = const Duration(seconds: 25),
}) async {
  final base = PrideApiConfig.normalizedBase;
  if (base == null) {
    return const PrideApiShopUsersFailure('API_BASE_URL not set');
  }
  final uri = Uri.parse('$base/shop/users');
  try {
    final response = await http
        .get(uri, headers: _jsonHeaders(accessToken))
        .timeout(timeout);
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is! List) {
        return PrideApiShopUsersFailure(
          'Unexpected response',
          statusCode: response.statusCode,
        );
      }
      final list = <Map<String, dynamic>>[];
      for (final e in decoded) {
        if (e is Map<String, dynamic>) list.add(e);
      }
      return PrideApiShopUsersOk(list);
    }
    return PrideApiShopUsersFailure(
      _extractErr(response.body) ?? 'HTTP ${response.statusCode}',
      statusCode: response.statusCode,
    );
  } on Exception catch (e) {
    return PrideApiShopUsersFailure(e.toString());
  }
}

Future<String?> postShopUser({
  required String accessToken,
  required String username,
  required String password,
  Duration timeout = const Duration(seconds: 25),
}) async {
  final base = PrideApiConfig.normalizedBase;
  if (base == null) return 'API_BASE_URL not set';
  final uri = Uri.parse('$base/shop/users');
  try {
    final response = await http
        .post(
          uri,
          headers: _jsonHeaders(accessToken),
          body: jsonEncode({'username': username, 'password': password}),
        )
        .timeout(timeout);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return null;
    }
    return _extractErr(response.body) ?? 'HTTP ${response.statusCode}';
  } on Exception catch (e) {
    return e.toString();
  }
}

Future<String?> deleteShopUser({
  required String accessToken,
  required String userId,
  Duration timeout = const Duration(seconds: 25),
}) async {
  final base = PrideApiConfig.normalizedBase;
  if (base == null) return 'API_BASE_URL not set';
  final uri = Uri.parse('$base/shop/users/$userId');
  try {
    final response = await http
        .delete(uri, headers: _jsonHeaders(accessToken))
        .timeout(timeout);
    if (response.statusCode == 200) return null;
    return _extractErr(response.body) ?? 'HTTP ${response.statusCode}';
  } on Exception catch (e) {
    return e.toString();
  }
}
