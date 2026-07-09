import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/core/formatting/app_number_format.dart';
import 'package:pride_v3/core/calendar/app_calendar_format.dart';
import 'package:pride_v3/core/calendar/date_calendar_notifier.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../../data/local/cloth_stock_models.dart';
import '../../../data/providers/local_data_providers.dart';
import '../../../licensing/license_providers.dart';

class SettingsClothPurchasesListScreen extends ConsumerWidget {
  const SettingsClothPurchasesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final calendar = ref.watch(dateCalendarSystemProvider);
    final locale = Localizations.localeOf(context).toString();
    final purchasesAsync = ref.watch(clothPurchasesStreamProvider);
    final paymentsAsync = ref.watch(clothPurchasePaymentsStreamProvider);
    final canEdit = !ref.watch(licenseEditingBlockedProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.settingsClothPurchasesTitle),
      ),
      floatingActionButton: canEdit
          ? FloatingActionButton(
              onPressed: () => context.push('/app/settings/fabric/purchases/new'),
              child: const Icon(Icons.add),
            )
          : null,
      body: purchasesAsync.when(
        data: (purchases) {
          if (purchases.isEmpty) {
            return Center(child: Text(l10n.settingsClothPurchasesEmpty));
          }
          final payments = paymentsAsync.valueOrNull ?? const [];
          return ListView.separated(
            itemCount: purchases.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final p = purchases[index];
              final balance = purchaseBalanceMinor(p, payments);
              final money = AppNumberFormat.formatMoney(l10n, p.totalAmountMinor);
              final dateLabel = AppCalendarFormat.dateTimeMedium(
                l10n,
                calendar,
                p.purchaseDate,
                locale,
              );
              return ListTile(
                title: Text(dateLabel),
                subtitle: Text('${l10n.settingsClothPurchaseTotalLabel}: $money'),
                trailing: Text(
                  balance > 0
                      ? AppNumberFormat.formatMoney(l10n, balance)
                      : l10n.settingsClothPurchasePaidLabel,
                ),
                onTap: () => context.push(
                  '/app/settings/fabric/purchases/${p.internalId}',
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
      ),
    );
  }
}
