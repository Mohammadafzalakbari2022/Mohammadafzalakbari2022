import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../local/dev_shop_constants.dart';
import '../providers/local_data_providers_io.dart';
import 'backup_merge_result.dart';
import 'isar_backup_v1.dart';

class BackupPlatformActions {
  static Future<bool> exportWithSaveDialog(WidgetRef ref) async {
    final isar = await ref.read(isarProvider.future);
    final doc = await IsarBackupV1.buildDocument(isar, kDevShopId);
    final json = IsarBackupV1.encodePretty(doc);
    final stamp = DateTime.now().toUtc().toIso8601String().replaceAll(':', '-');
    final safeStamp = stamp.split('.').first;
    final name = 'pride_backup_v3_$safeStamp.json';
    final path = await FilePicker.saveFile(
      dialogTitle: 'Save backup',
      fileName: name,
      type: FileType.custom,
      allowedExtensions: const ['json'],
    );
    if (path == null) return false;
    final target = path.toLowerCase().endsWith('.json') ? path : '$path.json';
    await File(target).writeAsString(json);
    return true;
  }

  static Future<BackupMergeResult?> restoreWithPickDialog(WidgetRef ref) async {
    final pick = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['json'],
      withData: true,
    );
    if (pick == null || pick.files.isEmpty) return null;
    final file = pick.files.single;
    final bytes = file.bytes;
    if (bytes == null || bytes.isEmpty) return null;
    final map = IsarBackupV1.decodeObject(utf8.decode(bytes));
    final isar = await ref.read(isarProvider.future);
    return IsarBackupV1.importMerge(isar, map);
  }
}
