import 'dart:io';

Future<void> sendThermalReceiptBytes({
  required String host,
  required int port,
  required List<int> bytes,
  Duration timeout = const Duration(seconds: 10),
}) async {
  final socket = await Socket.connect(host, port, timeout: timeout);
  try {
    socket.add(bytes);
    await socket.flush();
  } finally {
    await socket.close();
  }
}
