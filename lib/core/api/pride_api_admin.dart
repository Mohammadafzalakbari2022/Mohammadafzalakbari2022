import 'dart:convert';

import 'package:http/http.dart' as http;

import 'pride_api_config.dart';

sealed class PrideApiAdminMeResult {
  const PrideApiAdminMeResult();
}

final class PrideApiAdminMeOk extends PrideApiAdminMeResult {
  const PrideApiAdminMeOk({required this.isDeveloper});

  final bool isDeveloper;
}

final class PrideApiAdminMeFailure extends PrideApiAdminMeResult {
  const PrideApiAdminMeFailure(this.message, {this.statusCode});

  final String message;
  final int? statusCode;
}

/// `GET /admin/me` (`plan-18`).
Future<PrideApiAdminMeResult> getPrideApiAdminMe({
  required String accessToken,
  Duration timeout = const Duration(seconds: 20),
}) async {
  final base = PrideApiConfig.normalizedBase;
  if (base == null) {
    return const PrideApiAdminMeFailure('API_BASE_URL not set');
  }
  final uri = Uri.parse('$base/admin/me');
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
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        return PrideApiAdminMeFailure(
          'Unexpected response',
          statusCode: response.statusCode,
        );
      }
      final flag = decoded['is_developer'];
      if (flag is! bool) {
        return PrideApiAdminMeFailure(
          'Malformed response',
          statusCode: response.statusCode,
        );
      }
      return PrideApiAdminMeOk(isDeveloper: flag);
    }
    return PrideApiAdminMeFailure(
      _extractErr(response.body) ?? 'HTTP ${response.statusCode}',
      statusCode: response.statusCode,
    );
  } on Exception catch (e) {
    return PrideApiAdminMeFailure(e.toString());
  }
}

String? _extractErr(String body) {
  try {
    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) {
      final m = decoded['message'];
      if (m is String && m.isNotEmpty) return m;
      final msg = decoded['error'];
      if (msg is String && msg.isNotEmpty) return msg;
    }
  } catch (_) {}
  return null;
}

sealed class PrideApiAdminAuditLogResult {
  const PrideApiAdminAuditLogResult();
}

final class PrideApiAdminAuditLogOk extends PrideApiAdminAuditLogResult {
  const PrideApiAdminAuditLogOk({
    required this.schemaVersion,
    required this.rowCount,
    required this.rows,
  });

  final int schemaVersion;
  final int rowCount;
  final List<Map<String, dynamic>> rows;
}

final class PrideApiAdminAuditLogFailure extends PrideApiAdminAuditLogResult {
  const PrideApiAdminAuditLogFailure(this.message, {this.statusCode});

  final String message;
  final int? statusCode;
}

/// `GET /admin/audit-log` — developer-only; returns empty `rows` until wired (`plan-18`).
Future<PrideApiAdminAuditLogResult> getPrideApiAdminAuditLog({
  required String accessToken,
  Duration timeout = const Duration(seconds: 20),
}) async {
  final base = PrideApiConfig.normalizedBase;
  if (base == null) {
    return const PrideApiAdminAuditLogFailure('API_BASE_URL not set');
  }
  final uri = Uri.parse('$base/admin/audit-log');
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
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        return PrideApiAdminAuditLogFailure(
          'Unexpected response',
          statusCode: response.statusCode,
        );
      }
      final rawSchema = decoded['schema_version'];
      final schemaVersion = switch (rawSchema) {
        int v => v,
        String s => int.tryParse(s) ?? 0,
        _ => 0,
      };
      final rawRows = decoded['rows'];
      final list = rawRows is List
          ? rawRows
              .map((e) => Map<String, dynamic>.from(e as Map))
              .toList()
          : <Map<String, dynamic>>[];
      return PrideApiAdminAuditLogOk(
        schemaVersion: schemaVersion,
        rowCount: list.length,
        rows: list,
      );
    }
    return PrideApiAdminAuditLogFailure(
      _extractErr(response.body) ?? 'HTTP ${response.statusCode}',
      statusCode: response.statusCode,
    );
  } on Exception catch (e) {
    return PrideApiAdminAuditLogFailure(e.toString());
  }
}

// --- Developer directory + password reset queue (`plan-18`) ---

Future<({bool ok, List<Map<String, dynamic>> shops, String? error})>
    getPrideApiAdminShops({
  required String accessToken,
  Duration timeout = const Duration(seconds: 20),
}) async {
  final base = PrideApiConfig.normalizedBase;
  if (base == null) {
    return (ok: false, shops: <Map<String, dynamic>>[], error: 'API_BASE_URL not set');
  }
  try {
    final response = await http
        .get(
          Uri.parse('$base/admin/shops'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        )
        .timeout(timeout);
    if (response.statusCode != 200) {
      return (
        ok: false,
        shops: <Map<String, dynamic>>[],
        error: _extractErr(response.body) ?? 'HTTP ${response.statusCode}',
      );
    }
    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      return (ok: false, shops: <Map<String, dynamic>>[], error: 'Unexpected response');
    }
    final raw = decoded['shops'];
    final list = raw is List
        ? raw.whereType<Map<String, dynamic>>().toList()
        : <Map<String, dynamic>>[];
    return (ok: true, shops: list, error: null);
  } on Exception catch (e) {
    return (ok: false, shops: <Map<String, dynamic>>[], error: e.toString());
  }
}

Future<({bool ok, List<Map<String, dynamic>> rows, String? error})>
    getPrideApiAdminPasswordResetRequests({
  required String accessToken,
  Duration timeout = const Duration(seconds: 20),
}) async {
  final base = PrideApiConfig.normalizedBase;
  if (base == null) {
    return (ok: false, rows: <Map<String, dynamic>>[], error: 'API_BASE_URL not set');
  }
  try {
    final response = await http
        .get(
          Uri.parse('$base/admin/password-reset-requests'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        )
        .timeout(timeout);
    if (response.statusCode != 200) {
      return (
        ok: false,
        rows: <Map<String, dynamic>>[],
        error: _extractErr(response.body) ?? 'HTTP ${response.statusCode}',
      );
    }
    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      return (ok: false, rows: <Map<String, dynamic>>[], error: 'Unexpected response');
    }
    final raw = decoded['rows'];
    final list = raw is List
        ? raw.map((e) => Map<String, dynamic>.from(e as Map)).toList()
        : <Map<String, dynamic>>[];
    return (ok: true, rows: list, error: null);
  } on Exception catch (e) {
    return (ok: false, rows: <Map<String, dynamic>>[], error: e.toString());
  }
}

Future<({bool ok, String? error})> postPrideApiAdminResolvePasswordReset({
  required String accessToken,
  required String requestId,
  required String newPassword,
  Duration timeout = const Duration(seconds: 20),
}) async {
  final base = PrideApiConfig.normalizedBase;
  if (base == null) {
    return (ok: false, error: 'API_BASE_URL not set');
  }
  try {
    final response = await http
        .post(
          Uri.parse('$base/admin/password-reset-requests/$requestId/resolve'),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
          body: jsonEncode({'new_password': newPassword}),
        )
        .timeout(timeout);
    if (response.statusCode == 200) {
      return (ok: true, error: null);
    }
    return (
      ok: false,
      error: _extractErr(response.body) ?? 'HTTP ${response.statusCode}',
    );
  } on Exception catch (e) {
    return (ok: false, error: e.toString());
  }
}

Future<({bool ok, Map<String, dynamic>? data, String? error})>
    getPrideApiAdminStats({
  required String accessToken,
  Duration timeout = const Duration(seconds: 20),
}) async {
  final base = PrideApiConfig.normalizedBase;
  if (base == null) {
    return (ok: false, data: null, error: 'API_BASE_URL not set');
  }
  try {
    final response = await http
        .get(
          Uri.parse('$base/admin/stats'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        )
        .timeout(timeout);
    if (response.statusCode != 200) {
      return (
        ok: false,
        data: null,
        error: _extractErr(response.body) ?? 'HTTP ${response.statusCode}',
      );
    }
    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      return (ok: false, data: null, error: 'Unexpected response');
    }
    return (ok: true, data: decoded, error: null);
  } on Exception catch (e) {
    return (ok: false, data: null, error: e.toString());
  }
}

Future<({bool ok, List<Map<String, dynamic>> rows, String? error})>
    getPrideApiAdminActivationCodes({
  required String accessToken,
  Duration timeout = const Duration(seconds: 20),
}) async {
  final base = PrideApiConfig.normalizedBase;
  if (base == null) {
    return (ok: false, rows: <Map<String, dynamic>>[], error: 'API_BASE_URL not set');
  }
  try {
    final response = await http
        .get(
          Uri.parse('$base/admin/activation-codes'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        )
        .timeout(timeout);
    if (response.statusCode != 200) {
      return (
        ok: false,
        rows: <Map<String, dynamic>>[],
        error: _extractErr(response.body) ?? 'HTTP ${response.statusCode}',
      );
    }
    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      return (ok: false, rows: <Map<String, dynamic>>[], error: 'Unexpected response');
    }
    final raw = decoded['rows'];
    final list = raw is List
        ? raw.map((e) => Map<String, dynamic>.from(e as Map)).toList()
        : <Map<String, dynamic>>[];
    return (ok: true, rows: list, error: null);
  } on Exception catch (e) {
    return (ok: false, rows: <Map<String, dynamic>>[], error: e.toString());
  }
}

Future<({bool ok, Map<String, dynamic>? created, String? error})>
    postPrideApiAdminCreateActivationCode({
  required String accessToken,
  int planDays = 365,
  int maxUses = 1,
  String? assignedShopId,
  String? expiresAtIso,
  Duration timeout = const Duration(seconds: 20),
}) async {
  final base = PrideApiConfig.normalizedBase;
  if (base == null) {
    return (ok: false, created: null, error: 'API_BASE_URL not set');
  }
  final body = <String, dynamic>{
    'plan_days': planDays,
    'max_uses': maxUses,
  };
  if (assignedShopId != null && assignedShopId.trim().isNotEmpty) {
    body['assigned_shop_id'] = assignedShopId.trim();
  }
  if (expiresAtIso != null && expiresAtIso.trim().isNotEmpty) {
    body['expires_at'] = expiresAtIso.trim();
  }
  try {
    final response = await http
        .post(
          Uri.parse('$base/admin/activation-codes'),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
          body: jsonEncode(body),
        )
        .timeout(timeout);
    if (response.statusCode != 200) {
      return (
        ok: false,
        created: null,
        error: _extractErr(response.body) ?? 'HTTP ${response.statusCode}',
      );
    }
    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      return (ok: false, created: null, error: 'Unexpected response');
    }
    return (ok: true, created: decoded, error: null);
  } on Exception catch (e) {
    return (ok: false, created: null, error: e.toString());
  }
}

Future<({bool ok, String? error})> postPrideApiAdminRevokeActivationCode({
  required String accessToken,
  required String codeId,
  Duration timeout = const Duration(seconds: 20),
}) async {
  final base = PrideApiConfig.normalizedBase;
  if (base == null) {
    return (ok: false, error: 'API_BASE_URL not set');
  }
  try {
    final response = await http
        .post(
          Uri.parse('$base/admin/activation-codes/$codeId/revoke'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        )
        .timeout(timeout);
    if (response.statusCode == 200) {
      return (ok: true, error: null);
    }
    return (
      ok: false,
      error: _extractErr(response.body) ?? 'HTTP ${response.statusCode}',
    );
  } on Exception catch (e) {
    return (ok: false, error: e.toString());
  }
}
