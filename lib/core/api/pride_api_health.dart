import 'dart:convert';

import 'package:http/http.dart' as http;

import 'pride_api_config.dart';

/// Outcome of `GET {API_BASE_URL}/health` (plan-04).
sealed class PrideApiHealthResult {
  const PrideApiHealthResult();

  bool get isOk => this is PrideApiHealthOk;
}

final class PrideApiHealthOk extends PrideApiHealthResult {
  const PrideApiHealthOk();
}

final class PrideApiHealthFailure extends PrideApiHealthResult {
  const PrideApiHealthFailure(this.message);

  final String message;
}

/// Calls `GET /health` with a timeout. [PrideApiConfig] must be set.
Future<PrideApiHealthResult> pingPrideApiHealth({
  Duration timeout = const Duration(seconds: 20),
}) async {
  final base = PrideApiConfig.normalizedBase;
  if (base == null) {
    return const PrideApiHealthFailure('');
  }

  final uri = Uri.parse('$base/health');
  try {
    final response = await http.get(uri).timeout(timeout);
    if (response.statusCode == 200) {
      return const PrideApiHealthOk();
    }
    final snippet = _bodySnippet(response.body);
    return PrideApiHealthFailure(
      'HTTP ${response.statusCode}${snippet.isEmpty ? '' : ': $snippet'}',
    );
  } on Exception catch (e) {
    return PrideApiHealthFailure(e.toString());
  }
}

String _bodySnippet(String body) {
  final t = body.trim();
  if (t.isEmpty) return '';
  try {
    final decoded = jsonDecode(t);
    if (decoded is Map<String, dynamic>) {
      final status = decoded['status'];
      if (status != null) return status.toString();
    }
  } catch (_) {}
  return t.length > 120 ? '${t.substring(0, 120)}…' : t;
}
