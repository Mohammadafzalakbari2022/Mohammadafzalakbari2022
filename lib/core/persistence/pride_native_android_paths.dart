import 'package:flutter/services.dart';

/// Android fallback when pigeon [PathProviderApi] is unavailable in release.
class PrideNativeAndroidPaths {
  static const _channel = MethodChannel('com.pridev3.pride_v3/native_paths');

  static Future<String> getApplicationDocumentsPath() async {
    final path = await _channel.invokeMethod<String>('getApplicationDocumentsPath');
    if (path == null || path.isEmpty) {
      throw StateError('native_paths returned empty application documents path');
    }
    return path;
  }

  static Future<String> getTemporaryPath() async {
    final path = await _channel.invokeMethod<String>('getTemporaryPath');
    if (path == null || path.isEmpty) {
      throw StateError('native_paths returned empty temporary path');
    }
    return path;
  }
}
