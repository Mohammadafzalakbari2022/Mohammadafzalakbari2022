import 'package:shared_preferences/shared_preferences.dart';

abstract final class ThermalPrinterPrefs {
  static const hostKey = 'thermal_printer.host';
  static const portKey = 'thermal_printer.port';
  static const paperKey = 'thermal_printer.paper_mm';

  static const defaultPort = 9100;
  static const paper58 = '58';
  static const paper80 = '80';

  static String readHost(SharedPreferences prefs) =>
      prefs.getString(hostKey)?.trim() ?? '';

  static int readPort(SharedPreferences prefs) =>
      prefs.getInt(portKey) ?? defaultPort;

  /// `58` or `80` (millimetre roll width).
  static String readPaperMm(SharedPreferences prefs) {
    final v = prefs.getString(paperKey);
    return v == paper80 ? paper80 : paper58;
  }

  static Future<void> write(
    SharedPreferences prefs, {
    required String host,
    required int port,
    required String paperMm,
  }) async {
    await prefs.setString(hostKey, host.trim());
    await prefs.setInt(portKey, port);
    await prefs.setString(
      paperKey,
      paperMm == paper80 ? paper80 : paper58,
    );
  }
}
