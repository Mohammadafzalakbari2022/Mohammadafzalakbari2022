import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'pride_native_android_paths.dart';
import 'shared_preferences_bootstrap.dart';

Directory? _cachedDocumentsDir;
Directory? _cachedTempDir;

/// Resolves app documents dir after platform channels are ready (Android release fix).
Future<Directory> prideApplicationDocumentsDirectory() async {
  final cached = _cachedDocumentsDir;
  if (cached != null) return cached;

  await waitForPlatformChannelsReady();
  Object? lastError;
  for (var attempt = 0; attempt < 12; attempt++) {
    try {
      final dir = await getApplicationDocumentsDirectory();
      _cachedDocumentsDir = dir;
      return dir;
    } on PlatformException catch (e) {
      lastError = e;
      if (!isPathProviderChannelNotReady(e)) rethrow;
      await Future<void>.delayed(Duration(milliseconds: 80 * (attempt + 1)));
    }
  }

  if (!kIsWeb && Platform.isAndroid) {
    try {
      final path = await PrideNativeAndroidPaths.getApplicationDocumentsPath();
      final dir = Directory(path);
      _cachedDocumentsDir = dir;
      return dir;
    } on Object catch (fallbackError, fallbackStack) {
      final err = lastError;
      if (err != null) {
        Error.throwWithStackTrace(err, StackTrace.current);
      }
      Error.throwWithStackTrace(fallbackError, fallbackStack);
    }
  }

  final err = lastError;
  if (err != null) {
    Error.throwWithStackTrace(err, StackTrace.current);
  }
  throw StateError('Could not resolve application documents directory');
}

/// Resolves temp/cache dir after platform channels are ready (Android release fix).
Future<Directory> prideTemporaryDirectory() async {
  final cached = _cachedTempDir;
  if (cached != null) return cached;

  await waitForPlatformChannelsReady();
  Object? lastError;
  for (var attempt = 0; attempt < 12; attempt++) {
    try {
      final dir = await getTemporaryDirectory();
      _cachedTempDir = dir;
      return dir;
    } on PlatformException catch (e) {
      lastError = e;
      if (!isPathProviderChannelNotReady(e)) rethrow;
      await Future<void>.delayed(Duration(milliseconds: 80 * (attempt + 1)));
    }
  }

  if (!kIsWeb && Platform.isAndroid) {
    try {
      final path = await PrideNativeAndroidPaths.getTemporaryPath();
      final dir = Directory(path);
      _cachedTempDir = dir;
      return dir;
    } on Object catch (fallbackError, fallbackStack) {
      final err = lastError;
      if (err != null) {
        Error.throwWithStackTrace(err, StackTrace.current);
      }
      Error.throwWithStackTrace(fallbackError, fallbackStack);
    }
  }

  final err = lastError;
  if (err != null) {
    Error.throwWithStackTrace(err, StackTrace.current);
  }
  throw StateError('Could not resolve temporary directory');
}

@visibleForTesting
bool isPathProviderChannelNotReady(PlatformException error) {
  if (error.code == 'channel-error') return true;
  final message = error.message ?? '';
  return message.contains('Unable to establish connection on channel') &&
      (message.contains('PathProviderApi') ||
          message.contains('path_provider_android'));
}
