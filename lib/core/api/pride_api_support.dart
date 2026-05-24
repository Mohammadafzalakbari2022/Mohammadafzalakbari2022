import 'dart:convert';

import 'package:http/http.dart' as http;

import 'pride_api_config.dart';

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
      final err = decoded['error'];
      if (err is String && err.isNotEmpty) return err;
    }
  } catch (_) {}
  return t.length > 120 ? '${t.substring(0, 120)}…' : t;
}

/// `GET /license/support-info`
Future<({bool ok, Map<String, dynamic>? data, String? error})>
    fetchPrideApiLicenseSupportInfo({
  required String accessToken,
  Duration timeout = const Duration(seconds: 25),
}) async {
  final base = PrideApiConfig.normalizedBase;
  if (base == null) {
    return (ok: false, data: null, error: 'API_BASE_URL not set');
  }
  final uri = Uri.parse('$base/license/support-info');
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
      if (decoded is Map<String, dynamic>) {
        return (ok: true, data: decoded, error: null);
      }
      return (ok: false, data: null, error: 'Unexpected response');
    }
    return (
      ok: false,
      data: null,
      error: _extractErr(response.body) ?? 'HTTP ${response.statusCode}',
    );
  } on Exception catch (e) {
    return (ok: false, data: null, error: e.toString());
  }
}

/// `GET /admin/support-info` (developer-only)
Future<({bool ok, Map<String, dynamic>? data, String? error})>
    getPrideApiAdminSupportInfo({
  required String accessToken,
  Duration timeout = const Duration(seconds: 25),
}) async {
  final base = PrideApiConfig.normalizedBase;
  if (base == null) {
    return (ok: false, data: null, error: 'API_BASE_URL not set');
  }
  final uri = Uri.parse('$base/admin/support-info');
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
      if (decoded is Map<String, dynamic>) {
        return (ok: true, data: decoded, error: null);
      }
      return (ok: false, data: null, error: 'Unexpected response');
    }
    return (
      ok: false,
      data: null,
      error: _extractErr(response.body) ?? 'HTTP ${response.statusCode}',
    );
  } on Exception catch (e) {
    return (ok: false, data: null, error: e.toString());
  }
}

/// `POST /admin/support-info` (developer-only)
Future<({bool ok, Map<String, dynamic>? data, String? error})>
    postPrideApiAdminSupportInfo({
  required String accessToken,
  required Map<String, dynamic> body,
  Duration timeout = const Duration(seconds: 25),
}) async {
  final base = PrideApiConfig.normalizedBase;
  if (base == null) {
    return (ok: false, data: null, error: 'API_BASE_URL not set');
  }
  final uri = Uri.parse('$base/admin/support-info');
  try {
    final response = await http
        .post(
          uri,
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
          body: jsonEncode(body),
        )
        .timeout(timeout);
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        return (ok: true, data: decoded, error: null);
      }
      return (ok: false, data: null, error: 'Unexpected response');
    }
    return (
      ok: false,
      data: null,
      error: _extractErr(response.body) ?? 'HTTP ${response.statusCode}',
    );
  } on Exception catch (e) {
    return (ok: false, data: null, error: e.toString());
  }
}

