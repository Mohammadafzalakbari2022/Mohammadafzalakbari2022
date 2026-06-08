import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// Resolves a shop banner file from app-documents relative path.
Future<File?> resolveShopBannerFile(String? relativePath) async {
  if (kIsWeb) return null;
  final path = relativePath?.trim();
  if (path == null || path.isEmpty) return null;
  try {
    final dir = await getApplicationDocumentsDirectory();
    final segments = path.split('/');
    final file = File(
      '${dir.path}${Platform.pathSeparator}${segments.join(Platform.pathSeparator)}',
    );
    if (await file.exists()) return file;
  } on Object {
    // Safe fallback handled by callers.
  }
  return null;
}

/// True when an uploaded banner path should be attempted on this platform.
bool shopBannerUploadConfigured(String? bannerRelativePath) {
  if (kIsWeb) return false;
  final path = bannerRelativePath?.trim();
  return path != null && path.isNotEmpty;
}
