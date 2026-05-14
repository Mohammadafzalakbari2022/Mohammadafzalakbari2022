import 'dart:convert';

import 'package:http/http.dart' as http;

import 'pride_api_config.dart';

Future<bool> postPrideApiPushToken({
  required String accessToken,
  required String token,
  String platform = 'android',
  Duration timeout = const Duration(seconds: 20),
}) async {
  final base = PrideApiConfig.normalizedBase;
  if (base == null) return false;
  final uri = Uri.parse('$base/devices/push-token');
  try {
    final response = await http
        .post(
          uri,
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
          body: jsonEncode({'token': token, 'platform': platform}),
        )
        .timeout(timeout);
    return response.statusCode == 200;
  } on Exception {
    return false;
  }
}
