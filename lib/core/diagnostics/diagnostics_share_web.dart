import 'package:share_plus/share_plus.dart';

Future<void> shareDiagnosticsBundle(String json, String filename) async {
  await Share.share(
    json,
    subject: filename,
  );
}
