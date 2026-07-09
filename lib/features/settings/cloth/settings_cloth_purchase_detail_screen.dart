import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/core/calendar/app_calendar_format.dart';
import 'package:pride_v3/core/calendar/date_calendar_notifier.dart';
import 'package:pride_v3/core/formatting/app_number_format.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../../data/local/cloth_stock_models.dart';
import '../../../data/providers/local_data_providers.dart';
import '../../../licensing/license_providers.dart';
import 'cloth_purchase_payment_sheet.dart';

class SettingsClothPurchaseDetailScreen extends ConsumerWidget {
  const SettingsClothPurchaseDetailScreen({super.key, required this.purchaseId});

  final String purchaseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final calendar = ref.watch(dateCalendarSystemProvider);
    final locale = Localizations.localeOf(context).toString();
    final purchases = ref.watch(clothPurchasesStreamProvider).valueOrNull ?? [];
    final lines = ref.watch(clothPurchaseLinesStreamProvider).valueOrNull ?? [];
    final payments =
        ref.watch(clothPurchasePaymentsStreamProvider).valueOrNull ?? [];
    ClothPurchaseSummary? purchase;
    for (final p in purchases) {
      if (p.internalId == purchaseId) {
        purchase = p;
        break;
      }
    }

    if (purchase == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          title: Text(l10n.settingsClothPurchaseDetailTitle),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final purchaseLines =
        lines.where((l) => l.purchaseInternalId == purchaseId).toList();
    final paid = totalPaidForPurchase(purchaseId, payments);
    final balance = purchase.totalAmountMinor - paid;
    final canEdit = !ref.watch(licenseEditingBlockedProvider);
    final money = (int minor) => AppNumberFormat.formatMoney(l10n, minor);
    final dateLabel = AppCalendarFormat.dateTimeMedium(
      l10n,
      calendar,
      purchase.purchaseDate,
      locale,
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.settingsClothPurchaseDetailTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(dateLabel),
          const SizedBox(height: 8),
          Text('${l10n.settingsClothPurchaseTotalLabel}: ${money(purchase.totalAmountMinor)}'),
          Text('${l10n.settingsClothPurchasePaidLabel}: ${money(paid)}'),
          Text('${l10n.settingsClothPurchaseBalanceLabel}: ${money(balance)}'),
          const SizedBox(height: 16),
          for (final line in purchaseLines)
            ListTile(
              title: Text('${formatMilliMeters(line.qtyMilli)} m'),
              subtitle: Text(money(line.unitCostAmountMinor)),
              trailing: Text(money(line.lineTotalMinor)),
            ),
          if (canEdit && balance > 0)
            FilledButton(
              onPressed: () => showClothPurchasePaymentSheet(
                context: context,
                ref: ref,
                purchase: purchase!,
                balanceMinor: balance,
              ),
              child: Text(l10n.settingsClothPurchasePaymentCta),
            ),
        ],
      ),
    );
  }
}
