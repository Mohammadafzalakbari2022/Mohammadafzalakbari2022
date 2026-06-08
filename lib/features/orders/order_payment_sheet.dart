import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/core/formatting/app_number_format.dart';
import 'package:pride_v3/app/app_theme.dart';
import 'package:pride_v3/core/feedback/app_feedback.dart';
import 'package:pride_v3/core/formatting/digit_normalizer.dart';
import 'package:pride_v3/core/widgets/pride_modal_bottom_sheet.dart';
import 'package:pride_v3/core/widgets/pride_money_field.dart';
import 'package:pride_v3/l10n/app_localizations.dart';
import '../../data/local/order_summary.dart';
import 'order_composer_draft.dart';
import 'order_composer_item_card.dart';
import '../../data/local/payment_summary.dart';
import '../../data/local/sync_outbox_kinds.dart';
import '../../data/providers/local_data_providers.dart';
import '../../licensing/license_providers.dart';
import '../../shell/shell_sync_providers.dart';
import 'order_detail_edit_helpers.dart';
import 'order_payment_mutations.dart';
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
  List<OrderPaymentBreakdownLine> itemBreakdown = const [],
  bool totalReadOnly = false,
}) {
  return showPrideModalBottomSheet<OrderPaymentDraftResult>(
    context: context,
    builder: (ctx) => _OrderPaymentDraftSheet(
      initialTotalMinor: initialTotalMinor,
      initialPaidMinor: initialPaidMinor,
      itemBreakdown: itemBreakdown,
      totalReadOnly: totalReadOnly,
    ),
  );
}

Future<void> showOrderPaymentSavedSheet({
  required BuildContext context,
  required WidgetRef ref,
  required OrderSummary order,
}) {
  return showPrideModalBottomSheet<void>(
    context: context,
    builder: (ctx) => _OrderPaymentSavedSheet(order: order),
  );
}

/// Shared hint under signed money fields.
Widget orderPaymentSignedHint(BuildContext context, AppLocalizations l10n) {
  return Padding(
    padding: const EdgeInsets.only(top: 8),
    child: Text(
      l10n.ordersPaymentSignedHint,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
    ),
  );
}

class _OrderPaymentDraftSheet extends StatefulWidget {
  const _OrderPaymentDraftSheet({
    required this.initialTotalMinor,
    required this.initialPaidMinor,
    this.itemBreakdown = const [],
    this.totalReadOnly = false,
  });

  final int initialTotalMinor;
  final int initialPaidMinor;
  final List<OrderPaymentBreakdownLine> itemBreakdown;
  final bool totalReadOnly;

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

  int? get _parsedTotal {
    if (widget.totalReadOnly) return widget.initialTotalMinor;
    return tryParseMoneyAmount(_totalCtrl.text);
  }

  int get _parsedPaid => tryParseMoneyAmount(_paidCtrl.text) ?? 0;

  void _applyPaidInFull() {
    final total = _parsedTotal;
    if (total == null || total <= 0) return;
    setState(() => _paidCtrl.text = total.toString());
  }

  void _applyNothingPaid() {
    setState(() => _paidCtrl.text = '0');
  }

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
    final l10n = AppLocalizations.of(context)!;
    final total = _parsedTotal;
    final paid = _parsedPaid;
    if (total == null) {
      setState(() => _error = l10n.ordersComposerPaymentRequired);
      return;
    }
    if (!OrderPaymentRules.isValidInitialPay(total, paid)) {
      setState(() {
        _error = l10n.ordersPaymentInitialExceedsTotal;
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
    final total = _parsedTotal ?? 0;
    final paid = _parsedPaid;
    final due = OrderPaymentRules.remainingMinor(total, paid);
    final valid =
        _parsedTotal != null && OrderPaymentRules.isValidInitialPay(total, paid);
    return PrideDraggableSheetScaffold(
      header: Padding(
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
      body: (scroll) => ListView(
        controller: scroll,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        children: [
          if (widget.itemBreakdown.isNotEmpty) ...[
            Text(
              l10n.ordersComposerItemBreakdownTitle,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            for (final line in widget.itemBreakdown)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        composerGarmentLabel(l10n, line.garmentType),
                      ),
                    ),
                    Text(
                      AppNumberFormat.formatMoney(l10n, line.amountMinor),
                    ),
                  ],
                ),
              ),
            const Divider(height: 20),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.ordersComposerTotalLabel),
              trailing: Text(
                AppNumberFormat.formatMoney(
                  l10n,
                  widget.initialTotalMinor,
                ),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
            const SizedBox(height: 12),
          ] else
            PrideMoneyField(
              controller: _totalCtrl,
              labelText: l10n.ordersComposerPriceLabel,
              hintText: l10n.ordersComposerPriceHint,
              textInputAction: TextInputAction.next,
            ),
          if (widget.itemBreakdown.isEmpty) const SizedBox(height: 12),
          PrideMoneyField(
            controller: _paidCtrl,
            labelText: l10n.ordersComposerReceivedNowLabel,
            hintText: l10n.ordersComposerReceivedNowHint,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ActionChip(
                avatar: const Icon(Icons.check_circle_outline, size: 20),
                label: Text(l10n.ordersComposerPaidInFullCta),
                onPressed: _parsedTotal != null && _parsedTotal! > 0
                    ? _applyPaidInFull
                    : null,
              ),
              ActionChip(
                avatar: const Icon(Icons.money_off_outlined, size: 20),
                label: Text(l10n.ordersComposerNothingPaidCta),
                onPressed: _applyNothingPaid,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l10n.ordersComposerNewOrderPaymentHint,
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
            emphasizeDue: true,
          ),
        ],
      ),
      footer: PrideSheetFooter(
        child: Row(
          children: [
            TextButton(
              onPressed: _clear,
              child: Text(l10n.ordersComposerPaymentCancelCta),
            ),
            const Spacer(),
            FilledButton(
              onPressed: valid ? _save : null,
              child: Text(l10n.saveCta),
            ),
          ],
        ),
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
  bool _editing = false;
  late final TextEditingController _totalCtrl;
  final TextEditingController _nextCtrl = TextEditingController();
  final Map<String, TextEditingController> _depositCtrls = {};
  final Map<String, int> _depositBaselines = {};
  int _totalBaseline = 0;
  String? _error;
  String _lastSyncKey = '';

  @override
  void initState() {
    super.initState();
    _totalCtrl = TextEditingController();
    _totalCtrl.addListener(_onFieldChanged);
    _nextCtrl.addListener(_onFieldChanged);
  }

  void _onFieldChanged() => setState(() => _error = null);

  @override
  void dispose() {
    _totalCtrl
      ..removeListener(_onFieldChanged)
      ..dispose();
    _nextCtrl
      ..removeListener(_onFieldChanged)
      ..dispose();
    _disposeDepositCtrls();
    super.dispose();
  }

  void _disposeDepositCtrls() {
    for (final c in _depositCtrls.values) {
      c.dispose();
    }
    _depositCtrls.clear();
    _depositBaselines.clear();
  }

  List<PaymentSummary> _sortedDeposits(List<PaymentSummary> payments) {
    final list = [...payments]..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return list;
  }

  void _ensureDepositControllers(List<PaymentSummary> sorted) {
    final ids = sorted.map((p) => p.internalId).toList();
    for (final id in _depositCtrls.keys.toList()) {
      if (!ids.contains(id)) {
        _depositCtrls[id]!.dispose();
        _depositCtrls.remove(id);
        _depositBaselines.remove(id);
      }
    }
    for (var i = 0; i < sorted.length; i++) {
      final p = sorted[i];
      _depositBaselines[p.internalId] = p.amountMinor;
      final existing = _depositCtrls[p.internalId];
      if (existing == null) {
        final c = TextEditingController(text: p.amountMinor.toString());
        c.addListener(_onFieldChanged);
        _depositCtrls[p.internalId] = c;
      } else if (!_editing) {
        existing.text = p.amountMinor.toString();
      }
    }
  }

  String _syncKey(OrderSummary o, List<PaymentSummary> sorted) {
    final parts = sorted
        .map((p) => '${p.internalId}:${p.amountMinor}')
        .join('|');
    return '${o.internalId}:${o.totalAmountMinor}:$parts';
  }

  void _syncViewState(OrderSummary o, List<PaymentSummary> sorted) {
    _totalBaseline = o.totalAmountMinor;
    if (!_editing) {
      _totalCtrl.text = o.totalAmountMinor.toString();
      _nextCtrl.clear();
    }
    _ensureDepositControllers(sorted);
    if (!_editing) {
      for (final p in sorted) {
        _depositCtrls[p.internalId]?.text = p.amountMinor.toString();
      }
    }
  }

  void _scheduleSyncIfNeeded(OrderSummary o, List<PaymentSummary> sorted) {
    final key = _syncKey(o, sorted);
    if (key == _lastSyncKey) return;
    _lastSyncKey = key;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _syncViewState(o, sorted);
    });
  }

  Future<bool> _guardWrite(AppLocalizations l10n) async {
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
      return false;
    }
    return true;
  }

  Future<void> _startEdit(AppLocalizations l10n) async {
    final confirmed = await confirmOrderFieldEdit(context, l10n);
    if (!mounted || !confirmed) return;
    setState(() {
      _editing = true;
      _error = null;
      _totalBaseline = int.tryParse(_totalCtrl.text) ??
          widget.order.totalAmountMinor;
      for (final entry in _depositCtrls.entries) {
        final baseline = _depositBaselines[entry.key] ?? 0;
        _depositBaselines[entry.key] = baseline;
        entry.value.text = baseline.toString();
      }
    });
  }

  void _cancelEdit(OrderSummary o, List<PaymentSummary> sorted) {
    setState(() {
      _editing = false;
      _error = null;
      _lastSyncKey = '';
      _totalCtrl.text = o.totalAmountMinor.toString();
      _totalBaseline = o.totalAmountMinor;
      for (final p in sorted) {
        _depositBaselines[p.internalId] = p.amountMinor;
        _depositCtrls[p.internalId]?.text = p.amountMinor.toString();
      }
      _nextCtrl.clear();
    });
  }

  int? _resolveTotalFromField() => OrderPaymentRules.resolveFieldAmount(
        currentMinor: _totalBaseline,
        raw: _totalCtrl.text,
      );

  List<int> _resolveDepositAmounts(List<PaymentSummary> sorted) {
    final amounts = <int>[];
    for (final p in sorted) {
      final ctrl = _depositCtrls[p.internalId];
      if (ctrl == null) continue;
      final baseline = _depositBaselines[p.internalId] ?? p.amountMinor;
      final resolved = OrderPaymentRules.resolveFieldAmount(
        currentMinor: baseline,
        raw: ctrl.text,
      );
      if (resolved == null) return const [];
      amounts.add(resolved);
    }
    return amounts;
  }

  Future<void> _recordNextPayment(OrderSummary o) async {
    final l10n = AppLocalizations.of(context)!;
    if (!await _guardWrite(l10n)) return;

    final raw = _nextCtrl.text.trim();
    if (raw.isEmpty) return;

    final parsed = tryParseMoneyAmount(raw);
    if (parsed == null || parsed <= 0) {
      setState(() => _error = l10n.ordersPaymentNextMustBePositive);
      return;
    }
    final payments =
        ref.read(paymentsForOrderProvider(o.internalId)).valueOrNull ?? const [];
    final currentPaid = OrderPaymentRules.effectivePaidMinor(
      orderSummaryPaidMinor: o.paidAmountMinor,
      paymentAmountsMinor: payments.map((p) => p.amountMinor).toList(),
    );
    if (!OrderPaymentRules.canRecordNextPayment(
      totalMinor: o.totalAmountMinor,
      paidMinor: currentPaid,
      nextPaymentMinor: parsed,
    )) {
      setState(() => _error = l10n.ordersPaymentExceedsRemaining);
      return;
    }

    final repo = await ref.read(paymentRepositoryProvider.future);
    final paymentId = await OrderPaymentMutations.persistAppend(
      repo: repo,
      shopId: o.shopId,
      orderInternalId: o.internalId,
      amountMinor: parsed,
    );
    recordSyncOutboxMutation(
      ref,
      kind: SyncOutboxKinds.paymentAppend,
      entityRef: paymentId,
      shopId: o.shopId,
      payloadJson: OrderPaymentMutations.appendPayloadJson(
        orderInternalId: o.internalId,
        amountMinor: parsed,
      ),
    );
    if (!mounted) return;
    _nextCtrl.clear();
    showAppFeedback(
      context,
      ref,
      kind: AppFeedbackKind.success,
      message: l10n.paymentAdded,
    );
  }

  Future<void> _saveEdit(OrderSummary o, List<PaymentSummary> sorted) async {
    final l10n = AppLocalizations.of(context)!;
    if (!await _guardWrite(l10n)) return;

    final newTotal = _resolveTotalFromField();
    if (newTotal == null) {
      setState(() => _error = l10n.ordersPaymentNegativeInvalid);
      return;
    }

    final depositAmounts = _resolveDepositAmounts(sorted);
    if (depositAmounts.length != sorted.length) {
      setState(() => _error = l10n.ordersPaymentNegativeInvalid);
      return;
    }

    if (!OrderPaymentRules.validatePaymentState(
      totalMinor: newTotal,
      depositAmountsMinor: depositAmounts,
    )) {
      setState(() {
        _error = !OrderPaymentRules.canSetOrderTotal(newTotal, depositAmounts.fold(0, (a, b) => a + b))
            ? l10n.ordersPaymentTotalBelowPaid
            : l10n.ordersPaymentInitialExceedsTotal;
      });
      return;
    }

    final ordersRepo = await ref.read(orderListRepositoryProvider.future);
    final paymentsRepo = await ref.read(paymentRepositoryProvider.future);

    if (newTotal != o.totalAmountMinor) {
      try {
        await ordersRepo.updateOrderDetails(
          orderInternalId: o.internalId,
          totalAmountMinor: newTotal,
        );
      } on StateError {
        if (!mounted) return;
        setState(() => _error = l10n.ordersPaymentTotalBelowPaid);
        return;
      }
      recordSyncOutboxMutation(
        ref,
        kind: SyncOutboxKinds.orderUpdate,
        entityRef: o.internalId,
        shopId: o.shopId,
        payloadJson: jsonEncode({
          'total_amount_minor': newTotal,
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        }),
      );
    }

    for (var i = 0; i < sorted.length; i++) {
      final p = sorted[i];
      final amount = depositAmounts[i];
      if (amount == p.amountMinor) continue;
      await OrderPaymentMutations.persistUpdate(
        repo: paymentsRepo,
        internalId: p.internalId,
        amountMinor: amount,
      );
      recordSyncOutboxMutation(
        ref,
        kind: SyncOutboxKinds.paymentUpdate,
        entityRef: p.internalId,
        shopId: o.shopId,
        payloadJson: OrderPaymentMutations.updatePayloadJson(
          orderInternalId: o.internalId,
          amountMinor: amount,
          method: p.method,
          isAdjustment: p.isAdjustment,
          createdAt: p.createdAt,
        ),
      );
    }

    if (!mounted) return;
    setState(() {
      _editing = false;
      _error = null;
      _lastSyncKey = '';
    });
    showAppFeedback(
      context,
      ref,
      kind: AppFeedbackKind.success,
      message: l10n.ordersComposerSaved,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final asyncPayments =
        ref.watch(paymentsForOrderProvider(widget.order.internalId));

    return asyncPayments.when(
      data: (payments) {
        final orders = ref.watch(ordersListStreamProvider).valueOrNull ?? [];
        var order = widget.order;
        for (final row in orders) {
          if (row.internalId == widget.order.internalId) {
            order = row;
            break;
          }
        }
        final sorted = _sortedDeposits(payments);
        _scheduleSyncIfNeeded(order, sorted);

        final previewTotal = _editing
            ? (_resolveTotalFromField() ?? order.totalAmountMinor)
            : order.totalAmountMinor;
        final previewDeposits = _editing
            ? _resolveDepositAmounts(sorted)
            : sorted.map((p) => p.amountMinor).toList();
        final previewPaid = previewDeposits.isEmpty && !_editing
            ? order.paidAmountMinor
            : previewDeposits.fold<int>(0, (s, a) => s + a);
        final previewDue =
            OrderPaymentRules.remainingMinor(previewTotal, previewPaid);

        final canRecord = !_editing && previewDue > 0;

        return PrideDraggableSheetScaffold(
          header: Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
                Expanded(
                  child: Text(
                    _editing
                        ? l10n.ordersPaymentSheetEditTitle
                        : l10n.ordersPaymentSheetSavedTitle,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          ),
          body: (scroll) => ListView(
            controller: scroll,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            children: [
              PrideMoneyField(
                controller: _totalCtrl,
                signed: _editing,
                enabled: _editing,
                labelText: l10n.ordersComposerTotalLabel,
                hintText: l10n.ordersComposerTotalHint,
              ),
              if (_editing) orderPaymentSignedHint(context, l10n),
              const SizedBox(height: 12),
              for (var i = 0; i < sorted.length; i++) ...[
                if (i > 0) const SizedBox(height: 12),
                PrideMoneyField(
                  controller: _depositCtrls[sorted[i].internalId]!,
                  signed: _editing,
                  enabled: _editing,
                  labelText: l10n.ordersPaymentDepositLabel(i + 1),
                ),
              ],
              if (canRecord) ...[
                const SizedBox(height: 12),
                PrideMoneyField(
                  controller: _nextCtrl,
                  signed: true,
                  labelText: l10n.ordersPaymentNextPaymentLabel,
                  hintText: l10n.ordersComposerPaidHint,
                ),
                orderPaymentSignedHint(context, l10n),
              ],
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
                total: previewTotal,
                paid: previewPaid,
                due: previewDue,
              ),
            ],
          ),
          footer: PrideSheetFooter(
            child: _editing
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FilledButton(
                        onPressed: () => _saveEdit(order, sorted),
                        child: Text(l10n.saveCta),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => _cancelEdit(order, sorted),
                        child: Text(
                          MaterialLocalizations.of(context).cancelButtonLabel,
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      if (canRecord)
                        FilledButton(
                          style: prideLedgerTonalButtonStyle(context),
                          onPressed: () => _recordNextPayment(order),
                          child: Text(l10n.ordersPaymentRecordCta),
                        ),
                      const Spacer(),
                      FilledButton.icon(
                        style: prideButtonStyle(
                          context,
                          PrideButtonVariant.edit,
                        ),
                        onPressed: () => _startEdit(l10n),
                        icon: const Icon(Icons.edit_outlined),
                        label: Text(l10n.editCta),
                      ),
                    ],
                  ),
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
    this.emphasizeDue = false,
  });

  final AppLocalizations l10n;
  final int total;
  final int paid;
  final int due;
  final bool emphasizeDue;

  @override
  Widget build(BuildContext context) {
    String money(int m) => AppNumberFormat.formatMoney(l10n, m);
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
              emphasizeDue && due > 0
                  ? l10n.ordersComposerStillOwedLabel
                  : l10n.ordersComposerDueLabel,
              money(due),
              emphasize: due > 0,
              large: emphasizeDue && due > 0,
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
    bool large = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: (large ? theme.textTheme.titleSmall : theme.textTheme.bodyMedium)
                ?.copyWith(
              fontWeight: FontWeight.w600,
              color: emphasize ? theme.colorScheme.error : null,
            ),
          ),
        ),
        Text(
          value,
          style: (large ? theme.textTheme.titleLarge : theme.textTheme.titleSmall)
              ?.copyWith(
            fontWeight: FontWeight.w800,
            color: emphasize ? theme.colorScheme.error : null,
          ),
        ),
      ],
    );
  }
}
