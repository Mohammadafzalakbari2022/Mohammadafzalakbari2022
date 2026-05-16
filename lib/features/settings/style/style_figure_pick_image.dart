import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import 'style_figure_storage.dart';

/// Gallery or camera pick for a style figure image (native only).
Future<String?> pickStyleFigureImageRef(BuildContext context) async {
  final l10n = AppLocalizations.of(context)!;
  final source = await showModalBottomSheet<ImageSource>(
    context: context,
    showDragHandle: true,
    builder: (ctx) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(l10n.galleryCta),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(l10n.cameraCta),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
          ],
        ),
      );
    },
  );
  if (source == null) return null;
  return pickStyleFigureRelativePath(source: source);
}
