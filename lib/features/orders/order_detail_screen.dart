import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/core/calendar/app_calendar_format.dart';
import 'package:pride_v3/core/calendar/date_calendar_notifier.dart';
import 'package:pride_v3/core/calendar/date_calendar_system.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import 'package:uuid/uuid.dart';

import '../../auth/auth_providers.dart';
import '../../data/local/dev_shop_constants.dart';
import '../../data/local/measurement_profile_formatting.dart';
import '../../data/local/order_summary.dart';
import '../../data/local/payment_summary.dart';
import '../../data/local/sync_outbox_kinds.dart';
import '../../data/local/entities/order_status.dart';
import '../../data/providers/local_data_providers.dart';
import '../../licensing/license_providers.dart';
import '../../core/printing/thermal_print_order.dart';
import '../../security/owner_password_verify.dart';
import '../../shell/shell_sync_providers.dart';
import 'order_status_label.dart';

/// Order details with collapsible sections (plan-12); data from local stream.
class OrderDetailScreen extends ConsumerWidget {
  const OrderDetailScreen({super.key, required this.orderId});

  final String orderId;

  bool _requiresOwnerPassword(OrderLocalStatus status) {
    return status == OrderLocalStatus.delivered ||
        status == OrderLocalStatus.cancelled;
  }

  bool _isTerminal(OrderLocalStatus status) {
    return status == OrderLocalStatus.delivered ||
        status == OrderLocalStatus.cancelled;
  }

  Future<bool> _confirm(
    BuildContext context,
    String title,
    String body,
    String confirmText,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<String?> _promptOwnerPassword(BuildContext context) async {
    final controller = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.ownerPasswordTitle),
        content: TextField(
          controller: controller,
          obscureText: true,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.ownerPasswordLabel,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(MaterialLocalizations.of(context).okButtonLabel),
          ),
        ],
      ),
    );
    if (ok != true) return null;
    final value = controller.text.trim();
    if (value.isEmpty) return null;
    return value;
  }

  Future<int?> _promptAmount(BuildContext context, AppLocalizations l10n) async {
    final controller = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.addPaymentCta),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: l10n.paymentAmountLabel,
            hintText: l10n.paymentAmountHint,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(MaterialLocalizations.of(context).okButtonLabel),
          ),
        ],
      ),
    );
    if (ok != true) return null;
    final raw = controller.text.trim();
    final value = int.tryParse(raw);
    if (value == null || value <= 0) return null;
    return value;
  }

  Future<int?> _promptSignedAmount(
    BuildContext context,
    AppLocalizations l10n, {
    required String title,
    required String hint,
  }) async {
    final controller = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(hint, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(
                signed: true,
                decimal: false,
              ),
              decoration: InputDecoration(
                labelText: l10n.paymentAmountLabel,
                hintText: l10n.paymentAmountHint,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(MaterialLocalizations.of(context).okButtonLabel),
          ),
        ],
      ),
    );
    if (ok != true) return null;
    final raw = controller.text.trim();
    final value = int.tryParse(raw);
    if (value == null || value == 0) return null;
    return value;
  }

  Future<void> _editInternalNotes(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    OrderSummary o,
  ) async {
    final controller = TextEditingController(text: o.internalNotes);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.ordersInternalNotesDialogTitle),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.multiline,
          minLines: 3,
          maxLines: 8,
          decoration: InputDecoration(
            hintText: l10n.ordersInternalNotesHint,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.saveCta),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    final text = controller.text;
    if (text == o.internalNotes) return;
    final repo = await ref.read(orderListRepositoryProvider.future);
    await repo.updateOrderInternalNotes(
      orderInternalId: o.internalId,
      internalNotes: text,
    );
    recordSyncOutboxMutation(
      ref,
      kind: SyncOutboxKinds.orderInternalNotes,
      entityRef: o.internalId,
      shopId: o.shopId,
      payloadJson: jsonEncode({
        'internal_notes': text,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      }),
    );
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.ordersInternalNotesSaved)),
    );
  }

  Future<OrderLocalStatus?> _pickStatus(
    BuildContext context,
    AppLocalizations l10n,
    OrderLocalStatus current,
  ) async {
    return showModalBottomSheet<OrderLocalStatus>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(l10n.ordersDetailChangeStatus),
                subtitle: Text(l10n.ordersDetailChangeStatusSubtitle),
              ),
              for (final s in <OrderLocalStatus>[
                OrderLocalStatus.ready,
                OrderLocalStatus.delivered,
                OrderLocalStatus.cancelled,
              ])
                ListTile(
                  title: Text(orderStatusLabel(s, l10n)),
                  trailing: s == current ? const Icon(Icons.check) : null,
                  onTap: () => Navigator.of(context).pop(s),
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final calendar = ref.watch(dateCalendarSystemProvider);
    final asyncOrders = ref.watch(ordersListStreamProvider);
    final license = ref.watch(licenseNotifierProvider);

    return asyncOrders.when(
      data: (orders) {
        OrderSummary? found;
        for (final o in orders) {
          if (o.internalId == orderId) {
            found = o;
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
              title: Text(l10n.ordersDetailTitle),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  l10n.ordersDetailNotFound,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }
        final o = found;
        final snapshotAsync =
            ref.watch(orderMeasurementSnapshotProvider(orderId));
        final statusLocked = _isTerminal(o.status);
        final editBlockedByLicense = license.isExpired;
        final changeStatusEnabled = !statusLocked && !editBlockedByLicense;
        final asyncPayments = ref.watch(paymentsForOrderProvider(o.internalId));
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => context.pop(),
            ),
            title: Text(l10n.ordersNumberPrefix(o.displayOrderNo)),
            actions: [
              IconButton(
                icon: const Icon(Icons.print_outlined),
                tooltip: l10n.orderPrintReceiptTooltip,
                onPressed: () => printThermalOrderReceipt(
                  context: context,
                  ref: ref,
                  l10n: l10n,
                  order: o,
                  payments: asyncPayments.asData?.value ?? const [],
                  deliveryDateText: AppCalendarFormat.mediumDate(
                    l10n,
                    calendar,
                    o.deliveryDate,
                    locale,
                  ),
                  statusText: orderStatusLabel(o.status, l10n),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Center(
                  child: Chip(
                    label: Text(orderStatusLabel(o.status, l10n)),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  l10n.ordersDeliveryOn(
                    AppCalendarFormat.mediumDate(
                      l10n,
                      calendar,
                      o.deliveryDate,
                      locale,
                    ),
                  ),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: FilledButton.tonal(
                  onPressed: changeStatusEnabled
                      ? () async {
                          final picked =
                              await _pickStatus(context, l10n, o.status);
                          if (!context.mounted) return;
                          if (picked == null || picked == o.status) return;

                          final confirmed = await _confirm(
                            context,
                            l10n.ordersDetailConfirmTitle,
                            l10n.ordersDetailConfirmBody(
                              orderStatusLabel(picked, l10n),
                            ),
                            l10n.ordersDetailConfirmCta,
                          );
                          if (!context.mounted) return;
                          if (!confirmed) return;

                          if (_requiresOwnerPassword(picked)) {
                            final pw = await _promptOwnerPassword(context);
                            if (!context.mounted) return;
                            if (pw == null) return;
                            if (!verifyOwnerPasswordForLocalActions(pw)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(l10n.ownerPasswordMismatch),
                                ),
                              );
                              return;
                            }
                          }

                          final repo = await ref.read(
                            orderListRepositoryProvider.future,
                          );
                          await repo.updateOrderStatus(
                            orderInternalId: o.internalId,
                            newStatus: picked,
                          );
                          recordSyncOutboxMutation(
                            ref,
                            kind: SyncOutboxKinds.orderStatus,
                            entityRef: o.internalId,
                            shopId: o.shopId,
                            payloadJson: jsonEncode({
                              'status_index': picked.code,
                              'display_order_no': o.displayOrderNo,
                              'updated_at':
                                  DateTime.now().toUtc().toIso8601String(),
                            }),
                          );
                          final notifRepo = await ref.read(
                            appNotificationRepositoryProvider.future,
                          );
                          final shopForNotif =
                              ref.read(authSessionProvider).shopId?.trim();
                          final notifShopId =
                              (shopForNotif != null && shopForNotif.isNotEmpty)
                                  ? shopForNotif
                                  : kDevShopId;
                          final notifId = const Uuid().v4();
                          final title =
                              l10n.notifOrderStatusTitle(o.displayOrderNo);
                          final body = l10n.notifOrderStatusBody(
                            orderStatusLabel(picked, l10n),
                          );
                          await notifRepo.append(
                            shopId: notifShopId,
                            title: title,
                            body: body,
                            relatedOrderInternalId: o.internalId,
                            internalId: notifId,
                          );
                          recordSyncOutboxMutation(
                            ref,
                            kind: SyncOutboxKinds.notificationAppend,
                            entityRef: notifId,
                            shopId: notifShopId,
                            payloadJson: jsonEncode({
                              'title': title,
                              'body': body,
                              'related_order_internal_id': o.internalId,
                              'created_at':
                                  DateTime.now().toUtc().toIso8601String(),
                            }),
                          );
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                l10n.ordersDetailStatusUpdated(
                                  orderStatusLabel(picked, l10n),
                                ),
                              ),
                            ),
                          );
                        }
                      : null,
                  child: Text(l10n.ordersDetailChangeStatus),
                ),
              ),
              if (editBlockedByLicense)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    l10n.licenseReadOnlyHint,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              if (statusLocked)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        l10n.ordersDetailLockedHint,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.ordersDetailLockedStillInternalNotes,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 8),
              ExpansionTile(
                title: Text(l10n.ordersDetailSectionCustomer),
                subtitle: Text(o.customerName),
                initiallyExpanded: true,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.person_outline),
                          title: Text(l10n.customerNameLabel),
                          subtitle: Text(o.customerName),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.phone_outlined),
                          title: Text(l10n.customerPhoneLabel),
                          subtitle: Text(
                            o.customerPhone ?? l10n.customersPhoneMissing,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                title: Text(l10n.ordersDetailSectionMeasurements),
                children: [
                  if (o.sourceMeasurementProfileLabel.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      child: Text(
                        l10n.ordersDetailMeasurementsFromProfile(
                          o.sourceMeasurementProfileLabel,
                        ),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: snapshotAsync.when(
                      data: (snap) {
                        final items = snap?.items ?? [];
                        if (items.isNotEmpty) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              for (final it in items)
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                  title: Text(it.typeName),
                                  trailing: Text(
                                    '${it.value.trim()}'
                                    '${MeasurementProfileFormatting.unitSuffix(it.unitCode)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium,
                                  ),
                                ),
                              if (o.measurementsSnapshot.trim().isNotEmpty) ...[
                                const Divider(height: 24),
                                Text(
                                  l10n.ordersDetailMeasurementsNotes,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(o.measurementsSnapshot),
                              ],
                            ],
                          );
                        }
                        return Text(
                          o.measurementsSnapshot.trim().isEmpty
                              ? l10n.ordersDetailSnapshotEmpty
                              : o.measurementsSnapshot,
                        );
                      },
                      loading: () => const LinearProgressIndicator(),
                      error: (e, _) => Text('$e'),
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                title: Text(l10n.ordersDetailSectionStyle),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Text(
                      o.styleNotes.trim().isEmpty
                          ? l10n.ordersDetailSnapshotEmpty
                          : o.styleNotes,
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                title: Text(l10n.ordersDetailSectionInternalNotes),
                subtitle: Text(
                  o.internalNotes.trim().isEmpty
                      ? l10n.ordersDetailSnapshotEmpty
                      : o.internalNotes,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          o.internalNotes.trim().isEmpty
                              ? l10n.ordersDetailSnapshotEmpty
                              : o.internalNotes,
                        ),
                        if (!editBlockedByLicense) ...[
                          const SizedBox(height: 12),
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: FilledButton.tonal(
                              onPressed: () => _editInternalNotes(
                                context,
                                ref,
                                l10n,
                                o,
                              ),
                              child: Text(l10n.editCta),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                title: Text(l10n.ordersDetailSectionPayments),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: _TotalsCard(
                      totalMinor: o.totalAmountMinor,
                      paidMinor: o.paidAmountMinor,
                      l10n: l10n,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        FilledButton.tonal(
                          onPressed: editBlockedByLicense
                              ? null
                              : () async {
                                  final amount =
                                      await _promptAmount(context, l10n);
                                  if (!context.mounted) return;
                                  if (amount == null) return;
                                  final paymentId = const Uuid().v4();
                                  final repo = await ref.read(
                                    paymentRepositoryProvider.future,
                                  );
                                  await repo.addPayment(
                                    shopId: o.shopId,
                                    orderInternalId: o.internalId,
                                    amountMinor: amount,
                                    method: 'cash',
                                    isAdjustment: false,
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
                                      'method': 'cash',
                                      'is_adjustment': false,
                                      'created_at': DateTime.now()
                                          .toUtc()
                                          .toIso8601String(),
                                    }),
                                  );
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(l10n.paymentAdded)),
                                  );
                                },
                          child: Text(l10n.addPaymentCta),
                        ),
                        FilledButton.tonal(
                          onPressed: editBlockedByLicense
                              ? null
                              : () async {
                                  final amount =
                                      await _promptSignedAmount(
                                    context,
                                    l10n,
                                    title: l10n.addAdjustmentCta,
                                    hint: l10n.paymentAdjustmentHint,
                                  );
                                  if (!context.mounted) return;
                                  if (amount == null) return;
                                  final paymentId = const Uuid().v4();
                                  final repo = await ref.read(
                                    paymentRepositoryProvider.future,
                                  );
                                  await repo.addPayment(
                                    shopId: o.shopId,
                                    orderInternalId: o.internalId,
                                    amountMinor: amount,
                                    method: 'adjustment',
                                    isAdjustment: true,
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
                                      'method': 'adjustment',
                                      'is_adjustment': true,
                                      'created_at': DateTime.now()
                                          .toUtc()
                                          .toIso8601String(),
                                    }),
                                  );
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        l10n.paymentAdjustmentAdded,
                                      ),
                                    ),
                                  );
                                },
                          child: Text(l10n.addAdjustmentCta),
                        ),
                      ],
                    ),
                  ),
                  asyncPayments.when(
                    data: (payments) {
                      if (payments.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Text(l10n.paymentsEmpty),
                        );
                      }
                      return Column(
                        children: [
                          for (final p in payments)
                            ListTile(
                              leading: const Icon(Icons.payments_outlined),
                              title: Wrap(
                                crossAxisAlignment:
                                    WrapCrossAlignment.center,
                                spacing: 8,
                                children: [
                                  Text(
                                    l10n.paymentAmount(
                                      p.amountMinor.toString(),
                                    ),
                                  ),
                                  if (p.isAdjustment)
                                    Chip(
                                      label: Text(
                                        l10n.paymentLedgerAdjustmentTag,
                                      ),
                                      visualDensity: VisualDensity.compact,
                                    ),
                                ],
                              ),
                              subtitle: Text(
                                '${p.method} · ${AppCalendarFormat.dateTimeMedium(l10n, calendar, p.createdAt, locale)}',
                              ),
                            ),
                        ],
                      );
                    },
                    loading: () => const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (e, _) => Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text('$e'),
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                title: Text(l10n.ordersDetailSectionAudit),
                children: [
                  asyncPayments.when(
                    data: (payments) => _OrderAuditSection(
                      o: o,
                      payments: payments,
                      l10n: l10n,
                      calendar: calendar,
                      locale: locale,
                    ),
                    loading: () => const Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (e, _) => Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Text('$e'),
                    ),
                  ),
                ],
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
          title: Text(l10n.ordersDetailTitle),
        ),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
          ),
          title: Text(l10n.ordersDetailTitle),
        ),
        body: Center(child: Text('$e')),
      ),
    );
  }
}

class _OrderAuditSection extends StatelessWidget {
  const _OrderAuditSection({
    required this.o,
    required this.payments,
    required this.l10n,
    required this.calendar,
    required this.locale,
  });

  final OrderSummary o;
  final List<PaymentSummary> payments;
  final AppLocalizations l10n;
  final DateCalendarSystem calendar;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final sorted = [...payments]
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    final paySubtitle = payments.isEmpty
        ? l10n.ordersAuditPaymentsEmpty
        : l10n.ordersAuditPaymentsLine(
            payments.length,
            AppCalendarFormat.dateTimeMedium(
              l10n,
              calendar,
              sorted.first.createdAt,
              locale,
            ),
            AppCalendarFormat.dateTimeMedium(
              l10n,
              calendar,
              sorted.last.createdAt,
              locale,
            ),
          );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.ordersDetailAuditIntro,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.fingerprint_outlined),
            title: Text(l10n.ordersAuditInternalId),
            subtitle: SelectableText(
              o.internalId,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            trailing: IconButton(
              tooltip: l10n.ordersAuditCopyIdTooltip,
              icon: const Icon(Icons.copy_outlined),
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: o.internalId));
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.ordersAuditCopiedId)),
                );
              },
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.schedule_outlined),
            title: Text(l10n.ordersAuditCreatedAt),
            subtitle: Text(
              AppCalendarFormat.dateTimeMedium(
                l10n,
                calendar,
                o.createdAt,
                locale,
              ),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.update_outlined),
            title: Text(l10n.ordersAuditUpdatedAt),
            subtitle: Text(
              AppCalendarFormat.dateTimeMedium(
                l10n,
                calendar,
                o.updatedAt,
                locale,
              ),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.flag_outlined),
            title: Text(l10n.ordersAuditStatus),
            subtitle: Text(orderStatusLabel(o.status, l10n)),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.event_outlined),
            title: Text(l10n.ordersAuditDelivery),
            subtitle: Text(
              AppCalendarFormat.mediumDate(
                l10n,
                calendar,
                o.deliveryDate,
                locale,
              ),
            ),
          ),
          const Divider(height: 24),
          Text(
            l10n.ordersAuditPaymentsTitle,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 4),
          Text(
            paySubtitle,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _TotalsCard extends StatelessWidget {
  const _TotalsCard({
    required this.totalMinor,
    required this.paidMinor,
    required this.l10n,
  });

  final int totalMinor;
  final int paidMinor;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final remaining = totalMinor - paidMinor;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _kv(l10n.paymentTotal, totalMinor.toString(), context),
            _kv(l10n.paymentPaid, paidMinor.toString(), context),
            _kv(l10n.paymentRemaining, remaining.toString(), context),
          ],
        ),
      ),
    );
  }

  Widget _kv(String k, String v, BuildContext context) {
    final style = Theme.of(context).textTheme.bodySmall;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(k, style: style),
        const SizedBox(height: 4),
        Text(v, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}
