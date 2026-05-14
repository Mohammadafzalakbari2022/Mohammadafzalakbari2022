import 'dart:convert';

import 'package:http/http.dart' as http;

import 'pride_api_config.dart';

sealed class PrideApiLicenseResult {
  const PrideApiLicenseResult();
}

final class PrideApiLicenseOk extends PrideApiLicenseResult {
  const PrideApiLicenseOk(this.snapshot);

  final Map<String, dynamic> snapshot;
}

final class PrideApiLicenseFailure extends PrideApiLicenseResult {
  const PrideApiLicenseFailure(this.message, {this.statusCode});

  final String message;
  final int? statusCode;
}

/// `GET /license/status` (`plan-04`). Requires [accessToken] when the server enforces JWT.
Future<PrideApiLicenseResult> fetchPrideApiLicenseStatus({
  String? accessToken,
  Duration timeout = const Duration(seconds: 25),
}) async {
  final base = PrideApiConfig.normalizedBase;
  if (base == null) {
    return const PrideApiLicenseFailure('API_BASE_URL not set');
  }
  final uri = Uri.parse('$base/license/status');
  final headers = <String, String>{
    'Accept': 'application/json',
    if (accessToken != null && accessToken.isNotEmpty)
      'Authorization': 'Bearer $accessToken',
  };
  try {
    final response = await http.get(uri, headers: headers).timeout(timeout);
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        return PrideApiLicenseOk(decoded);
      }
      return PrideApiLicenseFailure(
        'Unexpected response',
        statusCode: response.statusCode,
      );
    }
    return PrideApiLicenseFailure(
      'HTTP ${response.statusCode}',
      statusCode: response.statusCode,
    );
  } on Exception catch (e) {
    return PrideApiLicenseFailure(e.toString());
  }
}

/// `POST /license/redeem` (`plan-04`). Requires [accessToken] when the server enforces JWT.
Future<PrideApiLicenseResult> postPrideApiLicenseRedeem({
  required String code,
  String? accessToken,
  Duration timeout = const Duration(seconds: 25),
}) async {
  final base = PrideApiConfig.normalizedBase;
  if (base == null) {
    return const PrideApiLicenseFailure('API_BASE_URL not set');
  }
  final uri = Uri.parse('$base/license/redeem');
  final headers = <String, String>{
    'Content-Type': 'application/json; charset=utf-8',
    'Accept': 'application/json',
    if (accessToken != null && accessToken.isNotEmpty)
      'Authorization': 'Bearer $accessToken',
  };
  try {
    final response = await http
        .post(
          uri,
          headers: headers,
          body: jsonEncode({'code': code}),
        )
        .timeout(timeout);
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        return PrideApiLicenseOk(decoded);
      }
      return PrideApiLicenseFailure(
        'Unexpected response',
        statusCode: response.statusCode,
      );
    }
    return PrideApiLicenseFailure(
      _redeemErrorSnippet(response.body) ??
          'HTTP ${response.statusCode}',
      statusCode: response.statusCode,
    );
  } on Exception catch (e) {
    return PrideApiLicenseFailure(e.toString());
  }
}

String? _redeemErrorSnippet(String body) {
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
