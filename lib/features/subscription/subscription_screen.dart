import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/core/api/pride_api_config.dart';
import 'package:pride_v3/core/api/pride_api_license.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../auth/auth_providers.dart';
import '../../licensing/license_notifier.dart';
import '../../licensing/license_providers.dart';
import '../../licensing/license_snapshot_persist.dart';
import 'subscription_billing_panel.dart';

/// `/app/settings/subscription` — always reachable when license expired (plan-19).
class SubscriptionScreen extends ConsumerStatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  ConsumerState<SubscriptionScreen> createState() =>
      _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen> {
  final _code = TextEditingController();
  bool _busyRedeem = false;
  bool _busyRefresh = false;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  String _statusLabel(AppLocalizations l10n, LicenseStatus s) {
    return switch (s) {
      LicenseStatus.trialActive => l10n.licenseStatusTrial,
      LicenseStatus.active => l10n.licenseStatusPaid,
      LicenseStatus.expired => l10n.licenseStatusExpired,
    };
  }

  Future<void> _applySnapshot(Map<String, dynamic> snapshot) async {
    await persistLicenseSnapshotFromApi(ref, snapshot);
  }

  Future<void> _redeem(AppLocalizations l10n) async {
    FocusScope.of(context).unfocus();
    final code = _code.text.trim();
    if (code.isEmpty) return;

    setState(() => _busyRedeem = true);
    try {
      final result = await postPrideApiLicenseRedeem(
        code: code,
        accessToken: ref.read(authSessionProvider).accessToken,
      );
      if (!mounted) return;
      if (result is PrideApiLicenseFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.subscriptionRedeemError(result.message)),
          ),
        );
        return;
      }
      final ok = result as PrideApiLicenseOk;
      await _applySnapshot(ok.snapshot);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.subscriptionRedeemSuccess)),
        );
      }
    } finally {
      if (mounted) setState(() => _busyRedeem = false);
    }
  }

  Future<void> _refresh(AppLocalizations l10n) async {
    setState(() => _busyRefresh = true);
    try {
      final result = await fetchPrideApiLicenseStatus(
        accessToken: ref.read(authSessionProvider).accessToken,
      );
      if (!mounted) return;
      if (result is PrideApiLicenseFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.subscriptionRefreshError(result.message)),
          ),
        );
        return;
      }
      final ok = result as PrideApiLicenseOk;
      await _applySnapshot(ok.snapshot);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.subscriptionRedeemSuccess)),
        );
      }
    } finally {
      if (mounted) setState(() => _busyRefresh = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final license = ref.watch(licenseNotifierProvider);
    final editingBlocked = ref.watch(licenseEditingBlockedProvider);
    final apiOn = PrideApiConfig.isConfigured;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.subscriptionCurrentStatusTitle,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Chip(
                      label: Text(_statusLabel(l10n, license.status)),
                    ),
                    if (license.isExpired)
                      Text(
                        l10n.subscriptionReadOnlyHint,
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    else if (license.suspectedTimeTamper)
                      Text(
                        l10n.subscriptionClockTamperHint,
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    else if (editingBlocked)
                      Text(
                        l10n.subscriptionGraceReadOnlyHint,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.subscriptionBody,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        if (apiOn) ...[
          const SizedBox(height: 20),
          Text(
            l10n.subscriptionBillingSectionTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
        const SubscriptionBillingPanel(),
        const SizedBox(height: 24),
        Text(
          l10n.subscriptionActivationTitle,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _code,
          enabled: apiOn && !_busyRedeem,
          decoration: InputDecoration(
            labelText: l10n.subscriptionActivationCodeLabel,
            hintText: apiOn
                ? l10n.subscriptionActivationCodeHintApi
                : l10n.subscriptionActivationCodeHint,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: !apiOn || _busyRedeem
              ? null
              : () => _redeem(l10n),
          icon: _busyRedeem
              ? SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                )
              : const Icon(Icons.key_outlined),
          label: Text(
            _busyRedeem
                ? l10n.subscriptionApplying
                : l10n.subscriptionActivateCta,
          ),
        ),
        if (!apiOn) ...[
          const SizedBox(height: 8),
          Text(
            l10n.subscriptionActivationComingSoon,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
        const SizedBox(height: 24),
        OutlinedButton.icon(
          onPressed: !apiOn || _busyRefresh
              ? null
              : () => _refresh(l10n),
          icon: _busyRefresh
              ? SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              : const Icon(Icons.sync_outlined),
          label: Text(
            _busyRefresh
                ? l10n.subscriptionRefreshing
                : l10n.subscriptionRefreshStatusCta,
          ),
        ),
        const SizedBox(height: 8),
        if (!apiOn)
          Text(
            l10n.subscriptionRefreshComingSoon,
            style: Theme.of(context).textTheme.bodySmall,
          ),
      ],
    );
  }
}
