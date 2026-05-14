import 'dart:convert';

import 'package:http/http.dart' as http;

import 'pride_api_config.dart';

sealed class PrideApiPasswordResetRequestResult {
  const PrideApiPasswordResetRequestResult();
}

final class PrideApiPasswordResetRequestOk extends PrideApiPasswordResetRequestResult {
  const PrideApiPasswordResetRequestOk();
}

final class PrideApiPasswordResetRequestFailure extends PrideApiPasswordResetRequestResult {
  const PrideApiPasswordResetRequestFailure(this.message, {this.statusCode});

  final String message;
  final int? statusCode;
}

/// `POST /auth/password-reset-request` — queues reset when user exists (`plan-18`).
Future<PrideApiPasswordResetRequestResult> postPrideApiPasswordResetRequest({
  required String shopId,
  required String username,
  Duration timeout = const Duration(seconds: 20),
}) async {
  final base = PrideApiConfig.normalizedBase;
  if (base == null) {
    return const PrideApiPasswordResetRequestFailure('API_BASE_URL not set');
  }
  final uri = Uri.parse('$base/auth/password-reset-request');
  try {
    final response = await http
        .post(
          uri,
          headers: const {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'shop_id': shopId.trim(),
            'username': username.trim(),
          }),
        )
        .timeout(timeout);
    if (response.statusCode == 200) {
      return const PrideApiPasswordResetRequestOk();
    }
    return PrideApiPasswordResetRequestFailure(
      _extractErr(response.body) ?? 'HTTP ${response.statusCode}',
      statusCode: response.statusCode,
    );
  } on Exception catch (e) {
    return PrideApiPasswordResetRequestFailure(e.toString());
  }
}

String? _extractErr(String body) {
  try {
    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) {
      final m = decoded['message'];
      if (m is String && m.isNotEmpty) return m;
    }
  } catch (_) {}
  return null;
}
