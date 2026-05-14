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
  });

  final int schemaVersion;
  final int rowCount;
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
      final rows = decoded['rows'];
      final rowCount = rows is List ? rows.length : 0;
      return PrideApiAdminAuditLogOk(
        schemaVersion: schemaVersion,
        rowCount: rowCount,
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
