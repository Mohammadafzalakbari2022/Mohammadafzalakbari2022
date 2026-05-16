import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pride_v3/core/defaults/effective_shop_profile.dart';

/// Shop logo from upload or bundled default thumbnail.
class ShopLogoImage extends StatelessWidget {
  const ShopLogoImage({
    super.key,
    this.logoRelativePath,
    this.size = 48,
    this.borderRadius = 12,
  });

  final String? logoRelativePath;
  final double size;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final path = logoRelativePath?.trim();
    if (kIsWeb || path == null || path.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.asset(
          kDefaultShopLogoAsset,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _placeholder(context),
        ),
      );
    }

    return FutureBuilder<File?>(
      future: _resolveLogoFile(path),
      builder: (context, snap) {
        final file = snap.data;
        if (file != null) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: Image.file(
              file,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _assetFallback(),
            ),
          );
        }
        return _assetFallback();
      },
    );
  }

  Widget _assetFallback() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.asset(
        kDefaultShopLogoAsset,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            SizedBox(width: size, height: size),
      ),
    );
  }

  Widget _placeholder(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Icon(Icons.store, size: size * 0.5),
    );
  }

  static Future<File?> _resolveLogoFile(String relativePath) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final segments = relativePath.split('/');
      final file = File(
        '${dir.path}${Platform.pathSeparator}${segments.join(Platform.pathSeparator)}',
      );
      if (await file.exists()) return file;
    } on Object {
      // ignore
    }
    return null;
  }
}
