import 'dart:io';

import 'package:pride_v3/core/persistence/pride_path_provider_io.dart';
import 'package:share_plus/share_plus.dart';

Future<void> shareDiagnosticsBundle(String json, String filename) async {
  final dir = await prideTemporaryDirectory();
  final path = '${dir.path}/$filename';
  final file = File(path);
  await file.writeAsString(json, flush: true);
  await Share.shareXFiles(
    [XFile(path, mimeType: 'application/json', name: filename)],
    subject: filename,
  );
}
