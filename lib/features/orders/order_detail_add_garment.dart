import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/core/feedback/app_feedback.dart';
import 'package:pride_v3/core/formatting/digit_normalizer.dart';
import 'package:pride_v3/core/widgets/pride_modal_bottom_sheet.dart';
import 'package:pride_v3/core/widgets/pride_money_field.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/local/entities/garment_type.dart';
import '../../data/local/order_item_input.dart';
import '../../data/local/order_summary.dart';
import '../../data/local/sync_outbox_kinds.dart';
import '../../data/providers/local_data_providers.dart';
import '../../licensing/license_providers.dart';
import '../../shell/shell_sync_providers.dart';
import 'order_composer_item_card.dart';
import 'order_detail_edit_helpers.dart';

Future<void> orderDetailAddGarment(
  BuildContext context,
  WidgetRef ref,
  AppLocalizations l10n,
  OrderSummary order,
  GarmentType garmentType,
) async {
  if (ref.read(licenseEditingBlockedProvider)) {
    showAppFeedback(
      context,
      ref,
      kind: AppFeedbackKind.error,
      message: licenseWriteBlockedMessage(
        ref.read(licenseNotifierProvider),
        l10n,
      ),
    );
    return;
  }
  final ok = await confirmOrderFieldEdit(context, l10n);
  if (!context.mounted || !ok) return;

  final priceMinor = await showPrideModalBottomSheet<int>(
    context: context,
    builder: (ctx) => _AddGarmentPriceSheet(
      garmentType: garmentType,
      l10n: l10n,
    ),
  );
  if (!context.mounted || priceMinor == null || priceMinor <= 0) return;

  final repo = await ref.read(orderListRepositoryProvider.future);
  if (!context.mounted) return;
  try {
    await repo.addOrderItem(
      orderInternalId: order.internalId,
      input: OrderItemCreateInput(
        garmentType: garmentType,
        priceAmountMinor: priceMinor,
      ),
    );
  } on OrderItemRepositoryException catch (e) {
    if (!context.mounted) return;
    final message = switch (e.code) {
      'duplicate_garment_type' => l10n.ordersDetailAddGarmentDuplicate,
      'order_total_below_paid' => l10n.ordersPaymentTotalBelowPaid,
      'item_price_required' => l10n.ordersComposerItemPriceRequired,
      _ => l10n.genericError,
    };
    showAppFeedback(
      context,
      ref,
      kind: AppFeedbackKind.error,
      message: message,
    );
    return;
  }

  recordSyncOutboxMutation(
    ref,
    kind: SyncOutboxKinds.orderUpdate,
    entityRef: order.internalId,
    shopId: order.shopId,
    payloadJson: jsonEncode({
      'garment_type': garmentType.apiKey,
      'price_amount_minor': priceMinor,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    }),
  );
  if (!context.mounted) return;
  showAppFeedback(
    context,
    ref,
    kind: AppFeedbackKind.success,
    message: l10n.ordersDetailAddGarmentSuccess(
      composerGarmentLabel(l10n, garmentType),
    ),
  );
}

class _AddGarmentPriceSheet extends StatefulWidget {
  const _AddGarmentPriceSheet({
    required this.garmentType,
    required this.l10n,
  });

  final GarmentType garmentType;
  final AppLocalizations l10n;

  @override
  State<_AddGarmentPriceSheet> createState() => _AddGarmentPriceSheetState();
}

class _AddGarmentPriceSheetState extends State<_AddGarmentPriceSheet> {
  final _priceCtrl = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _priceCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final minor = tryParseMoneyAmount(_priceCtrl.text);
    if (minor == null || minor <= 0) {
      setState(() => _error = widget.l10n.ordersComposerItemPriceRequired);
      return;
    }
    Navigator.of(context).pop(minor);
  }

  @override
  Widget build(BuildContext context) {
    final label = composerGarmentLabel(widget.l10n, widget.garmentType);
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.l10n.ordersDetailAddGarmentTitle(label),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            widget.l10n.ordersDetailAddGarmentSubtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 16),
          PrideMoneyField(
            controller: _priceCtrl,
            labelText: widget.l10n.ordersComposerItemPriceLabel,
            autofocus: true,
            onSubmitted: (_) => _save(),
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(
              _error!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ],
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _save,
            child: Text(widget.l10n.saveCta),
          ),
        ],
      ),
    );
  }
}
