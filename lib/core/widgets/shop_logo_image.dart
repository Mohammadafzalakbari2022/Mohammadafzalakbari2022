import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pride_v3/core/persistence/pride_path_provider_io.dart';
import 'package:pride_v3/core/defaults/effective_shop_profile.dart';

/// How the logo is framed in the UI.
enum ShopLogoPresentation {
  /// Settings and standalone rows — bordered square frame.
  standalone,

  /// On banner gradient or uploaded image — no visible background.
  onBanner,
}

/// Shop logo from upload or bundled app icon.
class ShopLogoImage extends StatelessWidget {
  const ShopLogoImage({
    super.key,
    this.logoRelativePath,
    this.size = 48,
    this.borderRadius = 8,
    this.presentation = ShopLogoPresentation.standalone,
  });

  final String? logoRelativePath;
  final double size;
  final double borderRadius;
  final ShopLogoPresentation presentation;

  @override
  Widget build(BuildContext context) {
    final path = logoRelativePath?.trim();
    if (kIsWeb || path == null || path.isEmpty) {
      return _framed(context, _defaultAssetImage(context));
    }

    return FutureBuilder<File?>(
      future: _resolveLogoFile(path),
      builder: (context, snap) {
        final file = snap.data;
        if (file != null) {
          return _framed(
            context,
            Image.file(
              file,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  _defaultAssetImage(context),
            ),
          );
        }
        if (snap.connectionState == ConnectionState.waiting) {
          return _framed(
            context,
            const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }
        return _framed(context, _defaultAssetImage(context));
      },
    );
  }

  Widget _framed(BuildContext context, Widget child) {
    if (presentation == ShopLogoPresentation.onBanner) {
      return SizedBox(
        width: size,
        height: size,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: child,
        ),
      );
    }

    final scheme = Theme.of(context).colorScheme;
    final inset = (size * 0.08).clamp(2.0, 6.0);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: scheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.all(inset),
        child: child,
      ),
    );
  }

  Widget _defaultAssetImage(BuildContext context) {
    return Image.asset(
      kDefaultShopLogoAsset,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => Icon(
        Icons.store,
        size: size * 0.45,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }

  static Future<File?> _resolveLogoFile(String relativePath) async {
    try {
      final dir = await prideApplicationDocumentsDirectory();
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
