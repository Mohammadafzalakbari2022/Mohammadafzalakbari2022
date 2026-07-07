import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:pride_v3/core/persistence/pride_path_provider_io.dart';

/// Clears non-essential on-device caches (temp PDFs, image memory cache).
abstract final class AppCacheManager {
  /// Run on sign-out and optionally after large operations.
  static Future<void> clearNonEssentialCaches() async {
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
    if (kIsWeb) return;
    await _clearTempInvoicePdfs();
  }

  /// Trim temp invoice PDFs older than [maxAge].
  static Future<void> trimTempFiles({
    Duration maxAge = const Duration(days: 3),
  }) async {
    if (kIsWeb) return;
    try {
      final dir = await prideTemporaryDirectory();
      final cutoff = DateTime.now().subtract(maxAge);
      await for (final entity in dir.list()) {
        if (entity is! File) continue;
        final name = entity.path.split(Platform.pathSeparator).last;
        if (!name.startsWith('invoice_') || !name.endsWith('.pdf')) continue;
        final stat = await entity.stat();
        if (stat.modified.isBefore(cutoff)) {
          await entity.delete();
        }
      }
    } on Object {
      // Best-effort cleanup.
    }
  }

  static Future<void> _clearTempInvoicePdfs() async {
    try {
      final dir = await prideTemporaryDirectory();
      await for (final entity in dir.list()) {
        if (entity is! File) continue;
        final name = entity.path.split(Platform.pathSeparator).last;
        if (name.startsWith('invoice_') && name.endsWith('.pdf')) {
          await entity.delete();
        }
      }
    } on Object {
      // Ignore.
    }
  }
}
