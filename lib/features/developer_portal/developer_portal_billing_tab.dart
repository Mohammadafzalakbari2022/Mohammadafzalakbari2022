import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/auth/auth_providers.dart';
import 'package:pride_v3/core/api/pride_api_billing.dart';
import 'package:pride_v3/core/api/pride_api_config.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../core/persistence/api_offline_cache_storage.dart';
import '../../core/persistence/shared_preferences_provider.dart';
import '../../shell/shell_sync_providers.dart';
import '../subscription/billing_settings_image.dart';
import 'developer_portal_code_share.dart';
import 'developer_portal_screen.dart';
import 'pick_billing_settings_image.dart';

/// Developer portal: settings image + payment claim inbox.
class DeveloperPortalBillingTab extends ConsumerStatefulWidget {
  const DeveloperPortalBillingTab({super.key, required this.l10n});

  final AppLocalizations l10n;

  @override
  ConsumerState<DeveloperPortalBillingTab> createState() =>
      _DeveloperPortalBillingTabState();
}

class _DeveloperPortalBillingTabState
    extends ConsumerState<DeveloperPortalBillingTab> {
  bool _loading = true;
  bool _saving = false;
  String? _error;
  bool _published = false;
  bool _showingOfflineCache = false;

  Uint8List? _imageBytes;
  Uint8List? _pendingImageBytes;
  String? _pendingImageMime;
  bool _removeImage = false;

  String _claimFilter = 'pending';
  List<Map<String, dynamic>> _claims = const [];
  bool _loadingClaims = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  String? _token() => ref.read(authSessionProvider).accessToken;

  void _applyBilling(Map<String, dynamic> d) {
    _published = d['is_published'] == true;
    _imageBytes = decodeBillingSettingsImageBytes(d);
    _pendingImageBytes = null;
    _pendingImageMime = null;
    _removeImage = false;
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
    final cached = ApiOfflineCacheStorage.readAdminBilling(prefs);

    if (cached != null) {
      _applyBilling(cached);
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
      await _loadClaims();
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
    final r = await getPrideApiAdminBillingInfo(accessToken: token);
    if (!mounted) return;
    if (r.ok && r.data != null) {
      _applyBilling(r.data!);
      await ApiOfflineCacheStorage.saveAdminBilling(prefs, r.data!);
      setState(() {
        _loading = false;
        _showingOfflineCache = false;
      });
    } else {
      final err = r.error ?? '';
      if (!err.toLowerCase().contains('billing config missing')) {
        setState(() {
          _loading = false;
          _error = widget.l10n.devPortalBillingLoadError(
            err.isEmpty ? 'HTTP' : err,
          );
          _showingOfflineCache = cached != null;
        });
        return;
      }
      setState(() {
        _loading = false;
        _showingOfflineCache = false;
      });
    }
    await _loadClaims();
  }

  Future<void> _loadClaims() async {
    final token = _token();
    if (token == null) return;
    setState(() => _loadingClaims = true);
    final status = _claimFilter == 'all' ? 'all' : 'pending';
    final r = await getPrideApiAdminPaymentClaims(
      accessToken: token,
      status: status,
    );
    if (!mounted) return;
    setState(() {
      _loadingClaims = false;
      if (r.ok) _claims = r.rows;
    });
  }

  Future<void> _pickImage() async {
    final picked = await pickBillingSettingsImage();
    if (!mounted || picked == null) return;
    if (picked.bytes.length > billingSettingsImageMaxBytes) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.l10n.devPortalBillingSettingsImageTooLarge)),
      );
      return;
    }
    setState(() {
      _pendingImageBytes = picked.bytes;
      _pendingImageMime = picked.mimeType;
      _removeImage = false;
    });
  }

  void _clearPendingImage() {
    setState(() {
      _pendingImageBytes = null;
      _pendingImageMime = null;
      if (_imageBytes != null) {
        _removeImage = true;
        _imageBytes = null;
      } else {
        _removeImage = false;
      }
    });
  }

  Future<void> _save() async {
    final token = _token();
    if (token == null) return;
    setState(() => _saving = true);

    final body = <String, dynamic>{
      'is_published': _published,
    };
    if (_removeImage) {
      body['remove_settings_image'] = true;
    } else if (_pendingImageBytes != null) {
      body['settings_image_base64'] = base64Encode(_pendingImageBytes!);
      body['settings_image_mime_type'] = _pendingImageMime ?? 'image/png';
    }

    final r = await postPrideApiAdminBillingInfo(
      accessToken: token,
      body: body,
    );
    if (!mounted) return;
    setState(() => _saving = false);
    if (r.ok && r.data != null) {
      _applyBilling(r.data!);
      final prefs = ref.read(sharedPreferencesProvider);
      await ApiOfflineCacheStorage.saveAdminBilling(prefs, r.data!);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.l10n.devPortalBillingSaveSuccess)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.l10n.devPortalBillingSaveError(r.error ?? ''),
          ),
        ),
      );
    }
  }

  Uint8List? get _previewBytes => _pendingImageBytes ?? _imageBytes;

  Future<void> _approveClaim(Map<String, dynamic> claim) async {
    final token = _token();
    if (token == null) return;
    final id = '${claim['id']}';
    final r = await postPrideApiAdminApprovePaymentClaim(
      accessToken: token,
      claimId: id,
      autoCreateCode: true,
    );
    if (!mounted) return;
    if (r.ok) {
      final code = r.data?['activation_code'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.l10n.devPortalBillingClaimApproved)),
      );
      if (code != null && '$code'.isNotEmpty) {
        await showDeveloperPortalActivationCodeDialog(
          context,
          widget.l10n,
          code: '$code',
          planDays: 365,
        );
      }
      await _loadClaims();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(r.error ?? 'Error')),
      );
    }
  }

  Future<void> _rejectClaim(Map<String, dynamic> claim) async {
    final token = _token();
    if (token == null) return;
    final notes = await showDialog<String>(
      context: context,
      builder: (ctx) {
        final ctrl = TextEditingController();
        return AlertDialog(
          title: Text(widget.l10n.devPortalBillingClaimReject),
          content: TextField(
            controller: ctrl,
            decoration: InputDecoration(
              labelText: widget.l10n.devPortalBillingClaimRejectNotes,
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, ctrl.text),
              child: Text(widget.l10n.devPortalBillingClaimReject),
            ),
          ],
        );
      },
    );
    if (notes == null) return;
    final r = await postPrideApiAdminRejectPaymentClaim(
      accessToken: token,
      claimId: '${claim['id']}',
      reviewNotes: notes,
    );
    if (!mounted) return;
    if (r.ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.l10n.devPortalBillingClaimRejected)),
      );
      await _loadClaims();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_error != null)
            Card(
              color: Theme.of(context).colorScheme.errorContainer,
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      _error!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: TextButton(
                        onPressed: _load,
                        child: Text(l10n.devPortalRetryCta),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (_showingOfflineCache) DevPortalOfflineCacheBanner(l10n: l10n),
          Text(
            l10n.devPortalBillingSettingsImageTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.devPortalBillingPublished),
            value: _published,
            onChanged: (v) => setState(() => _published = v),
          ),
          const SizedBox(height: 8),
          if (_previewBytes != null)
            BillingSettingsImageView(imageBytes: _previewBytes!),
          if (_previewBytes == null)
            Container(
              height: 120,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
              child: Icon(
                Icons.image_outlined,
                size: 48,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: _saving ? null : _pickImage,
                icon: const Icon(Icons.upload_outlined),
                label: Text(
                  _previewBytes == null
                      ? l10n.devPortalBillingSettingsImagePick
                      : l10n.devPortalBillingSettingsImageReplace,
                ),
              ),
              if (_previewBytes != null)
                OutlinedButton.icon(
                  onPressed: _saving ? null : _clearPendingImage,
                  icon: const Icon(Icons.delete_outline),
                  label: Text(l10n.devPortalBillingSettingsImageRemove),
                ),
            ],
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _saving || _error != null ? null : _save,
            icon: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save_outlined),
            label: Text(l10n.devPortalBillingSave),
          ),
          const Divider(height: 32),
          Text(
            l10n.devPortalBillingClaimsTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SegmentedButton<String>(
            segments: [
              ButtonSegment(
                value: 'pending',
                label: Text(l10n.devPortalBillingClaimsPending),
              ),
              ButtonSegment(
                value: 'all',
                label: Text(l10n.devPortalBillingClaimsAll),
              ),
            ],
            selected: {_claimFilter},
            onSelectionChanged: (s) {
              setState(() => _claimFilter = s.first);
              _loadClaims();
            },
          ),
          const SizedBox(height: 12),
          if (_loadingClaims)
            const Center(child: CircularProgressIndicator())
          else if (_claims.isEmpty)
            Text(l10n.devPortalBillingNoClaims)
          else
            ..._claims.map((c) {
              final status = '${c['status'] ?? ''}';
              final pending = status == 'pending';
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${c['shop_name'] ?? c['shop_id']}',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text('${c['transaction_id']} · ${c['plan_tier']}'),
                      Text('${c['amount_afn']} AFN · $status'),
                      if (c['activation_code'] != null)
                        Text('Code: ${c['activation_code']}'),
                      if (pending) ...[
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: [
                            FilledButton(
                              onPressed: () => _approveClaim(c),
                              child: Text(l10n.devPortalBillingClaimApprove),
                            ),
                            OutlinedButton(
                              onPressed: () => _rejectClaim(c),
                              child: Text(l10n.devPortalBillingClaimReject),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}
