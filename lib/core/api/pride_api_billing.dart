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
    }
  } catch (_) {}
  return t.length > 120 ? '${t.substring(0, 120)}…' : t;
}

/// `GET /license/billing-info`
Future<({bool ok, Map<String, dynamic>? data, String? error})>
    fetchPrideApiLicenseBillingInfo({
  required String accessToken,
  String? locale,
  Duration timeout = const Duration(seconds: 25),
}) async {
  final base = PrideApiConfig.normalizedBase;
  if (base == null) {
    return (ok: false, data: null, error: 'API_BASE_URL not set');
  }
  final q = locale != null && locale.isNotEmpty ? '?locale=$locale' : '';
  final uri = Uri.parse('$base/license/billing-info$q');
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

/// `GET /license/payment-claims` (owner).
Future<({bool ok, List<Map<String, dynamic>> rows, String? error})>
    fetchPrideApiLicensePaymentClaims({
  required String accessToken,
  Duration timeout = const Duration(seconds: 25),
}) async {
  final base = PrideApiConfig.normalizedBase;
  if (base == null) {
    return (ok: false, rows: <Map<String, dynamic>>[], error: 'API_BASE_URL not set');
  }
  final uri = Uri.parse('$base/license/payment-claims');
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
        final raw = decoded['rows'];
        final rows = raw is List
            ? raw
                .whereType<Map>()
                .map((e) => Map<String, dynamic>.from(e))
                .toList()
            : <Map<String, dynamic>>[];
        return (ok: true, rows: rows, error: null);
      }
    }
    return (
      ok: false,
      rows: <Map<String, dynamic>>[],
      error: _extractErr(response.body) ?? 'HTTP ${response.statusCode}',
    );
  } on Exception catch (e) {
    return (ok: false, rows: <Map<String, dynamic>>[], error: e.toString());
  }
}

/// `POST /license/payment-claims` (owner).
Future<({bool ok, Map<String, dynamic>? data, String? error})>
    postPrideApiLicensePaymentClaim({
  required String accessToken,
  required String planTier,
  required String transactionId,
  String? payerPhone,
  String? notes,
  Duration timeout = const Duration(seconds: 25),
}) async {
  final base = PrideApiConfig.normalizedBase;
  if (base == null) {
    return (ok: false, data: null, error: 'API_BASE_URL not set');
  }
  final uri = Uri.parse('$base/license/payment-claims');
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
            'plan_tier': planTier,
            'transaction_id': transactionId,
            if (payerPhone != null && payerPhone.isNotEmpty)
              'payer_phone': payerPhone,
            if (notes != null && notes.isNotEmpty) 'notes': notes,
          }),
        )
        .timeout(timeout);
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        return (ok: true, data: decoded, error: null);
      }
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

/// `GET /admin/billing-info`
Future<({bool ok, Map<String, dynamic>? data, String? error})>
    getPrideApiAdminBillingInfo({
  required String accessToken,
  Duration timeout = const Duration(seconds: 25),
}) async {
  final base = PrideApiConfig.normalizedBase;
  if (base == null) {
    return (ok: false, data: null, error: 'API_BASE_URL not set');
  }
  final uri = Uri.parse('$base/admin/billing-info');
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

/// `POST /admin/billing-info`
Future<({bool ok, Map<String, dynamic>? data, String? error})>
    postPrideApiAdminBillingInfo({
  required String accessToken,
  required Map<String, dynamic> body,
  Duration timeout = const Duration(seconds: 30),
}) async {
  final base = PrideApiConfig.normalizedBase;
  if (base == null) {
    return (ok: false, data: null, error: 'API_BASE_URL not set');
  }
  final uri = Uri.parse('$base/admin/billing-info');
  try {
    final response = await http
        .post(
          uri,
          headers: {
            'Content-Type': 'application/json; charset=utf-8',
            'Accept': 'application/json',
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

/// `GET /admin/payment-claims`
Future<({bool ok, List<Map<String, dynamic>> rows, String? error})>
    getPrideApiAdminPaymentClaims({
  required String accessToken,
  String? status,
  Duration timeout = const Duration(seconds: 25),
}) async {
  final base = PrideApiConfig.normalizedBase;
  if (base == null) {
    return (ok: false, rows: <Map<String, dynamic>>[], error: 'API_BASE_URL not set');
  }
  final q = status != null && status.isNotEmpty ? '?status=$status' : '';
  final uri = Uri.parse('$base/admin/payment-claims$q');
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
        final raw = decoded['rows'];
        final rows = raw is List
            ? raw
                .whereType<Map>()
                .map((e) => Map<String, dynamic>.from(e))
                .toList()
            : <Map<String, dynamic>>[];
        return (ok: true, rows: rows, error: null);
      }
    }
    return (
      ok: false,
      rows: <Map<String, dynamic>>[],
      error: _extractErr(response.body) ?? 'HTTP ${response.statusCode}',
    );
  } on Exception catch (e) {
    return (ok: false, rows: <Map<String, dynamic>>[], error: e.toString());
  }
}

/// `POST /admin/payment-claims/:id/approve`
Future<({bool ok, Map<String, dynamic>? data, String? error})>
    postPrideApiAdminApprovePaymentClaim({
  required String accessToken,
  required String claimId,
  bool autoCreateCode = true,
  String? activationCode,
  Duration timeout = const Duration(seconds: 30),
}) async {
  final base = PrideApiConfig.normalizedBase;
  if (base == null) {
    return (ok: false, data: null, error: 'API_BASE_URL not set');
  }
  final uri = Uri.parse('$base/admin/payment-claims/$claimId/approve');
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
            if (activationCode != null && activationCode.isNotEmpty)
              'activation_code': activationCode
            else
              'auto_create_code': autoCreateCode,
          }),
        )
        .timeout(timeout);
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        return (ok: true, data: decoded, error: null);
      }
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

/// `POST /admin/payment-claims/:id/reject`
Future<({bool ok, Map<String, dynamic>? data, String? error})>
    postPrideApiAdminRejectPaymentClaim({
  required String accessToken,
  required String claimId,
  String? reviewNotes,
  Duration timeout = const Duration(seconds: 25),
}) async {
  final base = PrideApiConfig.normalizedBase;
  if (base == null) {
    return (ok: false, data: null, error: 'API_BASE_URL not set');
  }
  final uri = Uri.parse('$base/admin/payment-claims/$claimId/reject');
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
            if (reviewNotes != null && reviewNotes.isNotEmpty)
              'review_notes': reviewNotes,
          }),
        )
        .timeout(timeout);
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        return (ok: true, data: decoded, error: null);
      }
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
