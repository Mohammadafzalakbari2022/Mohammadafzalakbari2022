import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

const _channel = MethodChannel('com.pridev3.pride_v3/ui_feedback');

/// Audible UI feedback on Android (notification stream tones). Falls back to [SystemSound] elsewhere.
Future<void> playPlatformUiSound(String kind, {bool deleted = false}) async {
  if (kIsWeb) {
    _playSystemSound(kind, deleted: deleted);
    return;
  }
  if (Platform.isAndroid) {
    try {
      await _channel.invokeMethod<void>('playUiSound', {
        'kind': kind,
        'deleted': deleted,
      });
      return;
    } catch (_) {
      // Fall through to system sounds.
    }
  }
  _playSystemSound(kind, deleted: deleted);
}

void _playSystemSound(String kind, {bool deleted = false}) {
  if (deleted) {
    SystemSound.play(SystemSoundType.alert);
    return;
  }
  switch (kind) {
    case 'error':
      SystemSound.play(SystemSoundType.alert);
    case 'success':
    case 'info':
    default:
      SystemSound.play(SystemSoundType.click);
  }
}
