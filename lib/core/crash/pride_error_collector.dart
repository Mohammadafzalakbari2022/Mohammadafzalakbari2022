import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:shared_preferences/shared_preferences.dart';

/// Ring buffer of recent errors for support exports and next-release triage.
///
/// Always active (local). When [PRIDE_SENTRY_DSN] is set, also forwards to Sentry.
abstract final class PrideErrorCollector {
  static const _prefsKey = 'pride_error_collector_log_v1';
  static const _maxEntries = 40;

  static SharedPreferences? _prefs;
  static final List<Map<String, dynamic>> _buffer = [];
  static var _installed = false;

  /// Call once after [SharedPreferences] is available (see [main.dart]).
  static Future<void> install(SharedPreferences prefs) async {
    if (_installed) return;
    _installed = true;
    _prefs = prefs;
    await _loadFromDisk();

    final prevFlutter = FlutterError.onError;
    FlutterError.onError = (details) {
      recordFlutterError(details);
      prevFlutter?.call(details);
    };

    final prevPlatform = PlatformDispatcher.instance.onError;
    PlatformDispatcher.instance.onError = (error, stack) {
      unawaited(record(
        error,
        stack: stack,
        source: 'platform',
      ));
      return prevPlatform?.call(error, stack) ?? false;
    };
  }

  static Future<void> record(
    Object error, {
    StackTrace? stack,
    String source = 'zone',
    String? context,
    bool fatal = false,
  }) async {
    final entry = <String, dynamic>{
      'atUtc': DateTime.now().toUtc().toIso8601String(),
      'source': source,
      'fatal': fatal,
      if (context != null && context.isNotEmpty) 'context': context,
      'type': error.runtimeType.toString(),
      'message': error.toString(),
      if (stack != null) 'stack': stack.toString(),
    };

    _buffer.add(entry);
    while (_buffer.length > _maxEntries) {
      _buffer.removeAt(0);
    }
    await _persist();

    const dsn = String.fromEnvironment('PRIDE_SENTRY_DSN', defaultValue: '');
    if (dsn.isNotEmpty) {
      await Sentry.captureException(
        error,
        stackTrace: stack,
        hint: Hint.withMap({
          if (context != null && context.isNotEmpty) 'context': context,
          'source': source,
          'fatal': fatal,
        }),
      );
    }
  }

  static void recordFlutterError(FlutterErrorDetails details) {
    unawaited(record(
      details.exception,
      stack: details.stack,
      source: 'flutter',
      context: details.context?.toDescription(),
      fatal: true,
    ));
  }

  static List<Map<String, dynamic>> snapshot() =>
      List<Map<String, dynamic>>.unmodifiable(_buffer);

  static Future<void> clear() async {
    _buffer.clear();
    await _prefs?.remove(_prefsKey);
  }

  static Future<void> _loadFromDisk() async {
    final raw = _prefs?.getString(_prefsKey);
    if (raw == null || raw.isEmpty) return;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return;
      _buffer
        ..clear()
        ..addAll(
          decoded
              .whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e)),
        );
      while (_buffer.length > _maxEntries) {
        _buffer.removeAt(0);
      }
    } on Object {
      await _prefs?.remove(_prefsKey);
    }
  }

  static Future<void> _persist() async {
    final prefs = _prefs;
    if (prefs == null) return;
    try {
      await prefs.setString(_prefsKey, jsonEncode(_buffer));
    } on Object {
      // Ignore quota / serialization failures.
    }
  }
}
