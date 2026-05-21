import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/auth/auth_providers.dart';
import 'package:pride_v3/core/api/pride_api_admin.dart';
import 'package:pride_v3/core/api/pride_api_config.dart';
import 'package:pride_v3/core/widgets/pride_numeric_text_field.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../core/persistence/api_offline_cache_storage.dart';
import '../../core/persistence/shared_preferences_provider.dart';
import '../../shell/shell_sync_providers.dart';
import 'developer_portal_screen.dart';
import 'developer_portal_code_share.dart';

/// Activation codes list + create (`plan-18`).
class DeveloperPortalCodesTab extends ConsumerStatefulWidget {
  const DeveloperPortalCodesTab({super.key, required this.l10n});

  final AppLocalizations l10n;

  @override
  ConsumerState<DeveloperPortalCodesTab> createState() =>
      _DeveloperPortalCodesTabState();
}

class _DeveloperPortalCodesTabState extends ConsumerState<DeveloperPortalCodesTab> {
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _rows = const [];
  bool _showingOfflineCache = false;

  Future<void> _load() async {
    if (!PrideApiConfig.isConfigured) {
      setState(() {
        _loading = false;
        _error = widget.l10n.devPortalStubAction;
        _rows = const [];
        _showingOfflineCache = false;
      });
      return;
    }
    final online = ref.read(connectivityOnlineProvider);
    final prefs = ref.read(sharedPreferencesProvider);
    final cached = ApiOfflineCacheStorage.readAdminActivationCodes(prefs);

    if (cached != null) {
      setState(() {
        _rows = cached;
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
          _rows = const [];
          _showingOfflineCache = false;
        });
      }
      return;
    }

    final auth = ref.read(authSessionProvider);
    final token = auth.accessToken;
    if (!auth.hasApiSession || token == null) {
      setState(() {
        _loading = false;
        _error = widget.l10n.devPortalAdminAuditNeedSignIn;
        _rows = cached ?? const [];
        _showingOfflineCache = false;
      });
      return;
    }
    if (cached == null) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }
    final r = await getPrideApiAdminActivationCodes(accessToken: token);
    if (!mounted) return;
    if (!r.ok) {
      setState(() {
        _loading = false;
        _error = widget.l10n.devPortalCodesLoadError(r.error ?? 'HTTP');
        _showingOfflineCache = cached != null;
      });
      return;
    }
    await ApiOfflineCacheStorage.saveAdminActivationCodes(prefs, r.rows);
    setState(() {
      _loading = false;
      _error = null;
      _rows = r.rows;
      _showingOfflineCache = false;
    });
  }

  Future<void> _create() async {
    final auth = ref.read(authSessionProvider);
    final token = auth.accessToken;
    if (token == null) return;
    final planCtrl = TextEditingController(text: '365');
    final maxCtrl = TextEditingController(text: '1');
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(widget.l10n.devPortalCodesCreateTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PrideNumericTextField(
              controller: planCtrl,
              labelText: widget.l10n.devPortalCodesPlanDaysLabel,
              decimal: false,
            ),
            const SizedBox(height: 12),
            PrideNumericTextField(
              controller: maxCtrl,
              labelText: widget.l10n.devPortalCodesMaxUsesLabel,
              decimal: false,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(widget.l10n.devPortalCodesCreateCta),
          ),
        ],
      ),
    );
    if (ok != true) return;
    final planDays = int.tryParse(planCtrl.text.trim()) ?? 365;
    final maxUses = int.tryParse(maxCtrl.text.trim()) ?? 1;
    final res = await postPrideApiAdminCreateActivationCode(
      accessToken: token,
      planDays: planDays,
      maxUses: maxUses,
    );
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    if (res.ok && res.created != null) {
      final created = res.created!;
      final code = '${created['code'] ?? ''}';
      final createdPlanDays =
          (created['plan_days'] as num?)?.toInt() ?? planDays;
      if (code.isNotEmpty) {
        await showDeveloperPortalActivationCodeDialog(
          context,
          widget.l10n,
          code: code,
          planDays: createdPlanDays,
        );
      } else {
        messenger.showSnackBar(
          SnackBar(
            content: Text(widget.l10n.devPortalCodesCreated(code)),
          ),
        );
      }
      await _load();
    } else {
      messenger.showSnackBar(
        SnackBar(content: Text(res.error ?? widget.l10n.devPortalCodesCreateFail)),
      );
    }
  }

  Future<void> _revoke(Map<String, dynamic> row) async {
    final id = '${row['id'] ?? ''}';
    if (id.isEmpty) return;
    final code = '${row['code'] ?? ''}';
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(widget.l10n.devPortalCodesRevokeTitle),
        content: Text(widget.l10n.devPortalCodesRevokeBody(code)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(widget.l10n.deleteCta),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    final token = ref.read(authSessionProvider).accessToken;
    if (token == null) return;
    final res = await postPrideApiAdminRevokeActivationCode(
      accessToken: token,
      codeId: id,
    );
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    if (res.ok) {
      messenger.showSnackBar(
        SnackBar(content: Text(widget.l10n.devPortalCodesRevoked)),
      );
      await _load();
    } else {
      messenger.showSnackBar(
        SnackBar(content: Text(res.error ?? widget.l10n.devPortalCodesRevokeFail)),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(_error!, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _load,
            child: Text(widget.l10n.devPortalRetryCta),
          ),
        ],
      );
    }
    return Column(
      children: [
        if (_showingOfflineCache) DevPortalOfflineCacheBanner(l10n: widget.l10n),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: _showingOfflineCache ? null : _create,
                  icon: const Icon(Icons.add),
                  label: Text(widget.l10n.devPortalCodesCreateCta),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _load,
            child: _rows.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.3,
                        child: Center(child: Text(widget.l10n.devPortalCodesEmpty)),
                      ),
                    ],
                  )
                : ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: _rows.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (context, i) {
                      final m = _rows[i];
                      final code = '${m['code'] ?? ''}';
                      final status = '${m['status'] ?? ''}';
                      final uses = '${m['uses_count'] ?? 0}/${m['max_uses'] ?? 1}';
                      final plan = '${m['plan_days'] ?? ''}d';
                      final revoked = status == 'revoked' || status == 'depleted';
                      final planDays =
                          (m['plan_days'] as num?)?.toInt() ?? 0;
                      return Card(
                        child: ListTile(
                          title: Text(
                            code,
                            style: const TextStyle(fontFamily: 'monospace'),
                          ),
                          subtitle: Text('$status · $uses · $plan'),
                          trailing: revoked
                              ? null
                              : IconButton(
                                  icon: const Icon(Icons.block),
                                  tooltip: widget.l10n.devPortalCodesRevokeCta,
                                  onPressed: () => _revoke(m),
                                ),
                          onTap: code.isEmpty
                              ? null
                              : () => showDeveloperPortalActivationCodeDialog(
                                    context,
                                    widget.l10n,
                                    code: code,
                                    planDays: planDays,
                                  ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
