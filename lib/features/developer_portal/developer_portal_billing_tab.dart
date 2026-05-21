import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/auth/auth_providers.dart';
import 'package:pride_v3/core/api/pride_api_billing.dart';
import 'package:pride_v3/core/api/pride_api_config.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../core/persistence/api_offline_cache_storage.dart';
import '../../core/persistence/shared_preferences_provider.dart';
import '../../shell/shell_sync_providers.dart';
import 'developer_portal_screen.dart';
import 'developer_portal_code_share.dart';

/// Developer portal: Hesab Pay profile + payment claim inbox.
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

  final _accountName = TextEditingController();
  final _accountNumber = TextEditingController();
  final _merchantId = TextEditingController();
  final _price1 = TextEditingController();
  final _price2 = TextEditingController();
  final _priceLife = TextEditingController();
  final _payEn = TextEditingController();
  final _payFa = TextEditingController();
  final _payPs = TextEditingController();
  final _actEn = TextEditingController();
  final _actFa = TextEditingController();
  final _actPs = TextEditingController();
  final _cashEn = TextEditingController();
  final _cashFa = TextEditingController();
  final _cashPs = TextEditingController();
  final _whatsapp = TextEditingController();
  final _telegram = TextEditingController();
  final _phone = TextEditingController();

  String _claimFilter = 'pending';
  List<Map<String, dynamic>> _claims = const [];
  bool _loadingClaims = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _accountName.dispose();
    _accountNumber.dispose();
    _merchantId.dispose();
    _price1.dispose();
    _price2.dispose();
    _priceLife.dispose();
    _payEn.dispose();
    _payFa.dispose();
    _payPs.dispose();
    _actEn.dispose();
    _actFa.dispose();
    _actPs.dispose();
    _cashEn.dispose();
    _cashFa.dispose();
    _cashPs.dispose();
    _whatsapp.dispose();
    _telegram.dispose();
    _phone.dispose();
    super.dispose();
  }

  String? _token() => ref.read(authSessionProvider).accessToken;

  Map<String, String> _localeMap(
    TextEditingController en,
    TextEditingController fa,
    TextEditingController ps,
  ) =>
      {
        'en': en.text.trim(),
        'fa': fa.text.trim(),
        'ps': ps.text.trim(),
      };

  void _applyBilling(Map<String, dynamic> d) {
    _published = d['is_published'] == true;
    _accountName.text = '${d['hesab_pay_account_name'] ?? ''}';
    _accountNumber.text = '${d['hesab_pay_account_number'] ?? ''}';
    _merchantId.text = '${d['hesab_pay_merchant_id'] ?? ''}';
    _price1.text = d['price_1_year_afn']?.toString() ?? '';
    _price2.text = d['price_2_year_afn']?.toString() ?? '';
    _priceLife.text = d['price_lifetime_afn']?.toString() ?? '';
    _whatsapp.text = '${d['whatsapp_e164'] ?? ''}';
    _telegram.text = '${d['telegram_handle'] ?? ''}';
    _phone.text = '${d['direct_phone_e164'] ?? ''}';

    void fillLocales(String key, TextEditingController en, fa, ps) {
      final all = d['${key}_all'];
      if (all is Map) {
        en.text = '${all['en'] ?? ''}';
        fa.text = '${all['fa'] ?? ''}';
        ps.text = '${all['ps'] ?? ''}';
      }
    }

    fillLocales('payment_steps', _payEn, _payFa, _payPs);
    fillLocales('activation_delivery_steps', _actEn, _actFa, _actPs);
    fillLocales('cash_payment_note', _cashEn, _cashFa, _cashPs);
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
    } else {
      final err = r.error ?? '';
      // Legacy API: missing row — still show the form so the developer can save.
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
    }
    setState(() {
      _loading = false;
      _showingOfflineCache = false;
    });
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

  Future<void> _save() async {
    final token = _token();
    if (token == null) return;
    setState(() => _saving = true);
    int? parsePrice(TextEditingController c) {
      final t = c.text.trim();
      if (t.isEmpty) return null;
      return int.tryParse(t);
    }

    final body = <String, dynamic>{
      'is_published': _published,
      'hesab_pay_account_name': _accountName.text.trim(),
      'hesab_pay_account_number': _accountNumber.text.trim(),
      'hesab_pay_merchant_id': _merchantId.text.trim(),
      'price_1_year_afn': parsePrice(_price1),
      'price_2_year_afn': parsePrice(_price2),
      'price_lifetime_afn': parsePrice(_priceLife),
      'payment_steps': _localeMap(_payEn, _payFa, _payPs),
      'activation_delivery_steps': _localeMap(_actEn, _actFa, _actPs),
      'cash_payment_note': _localeMap(_cashEn, _cashFa, _cashPs),
      'whatsapp_e164': _whatsapp.text.trim(),
      'telegram_handle': _telegram.text.trim(),
      'direct_phone_e164': _phone.text.trim(),
    };
    final r = await postPrideApiAdminBillingInfo(
      accessToken: token,
      body: body,
    );
    if (!mounted) return;
    setState(() => _saving = false);
    if (r.ok && r.data != null) {
      _applyBilling(r.data!);
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
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: _load,
                child: Text(l10n.devPortalRetryCta),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_showingOfflineCache) DevPortalOfflineCacheBanner(l10n: l10n),
          Text(
            l10n.devPortalBillingIntro,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.devPortalBillingProfileTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SwitchListTile(
            title: Text(l10n.devPortalBillingPublished),
            value: _published,
            onChanged: (v) => setState(() => _published = v),
          ),
          _field(l10n.devPortalBillingAccountName, _accountName),
          _field(l10n.devPortalBillingAccountNumber, _accountNumber),
          _field(l10n.devPortalBillingMerchantId, _merchantId),
          _field(l10n.devPortalBillingPrice1Year, _price1, keyboard: TextInputType.number),
          _field(l10n.devPortalBillingPrice2Year, _price2, keyboard: TextInputType.number),
          _field(l10n.devPortalBillingPriceLifetime, _priceLife, keyboard: TextInputType.number),
          _field(l10n.devPortalBillingPaymentStepsEn, _payEn, maxLines: 4),
          _field(l10n.devPortalBillingPaymentStepsFa, _payFa, maxLines: 4),
          _field(l10n.devPortalBillingPaymentStepsPs, _payPs, maxLines: 4),
          _field(l10n.devPortalBillingActivationStepsEn, _actEn, maxLines: 3),
          _field(l10n.devPortalBillingActivationStepsFa, _actFa, maxLines: 3),
          _field(l10n.devPortalBillingActivationStepsPs, _actPs, maxLines: 3),
          _field(l10n.devPortalBillingCashNoteEn, _cashEn, maxLines: 2),
          _field(l10n.devPortalBillingCashNoteFa, _cashFa, maxLines: 2),
          _field(l10n.devPortalBillingCashNotePs, _cashPs, maxLines: 2),
          _field(l10n.devPortalBillingWhatsapp, _whatsapp),
          _field(l10n.devPortalBillingTelegram, _telegram),
          _field(l10n.devPortalBillingPhone, _phone),
          FilledButton.icon(
            onPressed: _saving ? null : _save,
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

  Widget _field(
    String label,
    TextEditingController ctrl, {
    int maxLines = 1,
    TextInputType? keyboard,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextField(
        controller: ctrl,
        maxLines: maxLines,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
