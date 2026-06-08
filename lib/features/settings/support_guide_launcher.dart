import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:pride_v3/l10n/app_localizations.dart';

import 'support_info_cache.dart';

/// Reads cached support info and returns help video URL when published.
Future<String?> readPublishedHelpVideoUrl() async {
  final cached = await readCachedSupportInfo();
  final support = cached.data;
  if (support == null) return null;
  if (support['is_published'] != true) return null;
  final url = (support['help_video_url'] as String?)?.trim();
  if (url == null || url.isEmpty) return null;
  return url;
}

Future<void> openSupportGuideVideo(BuildContext context) async {
  final url = await readPublishedHelpVideoUrl();
  if (!context.mounted || url == null) return;
  final uri = Uri.tryParse(url);
  if (uri == null) return;
  final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!context.mounted || ok) return;
  final l10n = AppLocalizations.of(context)!;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(l10n.supportOpenLinkFailed)),
  );
}
