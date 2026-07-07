import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/core/crash/pride_error_collector.dart';

void main() {
  test('PrideErrorCollector records and formats entries', () async {
    PrideErrorCollector.installEarlyHooks();
    await PrideErrorCollector.record(
      StateError('test failure'),
      source: 'test',
      fatal: true,
    );

    final snap = PrideErrorCollector.snapshot();
    expect(snap, isNotEmpty);
    expect(snap.last['message'], contains('test failure'));
    expect(PrideErrorCollector.formatEntry(snap.last), contains('StateError'));
  });
}
