import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/core/formatting/app_number_format.dart';
import 'package:pride_v3/core/widgets/pride_modal_bottom_sheet.dart';
import 'package:pride_v3/core/widgets/pride_money_field.dart';
import 'package:pride_v3/l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

import '../../../auth/auth_providers.dart';
import '../../../data/local/dev_shop_constants.dart';
import '../../../data/local/cloth_stock_models.dart';
import '../../../data/providers/local_data_providers.dart';
import '../../../licensing/license_providers.dart';
import 'cloth_sync_helpers.dart';

Future<void> showClothPurchasePaymentSheet({
  required BuildContext context,
  required WidgetRef ref,
  required ClothPurchaseSummary purchase,
  required int balanceMinor,
}) {
  return showPrideModalBottomSheet<void>(
    context: context,
    builder: (ctx) => _ClothPurchasePaymentSheet(
      purchase: purchase,
      balanceMinor: balanceMinor,
    ),
  );
}

class _ClothPurchasePaymentSheet extends ConsumerStatefulWidget {
  const _ClothPurchasePaymentSheet({
    required this.purchase,
    required this.balanceMinor,
  });

  final ClothPurchaseSummary purchase;
  final int balanceMinor;

  @override
  ConsumerState<_ClothPurchasePaymentSheet> createState() =>
      _ClothPurchasePaymentSheetState();
}

class _ClothPurchasePaymentSheetState
    extends ConsumerState<_ClothPurchasePaymentSheet> {
  late final TextEditingController _amountCtrl;
  late final TextEditingController _noteCtrl;

  @override
  void initState() {
    super.initState();
    _amountCtrl = TextEditingController(
      text: widget.balanceMinor > 0 ? widget.balanceMinor.toString() : '',
    );
    _noteCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final amount = int.tryParse(_amountCtrl.text.trim()) ?? 0;
    if (amount <= 0) return;
    final shopId = effectiveShopIdFromAuth(ref.read(authSessionProvider).shopId);
    final id = const Uuid().v4();
    final repo = await ref.read(clothStockRepositoryProvider.future);
    await repo.appendPurchasePayment(
      shopId: shopId,
      purchaseInternalId: widget.purchase.internalId,
      amountMinor: amount,
      paidAt: DateTime.now(),
      note: _noteCtrl.text.trim(),
      internalId: id,
    );
    enqueueClothPurchasePaymentAppend(
      ref,
      internalId: id,
      purchaseInternalId: widget.purchase.internalId,
      amountMinor: amount,
      paidAt: DateTime.now(),
      note: _noteCtrl.text.trim(),
    );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.settingsClothPurchasePaymentCta,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          PrideMoneyField(
            controller: _amountCtrl,
            labelText: l10n.shopFinanceAmountLabel,
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _noteCtrl,
            decoration: InputDecoration(
              labelText: l10n.shopFinanceNoteLabel,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _save,
            child: Text(l10n.saveCta),
          ),
        ],
      ),
    );
  }
}
