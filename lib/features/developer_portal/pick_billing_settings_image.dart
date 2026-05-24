import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../subscription/billing_settings_image.dart';

/// Picks a billing settings image (≤ 1 MB) from the gallery.
Future<({Uint8List bytes, String mimeType})?> pickBillingSettingsImage() async {
  final picker = ImagePicker();
  final picked = await picker.pickImage(
    source: ImageSource.gallery,
    maxWidth: 1080,
    imageQuality: 88,
  );
  if (picked == null) return null;

  final bytes = await picked.readAsBytes();
  if (bytes.isEmpty) return null;

  final mime = _mimeFromName(picked.name);
  if (bytes.length <= billingSettingsImageMaxBytes) {
    return (bytes: bytes, mimeType: mime);
  }

  if (kDebugMode) {
    debugPrint(
      'Billing settings image ${bytes.length} bytes exceeds '
      '$billingSettingsImageMaxBytes; pick a smaller file.',
    );
  }
  return null;
}

String _mimeFromName(String name) {
  final lower = name.toLowerCase();
  if (lower.endsWith('.webp')) return 'image/webp';
  if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) return 'image/jpeg';
  return 'image/png';
}
