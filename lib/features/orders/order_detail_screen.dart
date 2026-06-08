import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/core/formatting/app_number_format.dart';
import 'package:pride_v3/core/formatting/display_customer_no_format.dart';
import 'package:pride_v3/core/formatting/display_order_no_format.dart';
import 'package:pride_v3/core/calendar/app_calendar_format.dart';
import 'package:pride_v3/core/calendar/date_calendar_notifier.dart';
import 'package:pride_v3/core/calendar/date_calendar_system.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import 'package:pride_v3/app/app_theme.dart';
import 'package:pride_v3/core/widgets/pride_action_buttons.dart';
import 'package:pride_v3/core/widgets/pride_carved_section.dart';
import 'package:pride_v3/core/feedback/app_feedback.dart';

import 'package:uuid/uuid.dart';

import '../../auth/auth_providers.dart';
import '../../data/local/customer_display_no.dart';
import '../../data/local/customer_summary.dart';
import '../../data/local/dev_shop_constants.dart';
import '../../data/local/measurement_profile_formatting.dart';
import '../../data/local/order_summary.dart';
import '../../data/local/payment_summary.dart';
import '../../data/local/sync_outbox_kinds.dart';
import '../../data/local/entities/order_status.dart';
import '../../data/providers/local_data_providers.dart';
import '../../licensing/license_providers.dart';
import '../../core/printing/thermal_print_order.dart';
import '../../security/delete_by_typing_name.dart';
import '../../shell/shell_sync_providers.dart';
import '../catalog/catalog_item_image.dart';
import 'order_composer_screen.dart';
import 'order_detail_field_tile.dart';
import 'order_detail_hero_card.dart';
import 'order_detail_share_actions.dart';
import 'order_invoice_share.dart';
import 'order_payment_sheet.dart';
import 'order_status_label.dart';
import 'order_customer_fabric_panel.dart';
import 'order_style_figures_panel.dart';
import 'order_detail_edit_actions.dart';
import 'order_detail_edit_helpers.dart';
import 'order_payment_rules.dart';

/// Order details with collapsible sections (plan-12); data from local stream.
class OrderDetailScreen extends ConsumerWidget {
  const OrderDetailScreen({super.key, required this.orderId});

  final String orderId;

  Future<void> _deleteOrder(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    OrderSummary o,
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

    final ok = await confirmDeleteByTypingName(
      context,
      l10n: l10n,
      title: l10n.orderDeleteConfirmTitle,
      explanation: l10n.orderDeleteConfirmBody,
      expectedName: o.customerName.trim(),
    );
    if (!ok || !context.mounted) return;

    final shopId = ref.read(effectiveShopIdProvider);
    recordSyncOutboxMutation(
      ref,
      kind: SyncOutboxKinds.orderDelete,
      entityRef: o.internalId,
      shopId: shopId,
    );

    final repo = await ref.read(orderListRepositoryProvider.future);
    await repo.softDeleteOrder(o.internalId);

    if (!context.mounted) return;
    showAppFeedback(
      context,
      ref,
      kind: AppFeedbackKind.success,
      message: l10n.orderDeleted,
      deleted: true,
    );
    context.go('/app/orders');
  }

  Future<void> _editInternalNotes(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    OrderSummary o,
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
        actions: prideDialogCancelSave(
          context: ctx,
          onCancel: () => Navigator.of(ctx).pop(false),
          onConfirm: () => Navigator.of(ctx).pop(true),
          saveLabel: l10n.saveCta,
        ),
      ),
    );
    if (ok != true || !context.mounted) return;
    final text = controller.text;
    if (text == o.internalNotes) return;
    final confirmed = await confirmOrderFieldEdit(context, l10n);
    if (!context.mounted || !confirmed) return;
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
    showAppFeedback(
      context,
      ref,
      kind: AppFeedbackKind.success,
      message: l10n.ordersInternalNotesSaved,
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
              for (final s in OrderLocalStatus.values)
                if (s != current)
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
    String formatMoney(int minor) => AppNumberFormat.formatMoney(l10n, minor);

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
        final customers = ref.watch(customersListStreamProvider).valueOrNull ??
            const <CustomerSummary>[];
        CustomerSummary? linkedCustomer;
        for (final c in customers) {
          if (c.internalId == o.customerInternalId) {
            linkedCustomer = c;
            break;
          }
        }
        final customerIdDisplay =
            linkedCustomer != null &&
                    parseStoredDisplayCustomerNo(
                      linkedCustomer.displayCustomerNo,
                    ) >
                        0
                ? formatDisplayCustomerNo(linkedCustomer.displayCustomerNo)
                : null;
        final snapshotAsync =
            ref.watch(orderMeasurementSnapshotProvider(orderId));
        final editBlockedByLicense = ref.watch(licenseEditingBlockedProvider);
        final changeStatusEnabled = !editBlockedByLicense;
        final canEdit = !editBlockedByLicense;
        final asyncPayments = ref.watch(paymentsForOrderProvider(o.internalId));
        final paymentAmounts = asyncPayments.valueOrNull
            ?.map((p) => p.amountMinor)
            .toList();
        final paidMinor = OrderPaymentRules.effectivePaidMinor(
          orderSummaryPaidMinor: o.paidAmountMinor,
          paymentAmountsMinor: paymentAmounts,
        );
        final remainingMinor = OrderPaymentRules.remainingMinor(
          o.totalAmountMinor,
          paidMinor,
        );
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => context.pop(),
            ),
            title: Text(displayOrderNumberLabel(l10n, o.displayOrderNo)),
            actions: [
              if (!editBlockedByLicense)
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'delete') {
                      _deleteOrder(context, ref, l10n, o);
                    }
                  },
                  itemBuilder: (ctx) => [
                    PopupMenuItem(
                      value: 'delete',
                      child: Text(l10n.orderDeleteMenu),
                    ),
                  ],
                ),
              IconButton(
                icon: const Icon(Icons.share_outlined),
                tooltip: l10n.orderShareInvoiceTooltip,
                onPressed: () => shareOrderInvoice(
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
              if (GoRouterState.of(context).uri.queryParameters['fromNew'] ==
                  '1')
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: _FromNewBanner(orderId: o.internalId),
                ),
              OrderDetailHeroCard(
                order: o,
                paidAmountMinor: paidMinor,
                remainingAmountMinor: remainingMinor,
                l10n: l10n,
                locale: locale,
                calendar: calendar,
                formatMoney: formatMoney,
                onNewOrder: () => context.push(
                  orderComposerRoute(
                    customerId: o.customerInternalId,
                    referenceOrderId: o.internalId,
                  ),
                ),
              ),
              OrderDetailShareActions(
                order: o,
                payments: asyncPayments.asData?.value ?? const [],
                l10n: l10n,
                locale: locale,
                calendar: calendar,
                statusText: orderStatusLabel(o.status, l10n),
              ),
              PrideCarvedPanel(
                title: l10n.ordersDetailChangeStatus,
                subtitle: changeStatusEnabled
                    ? l10n.ordersDetailChangeStatusSubtitle
                    : l10n.licenseReadOnlyHint,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FilledButton(
                      style: prideButtonStyle(
                        context,
                        PrideButtonVariant.warning,
                      ),
                      onPressed: changeStatusEnabled
                          ? () async {
                              final picked =
                                  await _pickStatus(context, l10n, o.status);
                              if (!context.mounted) return;
                              if (picked == null || picked == o.status) {
                                return;
                              }

                              if (picked == OrderLocalStatus.cancelled) {
                                final cancelOk =
                                    await confirmOrderCancelByCustomerName(
                                  context,
                                  l10n,
                                  o.customerName,
                                );
                                if (!context.mounted || !cancelOk) return;
                              } else {
                                final statusOk = await confirmOrderStatusChange(
                                  context,
                                  l10n,
                                  orderStatusLabel(picked, l10n),
                                );
                                if (!context.mounted || !statusOk) return;
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
                                  'updated_at': DateTime.now()
                                      .toUtc()
                                      .toIso8601String(),
                                }),
                              );
                              final notifRepo = await ref.read(
                                appNotificationRepositoryProvider.future,
                              );
                              final shopForNotif =
                                  ref.read(authSessionProvider).shopId?.trim();
                              final notifShopId = (shopForNotif != null &&
                                      shopForNotif.isNotEmpty)
                                  ? shopForNotif
                                  : kDevShopId;
                              final notifId = const Uuid().v4();
                              final title = l10n.notifOrderStatusTitle(
                                formatDisplayOrderNo(o.displayOrderNo),
                              );
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
                                  'created_at': DateTime.now()
                                      .toUtc()
                                      .toIso8601String(),
                                }),
                              );
                              if (!context.mounted) return;
                              showAppFeedback(
                                context,
                                ref,
                                kind: AppFeedbackKind.success,
                                message: l10n.ordersDetailStatusUpdated(
                                  orderStatusLabel(picked, l10n),
                                ),
                              );
                            }
                          : null,
                      child: Text(l10n.ordersDetailChangeStatus),
                    ),
                  ],
                ),
              ),
              PrideCarvedSection(
                title: l10n.ordersDetailSectionCustomer,
                initiallyExpanded: true,
                trailing: orderDetailEditTrailing(
                  l10n: l10n,
                  onPressed: canEdit
                      ? () => orderDetailEditCustomer(context, ref, l10n, o)
                      : null,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    OrderDetailFieldTile(
                      icon: Icons.person_outline,
                      label: l10n.customerNameLabel,
                      value: o.customerName,
                    ),
                    if (customerIdDisplay != null)
                      OrderDetailFieldTile(
                        icon: Icons.badge_outlined,
                        label: l10n.customerIdLabel,
                        value: customerIdDisplay,
                      ),
                    OrderDetailFieldTile(
                      icon: Icons.phone_outlined,
                      label: l10n.customerPhoneLabel,
                      value: o.customerPhone ?? l10n.customersPhoneMissing,
                    ),
                    if (o.customerChangeHistory.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        l10n.ordersDetailCustomerHistoryTitle,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 6),
                      for (final h in o.customerChangeHistory)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text(
                            l10n.ordersDetailCustomerHistoryChange(
                              h.fromName,
                              h.fromPhone ?? l10n.customersPhoneMissing,
                              h.toName,
                              h.toPhone ?? l10n.customersPhoneMissing,
                            ),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                    ],
                  ],
                ),
              ),
              PrideCarvedSection(
                title: l10n.ordersDetailSectionMeasurements,
                subtitle: o.sourceMeasurementProfileLabel.isNotEmpty
                    ? o.sourceMeasurementProfileLabel
                    : null,
                trailing: orderDetailEditTrailing(
                  l10n: l10n,
                  onPressed: canEdit
                      ? () =>
                          orderDetailEditMeasurements(context, ref, l10n, o)
                      : null,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (o.sourceMeasurementProfileLabel.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          l10n.ordersDetailMeasurementsFromProfile(
                            o.sourceMeasurementProfileLabel,
                          ),
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                      ),
                    snapshotAsync.when(
                      data: (snap) {
                        final items = snap?.items ?? [];
                        if (items.isNotEmpty) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              for (var i = 0; i < items.length; i++)
                                _OrderDetailMeasurementRow(
                                  label: items[i].typeName,
                                  value:
                                      '${items[i].value.trim()}${MeasurementProfileFormatting.unitSuffix(items[i].unitCode)}',
                                  altBackground: i.isOdd,
                                ),
                            ],
                          );
                        }
                        return Text(
                          o.measurementsSnapshot.trim().isEmpty
                              ? l10n.ordersDetailSnapshotEmpty
                              : o.measurementsSnapshot,
                          style: Theme.of(context).textTheme.bodyMedium,
                        );
                      },
                      loading: () => const LinearProgressIndicator(),
                      error: (e, _) => Text('$e'),
                    ),
                  ],
                ),
              ),
              if (o.catalogDesignNameSnapshot.trim().isNotEmpty)
                PrideCarvedSection(
                  title: l10n.orderDetailCatalogDesignTitle,
                  subtitle: o.catalogDesignNameSnapshot.trim(),
                  trailing: orderDetailEditTrailing(
                    l10n: l10n,
                    onPressed: canEdit
                        ? () => orderDetailEditStyle(context, ref, l10n, o)
                        : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CatalogItemImage(
                          imagePath: o.catalogImagePathSnapshot ??
                              o.catalogThumbnailPathSnapshot,
                        ),
                      ),
                      const SizedBox(height: 10),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: prideFriendlyTileFill(
                            Theme.of(context).colorScheme,
                            variant: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Theme.of(context)
                                .colorScheme
                                .outlineVariant
                                .withValues(alpha: 0.55),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                            12,
                            10,
                            12,
                            10,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                o.catalogDesignNameSnapshot.trim(),
                                style:
                                    Theme.of(context).textTheme.titleMedium,
                              ),
                              if (o.catalogDesignerShopNameSnapshot
                                  .trim()
                                  .isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  o.catalogDesignerShopNameSnapshot.trim(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      if (o.catalogItemInternalId != null) ...[
                        const SizedBox(height: 8),
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: TextButton(
                            onPressed: () => context.push(
                              '/app/catalog/${o.catalogItemInternalId}',
                            ),
                            child: Text(l10n.catalogDetailTitle),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              PrideCarvedSection(
                title: l10n.ordersDetailSectionStyle,
                subtitle: o.styleName.trim().isNotEmpty
                    ? o.styleName.trim()
                    : l10n.ordersComposerStyleRequired,
                trailing: orderDetailEditTrailing(
                  l10n: l10n,
                  onPressed: canEdit
                      ? () => orderDetailEditStyle(context, ref, l10n, o)
                      : null,
                ),
                child: (o.styleName.trim().isNotEmpty ||
                        o.styleSummary.trim().isNotEmpty ||
                        o.styleSelectionJson.trim().isNotEmpty)
                    ? OrderStyleFiguresPanel(order: o)
                    : Text(
                        l10n.ordersDetailSnapshotEmpty,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
              ),
              PrideCarvedSection(
                title: l10n.orderDetailFabricTitle,
                subtitle: o.hasCustomerFabric
                    ? orderCustomerFabricSummaryLine(l10n, o)
                    : l10n.ordersComposerFabricUnset,
                trailing: orderDetailEditTrailing(
                  l10n: l10n,
                  onPressed: canEdit
                      ? () => orderDetailEditFabric(context, ref, l10n, o)
                      : null,
                ),
                child: o.hasCustomerFabric
                    ? OrderCustomerFabricPanel(order: o)
                    : Text(
                        l10n.ordersDetailSnapshotEmpty,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
              ),
              PrideCarvedSection(
                title: l10n.ordersComposerDeliveryDateTitle,
                trailing: orderDetailEditTrailing(
                  l10n: l10n,
                  onPressed: canEdit
                      ? () =>
                          orderDetailEditDeliveryDate(context, ref, l10n, o)
                      : null,
                ),
                child: OrderDetailFieldTile(
                  icon: Icons.event_outlined,
                  label: l10n.ordersComposerDeliveryDateTitle,
                  value: AppCalendarFormat.mediumDate(
                    l10n,
                    calendar,
                    o.deliveryDate,
                    locale,
                  ),
                  emphasizeValue: true,
                ),
              ),
              PrideCarvedSection(
                title: l10n.ordersDetailSectionInternalNotes,
                subtitle: o.internalNotes.trim().isEmpty
                    ? l10n.ordersDetailSnapshotEmpty
                    : null,
                initiallyExpanded: o.internalNotes.trim().isNotEmpty,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      o.internalNotes.trim().isEmpty
                          ? l10n.ordersDetailSnapshotEmpty
                          : o.internalNotes,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    if (canEdit) ...[
                      const SizedBox(height: 12),
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: FilledButton(
                          style: prideButtonStyle(
                            context,
                            PrideButtonVariant.edit,
                          ),
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
              PrideCarvedSection(
                title: l10n.ordersDetailSectionPayments,
                subtitle: l10n.ordersComposerPaymentSummary(
                  formatMoney(o.totalAmountMinor),
                  formatMoney(paidMinor),
                  formatMoney(remainingMinor),
                ),
                trailing: orderDetailEditTrailing(
                  l10n: l10n,
                  onPressed: canEdit
                      ? () => showOrderPaymentSavedSheet(
                            context: context,
                            ref: ref,
                            order: o,
                          )
                      : null,
                ),
                child: _TotalsCard(
                  totalMinor: o.totalAmountMinor,
                  paidMinor: paidMinor,
                  remainingMinor: remainingMinor,
                  l10n: l10n,
                  formatMoney: formatMoney,
                ),
              ),
              PrideCarvedSection(
                title: l10n.ordersDetailSectionAudit,
                initiallyExpanded: false,
                child: asyncPayments.when(
                  data: (payments) => _OrderAuditSection(
                    o: o,
                    payments: payments,
                    l10n: l10n,
                    calendar: calendar,
                    locale: locale,
                  ),
                  loading: () => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (e, _) => Text('$e'),
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

class _OrderAuditSection extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.ordersDetailAuditIntro,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 10),
        OrderDetailFieldTile(
          icon: Icons.fingerprint_outlined,
          label: l10n.ordersAuditInternalId,
          value: o.internalId,
          selectable: true,
          trailing: IconButton(
            tooltip: l10n.ordersAuditCopyIdTooltip,
            icon: const Icon(Icons.copy_outlined),
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: o.internalId));
              if (!context.mounted) return;
              showAppFeedback(
                context,
                ref,
                kind: AppFeedbackKind.info,
                message: l10n.ordersAuditCopiedId,
              );
            },
          ),
        ),
        OrderDetailFieldTile(
          icon: Icons.schedule_outlined,
          label: l10n.ordersAuditCreatedAt,
          value: AppCalendarFormat.dateTimeMedium(
            l10n,
            calendar,
            o.createdAt,
            locale,
          ),
        ),
        OrderDetailFieldTile(
          icon: Icons.update_outlined,
          label: l10n.ordersAuditUpdatedAt,
          value: AppCalendarFormat.dateTimeMedium(
            l10n,
            calendar,
            o.updatedAt,
            locale,
          ),
        ),
        OrderDetailFieldTile(
          icon: Icons.flag_outlined,
          label: l10n.ordersAuditStatus,
          value: orderStatusLabel(o.status, l10n),
        ),
        OrderDetailFieldTile(
          icon: Icons.event_outlined,
          label: l10n.ordersAuditDelivery,
          value: AppCalendarFormat.mediumDate(
            l10n,
            calendar,
            o.deliveryDate,
            locale,
          ),
        ),
        const Divider(height: 20),
        Text(
          l10n.ordersAuditPaymentsTitle,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          paySubtitle,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _TotalsCard extends StatelessWidget {
  const _TotalsCard({
    required this.totalMinor,
    required this.paidMinor,
    required this.remainingMinor,
    required this.l10n,
    required this.formatMoney,
  });

  final int totalMinor;
  final int paidMinor;
  final int remainingMinor;
  final AppLocalizations l10n;
  final String Function(int minor) formatMoney;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final remaining = remainingMinor;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: prideFriendlyTileFill(scheme, variant: 2),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.55),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: _kv(
                l10n.paymentTotal,
                formatMoney(totalMinor),
                context,
              ),
            ),
            Expanded(
              child: _kv(
                l10n.paymentPaid,
                formatMoney(paidMinor),
                context,
              ),
            ),
            Expanded(
              child: _kv(
                l10n.paymentRemaining,
                formatMoney(remaining),
                context,
                emphasize: remaining > 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _kv(
    String k,
    String v,
    BuildContext context, {
    bool emphasize = false,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          k,
          style: theme.textTheme.labelMedium?.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          v,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: emphasize ? FontWeight.w800 : FontWeight.w700,
            color: emphasize ? scheme.error : null,
          ),
        ),
      ],
    );
  }
}

class _OrderDetailMeasurementRow extends StatelessWidget {
  const _OrderDetailMeasurementRow({
    required this.label,
    required this.value,
    this.altBackground = false,
  });

  final String label;
  final String value;
  final bool altBackground;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: prideFriendlyTileFill(
            scheme,
            variant: altBackground ? 1 : 0,
          ),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: scheme.outlineVariant.withValues(alpha: 0.55),
          ),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(10, 8, 10, 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 3,
                  softWrap: true,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: Text(
                  value,
                  textAlign: TextAlign.end,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 3,
                  softWrap: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FromNewBanner extends StatefulWidget {
  const _FromNewBanner({required this.orderId});

  final String orderId;

  @override
  State<_FromNewBanner> createState() => _FromNewBannerState();
}

class _FromNewBannerState extends State<_FromNewBanner> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    if (!_visible) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final actions = Theme.of(context).extension<PrideActionColors>()!;
    return DecoratedBox(
      decoration: prideCarvedDecoration(scheme).copyWith(
        color: actions.addContainer,
        border: Border.all(color: actions.add.withValues(alpha: 0.35)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            Icon(Icons.celebration_outlined, color: actions.add),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.ordersDetailFromNewBanner,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: actions.onAddContainer,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.close, color: scheme.onSurfaceVariant),
              onPressed: () {
                setState(() => _visible = false);
                GoRouter.of(context).go('/app/orders/${widget.orderId}');
              },
            ),
          ],
        ),
      ),
    );
  }
}
