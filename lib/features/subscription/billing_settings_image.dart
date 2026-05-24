import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

const billingSettingsImageMaxBytes = 1048576;

/// Decodes [settings_image_base64] from billing API JSON.
Uint8List? decodeBillingSettingsImageBytes(Map<String, dynamic>? billing) {
  if (billing == null || billing['has_settings_image'] != true) return null;
  final raw = billing['settings_image_base64'];
  if (raw is! String || raw.isEmpty) return null;
  try {
    return base64Decode(raw);
  } catch (_) {
    return null;
  }
}

/// Full-width subscription billing poster (no captions).
class BillingSettingsImageView extends StatelessWidget {
  const BillingSettingsImageView({
    super.key,
    required this.imageBytes,
  });

  final Uint8List imageBytes;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.memory(
        imageBytes,
        fit: BoxFit.fitWidth,
        width: double.infinity,
        gaplessPlayback: true,
        filterQuality: FilterQuality.medium,
      ),
    );
  }
}
