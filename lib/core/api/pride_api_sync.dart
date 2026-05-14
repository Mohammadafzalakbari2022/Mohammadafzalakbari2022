import 'dart:convert';

import 'package:http/http.dart' as http;

import 'pride_api_config.dart';

sealed class PrideApiSyncPushResult {
  const PrideApiSyncPushResult();
}

final class PrideApiSyncPushOk extends PrideApiSyncPushResult {
  const PrideApiSyncPushOk({
    required this.serverNow,
    required this.nextCursor,
    required this.results,
  });

  final String serverNow;
  final String nextCursor;
  final List<SyncPushResultRow> results;
}

final class PrideApiSyncPushFailure extends PrideApiSyncPushResult {
  const PrideApiSyncPushFailure(this.message, {this.statusCode, this.errorCode});

  final String message;
  final int? statusCode;
  final String? errorCode;
}

class SyncPushResultRow {
  const SyncPushResultRow({
    required this.internalId,
    required this.status,
    this.message,
  });

  final String internalId;
  final String status;
  final String? message;
}

sealed class PrideApiSyncPullResult {
  const PrideApiSyncPullResult();
}

final class PrideApiSyncPullOk extends PrideApiSyncPullResult {
  const PrideApiSyncPullOk({
    required this.serverNow,
    required this.nextCursor,
    required this.changes,
  });

  final String serverNow;
  final String nextCursor;
  final List<Map<String, dynamic>> changes;
}

final class PrideApiSyncPullFailure extends PrideApiSyncPullResult {
  const PrideApiSyncPullFailure(this.message, {this.statusCode, this.errorCode});

  final String message;
  final int? statusCode;
  final String? errorCode;
}

/// `POST /sync/push` (`plan-04`).
Future<PrideApiSyncPushResult> postPrideApiSyncPush({
  required String accessToken,
  required List<Map<String, dynamic>> mutations,
  Duration timeout = const Duration(seconds: 45),
}) async {
  final base = PrideApiConfig.normalizedBase;
  if (base == null) {
    return const PrideApiSyncPushFailure('API_BASE_URL not set');
  }
  final uri = Uri.parse('$base/sync/push');
  try {
    final response = await http
        .post(
          uri,
          headers: {
            'Content-Type': 'application/json; charset=utf-8',
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
          body: jsonEncode({'mutations': mutations}),
        )
        .timeout(timeout);
    final decoded = _tryDecodeMap(response.body);
    if (response.statusCode == 200 && decoded != null) {
      final serverNow = decoded['server_now'];
      final nextCursor = decoded['next_cursor'];
      final rawResults = decoded['results'];
      if (serverNow is! String ||
          nextCursor is! String ||
          rawResults is! List<dynamic>) {
        return PrideApiSyncPushFailure(
          'Malformed response',
          statusCode: response.statusCode,
        );
      }
      final results = <SyncPushResultRow>[];
      for (final e in rawResults) {
        if (e is! Map<String, dynamic>) {
          return PrideApiSyncPushFailure(
            'Malformed results',
            statusCode: response.statusCode,
          );
        }
        final id = e['internal_id'];
        final st = e['status'];
        if (id is! String || st is! String) {
          return PrideApiSyncPushFailure(
            'Malformed result row',
            statusCode: response.statusCode,
          );
        }
        final msg = e['message'];
        results.add(
          SyncPushResultRow(
            internalId: id,
            status: st,
            message: msg is String ? msg : null,
          ),
        );
      }
      return PrideApiSyncPushOk(
        serverNow: serverNow,
        nextCursor: nextCursor,
        results: results,
      );
    }
    final err = decoded?['error'];
    return PrideApiSyncPushFailure(
      _extractMessage(decoded, response.body) ?? 'HTTP ${response.statusCode}',
      statusCode: response.statusCode,
      errorCode: err is String ? err : null,
    );
  } on Exception catch (e) {
    return PrideApiSyncPushFailure(e.toString());
  }
}

/// `GET /sync/pull` (`plan-04`). [cursor] is opaque from last push/pull `next_cursor`.
Future<PrideApiSyncPullResult> getPrideApiSyncPull({
  required String accessToken,
  String? cursor,
  Duration timeout = const Duration(seconds: 45),
}) async {
  final base = PrideApiConfig.normalizedBase;
  if (base == null) {
    return const PrideApiSyncPullFailure('API_BASE_URL not set');
  }
  final q = <String, String>{};
  if (cursor != null && cursor.isNotEmpty) {
    q['cursor'] = cursor;
  }
  final uri = Uri.parse('$base/sync/pull').replace(queryParameters: q);
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
    final decoded = _tryDecodeMap(response.body);
    if (response.statusCode == 200 && decoded != null) {
      final serverNow = decoded['server_now'];
      final nextCursor = decoded['next_cursor'];
      final rawChanges = decoded['changes'];
      if (serverNow is! String ||
          nextCursor is! String ||
          rawChanges is! List<dynamic>) {
        return PrideApiSyncPullFailure(
          'Malformed response',
          statusCode: response.statusCode,
        );
      }
      final changes = <Map<String, dynamic>>[];
      for (final c in rawChanges) {
        if (c is Map<String, dynamic>) {
          changes.add(c);
        } else {
          return PrideApiSyncPullFailure(
            'Malformed changes',
            statusCode: response.statusCode,
          );
        }
      }
      return PrideApiSyncPullOk(
        serverNow: serverNow,
        nextCursor: nextCursor,
        changes: changes,
      );
    }
    final err = decoded?['error'];
    return PrideApiSyncPullFailure(
      _extractMessage(decoded, response.body) ?? 'HTTP ${response.statusCode}',
      statusCode: response.statusCode,
      errorCode: err is String ? err : null,
    );
  } on Exception catch (e) {
    return PrideApiSyncPullFailure(e.toString());
  }
}

Map<String, dynamic>? _tryDecodeMap(String body) {
  try {
    final decoded = jsonDecode(body);
    return decoded is Map<String, dynamic> ? decoded : null;
  } catch (_) {
    return null;
  }
}

String? _extractMessage(Map<String, dynamic>? decoded, String body) {
  if (decoded != null) {
    final m = decoded['message'];
    if (m is String && m.isNotEmpty) return m;
  }
  return null;
}
