import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pride_native_android_preferences_store.dart';

/// Obtains [SharedPreferences] after platform channels are ready.
///
/// Tries the pigeon plugin first; on persistent `channel-error`, falls back to
/// [PrideNativeAndroidPreferencesStore] (direct Android SharedPreferences).
Future<SharedPreferences> obtainSharedPreferences({
  Duration initialDelay = const Duration(milliseconds: 120),
  int maxAttempts = 12,
}) async {
  await waitForPlatformChannelsReady();
  if (initialDelay > Duration.zero) {
    await Future<void>.delayed(initialDelay);
  }

  Object? lastError;
  for (var attempt = 0; attempt < maxAttempts; attempt++) {
    try {
      _resetSharedPreferencesSingleton();
      return await SharedPreferences.getInstance();
    } on PlatformException catch (e) {
      lastError = e;
      if (!_isSharedPreferencesChannelNotReady(e)) {
        rethrow;
      }
      await Future<void>.delayed(
        Duration(milliseconds: 80 * (attempt + 1)),
      );
    }
  }

  // Pigeon never connected — use native MethodChannel store (release APK fix).
  try {
    _resetSharedPreferencesSingleton();
    PrideNativeAndroidPreferencesStore.install();
    return await SharedPreferences.getInstance();
  } on Object catch (fallbackError, fallbackStack) {
    if (lastError != null) {
      Error.throwWithStackTrace(lastError!, StackTrace.current);
    }
    Error.throwWithStackTrace(fallbackError, fallbackStack);
  }
}

/// Yields until the first Flutter frame has been requested (plugins registered).
Future<void> waitForPlatformChannelsReady() async {
  final binding = WidgetsBinding.instance;
  if (binding is! WidgetsFlutterBinding) {
    await Future<void>.delayed(const Duration(milliseconds: 80));
    return;
  }

  for (var frame = 0; frame < 2; frame++) {
    final done = Completer<void>();
    binding.addPostFrameCallback((_) {
      if (!done.isCompleted) done.complete();
    });
    await Future<void>.delayed(Duration.zero);
    await done.future.timeout(
      const Duration(seconds: 3),
      onTimeout: () {},
    );
    await Future<void>.delayed(const Duration(milliseconds: 50));
  }
}

void _resetSharedPreferencesSingleton() {
  // Package-private reset so a failed getInstance() attempt can retry.
  // ignore: invalid_use_of_visible_for_testing_member
  SharedPreferences.resetStatic();
}

@visibleForTesting
bool isSharedPreferencesChannelNotReady(PlatformException error) =>
    _isSharedPreferencesChannelNotReady(error);

bool _isSharedPreferencesChannelNotReady(PlatformException error) {
  if (error.code == 'channel-error') return true;
  final message = error.message ?? '';
  return message.contains('Unable to establish connection on channel') &&
      message.contains('SharedPreferencesApi');
}
