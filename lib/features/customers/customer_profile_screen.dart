import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pride_v3/core/input/pride_ltr_input.dart';
import 'package:pride_v3/core/validation/afghan_phone_input.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/core/formatting/app_number_format.dart';
import 'package:pride_v3/core/widgets/pride_carved_section.dart';
import 'package:pride_v3/core/calendar/date_calendar_notifier.dart';
import 'package:pride_v3/core/feedback/app_feedback.dart';
import 'package:pride_v3/core/widgets/pride_action_buttons.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../auth/auth_providers.dart';
import '../../data/local/customer_display_no.dart';
import '../../data/local/customer_repository_exception.dart';
import '../../data/local/customer_summary.dart';
import '../../data/local/order_summary.dart';
import '../../data/local/style/order_shape_selection_formatter.dart';
import 'package:pride_v3/core/calendar/date_calendar_system.dart';
import '../../data/local/sync_outbox_kinds.dart';
import '../../data/providers/local_data_providers.dart';
import '../../licensing/license_providers.dart';
import '../../security/delete_by_typing_name.dart';
import '../../shell/shell_sync_providers.dart';
import '../orders/order_composer_screen.dart';
import '../orders/order_list_tile.dart';
import '../orders/order_payment_rules.dart';
import 'customer_profile_hero_card.dart';

class CustomerProfileScreen extends ConsumerWidget {
  const CustomerProfileScreen({super.key, required this.customerId});

  final String customerId;

  Future<void> _editCustomer(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n, {
    required String customerId,
    required DateTime customerCreatedAt,
    required String currentName,
    required String? currentPhone,
    required String? currentAddress,
    required String displayCustomerNo,
  }) async {
    final license = ref.read(licenseNotifierProvider);
    if (ref.read(licenseEditingBlockedProvider)) {
      showAppFeedback(
        context,
        ref,
        kind: AppFeedbackKind.error,
        message: licenseWriteBlockedMessage(license, l10n),
      );
      return;
    }

    final nameCtrl = TextEditingController(text: currentName);
    final phoneCtrl = TextEditingController(text: currentPhone ?? '');
    final addressCtrl = TextEditingController(text: currentAddress ?? '');

    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.customerEditDialogTitle),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: l10n.customerNameLabel,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                textDirection: PrideLtrInput.direction,
                textAlign: PrideLtrInput.align,
                inputFormatters: const [AfghanPhoneInputFormatter()],
                decoration: InputDecoration(
                  labelText: l10n.customerPhoneLabel,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: addressCtrl,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: l10n.customerAddressLabel,
                  hintText: l10n.customerAddressHint,
                  border: const OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
            ],
          ),
        ),
        actions: prideDialogCancelSave(
          context: context,
          onCancel: () => Navigator.of(context).pop(false),
          onConfirm: () => Navigator.of(context).pop(true),
          saveLabel: l10n.saveCta,
        ),
      ),
    );

    if (ok != true) {
      nameCtrl.dispose();
      phoneCtrl.dispose();
      addressCtrl.dispose();
      return;
    }
    final nextName = nameCtrl.text.trim();
    if (nextName.isEmpty) {
      nameCtrl.dispose();
      phoneCtrl.dispose();
      addressCtrl.dispose();
      return;
    }

    final phoneRaw = phoneCtrl.text.trim();
    final phoneText =
        phoneRaw.isEmpty ? '' : normalizeAfghanPhoneDigits(phoneRaw);
    final addressText = addressCtrl.text;
    nameCtrl.dispose();
    phoneCtrl.dispose();
    addressCtrl.dispose();

    final repo = await ref.read(customerListRepositoryProvider.future);
    try {
      await repo.updateCustomer(
        internalId: customerId,
        name: nextName,
        phone: phoneText,
        address: addressText,
        notes: '',
      );
    } on CustomerRepositoryException catch (e) {
      if (!context.mounted) return;
      showAppFeedback(
        context,
        ref,
        kind: AppFeedbackKind.error,
        message: customerRepositoryErrorMessage(e, l10n),
      );
      return;
    }

    final shopId = ref.read(effectiveShopIdProvider);
    recordSyncOutboxMutation(
      ref,
      kind: SyncOutboxKinds.customerUpsert,
      entityRef: customerId,
      shopId: shopId,
      payloadJson: jsonEncode({
        'name': nextName,
        ...customerUpsertPayloadExtras(displayCustomerNo: displayCustomerNo),
        if (phoneText.trim().isNotEmpty) 'phone': phoneText.trim(),
        if (addressText.trim().isNotEmpty) 'address': addressText.trim(),
        'created_at': customerCreatedAt.toUtc().toIso8601String(),
      }),
    );

    if (!context.mounted) return;
    showAppFeedback(
      context,
      ref,
      kind: AppFeedbackKind.success,
      message: l10n.customerUpdated,
    );
  }

  Future<void> _deleteCustomer(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    String customerName,
  ) async {
    final license = ref.read(licenseNotifierProvider);
    if (ref.read(licenseEditingBlockedProvider)) {
      showAppFeedback(
        context,
        ref,
        kind: AppFeedbackKind.error,
        message: licenseWriteBlockedMessage(license, l10n),
      );
      return;
    }

    final ok = await confirmDeleteByTypingName(
      context,
      l10n: l10n,
      title: l10n.customerDeleteConfirmTitle,
      explanation: l10n.customerDeleteConfirmBody,
      expectedName: customerName,
    );
    if (!ok || !context.mounted) return;

    final shopId = ref.read(effectiveShopIdProvider);
    recordSyncOutboxMutation(
      ref,
      kind: SyncOutboxKinds.customerDelete,
      entityRef: customerId,
      shopId: shopId,
    );

    final repo = await ref.read(customerListRepositoryProvider.future);
    await repo.softDeleteCustomer(customerId);

    if (!context.mounted) return;
    showAppFeedback(
      context,
      ref,
      kind: AppFeedbackKind.success,
      message: l10n.customerDeleted,
      deleted: true,
    );
    context.go('/app/customers');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final calendar = ref.watch(dateCalendarSystemProvider);

    final asyncCustomers = ref.watch(customersListStreamProvider);
    final asyncOrders = ref.watch(ordersListStreamProvider);
    final shopId = ref.watch(effectiveShopIdProvider);
    final asyncShopPayments = ref.watch(paymentsForShopProvider(shopId));
    final paidByOrderId = asyncShopPayments.hasValue
        ? OrderPaymentRules.sumPaidMinorByOrderId(
            (asyncShopPayments.value ?? const [])
                .map((p) => (orderInternalId: p.orderInternalId, amountMinor: p.amountMinor)),
          )
        : const <String, int>{};
    final paymentsLedgerLoaded = asyncShopPayments.hasValue;

    return asyncCustomers.when(
      data: (customers) {
        CustomerSummary? found;
        for (final c in customers) {
          if (c.internalId == customerId) {
            found = c;
            break;
          }
        }
        if (found == null) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => context.pop(),
              ),
              title: Text(l10n.customerProfileTitle),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  l10n.customerNotFound,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        final c = found;
        final customerName = c.name;
        final customerPhone = c.phone;
        final customerAddress = c.address;
        final ordersList = asyncOrders.asData?.value ?? const [];
        var orderCount = 0;
        var unpaidMinor = 0;
        for (final o in ordersList) {
          if (o.customerInternalId != customerId) continue;
          orderCount++;
          final paidMinor = OrderPaymentRules.paidMinorForOrder(
            orderSummaryPaidMinor: o.paidAmountMinor,
            paidByOrderId: paidByOrderId,
            orderInternalId: o.internalId,
            paymentsLedgerLoaded: paymentsLedgerLoaded,
          );
          final remainingMinor = OrderPaymentRules.remainingMinor(
            o.totalAmountMinor,
            paidMinor,
          );
          if (remainingMinor > 0) unpaidMinor += remainingMinor;
        }
        String formatMoney(int minor) =>
            AppNumberFormat.formatMoney(l10n, minor);

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => context.pop(),
            ),
            title: Text(customerName),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: l10n.editCta,
                onPressed: () => _editCustomer(
                  context,
                  ref,
                  l10n,
                  customerId: customerId,
                  customerCreatedAt: c.createdAt,
                  currentName: customerName,
                  currentPhone: customerPhone,
                  currentAddress: customerAddress,
                  displayCustomerNo: c.displayCustomerNo,
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'delete') {
                    _deleteCustomer(context, ref, l10n, customerName);
                  }
                },
                itemBuilder: (ctx) => [
                  PopupMenuItem(
                    value: 'delete',
                    child: Text(l10n.customerDeleteMenu),
                  ),
                ],
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              CustomerProfileHeroCard(
                customer: c,
                l10n: l10n,
                locale: locale,
                calendar: calendar,
                orderCount: orderCount,
                unpaidMinor: unpaidMinor,
                formatMoney: formatMoney,
              ),
              asyncOrders.when(
                data: (orders) {
                  final history = orders
                      .where((o) => o.customerInternalId == customerId)
                      .toList()
                    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

                  return PrideCarvedSection(
                    title: l10n.customerOrderHistoryTitle,
                    subtitle: history.isEmpty
                        ? l10n.customerNoOrders
                        : l10n.customersRowMeta(
                            history.length,
                            unpaidMinor > 0
                                ? l10n.ordersRemainingChip(
                                    formatMoney(unpaidMinor),
                                  )
                                : formatMoney(0),
                          ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: FilledButton.tonalIcon(
                            onPressed: () => context.push(
                              orderComposerRoute(customerId: customerId),
                            ),
                            icon: const Icon(Icons.note_add_outlined),
                            label: Text(l10n.customersNewOrderCta),
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (history.isEmpty)
                          Text(l10n.customerNoOrders)
                        else
                          Column(
                            children: [
                              for (final o in history)
                                _customerOrderHistoryTile(
                                  order: o,
                                  paidByOrderId: paidByOrderId,
                                  paymentsLedgerLoaded: paymentsLedgerLoaded,
                                  l10n: l10n,
                                  locale: locale,
                                  calendar: calendar,
                                  formatMoney: formatMoney,
                                  onTap: () => context.go(
                                    orderComposerRoute(orderId: o.internalId),
                                  ),
                                ),
                            ],
                          ),
                      ],
                    ),
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => PrideCarvedSection(
                  title: l10n.customerOrderHistoryTitle,
                  child: Text('$e'),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
          ),
          title: Text(l10n.customerProfileTitle),
        ),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
          ),
          title: Text(l10n.customerProfileTitle),
        ),
        body: Center(child: Text('$e')),
      ),
    );
  }
}

OrderListTile _customerOrderHistoryTile({
  required OrderSummary order,
  required Map<String, int> paidByOrderId,
  required bool paymentsLedgerLoaded,
  required AppLocalizations l10n,
  required String locale,
  required DateCalendarSystem calendar,
  required String Function(int minor) formatMoney,
  required VoidCallback onTap,
}) {
  final paidMinor = OrderPaymentRules.paidMinorForOrder(
    orderSummaryPaidMinor: order.paidAmountMinor,
    paidByOrderId: paidByOrderId,
    orderInternalId: order.internalId,
    paymentsLedgerLoaded: paymentsLedgerLoaded,
  );
  return OrderListTile(
    order: order,
    paidAmountMinor: paidMinor,
    remainingAmountMinor: OrderPaymentRules.remainingMinor(
      order.totalAmountMinor,
      paidMinor,
    ),
    l10n: l10n,
    locale: locale,
    calendar: calendar,
    detailed: true,
    formatMoney: formatMoney,
    stylePreviewLine: formatOrderShapeSelectionDisplay(
      styleName: order.styleName,
      styleSelectionJson: order.styleSelectionJson,
      styleSummary: order.styleSummary,
    ).compactPreview,
    onTap: onTap,
  );
}

