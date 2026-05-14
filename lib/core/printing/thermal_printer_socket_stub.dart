Future<void> sendThermalReceiptBytes({
  required String host,
  required int port,
  required List<int> bytes,
  Duration timeout = const Duration(seconds: 10),
}) async {
  throw UnsupportedError(
    'Network thermal printing is not available on this platform.',
  );
}
