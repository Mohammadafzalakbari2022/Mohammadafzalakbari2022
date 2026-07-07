import 'package:flutter/services.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:shared_preferences_platform_interface/types.dart';

/// Android fallback when pigeon [SharedPreferencesApi] is unavailable in release.
///
/// Talks to [MainActivity] via `com.pridev3.pride_v3/native_prefs`.
class PrideNativeAndroidPreferencesStore extends SharedPreferencesStorePlatform {
  static const _channel = MethodChannel('com.pridev3.pride_v3/native_prefs');
  static const _defaultPrefix = 'flutter.';

  static void install() {
    SharedPreferencesStorePlatform.instance = PrideNativeAndroidPreferencesStore();
  }

  @override
  Future<bool> clear() {
    return clearWithParameters(
      ClearParameters(filter: PreferencesFilter(prefix: _defaultPrefix)),
    );
  }

  @override
  Future<bool> clearWithParameters(ClearParameters parameters) async {
    final filter = parameters.filter;
    return (await _channel.invokeMethod<bool>('clearWithParameters', {
          'prefix': filter.prefix,
          'allowList': filter.allowList?.toList(),
        })) ??
        false;
  }

  @override
  Future<Map<String, Object>> getAll() {
    return getAllWithParameters(
      GetAllParameters(filter: PreferencesFilter(prefix: _defaultPrefix)),
    );
  }

  @override
  Future<Map<String, Object>> getAllWithParameters(
    GetAllParameters parameters,
  ) async {
    final filter = parameters.filter;
    final raw = await _channel.invokeMethod<Map<Object?, Object?>>(
      'getAllWithParameters',
      {
        'prefix': filter.prefix,
        'allowList': filter.allowList?.toList(),
      },
    );
    final out = <String, Object>{};
    for (final entry in raw?.entries ?? const <MapEntry<Object?, Object?>>[]) {
      final key = entry.key;
      final value = entry.value;
      if (key is String && value != null) {
        out[key] = _normalizeValue(value);
      }
    }
    return out;
  }

  @override
  Future<bool> remove(String key) async {
    return (await _channel.invokeMethod<bool>('remove', {'key': key})) ?? false;
  }

  @override
  Future<bool> setValue(String valueType, String key, Object value) async {
    return (await _channel.invokeMethod<bool>('setValue', {
          'valueType': valueType,
          'key': key,
          'value': value,
        })) ??
        false;
  }

  Object _normalizeValue(Object value) {
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return value;
  }
}
