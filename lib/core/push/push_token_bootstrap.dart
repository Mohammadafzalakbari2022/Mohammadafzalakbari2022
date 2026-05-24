import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/auth_providers.dart';
import '../api/pride_api_devices.dart';
import '../persistence/shared_preferences_provider.dart';

const _kCachedPushTokenKey = 'pride_cached_push_token_v1';
const _kCachedPushPlatformKey = 'pride_cached_push_platform_v1';

/// Re-registers a cached FCM/device token after login (`plan-22`).
Future<void> bootstrapPushTokenRegistration(WidgetRef ref) async {
  if (kIsWeb) return;
  final auth = ref.read(authSessionProvider);
  final token = auth.accessToken;
  if (!auth.hasApiSession || token == null) return;

  final prefs = ref.read(sharedPreferencesProvider);
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
