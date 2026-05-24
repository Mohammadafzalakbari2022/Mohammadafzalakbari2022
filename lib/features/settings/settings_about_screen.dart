import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pride_v3/auth/auth_providers.dart';
import 'package:pride_v3/core/api/pride_api_config.dart';
import 'package:pride_v3/core/api/pride_api_support.dart';
import 'package:pride_v3/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import 'support_info_cache.dart';

class SettingsAboutScreen extends ConsumerStatefulWidget {
  const SettingsAboutScreen({super.key});

  @override
  ConsumerState<SettingsAboutScreen> createState() => _SettingsAboutScreenState();
}

class _SettingsAboutScreenState extends ConsumerState<SettingsAboutScreen> {
  PackageInfo? _info;
  Map<String, dynamic>? _support;
  DateTime? _supportCachedAt;
  bool _loadingSupport = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final info = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() => _info = info);
    await _loadSupport();
  }

  Future<void> _loadSupport() async {
    final cached = await readCachedSupportInfo();
    if (mounted && cached.data != null) {
      setState(() {
        _support = cached.data;
        _supportCachedAt = cached.fetchedAt;
        _loadingSupport = false;
      });
    }
    await _refreshSupport();
  }

  Future<void> _refreshSupport() async {
    if (!PrideApiConfig.isConfigured) {
      setState(() => _loadingSupport = false);
      return;
    }
    final token = ref.read(authSessionProvider).accessToken;
    if (token == null) {
      setState(() => _loadingSupport = false);
      return;
    }
    final r = await fetchPrideApiLicenseSupportInfo(accessToken: token);
    if (!mounted) return;
    setState(() => _loadingSupport = false);
    if (r.ok && r.data != null) {
      await cacheSupportInfo(r.data!);
      if (!mounted) return;
      setState(() {
        _support = r.data;
        _supportCachedAt = DateTime.now();
      });
    }
  }

  Future<void> _openExternal(BuildContext context, String url) async {
    final uri = Uri.tryParse(url.trim());
    if (uri == null) return;
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!context.mounted) return;
    if (!ok) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.supportOpenLinkFailed)),
      );
    }
  }

  String? _waMeLink(String raw) {
    final digits = raw.replaceAll(RegExp(r'[^0-9+]'), '').replaceAll('+', '');
    if (digits.isEmpty) return null;
    // Try to convert Afghanistan local mobile numbers like 07xxxxxxxx to 93xxxxxxxxx.
    final normalized = (digits.startsWith('0') && digits.length == 10)
        ? '93${digits.substring(1)}'
        : digits;
    return 'https://wa.me/$normalized';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final info = _info;
    final support = _support;
    final cachedAt = _supportCachedAt;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsAboutTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.apps_outlined),
                  title: Text(l10n.appTitle),
                  subtitle: Text(l10n.settingsAboutSubtitle),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.tag_outlined),
                  title: Text(l10n.settingsVersionTitle),
                  subtitle: Text(
                    info == null
                        ? l10n.loading
                        : '${info.version}+${info.buildNumber}',
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text(l10n.settingsBuildTitle),
                  subtitle: Text(info?.packageName ?? l10n.loading),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.support_agent_outlined),
                  title: Text(l10n.supportSectionTitle),
                  subtitle: Text(
                    cachedAt == null
                        ? l10n.supportSectionSubtitle
                        : l10n.supportSectionSubtitleCached(
                            cachedAt.toLocal().toString(),
                          ),
                  ),
                ),
                const Divider(height: 1),
                if (_loadingSupport)
                  ListTile(
                    leading: const Icon(Icons.downloading_outlined),
                    title: Text(l10n.loading),
                  )
                else if (support == null ||
                    support['is_published'] != true ||
                    (support['developer_name'] == null &&
                        support['support_email'] == null &&
                        support['support_phone'] == null &&
                        support['support_whatsapp'] == null &&
                        support['help_video_url'] == null))
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: Text(l10n.supportNotAvailableTitle),
                    subtitle: Text(l10n.supportNotAvailableBody),
                  )
                else ...[
                  if ((support['help_video_url'] as String?)?.trim().isNotEmpty ==
                      true)
                    ListTile(
                      leading: const Icon(Icons.ondemand_video_outlined),
                      title: Text(l10n.supportHowToVideoTitle),
                      subtitle: Text(
                        (support['help_video_url'] as String).trim(),
                      ),
                      onTap: () => _openExternal(
                        context,
                        (support['help_video_url'] as String).trim(),
                      ),
                    ),
                  if ((support['help_video_url'] as String?)?.trim().isNotEmpty ==
                      true)
                    const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: Text((support['developer_name'] as String?)?.trim().isNotEmpty ==
                            true
                        ? (support['developer_name'] as String).trim()
                        : l10n.supportDeveloperFallback),
                    subtitle: Text(
                      [
                        (support['developer_title'] as String?)?.trim(),
                        (support['developer_bio'] as String?)?.trim(),
                      ]
                          .whereType<String>()
                          .map((e) => e.trim())
                          .where((e) => e.isNotEmpty)
                          .join('\n'),
                    ),
                  ),
                  const Divider(height: 1),
                  if ((support['support_email'] as String?)?.trim().isNotEmpty ==
                      true)
                    ListTile(
                      leading: const Icon(Icons.email_outlined),
                      title: Text(l10n.supportEmailTitle),
                      subtitle:
                          Text((support['support_email'] as String).trim()),
                      onTap: () => _openExternal(
                        context,
                        'mailto:${(support['support_email'] as String).trim()}',
                      ),
                    ),
                  if ((support['support_phone'] as String?)?.trim().isNotEmpty ==
                      true)
                    ListTile(
                      leading: const Icon(Icons.call_outlined),
                      title: Text(l10n.supportPhoneTitle),
                      subtitle:
                          Text((support['support_phone'] as String).trim()),
                      onTap: () => _openExternal(
                        context,
                        'tel:${(support['support_phone'] as String).trim()}',
                      ),
                    ),
                  if ((support['support_whatsapp'] as String?)?.trim().isNotEmpty ==
                      true)
                    ListTile(
                      leading: const Icon(Icons.chat_outlined),
                      title: Text(l10n.supportWhatsappTitle),
                      subtitle: Text(
                        (support['support_whatsapp'] as String).trim(),
                      ),
                      onTap: () {
                        final link = _waMeLink(
                          (support['support_whatsapp'] as String).trim(),
                        );
                        if (link != null) _openExternal(context, link);
                      },
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

