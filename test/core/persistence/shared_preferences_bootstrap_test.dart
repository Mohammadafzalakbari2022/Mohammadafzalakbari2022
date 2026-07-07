import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/core/persistence/shared_preferences_bootstrap.dart';

void main() {
  test('detects shared_preferences pigeon channel-not-ready errors', () {
    final error = PlatformException(
      code: 'channel-error',
      message:
          'Unable to establish connection on channel: '
          '"dev.flutter.pigeon.shared_preferences_android.SharedPreferencesApi.getAll".',
    );
    expect(isSharedPreferencesChannelNotReady(error), isTrue);
  });
}
