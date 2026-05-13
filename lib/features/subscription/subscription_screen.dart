import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../licensing/license_notifier.dart';
import '../../licensing/license_providers.dart';

/// `/app/settings/subscription` — always reachable when license expired (plan-19).
class SubscriptionScreen extends ConsumerWidget {
  const SubscriptionScreen({super.key});

  String _statusLabel(AppLocalizations l10n, LicenseStatus s) {
    return switch (s) {
      LicenseStatus.trialActive => l10n.licenseStatusTrial,
      LicenseStatus.active => l10n.licenseStatusPaid,
      LicenseStatus.expired => l10n.licenseStatusExpired,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final license = ref.watch(licenseNotifierProvider);

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
        const SizedBox(height: 24),
        Text(
          l10n.subscriptionActivationTitle,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        TextField(
          enabled: false,
          decoration: InputDecoration(
            labelText: l10n.subscriptionActivationCodeLabel,
            hintText: l10n.subscriptionActivationCodeHint,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: null,
          icon: const Icon(Icons.key_outlined),
          label: Text(l10n.subscriptionActivateCta),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.subscriptionActivationComingSoon,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 24),
        OutlinedButton.icon(
          onPressed: null,
          icon: const Icon(Icons.sync_outlined),
          label: Text(l10n.subscriptionRefreshStatusCta),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.subscriptionRefreshComingSoon,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
