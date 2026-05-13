import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'backup_merge_result.dart';

/// Web / non-IO: backup uses Isar (not available).
class BackupPlatformActions {
  static Future<bool> exportWithSaveDialog(WidgetRef ref) async => false;

  static Future<BackupMergeResult?> restoreWithPickDialog(WidgetRef ref) async =>
      null;
}
