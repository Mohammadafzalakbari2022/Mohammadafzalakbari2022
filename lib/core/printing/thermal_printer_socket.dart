import 'thermal_printer_socket_stub.dart'
    if (dart.library.io) 'thermal_printer_socket_io.dart' as impl;

Future<void> sendThermalReceiptBytes({
  required String host,
  required int port,
  required List<int> bytes,
  Duration timeout = const Duration(seconds: 10),
  int maxAttempts = 3,
}) =>
    impl.sendThermalReceiptBytes(
      host: host,
      port: port,
      bytes: bytes,
      timeout: timeout,
      maxAttempts: maxAttempts,
    );
