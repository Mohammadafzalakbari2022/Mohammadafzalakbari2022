import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<void> shareDiagnosticsBundle(String json, String filename) async {
  final dir = await getTemporaryDirectory();
  final path = '${dir.path}/$filename';
  final file = File(path);
  await file.writeAsString(json, flush: true);
  await Share.shareXFiles(
    [XFile(path, mimeType: 'application/json', name: filename)],
    subject: filename,
  );
}
