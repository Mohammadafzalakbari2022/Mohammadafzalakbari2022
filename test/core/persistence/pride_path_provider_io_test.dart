import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/core/persistence/pride_path_provider_io.dart';

void main() {
  test('detects path_provider pigeon channel-not-ready errors', () {
    final error = PlatformException(
      code: 'channel-error',
      message:
          'Unable to establish connection on channel: '
          '"dev.flutter.pigeon.path_provider_android.PathProviderApi.getApplicationDocumentsPath".',
    );
    expect(isPathProviderChannelNotReady(error), isTrue);
  });
}
