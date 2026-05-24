import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/auth/auth_providers.dart';
import 'package:pride_v3/core/api/pride_api_billing.dart';
import 'package:pride_v3/core/api/pride_api_config.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../shell/shell_sync_providers.dart';
import 'billing_info_cache.dart';
import 'billing_settings_image.dart';

/// Subscription billing poster + owner payment claims (same layout as before).
class SubscriptionBillingPanel extends ConsumerStatefulWidget {
  const SubscriptionBillingPanel({super.key});

  @override
  ConsumerState<SubscriptionBillingPanel> createState() =>
      _SubscriptionBillingPanelState();
}

class _SubscriptionBillingPanelState
    extends ConsumerState<SubscriptionBillingPanel> {
  Map<String, dynamic>? _billing;
  DateTime? _cachedAt;
  String? _billingError;
  bool _loadingBilling = true;

  List<Map<String, dynamic>> _claims = const [];
  bool _loadingClaims = false;

  final _txnCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  String _planTier = 'one_year';
  bool _submittingClaim = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _txnCtrl.dispose();
    _phoneCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  String _localeCode(BuildContext context) {
    final code = Localizations.localeOf(context).languageCode;
    if (code == 'fa' || code == 'ps') return code;
    return 'en';
  }

  Future<void> _load() async {
    final cached = await readCachedBillingInfo();
    if (mounted && cached.data != null) {
      setState(() {
        _billing = cached.data;
        _cachedAt = cached.fetchedAt;
      });
    }
    await _refreshBilling();
    await _loadClaims();
  }

  Future<void> _refreshBilling() async {
    if (!PrideApiConfig.isConfigured) {
      setState(() {
        _loadingBilling = false;
        _billingError = null;
      });
      return;
    }
    final token = ref.read(authSessionProvider).accessToken;
    if (token == null) {
      setState(() => _loadingBilling = false);
      return;
    }
    setState(() {
      _loadingBilling = true;
      _billingError = null;
    });
    final r = await fetchPrideApiLicenseBillingInfo(
      accessToken: token,
      locale: _localeCode(context),
    );
    if (!mounted) return;
    if (r.ok && r.data != null) {
      await cacheBillingInfo(r.data!);
      setState(() {
        _billing = r.data;
        _cachedAt = DateTime.now();
        _loadingBilling = false;
        _billingError = null;
      });
    } else {
      setState(() {
        _loadingBilling = false;
        _billingError = r.error;
      });
    }
  }

  Future<void> _loadClaims() async {
    final auth = ref.read(authSessionProvider);
    if (!auth.isShopOwner || !auth.hasApiSession) return;
    final token = auth.accessToken;
    if (token == null) return;
    setState(() => _loadingClaims = true);
    final r = await fetchPrideApiLicensePaymentClaims(accessToken: token);
    if (!mounted) return;
    setState(() {
      _loadingClaims = false;
      if (r.ok) _claims = r.rows;
    });
  }

  Future<void> _submitClaim(AppLocalizations l10n) async {
    final token = ref.read(authSessionProvider).accessToken;
    if (token == null) return;
    final txn = _txnCtrl.text.trim();
    if (txn.isEmpty) return;
    setState(() => _submittingClaim = true);
    final r = await postPrideApiLicensePaymentClaim(
      accessToken: token,
      planTier: _planTier,
      transactionId: txn,
      payerPhone: _phoneCtrl.text.trim(),
      notes: _notesCtrl.text.trim(),
    );
    if (!mounted) return;
    setState(() => _submittingClaim = false);
    if (r.ok) {
      _txnCtrl.clear();
      _phoneCtrl.clear();
      _notesCtrl.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.subscriptionPaymentClaimSubmitSuccess)),
      );
      await _loadClaims();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.subscriptionPaymentClaimSubmitError(r.error ?? ''),
          ),
        ),
      );
    }
  }

  String _claimStatusLabel(AppLocalizations l10n, String status) {
    return switch (status) {
      'approved' => l10n.subscriptionPaymentClaimStatusApproved,
      'rejected' => l10n.subscriptionPaymentClaimStatusRejected,
      _ => l10n.subscriptionPaymentClaimStatusPending,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final auth = ref.watch(authSessionProvider);
    final online = ref.watch(connectivityOnlineProvider);
    final apiOn = PrideApiConfig.isConfigured;

    if (!apiOn) {
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          l10n.subscriptionBillingNotPublished,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    final billing = _billing;
    final hasPublished = billing != null && billing['is_published'] == true;
    final imageBytes = decodeBillingSettingsImageBytes(billing);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        if (_loadingBilling)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Center(child: CircularProgressIndicator()),
          ),
        if (!online && _cachedAt != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              l10n.subscriptionBillingOfflineCache(
                MaterialLocalizations.of(context).formatShortDate(_cachedAt!),
              ),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        if (_billingError != null && billing == null)
          Text(
            l10n.subscriptionBillingLoadError(_billingError!),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        if (!hasPublished && !_loadingBilling)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              l10n.subscriptionBillingNotPublished,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        if (hasPublished) ...[
          if (imageBytes != null) ...[
            BillingSettingsImageView(imageBytes: imageBytes),
            const SizedBox(height: 24),
          ],
          _sectionTitle(context, l10n.subscriptionPaymentClaimTitle),
          if (!auth.isShopOwner)
            Text(
              l10n.subscriptionPaymentClaimOwnerOnly,
              style: Theme.of(context).textTheme.bodySmall,
            )
          else if (auth.hasApiSession) ...[
            DropdownButtonFormField<String>(
              initialValue: _planTier,
              decoration: InputDecoration(
                labelText: l10n.subscriptionPaymentClaimPlanTier,
                border: const OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(
                  value: 'one_year',
                  child: Text(l10n.subscriptionPaymentClaimPlanOneYear),
                ),
                DropdownMenuItem(
                  value: 'two_year',
                  child: Text(l10n.subscriptionPaymentClaimPlanTwoYear),
                ),
                DropdownMenuItem(
                  value: 'lifetime',
                  child: Text(l10n.subscriptionPaymentClaimPlanLifetime),
                ),
              ],
              onChanged: _submittingClaim
                  ? null
                  : (v) {
                      if (v != null) setState(() => _planTier = v);
                    },
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _txnCtrl,
              enabled: !_submittingClaim,
              decoration: InputDecoration(
                labelText: l10n.subscriptionPaymentClaimTransactionId,
                hintText: l10n.subscriptionPaymentClaimTransactionHint,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _phoneCtrl,
              enabled: !_submittingClaim,
              decoration: InputDecoration(
                labelText: l10n.subscriptionPaymentClaimPayerPhone,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _notesCtrl,
              enabled: !_submittingClaim,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: l10n.subscriptionPaymentClaimNotes,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: !online || _submittingClaim
                  ? null
                  : () => _submitClaim(l10n),
              icon: _submittingClaim
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.payments_outlined),
              label: Text(
                _submittingClaim
                    ? l10n.subscriptionPaymentClaimSubmitting
                    : l10n.subscriptionPaymentClaimSubmit,
              ),
            ),
            const SizedBox(height: 16),
            _sectionTitle(context, l10n.subscriptionPaymentClaimHistoryTitle),
            if (_loadingClaims)
              const Center(child: CircularProgressIndicator())
            else if (_claims.isEmpty)
              Text(
                '—',
                style: Theme.of(context).textTheme.bodySmall,
              )
            else
              ..._claims.map((c) {
                final status = '${c['status'] ?? 'pending'}';
                final code = c['activation_code'];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text('${c['transaction_id'] ?? ''}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_claimStatusLabel(l10n, status)),
                        if (code != null && '$code'.isNotEmpty)
                          Text(
                            '${l10n.subscriptionPaymentClaimCodeLabel}: $code',
                          ),
                        if (c['review_notes'] != null &&
                            '$c[review_notes]'.isNotEmpty)
                          Text('${c['review_notes']}'),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                );
              }),
          ],
          const SizedBox(height: 24),
        ],
      ],
    );
  }

  Widget _sectionTitle(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: Theme.of(context).textTheme.titleSmall),
    );
  }
}
