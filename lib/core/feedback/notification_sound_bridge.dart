import 'platform_ui_sound.dart';

/// Lets data-layer code play notification sounds without [WidgetRef].
///
/// Updated from [main.dart] and settings toggles.
class NotificationSoundBridge {
  NotificationSoundBridge._();

  static bool uiSoundsEnabled = true;
  static bool notificationsMuted = false;

  static DateTime? _lastPlayedAt;

  static void configure({
    required bool soundsEnabled,
    required bool muted,
  }) {
    uiSoundsEnabled = soundsEnabled;
    notificationsMuted = muted;
  }

  /// Debounced info tone when a new notification is stored.
  static Future<void> onNotificationInserted() async {
    if (!uiSoundsEnabled || notificationsMuted) return;
    final now = DateTime.now();
    if (_lastPlayedAt != null &&
        now.difference(_lastPlayedAt!) < const Duration(seconds: 2)) {
      return;
    }
    _lastPlayedAt = now;
    await playPlatformUiSound('info');
  }
}
