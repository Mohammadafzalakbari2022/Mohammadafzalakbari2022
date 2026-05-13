import 'package:flutter/material.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

/// Developer portal shell (plan-18). API-backed; shows offline / stub state until server exists.
class DeveloperPortalScreen extends StatelessWidget {
  const DeveloperPortalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
            MaterialBanner(
              content: Text(l10n.devPortalOnlineRequired),
              actions: [
                TextButton(
                  onPressed: () =>
                      ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.devPortalStubAction)),
                  ),
                  child: Text(l10n.devPortalRetryCta),
                ),
              ],
            ),
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
                  _PlaceholderTab(message: l10n.devPortalDiagStub),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _StatCard(title: l10n.devPortalStatShops, value: '—'),
        _StatCard(title: l10n.devPortalStatActiveExpired, value: '—'),
        _StatCard(title: l10n.devPortalStatTrials, value: '—'),
        _StatCard(title: l10n.devPortalStatActivations, value: '—'),
        Card(
          child: ListTile(
            leading: const Icon(Icons.cloud_outlined),
            title: Text(l10n.devPortalApiHealthTitle),
            subtitle: Text(l10n.devPortalApiHealthUnknown),
          ),
        ),
      ],
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
