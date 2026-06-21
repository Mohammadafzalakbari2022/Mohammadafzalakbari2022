import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/core/formatting/display_order_no_format.dart';
import 'package:pride_v3/core/feedback/app_feedback.dart';
import 'package:pride_v3/l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

import '../../auth/auth_providers.dart';
import '../../data/local/dev_shop_constants.dart';
import '../../data/local/entities/order_status.dart';
import '../../data/local/order_summary.dart';
import '../../data/local/sync_outbox_kinds.dart';
import '../../data/providers/local_data_providers.dart';
import '../../licensing/license_providers.dart';
import '../../shell/shell_sync_providers.dart';
import 'order_detail_edit_helpers.dart';
import 'order_status_label.dart';

Future<OrderLocalStatus?> showOrderListStatusPicker({
  required BuildContext context,
  required AppLocalizations l10n,
  required OrderLocalStatus current,
}) {
  return showModalBottomSheet<OrderLocalStatus>(
    context: context,
    showDragHandle: true,
    builder: (ctx) {
      return SafeArea(
        child: SingleChildScrollView(
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
                    onTap: () => Navigator.of(ctx).pop(s),
                  ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> changeOrderStatusFromList({
  required BuildContext context,
  required WidgetRef ref,
  required AppLocalizations l10n,
  required OrderSummary order,
}) async {
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

  final picked = await showOrderListStatusPicker(
    context: context,
    l10n: l10n,
    current: order.status,
  );
  if (!context.mounted || picked == null || picked == order.status) return;

  if (picked == OrderLocalStatus.cancelled) {
    final cancelOk = await confirmOrderCancelByCustomerName(
      context,
      l10n,
      order.customerName,
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

  final repo = await ref.read(orderListRepositoryProvider.future);
  await repo.updateOrderStatus(
    orderInternalId: order.internalId,
    newStatus: picked,
  );
  recordSyncOutboxMutation(
    ref,
    kind: SyncOutboxKinds.orderStatus,
    entityRef: order.internalId,
    shopId: order.shopId,
    payloadJson: jsonEncode({
      'status_index': picked.code,
      'display_order_no': order.displayOrderNo,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    }),
  );
  final notifRepo = await ref.read(appNotificationRepositoryProvider.future);
  final shopForNotif = ref.read(authSessionProvider).shopId?.trim();
  final notifShopId = (shopForNotif != null && shopForNotif.isNotEmpty)
      ? shopForNotif
      : kDevShopId;
  final notifId = const Uuid().v4();
  await notifRepo.append(
    shopId: notifShopId,
    title: l10n.notifOrderStatusTitle(
      formatDisplayOrderNo(order.displayOrderNo),
    ),
    body: l10n.notifOrderStatusBody(orderStatusLabel(picked, l10n)),
    relatedOrderInternalId: order.internalId,
    internalId: notifId,
  );
  recordSyncOutboxMutation(
    ref,
    kind: SyncOutboxKinds.notificationAppend,
    entityRef: notifId,
    shopId: notifShopId,
    payloadJson: jsonEncode({
      'title': l10n.notifOrderStatusTitle(
        formatDisplayOrderNo(order.displayOrderNo),
      ),
      'body': l10n.notifOrderStatusBody(orderStatusLabel(picked, l10n)),
      'related_order_internal_id': order.internalId,
    }),
  );
  if (!context.mounted) return;
  showAppFeedback(
    context,
    ref,
    kind: AppFeedbackKind.success,
    message: l10n.ordersDetailStatusUpdated(orderStatusLabel(picked, l10n)),
  );
}
