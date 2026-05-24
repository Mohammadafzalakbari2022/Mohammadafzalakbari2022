import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/auth/auth_providers.dart';
import 'package:pride_v3/core/api/pride_api_admin.dart';
import 'package:pride_v3/core/api/pride_api_config.dart';
import 'package:pride_v3/core/api/pride_api_health.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../core/persistence/api_offline_cache_storage.dart';
import '../../core/persistence/shared_preferences_provider.dart';
import '../../shell/shell_sync_providers.dart';
import 'developer_portal_account_tab.dart';
import 'developer_portal_codes_tab.dart';
import 'developer_portal_billing_tab.dart';
import 'developer_portal_diagnostics_tab.dart';
import 'developer_portal_support_tab.dart';

/// Developer portal shell (plan-18): overview, activation codes, shops, resets, diagnostics.
class DeveloperPortalScreen extends ConsumerWidget {
  const DeveloperPortalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final online = ref.watch(connectivityOnlineProvider);
    return DefaultTabController(
      length: 8,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.devPortalTitle),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: l10n.devPortalTabOverview),
              Tab(text: l10n.devPortalTabCodes),
              Tab(text: l10n.devPortalTabBilling),
              Tab(text: l10n.devPortalTabSupport),
              Tab(text: l10n.devPortalTabShops),
              Tab(text: l10n.devPortalTabResets),
              Tab(text: l10n.devPortalTabDiagnostics),
              Tab(text: l10n.devPortalTabAccount),
            ],
          ),
        ),
        body: Column(
          children: [
            _DevPortalAdviceCard(online: online, l10n: l10n),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Chip(
                  avatar: const Icon(Icons.developer_mode, size: 18),
                  label: Text(l10n.devPortalEnvBadge),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _OverviewTab(l10n: l10n),
                  DeveloperPortalCodesTab(l10n: l10n),
                  DeveloperPortalBillingTab(l10n: l10n),
                  DeveloperPortalSupportTab(l10n: l10n),
                  _DevPortalShopsTab(l10n: l10n),
                  _DevPortalResetsTab(l10n: l10n),
                  const DeveloperPortalDiagnosticsTab(),
                  const DeveloperPortalAccountTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DevPortalOfflineCacheBanner extends StatelessWidget {
  const DevPortalOfflineCacheBanner({super.key, required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.wifi_off_outlined,
              size: 20,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.devPortalOfflineCacheNote,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DevPortalAdviceCard extends StatelessWidget {
  const _DevPortalAdviceCard({
    required this.online,
    required this.l10n,
  });

  final bool online;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (title, body, icon) = online
        ? (
            l10n.devPortalAdviceOnlineTitle,
            l10n.devPortalAdviceOnlineBody,
            Icons.info_outline,
          )
        : (
            l10n.devPortalAdviceOfflineTitle,
            l10n.devPortalAdviceOfflineBody,
            Icons.wifi_off_outlined,
          );

    final bg = online
        ? scheme.surfaceContainerHighest
        : scheme.errorContainer;
    final fg = online ? scheme.onSurface : scheme.onErrorContainer;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Card(
        color: bg,
        margin: EdgeInsets.zero,
        child: ListTile(
          leading: Icon(icon, color: fg),
          title: Text(title, style: TextStyle(color: fg)),
          subtitle: Text(body, style: TextStyle(color: fg)),
        ),
      ),
    );
  }
}

class _OverviewTab extends ConsumerStatefulWidget {
  const _OverviewTab({required this.l10n});

  final AppLocalizations l10n;

  @override
  ConsumerState<_OverviewTab> createState() => _OverviewTabState();
}

class _OverviewTabState extends ConsumerState<_OverviewTab> {
  PrideApiHealthResult? _health;
  PrideApiAdminAuditLogResult? _audit;
  Map<String, dynamic>? _stats;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshHealth());
  }

  bool _showingOfflineStats = false;

  Future<void> _refreshHealth() async {
    if (!PrideApiConfig.isConfigured) return;
    final online = ref.read(connectivityOnlineProvider);
    final prefs = ref.read(sharedPreferencesProvider);
    final cachedStats = ApiOfflineCacheStorage.readAdminStats(prefs);
    if (!online) {
      if (!mounted) return;
      setState(() {
        _health = null;
        _audit = null;
        _stats = cachedStats;
        _showingOfflineStats = cachedStats != null;
      });
      return;
    }
    final result = await pingPrideApiHealth();
    if (!mounted) return;
    setState(() => _health = result);

    final token = ref.read(authSessionProvider).accessToken;
    if (token == null) {
      if (!mounted) return;
      setState(() {
        _audit = null;
        _stats = cachedStats;
        _showingOfflineStats = cachedStats != null;
      });
      return;
    }
    final audit = await getPrideApiAdminAuditLog(accessToken: token);
    final stats = await getPrideApiAdminStats(accessToken: token);
    if (!mounted) return;
    if (stats.ok && stats.data != null) {
      await ApiOfflineCacheStorage.saveAdminStats(prefs, stats.data!);
    }
    setState(() {
      _audit = audit;
      _stats = stats.ok ? stats.data : cachedStats;
      _showingOfflineStats = false;
    });
  }

  String _healthSubtitle() {
    final h = _health;
    if (h == null) return widget.l10n.devPortalApiHealthUnknown;
    return switch (h) {
      PrideApiHealthOk() => widget.l10n.settingsApiHealthOk,
      PrideApiHealthFailure(:final message) =>
        widget.l10n.settingsApiHealthFailed(message),
    };
  }

  String _auditSubtitle() {
    final auth = ref.read(authSessionProvider);
    if (!PrideApiConfig.isConfigured) {
      return widget.l10n.devPortalApiHealthUnknown;
    }
    if (!auth.hasApiSession) {
      return widget.l10n.devPortalAdminAuditNeedSignIn;
    }
    final a = _audit;
    if (a == null) return widget.l10n.devPortalDiagCountLoading;
    return switch (a) {
      PrideApiAdminAuditLogOk(:final rowCount, :final schemaVersion) =>
        widget.l10n.devPortalAdminAuditLine(rowCount, schemaVersion),
      PrideApiAdminAuditLogFailure(:final message) =>
        widget.l10n.settingsApiHealthFailed(message),
    };
  }

  String _statShops() {
    final s = _stats;
    if (s == null) return '—';
    final n = s['shop_count'];
    if (n is int) return '$n';
    if (n is num) return '${n.toInt()}';
    return '—';
  }

  String _statPaidExpired() {
    final s = _stats;
    if (s == null) return '—';
    final paid = s['license_paid_active'];
    final ex = s['license_expired'];
    final pi = paid is int ? paid : (paid is num ? paid.toInt() : 0);
    final ei = ex is int ? ex : (ex is num ? ex.toInt() : 0);
    return '$pi / $ei';
  }

  String _statTrials() {
    final s = _stats;
    if (s == null) return '—';
    final t = s['license_trial_active'];
    if (t is int) return '$t';
    if (t is num) return '${t.toInt()}';
    return '—';
  }

  String _statActivations() {
    final a = _audit;
    if (a is! PrideApiAdminAuditLogOk) return '—';
    final n = a.rows
        .where((r) => '${r['action']}' == 'activation_code.create')
        .length;
    return '$n';
  }

  @override
  Widget build(BuildContext context) {
    final audit = _audit;
    return RefreshIndicator(
      onRefresh: _refreshHealth,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          if (_showingOfflineStats)
            DevPortalOfflineCacheBanner(l10n: widget.l10n),
          if (PrideApiConfig.isConfigured) ...[
            Text(
              widget.l10n.devPortalApiHealthPrompt,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
          ],
          _StatCard(title: widget.l10n.devPortalStatShops, value: _statShops()),
          _StatCard(
            title: widget.l10n.devPortalStatActiveExpired,
            value: _statPaidExpired(),
          ),
          _StatCard(title: widget.l10n.devPortalStatTrials, value: _statTrials()),
          _StatCard(
            title: widget.l10n.devPortalStatActivations,
            value: _statActivations(),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.cloud_outlined),
              title: Text(widget.l10n.devPortalApiHealthTitle),
              subtitle: Text(_healthSubtitle()),
            ),
          ),
          Card(
            clipBehavior: Clip.antiAlias,
            child: ExpansionTile(
              leading: const Icon(Icons.receipt_long_outlined),
              title: Text(widget.l10n.devPortalAdminAuditTitle),
              subtitle: Text(_auditSubtitle()),
              children: [
                if (audit is PrideApiAdminAuditLogOk)
                  for (final r in audit.rows.take(12))
                    ListTile(
                      dense: true,
                      title: Text(
                        '${r['action']}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      subtitle: Text(
                        '${r['created_at']}',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    )
                else if (audit is PrideApiAdminAuditLogFailure)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(audit.message),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(title),
        trailing: Text(
          value,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}

class _DevPortalShopsTab extends ConsumerStatefulWidget {
  const _DevPortalShopsTab({required this.l10n});

  final AppLocalizations l10n;

  @override
  ConsumerState<_DevPortalShopsTab> createState() => _DevPortalShopsTabState();
}

class _DevPortalShopsTabState extends ConsumerState<_DevPortalShopsTab> {
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _rows = const [];
  bool _showingOfflineCache = false;

  String _formatIsoDate(String? raw) {
    if (raw == null || raw.isEmpty || raw == 'null') return '—';
    final dt = DateTime.tryParse(raw);
    if (dt == null) return raw;
    final local = dt.toLocal();
    final y = local.year.toString().padLeft(4, '0');
    final m = local.month.toString().padLeft(2, '0');
    final d = local.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  List<Map<String, dynamic>> _shopUsers(Map<String, dynamic> shop) {
    final raw = shop['users'];
    if (raw is! List) return const [];
    return raw.whereType<Map<String, dynamic>>().toList();
  }

  String? _shopContactField(Map<String, dynamic> shop, String key) {
    final raw = shop[key];
    if (raw == null) return null;
    final s = '$raw'.trim();
    if (s.isEmpty || s == 'null') return null;
    return s;
  }

  Widget _shopContactSection(Map<String, dynamic> shop) {
    final whatsapp = _shopContactField(shop, 'contact_whatsapp');
    final email = _shopContactField(shop, 'contact_email');
    final address = _shopContactField(shop, 'contact_address');
    final hasAny =
        whatsapp != null || email != null || address != null;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.l10n.devPortalShopContactHeader,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 6),
          if (!hasAny)
            Text(
              widget.l10n.devPortalShopContactMissing,
              style: Theme.of(context).textTheme.bodySmall,
            )
          else ...[
            if (whatsapp != null)
              Text(
                widget.l10n.devPortalShopContactWhatsapp(whatsapp),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            if (email != null)
              Text(
                widget.l10n.devPortalShopContactEmail(email),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            if (address != null)
              Text(
                widget.l10n.devPortalShopContactAddress(address),
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ],
      ),
    );
  }

  Future<void> _disableShop(String shopId) async {
    final token = ref.read(authSessionProvider).accessToken;
    if (token == null) return;
    final r = await postPrideApiAdminDisableShop(
      accessToken: token,
      shopId: shopId,
    );
    if (!mounted) return;
    if (!r.ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(r.error ?? 'HTTP')),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(widget.l10n.devPortalShopActionOk)),
    );
    await _load();
  }

  Future<void> _enableShop(String shopId) async {
    final token = ref.read(authSessionProvider).accessToken;
    if (token == null) return;
    final r = await postPrideApiAdminEnableShop(
      accessToken: token,
      shopId: shopId,
    );
    if (!mounted) return;
    if (!r.ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(r.error ?? 'HTTP')),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(widget.l10n.devPortalShopActionOk)),
    );
    await _load();
  }

  Future<void> _setMaxUsers(
    String shopId, {
    required int currentMax,
    required int userCount,
  }) async {
    final ctrl = TextEditingController(text: '$currentMax');
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(widget.l10n.devPortalShopSetMaxUsersTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.l10n.devPortalShopSetMaxUsersHint),
            const SizedBox(height: 8),
            Text(
              widget.l10n.devPortalShopRowMaxUsers(currentMax, userCount),
              style: Theme.of(ctx).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: ctrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: widget.l10n.devPortalShopMaxUsersLabel,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(widget.l10n.saveCta),
          ),
        ],
      ),
    );
    if (ok != true) return;
    final next = int.tryParse(ctrl.text.trim()) ?? 0;
    if (next < 1 || next > 20) return;
    final token = ref.read(authSessionProvider).accessToken;
    if (token == null) return;
    final r = await postPrideApiAdminSetShopMaxUsers(
      accessToken: token,
      shopId: shopId,
      maxUsers: next,
    );
    if (!mounted) return;
    if (!r.ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(r.error ?? 'HTTP')),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(widget.l10n.devPortalShopActionOk)),
    );
    await _load();
  }

  Future<void> _extendLicense(String shopId) async {
    final ctrl = TextEditingController(text: '30');
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(widget.l10n.devPortalShopExtendTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.l10n.devPortalShopExtendHint),
            const SizedBox(height: 12),
            TextField(
              controller: ctrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: widget.l10n.devPortalShopExtendDaysLabel,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(widget.l10n.saveCta),
          ),
        ],
      ),
    );
    if (ok != true) return;
    final days = int.tryParse(ctrl.text.trim()) ?? 0;
    if (days < 1) return;
    final token = ref.read(authSessionProvider).accessToken;
    if (token == null) return;
    final r = await postPrideApiAdminExtendShopLicense(
      accessToken: token,
      shopId: shopId,
      addDays: days,
    );
    if (!mounted) return;
    if (!r.ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(r.error ?? 'HTTP')),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(widget.l10n.devPortalShopActionOk)),
    );
    await _load();
  }

  Future<void> _pushTest(String shopId, String shopLabel) async {
    final titleCtrl = TextEditingController(text: 'Afghan Pride');
    final bodyCtrl = TextEditingController(text: 'Test: $shopLabel');
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(widget.l10n.devPortalShopPushTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: InputDecoration(
                labelText: widget.l10n.devPortalShopPushNotifTitleLabel,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: bodyCtrl,
              decoration: InputDecoration(
                labelText: widget.l10n.devPortalShopPushBodyLabel,
              ),
              minLines: 2,
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(widget.l10n.devPortalShopPushTestCta),
          ),
        ],
      ),
    );
    if (ok != true) return;
    final token = ref.read(authSessionProvider).accessToken;
    if (token == null) return;
    final r = await postPrideApiAdminPushShop(
      accessToken: token,
      shopId: shopId,
      title: titleCtrl.text.trim().isEmpty ? 'Afghan Pride' : titleCtrl.text.trim(),
      bodyText: bodyCtrl.text.trim(),
    );
    if (!mounted) return;
    final msg = r.error ??
        widget.l10n.devPortalShopPushResult(
          r.successCount,
          r.failureCount,
          r.reason ?? '—',
        );
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

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
    final cached = ApiOfflineCacheStorage.readAdminShops(prefs);

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
    final r = await getPrideApiAdminShops(accessToken: token);
    if (!mounted) return;
    if (!r.ok) {
      setState(() {
        _loading = false;
        _error = widget.l10n.devPortalShopsLoadError(r.error ?? 'HTTP');
        _showingOfflineCache = cached != null;
      });
      return;
    }
    await ApiOfflineCacheStorage.saveAdminShops(prefs, r.shops);
    setState(() {
      _loading = false;
      _error = null;
      _rows = r.shops;
      _showingOfflineCache = false;
    });
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
    if (_rows.isEmpty) {
      return Center(child: Text(widget.l10n.devPortalShopsEmpty));
    }
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: _rows.length + (_showingOfflineCache ? 1 : 0),
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          if (_showingOfflineCache && i == 0) {
            return DevPortalOfflineCacheBanner(l10n: widget.l10n);
          }
          final rowIndex = _showingOfflineCache ? i - 1 : i;
          final m = _rows[rowIndex];
          final id = '${m['id'] ?? ''}';
          final name = '${m['name'] ?? ''}';
          final uc = m['user_count'];
          final count = uc is int ? uc : int.tryParse('$uc') ?? 0;
          final lic = '${m['license_status'] ?? ''}';
          final exp = _formatIsoDate('${m['license_expires_at'] ?? ''}');
          final created = _formatIsoDate('${m['created_at'] ?? ''}');
          final trial = _formatIsoDate('${m['trial_started_at'] ?? ''}');
          final disabledRaw = m['disabled_at'];
          final disabled = disabledRaw != null &&
              '$disabledRaw'.trim().isNotEmpty &&
              '$disabledRaw' != 'null';
          final users = _shopUsers(m);
          final licStatus = '${m['license_status'] ?? ''}';
          final isPaidActive = licStatus == 'active';
          final storedMax = m['max_users'];
          final effectiveMax = m['effective_max_users'];
          final maxUsers = effectiveMax is int
              ? effectiveMax
              : int.tryParse('$effectiveMax') ??
                  (storedMax is int
                      ? storedMax
                      : int.tryParse('$storedMax') ?? 5);
          return Card(
            clipBehavior: Clip.antiAlias,
            child: ExpansionTile(
              title: Row(
                children: [
                  Expanded(
                    child: Text(name.isEmpty ? id : name),
                  ),
                  PopupMenuButton<String>(
                tooltip: widget.l10n.devPortalShopActionsTooltip,
                onSelected: (v) async {
                  if (v == 'disable') {
                    await _disableShop(id);
                  } else if (v == 'enable') {
                    await _enableShop(id);
                  } else if (v == 'extend') {
                    await _extendLicense(id);
                  } else if (v == 'max_users') {
                    await _setMaxUsers(
                      id,
                      currentMax: maxUsers,
                      userCount: count,
                    );
                  } else if (v == 'push') {
                    await _pushTest(id, name.isEmpty ? id : name);
                  }
                },
                itemBuilder: (ctx) => [
                  if (!disabled)
                    PopupMenuItem(
                      value: 'disable',
                      child: Text(widget.l10n.devPortalShopDisableCta),
                    )
                  else
                    PopupMenuItem(
                      value: 'enable',
                      child: Text(widget.l10n.devPortalShopEnableCta),
                    ),
                  PopupMenuItem(
                    value: 'extend',
                    child: Text(widget.l10n.devPortalShopExtendCta),
                  ),
                  if (isPaidActive)
                    PopupMenuItem(
                      value: 'max_users',
                      child: Text(widget.l10n.devPortalShopSetMaxUsersCta),
                    ),
                  PopupMenuItem(
                    value: 'push',
                    child: Text(widget.l10n.devPortalShopPushTestCta),
                  ),
                ],
                  ),
                ],
              ),
              subtitle: Text(
                '$id · ${widget.l10n.devPortalShopRowUsers(count)}\n'
                '${isPaidActive ? widget.l10n.devPortalShopRowMaxUsers(maxUsers, count) : widget.l10n.devPortalShopTrialUserLimitNote}\n'
                '${widget.l10n.devPortalShopSignedUp(created)}\n'
                '$lic · $exp'
                '${trial != '—' ? '\n${widget.l10n.devPortalShopTrialStarted(trial)}' : ''}'
                '${disabled ? '\n${widget.l10n.devPortalShopDisabledLabel}' : ''}',
              ),
              children: [
                _shopContactSection(m),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      widget.l10n.devPortalShopUsersHeader,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ),
                if (users.isEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Text(
                      widget.l10n.devPortalShopRowUsers(0),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  )
                else
                  for (final u in users)
                    ListTile(
                      dense: true,
                      title: Text('${u['username'] ?? ''}'),
                      subtitle: Text(
                        [
                          '${u['id'] ?? ''}',
                          if (u['is_shop_owner'] == true)
                            widget.l10n.devPortalShopUserOwnerBadge,
                          if (u['deleted_at'] != null &&
                              '${u['deleted_at']}'.trim().isNotEmpty &&
                              '${u['deleted_at']}' != 'null')
                            widget.l10n.devPortalShopUserDeletedBadge,
                          if (u['has_password'] == true)
                            widget.l10n.devPortalShopUserPasswordNote,
                        ].join(' · '),
                      ),
                      isThreeLine: true,
                    ),
                const SizedBox(height: 8),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DevPortalResetsTab extends ConsumerStatefulWidget {
  const _DevPortalResetsTab({required this.l10n});

  final AppLocalizations l10n;

  @override
  ConsumerState<_DevPortalResetsTab> createState() => _DevPortalResetsTabState();
}

class _DevPortalResetsTabState extends ConsumerState<_DevPortalResetsTab> {
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
    final cached = ApiOfflineCacheStorage.readAdminPasswordResets(prefs);

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
    final r = await getPrideApiAdminPasswordResetRequests(accessToken: token);
    if (!mounted) return;
    if (!r.ok) {
      setState(() {
        _loading = false;
        _error = widget.l10n.devPortalResetsLoadError(r.error ?? 'HTTP');
        _showingOfflineCache = cached != null;
      });
      return;
    }
    await ApiOfflineCacheStorage.saveAdminPasswordResets(prefs, r.rows);
    setState(() {
      _loading = false;
      _error = null;
      _rows = r.rows;
      _showingOfflineCache = false;
    });
  }

  Future<void> _resolve(Map<String, dynamic> row) async {
    final id = '${row['id'] ?? ''}';
    if (id.isEmpty) return;
    final pwCtrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(widget.l10n.devPortalResetsSetPasswordTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.l10n.devPortalResetsSetPasswordHint),
            const SizedBox(height: 12),
            TextField(
              controller: pwCtrl,
              obscureText: true,
              decoration: InputDecoration(
                labelText: widget.l10n.loginPasswordLabel,
              ),
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
            child: Text(widget.l10n.devPortalResetsResolveCta),
          ),
        ],
      ),
    );
    if (ok != true) return;
    final auth = ref.read(authSessionProvider);
    final token = auth.accessToken;
    if (token == null) return;
    final res = await postPrideApiAdminResolvePasswordReset(
      accessToken: token,
      requestId: id,
      newPassword: pwCtrl.text,
    );
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    if (res.ok) {
      messenger.showSnackBar(
        SnackBar(content: Text(widget.l10n.devPortalResetsResolved)),
      );
      await _load();
    } else {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            widget.l10n.devPortalResetsResolveFailed(res.error ?? 'HTTP'),
          ),
        ),
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
    if (_rows.isEmpty) {
      return Center(child: Text(widget.l10n.devPortalResetsEmpty));
    }
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: _rows.length + (_showingOfflineCache ? 1 : 0),
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          if (_showingOfflineCache && i == 0) {
            return DevPortalOfflineCacheBanner(l10n: widget.l10n);
          }
          final rowIndex = _showingOfflineCache ? i - 1 : i;
          final m = _rows[rowIndex];
          final username = '${m['username'] ?? ''}';
          final shopId = '${m['shop_id'] ?? ''}';
          final created = '${m['created_at'] ?? ''}';
          return Card(
            child: ListTile(
              title: Text(username),
              subtitle: Text('$shopId · $created'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _resolve(m),
            ),
          );
        },
      ),
    );
  }
}
