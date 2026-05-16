import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'phone_whatsapp.dart';

const _channel = MethodChannel('com.pridev3.pride_v3/whatsapp_share');

/// Android: opens WhatsApp with PDF attached to [phoneDigits] when installed.
Future<bool> shareInvoicePdfToWhatsApp({
  required String filePath,
  required String phoneDigits,
  String? caption,
}) async {
  if (kIsWeb || !Platform.isAndroid) return false;
  final normalized = normalizePhoneForWhatsApp(phoneDigits);
  if (normalized == null) return false;

  try {
    final ok = await _channel.invokeMethod<bool>('sharePdf', {
      'path': filePath,
      'phone': normalized,
      'caption': caption ?? '',
    });
    return ok == true;
  } on PlatformException {
    return false;
  }
}
