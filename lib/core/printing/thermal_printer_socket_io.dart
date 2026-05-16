import 'dart:io';

Future<void> sendThermalReceiptBytes({
  required String host,
  required int port,
  required List<int> bytes,
  Duration timeout = const Duration(seconds: 10),
  int maxAttempts = 3,
}) async {
  Object? lastError;
  final attempts = maxAttempts < 1 ? 1 : maxAttempts;
  for (var i = 0; i < attempts; i++) {
    try {
      final socket = await Socket.connect(host, port, timeout: timeout);
      try {
        socket.add(bytes);
        await socket.flush();
      } finally {
        await socket.close();
      }
      return;
    } catch (e) {
      lastError = e;
      if (i + 1 < attempts) {
        await Future<void>.delayed(Duration(milliseconds: 200 * (i + 1)));
      }
    }
  }
  if (lastError != null) {
    throw lastError;
  }
  throw StateError('thermal print connect failed');
}
