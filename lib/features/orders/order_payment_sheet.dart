import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pride_v3/app/app_theme.dart';
import 'package:pride_v3/core/calendar/app_calendar_format.dart';
import 'package:pride_v3/core/calendar/date_calendar_notifier.dart';
import 'package:pride_v3/core/calendar/date_calendar_system.dart';
import 'package:pride_v3/core/feedback/app_feedback.dart';
import 'package:pride_v3/core/formatting/digit_normalizer.dart';
import 'package:pride_v3/core/widgets/pride_money_field.dart';
import 'package:pride_v3/l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

import '../../data/local/order_summary.dart';
import '../../data/local/payment_summary.dart';
import '../../data/local/sync_outbox_kinds.dart';
import '../../data/providers/local_data_providers.dart';
import '../../licensing/license_providers.dart';
import '../../shell/shell_sync_providers.dart';
import 'order_detail_edit_helpers.dart';
import 'order_payment_amount_sheet.dart';
import 'order_payment_rules.dart';

class OrderPaymentDraftResult {
  const OrderPaymentDraftResult({
    required this.totalMinor,
    required this.initialPaidMinor,
  });

  final int totalMinor;
  final int initialPaidMinor;
}

Future<OrderPaymentDraftResult?> showOrderPaymentDraftSheet({
  required BuildContext context,
  int initialTotalMinor = 0,
  int initialPaidMinor = 0,
}) {
  return showModalBottomSheet<OrderPaymentDraftResult>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (ctx) => _OrderPaymentDraftSheet(
      initialTotalMinor: initialTotalMinor,
      initialPaidMinor: initialPaidMinor,
    ),
  );
}

Future<void> showOrderPaymentSavedSheet({
  required BuildContext context,
  required WidgetRef ref,
  required OrderSummary order,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (ctx) => _OrderPaymentSavedSheet(order: order),
  );
}

class _OrderPaymentDraftSheet extends StatefulWidget {
  const _OrderPaymentDraftSheet({
    required this.initialTotalMinor,
    required this.initialPaidMinor,
  });

  final int initialTotalMinor;
  final int initialPaidMinor;

  @override
  State<_OrderPaymentDraftSheet> createState() => _OrderPaymentDraftSheetState();
}

class _OrderPaymentDraftSheetState extends State<_OrderPaymentDraftSheet> {
  late final TextEditingController _totalCtrl;
  late final TextEditingController _paidCtrl;
  String? _error;

  @override
  void initState() {
    super.initState();
    _totalCtrl = TextEditingController(
      text: widget.initialTotalMinor > 0
          ? widget.initialTotalMinor.toString()
          : '',
    );
    _paidCtrl = TextEditingController(
      text: widget.initialPaidMinor > 0
          ? widget.initialPaidMinor.toString()
          : '',
    );
    _totalCtrl.addListener(_revalidate);
    _paidCtrl.addListener(_revalidate);
  }

  void _revalidate() => setState(() => _error = null);

  @override
  void dispose() {
    _totalCtrl
      ..removeListener(_revalidate)
      ..dispose();
    _paidCtrl
      ..removeListener(_revalidate)
      ..dispose();
    super.dispose();
  }

  void _save() {
    final total = tryParseMoneyAmount(_totalCtrl.text);
    final paid = tryParseMoneyAmount(_paidCtrl.text) ?? 0;
    if (total == null || !OrderPaymentRules.isValidInitialPay(total, paid)) {
      setState(() {
        _error = AppLocalizations.of(context)!
            .ordersPaymentInitialExceedsTotal;
      });
      return;
    }
    Navigator.pop(
      context,
      OrderPaymentDraftResult(totalMinor: total, initialPaidMinor: paid),
    );
  }

  void _clear() => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final viewInsets = MediaQuery.viewInsetsOf(context).bottom;
    final total = tryParseMoneyAmount(_totalCtrl.text) ?? 0;
    final paid = tryParseMoneyAmount(_paidCtrl.text) ?? 0;
    final due = OrderPaymentRules.remainingMinor(total, paid);
    final valid = OrderPaymentRules.isValidInitialPay(total, paid);

    return Padding(
      padding: EdgeInsets.only(bottom: viewInsets),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.55,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (context, scroll) {
          return Material(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                      Expanded(
                        child: Text(
                          l10n.ordersComposerPaymentSheetTitle,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    controller: scroll,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    children: [
                      PrideMoneyField(
                        controller: _totalCtrl,
                        labelText: l10n.ordersComposerTotalLabel,
                        hintText: l10n.ordersComposerTotalHint,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 12),
                      PrideMoneyField(
                        controller: _paidCtrl,
                        labelText: l10n.ordersComposerPaidLabel,
                        hintText: l10n.ordersComposerPaidHint,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.ordersComposerPaymentInitialOnSaveHint,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          _error!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      _DueSummaryCard(
                        l10n: l10n,
                        total: total,
                        paid: paid,
                        due: due,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    16,
                    8,
                    16,
                    16 + MediaQuery.paddingOf(context).bottom,
                  ),
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: _clear,
                        child: Text(l10n.ordersComposerFabricClearCta),
                      ),
                      const Spacer(),
                      FilledButton(
                        onPressed: valid ? _save : null,
                        child: Text(l10n.saveCta),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _OrderPaymentSavedSheet extends ConsumerStatefulWidget {
  const _OrderPaymentSavedSheet({required this.order});

  final OrderSummary order;

  @override
  ConsumerState<_OrderPaymentSavedSheet> createState() =>
      _OrderPaymentSavedSheetState();
}

class _OrderPaymentSavedSheetState extends ConsumerState<_OrderPaymentSavedSheet> {
  late final TextEditingController _totalCtrl;
  String? _error;

  @override
  void initState() {
    super.initState();
    _totalCtrl = TextEditingController(
      text: widget.order.totalAmountMinor.toString(),
    );
  }

  @override
  void dispose() {
    _totalCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveTotalIfChanged(OrderSummary o) async {
    final l10n = AppLocalizations.of(context)!;
    final parsed = tryParseMoneyAmount(_totalCtrl.text);
    if (parsed == null || parsed == o.totalAmountMinor) return;
    if (!OrderPaymentRules.canSetOrderTotal(parsed, o.paidAmountMinor)) {
      setState(() {
        _error = AppLocalizations.of(context)!.ordersPaymentTotalBelowPaid;
      });
      return;
    }
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
    final confirmed = await confirmOrderFieldEdit(context, l10n);
    if (!mounted || !confirmed) return;
    final repo = await ref.read(orderListRepositoryProvider.future);
    try {
      await repo.updateOrderDetails(
        orderInternalId: o.internalId,
        totalAmountMinor: parsed,
      );
    } on StateError {
      if (!mounted) return;
      setState(() {
        _error = AppLocalizations.of(context)!.ordersPaymentTotalBelowPaid;
      });
      return;
    }
    recordSyncOutboxMutation(
      ref,
      kind: SyncOutboxKinds.orderUpdate,
      entityRef: o.internalId,
      shopId: o.shopId,
      payloadJson: jsonEncode({
        'total_amount_minor': parsed,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      }),
    );
    if (!mounted) return;
    setState(() => _error = null);
    showAppFeedback(
      context,
      ref,
      kind: AppFeedbackKind.success,
      message: AppLocalizations.of(context)!.ordersComposerSaved,
    );
  }

  Future<void> _addPayment(OrderSummary o, {required bool adjustment}) async {
    final l10n = AppLocalizations.of(context)!;
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
    final remaining = o.remainingAmountMinor;
    final amount = await showOrderPaymentAmountSheet(
      context,
      l10n,
      title: adjustment ? l10n.addAdjustmentCta : l10n.addPaymentCta,
      hint: adjustment ? l10n.paymentAdjustmentHint : null,
      signed: adjustment,
      maxAmountMinor: adjustment ? null : remaining,
    );
    if (!mounted || amount == null) return;
    if (!OrderPaymentRules.canAppendPayment(
      totalMinor: o.totalAmountMinor,
      paidMinor: o.paidAmountMinor,
      amountMinor: amount,
      isAdjustment: adjustment,
    )) {
      showAppFeedback(
        context,
        ref,
        kind: AppFeedbackKind.error,
        message: l10n.ordersPaymentExceedsRemaining,
      );
      return;
    }
    final paymentId = const Uuid().v4();
    final repo = await ref.read(paymentRepositoryProvider.future);
    await repo.addPayment(
      shopId: o.shopId,
      orderInternalId: o.internalId,
      amountMinor: amount,
      method: adjustment ? 'adjustment' : 'cash',
      isAdjustment: adjustment,
      internalId: paymentId,
    );
    recordSyncOutboxMutation(
      ref,
      kind: SyncOutboxKinds.paymentAppend,
      entityRef: paymentId,
      shopId: o.shopId,
      payloadJson: jsonEncode({
        'order_internal_id': o.internalId,
        'amount_minor': amount,
        'method': adjustment ? 'adjustment' : 'cash',
        'is_adjustment': adjustment,
        'created_at': DateTime.now().toUtc().toIso8601String(),
      }),
    );
    if (!mounted) return;
    showAppFeedback(
      context,
      ref,
      kind: AppFeedbackKind.success,
      message: adjustment ? l10n.paymentAdjustmentAdded : l10n.paymentAdded,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final calendar = ref.watch(dateCalendarSystemProvider);
    final viewInsets = MediaQuery.viewInsetsOf(context).bottom;
    final asyncPayments =
        ref.watch(paymentsForOrderProvider(widget.order.internalId));

    return asyncPayments.when(
      data: (payments) {
        final orders = ref.watch(ordersListStreamProvider).valueOrNull ?? [];
        OrderSummary? o;
        for (final row in orders) {
          if (row.internalId == widget.order.internalId) {
            o = row;
            break;
          }
        }
        o ??= widget.order;
        final paid = o.paidAmountMinor;
        final due = OrderPaymentRules.remainingMinor(
          o.totalAmountMinor,
          paid,
        );

        return Padding(
          padding: EdgeInsets.only(bottom: viewInsets),
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.72,
            minChildSize: 0.45,
            maxChildSize: 0.92,
            builder: (context, scroll) {
              return Material(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close),
                          ),
                          Expanded(
                            child: Text(
                              l10n.ordersPaymentSheetSavedTitle,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        controller: scroll,
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        children: [
                          PrideMoneyField(
                            controller: _totalCtrl,
                            labelText: l10n.ordersComposerTotalLabel,
                            hintText: l10n.ordersComposerTotalHint,
                          ),
                          if (_error != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              _error!,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ],
                          const SizedBox(height: 12),
                          _DueSummaryCard(
                            l10n: l10n,
                            total: o!.totalAmountMinor,
                            paid: paid,
                            due: due,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.ordersPaymentHistoryTitle,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 8),
                          if (payments.isEmpty)
                            Text(
                              l10n.paymentsEmpty,
                              style: Theme.of(context).textTheme.bodyMedium,
                            )
                          else
                            for (var i = 0; i < payments.length; i++) ...[
                              if (i > 0) const SizedBox(height: 8),
                              _PaymentHistoryRow(
                                payment: payments[i],
                                l10n: l10n,
                                calendar: calendar,
                                locale: locale,
                              ),
                            ],
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        16,
                        8,
                        16,
                        16 + MediaQuery.paddingOf(context).bottom,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              FilledButton.icon(
                                style: prideLedgerTonalButtonStyle(context),
                                onPressed: o.remainingAmountMinor > 0
                                    ? () => _addPayment(o!, adjustment: false)
                                    : null,
                                icon: const Icon(Icons.add_card_outlined),
                                label: Text(l10n.addPaymentCta),
                              ),
                              FilledButton.icon(
                                style: prideButtonStyle(
                                  context,
                                  PrideButtonVariant.warning,
                                ),
                                onPressed: () =>
                                    _addPayment(o!, adjustment: true),
                                icon: const Icon(Icons.tune_outlined),
                                label: Text(l10n.addAdjustmentCta),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          FilledButton(
                            onPressed: () async {
                              await _saveTotalIfChanged(o!);
                            },
                            child: Text(l10n.saveCta),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
      loading: () => const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => SizedBox(
        height: 120,
        child: Center(child: Text('$e')),
      ),
    );
  }
}

class _DueSummaryCard extends StatelessWidget {
  const _DueSummaryCard({
    required this.l10n,
    required this.total,
    required this.paid,
    required this.due,
  });

  final AppLocalizations l10n;
  final int total;
  final int paid;
  final int due;

  @override
  Widget build(BuildContext context) {
    String money(int m) =>
        l10n.moneyAfn(NumberFormat.decimalPattern().format(m));
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _row(theme, l10n.paymentTotal, money(total)),
            const SizedBox(height: 6),
            _row(theme, l10n.paymentPaid, money(paid)),
            const SizedBox(height: 6),
            _row(
              theme,
              l10n.ordersComposerDueLabel,
              money(due),
              emphasize: due > 0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(
    ThemeData theme,
    String label,
    String value, {
    bool emphasize = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: emphasize ? theme.colorScheme.error : null,
          ),
        ),
      ],
    );
  }
}

class _PaymentHistoryRow extends StatelessWidget {
  const _PaymentHistoryRow({
    required this.payment,
    required this.l10n,
    required this.calendar,
    required this.locale,
  });

  final PaymentSummary payment;
  final AppLocalizations l10n;
  final DateCalendarSystem calendar;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: scheme.surfaceContainerLowest,
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.75),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              payment.isAdjustment
                  ? Icons.tune_outlined
                  : Icons.payments_outlined,
              size: 22,
              color: scheme.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.paymentAmount(payment.amountMinor.toString()),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${payment.method} · ${AppCalendarFormat.dateTimeMedium(l10n, calendar, payment.createdAt, locale)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
