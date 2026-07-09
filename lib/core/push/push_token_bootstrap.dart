import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/pride_api_devices.dart';

const _kCachedPushTokenKey = 'pride_cached_push_token_v1';
const _kCachedPushPlatformKey = 'pride_cached_push_platform_v1';

/// Re-registers a cached FCM/device token after login (`plan-22`).
Future<void> bootstrapPushTokenRegistration({
  required String? accessToken,
  required SharedPreferences prefs,
}) async {
  if (kIsWeb) return;
  final token = accessToken?.trim();
  if (token == null || token.isEmpty) return;

  final cached = prefs.getString(_kCachedPushTokenKey);
  final platform = prefs.getString(_kCachedPushPlatformKey) ?? 'android';
  if (cached == null || cached.trim().length < 8) return;

  await postPrideApiPushToken(
    accessToken: token,
    token: cached.trim(),
    platform: platform,
  );
}

Future<void> cachePushTokenForBootstrap(
  SharedPreferences prefs, {
  required String token,
  required String platform,
}) async {
  await prefs.setString(_kCachedPushTokenKey, token.trim());
  await prefs.setString(_kCachedPushPlatformKey, platform);
}
