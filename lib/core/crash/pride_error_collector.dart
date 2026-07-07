import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:shared_preferences/shared_preferences.dart';

/// Ring buffer of recent errors for support exports and on-device diagnostics.
///
/// Always active (local). When [PRIDE_SENTRY_DSN] is set, also forwards to Sentry.
abstract final class PrideErrorCollector {
  static const _prefsKey = 'pride_error_collector_log_v1';
  static const _maxEntries = 40;

  static SharedPreferences? _prefs;
  static final List<Map<String, dynamic>> _buffer = [];
  static var _installed = false;
  static var _earlyHooksInstalled = false;

  /// Fires whenever a new error is recorded (UI overlay listens).
  static final ValueNotifier<Map<String, dynamic>?> latestError =
      ValueNotifier<Map<String, dynamic>?>(null);

  /// Installs framework hooks immediately — safe before [runApp].
  static void installEarlyHooks() {
    if (_earlyHooksInstalled) return;
    _earlyHooksInstalled = true;

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
        fatal: true,
      ));
      return prevPlatform?.call(error, stack) ?? false;
    };
  }

  /// Attaches SharedPreferences persistence (call after first frame if needed).
  static Future<void> attachPreferences(SharedPreferences prefs) async {
    if (_installed) {
      _prefs = prefs;
      return;
    }
    _installed = true;
    _prefs = prefs;
    await _loadFromDisk();
  }

  /// Call once after [SharedPreferences] is available.
  static Future<void> install(SharedPreferences prefs) async {
    installEarlyHooks();
    await attachPreferences(prefs);
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
    latestError.value = entry;
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

  static Map<String, dynamic>? get lastEntry =>
      _buffer.isEmpty ? null : _buffer.last;

  static String formatEntry(Map<String, dynamic> entry) {
    final type = entry['type'] ?? 'Error';
    final message = entry['message'] ?? '';
    final source = entry['source'] ?? '';
    final atUtc = entry['atUtc'];
    final context = entry['context'];
    final stack = entry['stack'];
    final buf = StringBuffer();
    if (atUtc is String && atUtc.isNotEmpty) {
      buf.writeln('[$atUtc]');
    }
    buf.write('$type ($source): $message');
    if (context is String && context.isNotEmpty) {
      buf.writeln();
      buf.write('context: $context');
    }
    if (stack is String && stack.isNotEmpty) {
      buf.writeln();
      buf.write(stack);
    }
    return buf.toString();
  }

  /// Stable key for dismissing a single overlay entry.
  static String entryKey(Map<String, dynamic> entry) =>
      '${entry['atUtc']}|${entry['type']}|${entry['message']}';

  /// Full text report for clipboard / share (newest last).
  static String formatFullReport() {
    if (_buffer.isEmpty) return '';
    final buf = StringBuffer();
    for (var i = 0; i < _buffer.length; i++) {
      if (i > 0) buf.writeln('\n---\n');
      buf.write(formatEntry(_buffer[i]));
    }
    return buf.toString();
  }

  static Future<void> clear() async {
    _buffer.clear();
    latestError.value = null;
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
      if (_buffer.isNotEmpty) {
        latestError.value = _buffer.last;
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

/// Ensures a visible frame is scheduled right after [runApp].
void schedulePrideWarmUpFrame() {
  SchedulerBinding.instance.scheduleWarmUpFrame();
}
