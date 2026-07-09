import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

/// Privacy and data-access disclosure shown before shop registration.
class ShopCreateConsentPanel extends StatelessWidget {
  const ShopCreateConsentPanel({
    required this.accepted,
    required this.onAcceptedChanged,
    required this.enabled,
    super.key,
  });

  final bool accepted;
  final ValueChanged<bool?> onAcceptedChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final bullets = <String>[
      l10n.loginShopCreateConsentAccount,
      l10n.loginShopCreateConsentCustomers,
      l10n.loginShopCreateConsentOrders,
      l10n.loginShopCreateConsentPayments,
      l10n.loginShopCreateConsentMedia,
      l10n.loginShopCreateConsentDevice,
    ];

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.loginShopCreateConsentTitle,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.loginShopCreateConsentIntro,
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            ...bullets.map(
              (line) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ',
                      style: theme.textTheme.bodySmall?.copyWith(
                        height: 1.35,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        line,
                        style: theme.textTheme.bodySmall?.copyWith(
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            CheckboxListTile(
              value: accepted,
              onChanged: enabled ? onAcceptedChanged : null,
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                l10n.loginShopCreateConsentCheckbox,
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
