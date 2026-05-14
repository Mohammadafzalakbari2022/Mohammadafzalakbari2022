import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/auth/auth_providers.dart';
import 'package:pride_v3/core/api/pride_api_admin.dart';
import 'package:pride_v3/core/api/pride_api_config.dart';
import 'package:pride_v3/core/api/pride_api_health.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../shell/shell_sync_providers.dart';
import 'developer_portal_diagnostics_tab.dart';

/// Developer portal shell (plan-18). Admin list APIs ship separately; health ping works today.
class DeveloperPortalScreen extends ConsumerWidget {
  const DeveloperPortalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final online = ref.watch(connectivityOnlineProvider);
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.devPortalTitle),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: l10n.devPortalTabOverview),
              Tab(text: l10n.devPortalTabCodes),
              Tab(text: l10n.devPortalTabShops),
              Tab(text: l10n.devPortalTabResets),
              Tab(text: l10n.devPortalTabDiagnostics),
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
                  _PlaceholderTab(message: l10n.devPortalCodesStub),
                  _PlaceholderTab(message: l10n.devPortalShopsStub),
                  _PlaceholderTab(message: l10n.devPortalResetsStub),
                  const DeveloperPortalDiagnosticsTab(),
                ],
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

  Future<void> _refreshHealth() async {
    if (!PrideApiConfig.isConfigured) return;
    if (!ref.read(connectivityOnlineProvider)) return;
    final result = await pingPrideApiHealth();
    if (!mounted) return;
    setState(() => _health = result);

    final token = ref.read(authSessionProvider).accessToken;
    if (token == null) {
      if (!mounted) return;
      setState(() => _audit = null);
      return;
    }
    final audit = await getPrideApiAdminAuditLog(accessToken: token);
    if (!mounted) return;
    setState(() => _audit = audit);
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

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshHealth,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          if (PrideApiConfig.isConfigured) ...[
            Text(
              widget.l10n.devPortalApiHealthPrompt,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
          ],
          _StatCard(title: widget.l10n.devPortalStatShops, value: '—'),
          _StatCard(title: widget.l10n.devPortalStatActiveExpired, value: '—'),
          _StatCard(title: widget.l10n.devPortalStatTrials, value: '—'),
          _StatCard(title: widget.l10n.devPortalStatActivations, value: '—'),
          Card(
            child: ListTile(
              leading: const Icon(Icons.cloud_outlined),
              title: Text(widget.l10n.devPortalApiHealthTitle),
              subtitle: Text(_healthSubtitle()),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.receipt_long_outlined),
              title: Text(widget.l10n.devPortalAdminAuditTitle),
              subtitle: Text(_auditSubtitle()),
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

class _PlaceholderTab extends StatelessWidget {
  const _PlaceholderTab({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
