import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/auth/auth_providers.dart';
import 'package:pride_v3/core/api/pride_api_config.dart';
import 'package:pride_v3/core/api/pride_api_support.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../core/persistence/api_offline_cache_storage.dart';
import '../../core/persistence/shared_preferences_provider.dart';
import '../../shell/shell_sync_providers.dart';
import 'developer_portal_screen.dart';

class DeveloperPortalSupportTab extends ConsumerStatefulWidget {
  const DeveloperPortalSupportTab({super.key, required this.l10n});

  final AppLocalizations l10n;

  @override
  ConsumerState<DeveloperPortalSupportTab> createState() =>
      _DeveloperPortalSupportTabState();
}

class _DeveloperPortalSupportTabState
    extends ConsumerState<DeveloperPortalSupportTab> {
  bool _loading = true;
  bool _saving = false;
  String? _error;
  bool _published = false;
  bool _showingOfflineCache = false;

  final _nameCtrl = TextEditingController();
  final _titleCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _whatsCtrl = TextEditingController();
  final _videoCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _titleCtrl.dispose();
    _bioCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _whatsCtrl.dispose();
    _videoCtrl.dispose();
    super.dispose();
  }

  String? _token() => ref.read(authSessionProvider).accessToken;

  void _applySupport(Map<String, dynamic> d) {
    _published = d['is_published'] == true;
    _nameCtrl.text = (d['developer_name'] as String?)?.trim() ?? '';
    _titleCtrl.text = (d['developer_title'] as String?)?.trim() ?? '';
    _bioCtrl.text = (d['developer_bio'] as String?)?.trim() ?? '';
    _emailCtrl.text = (d['support_email'] as String?)?.trim() ?? '';
    _phoneCtrl.text = (d['support_phone'] as String?)?.trim() ?? '';
    _whatsCtrl.text = (d['support_whatsapp'] as String?)?.trim() ?? '';
    _videoCtrl.text = (d['help_video_url'] as String?)?.trim() ?? '';
  }

  Future<void> _load() async {
    if (!PrideApiConfig.isConfigured) {
      setState(() {
        _loading = false;
        _error = widget.l10n.devPortalStubAction;
        _showingOfflineCache = false;
      });
      return;
    }

    final online = ref.read(connectivityOnlineProvider);
    final prefs = ref.read(sharedPreferencesProvider);
    final cached = ApiOfflineCacheStorage.readAdminSupport(prefs);
    if (cached != null) {
      _applySupport(cached);
      setState(() {
        _loading = false;
        _error = null;
        _showingOfflineCache = !online;
      });
    }

    if (!online) {
      if (cached == null && mounted) {
        setState(() {
          _loading = false;
          _error = widget.l10n.devPortalAdviceOfflineBody;
          _showingOfflineCache = false;
        });
      }
      return;
    }

    final token = _token();
    if (token == null) {
      setState(() {
        _loading = false;
        _error = widget.l10n.devPortalAdminAuditNeedSignIn;
        _showingOfflineCache = cached != null;
      });
      return;
    }

    if (cached == null) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }

    final r = await getPrideApiAdminSupportInfo(accessToken: token);
    if (!mounted) return;
    if (r.ok && r.data != null) {
      _applySupport(r.data!);
      await ApiOfflineCacheStorage.saveAdminSupport(prefs, r.data!);
      if (!mounted) return;
      setState(() {
        _loading = false;
        _showingOfflineCache = false;
      });
    } else {
      setState(() {
        _loading = false;
        _error = widget.l10n.devPortalSupportLoadError(r.error ?? '');
        _showingOfflineCache = cached != null;
      });
    }
  }

  Future<void> _save() async {
    final token = _token();
    if (token == null) return;
    setState(() => _saving = true);
    final body = <String, dynamic>{
      'is_published': _published,
      'developer_name': _nameCtrl.text.trim(),
      'developer_title': _titleCtrl.text.trim(),
      'developer_bio': _bioCtrl.text.trim(),
      'support_email': _emailCtrl.text.trim(),
      'support_phone': _phoneCtrl.text.trim(),
      'support_whatsapp': _whatsCtrl.text.trim(),
      'help_video_url': _videoCtrl.text.trim(),
    };

    final r = await postPrideApiAdminSupportInfo(accessToken: token, body: body);
    if (!mounted) return;
    setState(() => _saving = false);
    if (r.ok && r.data != null) {
      _applySupport(r.data!);
      final prefs = ref.read(sharedPreferencesProvider);
      await ApiOfflineCacheStorage.saveAdminSupport(prefs, r.data!);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.l10n.devPortalSupportSaveSuccess)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.l10n.devPortalSupportSaveError(r.error ?? '')),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(_error!),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (_showingOfflineCache) DevPortalOfflineCacheBanner(l10n: widget.l10n),
        Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              SwitchListTile(
                title: Text(widget.l10n.devPortalSupportPublishTitle),
                subtitle: Text(widget.l10n.devPortalSupportPublishSubtitle),
                value: _published,
                onChanged: _saving ? null : (v) => setState(() => _published = v),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _nameCtrl,
                      decoration: InputDecoration(
                        labelText: widget.l10n.devPortalSupportDeveloperName,
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _titleCtrl,
                      decoration: InputDecoration(
                        labelText: widget.l10n.devPortalSupportDeveloperTitle,
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _bioCtrl,
                      decoration: InputDecoration(
                        labelText: widget.l10n.devPortalSupportDeveloperBio,
                      ),
                      minLines: 2,
                      maxLines: 4,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _emailCtrl,
                      decoration: InputDecoration(
                        labelText: widget.l10n.devPortalSupportEmail,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _phoneCtrl,
                      decoration: InputDecoration(
                        labelText: widget.l10n.devPortalSupportPhone,
                      ),
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _whatsCtrl,
                      decoration: InputDecoration(
                        labelText: widget.l10n.devPortalSupportWhatsapp,
                      ),
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _videoCtrl,
                      decoration: InputDecoration(
                        labelText: widget.l10n.devPortalSupportHelpVideoUrl,
                        hintText: 'https://youtube.com/…',
                      ),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _saving ? null : _save,
                        icon: _saving
                            ? const SizedBox.square(
                                dimension: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.save_outlined),
                        label: Text(widget.l10n.saveCta),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

