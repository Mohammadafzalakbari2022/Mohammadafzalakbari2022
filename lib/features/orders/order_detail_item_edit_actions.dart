import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/core/feedback/app_feedback.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../auth/auth_providers.dart';
import '../../data/local/dev_shop_constants.dart' show effectiveShopIdFromAuth;
import '../../data/local/entities/garment_type.dart';
import '../../data/local/measurement_profile_summary.dart';
import '../../data/local/order_item_input.dart';
import '../../data/local/order_item_snapshot_key.dart';
import '../../data/local/order_item_summary.dart';
import '../../data/local/order_measurement_snapshot_item_input.dart';
import '../../data/local/order_summary.dart';
import '../../data/local/style/style_order_selection.dart';
import '../../data/local/sync_outbox_kinds.dart';
import '../../data/providers/local_data_providers.dart';
import '../../licensing/license_providers.dart';
import '../../shell/shell_sync_providers.dart';
import 'order_composer_fabric_sheet.dart';
import 'order_composer_measurements_sheet.dart';
import 'order_composer_style_sheet.dart';
import 'order_detail_edit_helpers.dart';

Future<void> _applyItemUpdate(
  BuildContext context,
  WidgetRef ref,
  AppLocalizations l10n,
  OrderSummary order,
  OrderItemSummary item, {
  required Future<void> Function() patch,
  required Map<String, dynamic> syncPayload,
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
  final ok = await confirmOrderFieldEdit(context, l10n);
  if (!context.mounted || !ok) return;
  try {
    await patch();
  } on OrderItemRepositoryException catch (e) {
    if (!context.mounted) return;
    final message = switch (e.code) {
      'item_price_required' => l10n.ordersComposerItemPriceRequired,
      'order_total_below_paid' => l10n.ordersPaymentTotalBelowPaid,
      _ => l10n.genericError,
    };
    showAppFeedback(
      context,
      ref,
      kind: AppFeedbackKind.error,
      message: message,
    );
    return;
  } on StateError {
    if (!context.mounted) return;
    showAppFeedback(
      context,
      ref,
      kind: AppFeedbackKind.error,
      message: l10n.ordersPaymentTotalBelowPaid,
    );
    return;
  }
  final payload = {
    ...syncPayload,
    'garment_type': item.garmentType.apiKey,
    'updated_at': DateTime.now().toUtc().toIso8601String(),
  };
  recordSyncOutboxMutation(
    ref,
    kind: SyncOutboxKinds.orderUpdate,
    entityRef: order.internalId,
    shopId: order.shopId,
    payloadJson: jsonEncode(payload),
  );
  if (!context.mounted) return;
  showAppFeedback(
    context,
    ref,
    kind: AppFeedbackKind.success,
    message: l10n.ordersDetailStatusUpdated(l10n.ordersDetailEditCta),
  );
}

Future<void> orderDetailItemEditMeasurements(
  BuildContext context,
  WidgetRef ref,
  AppLocalizations l10n,
  OrderSummary order,
  OrderItemSummary item,
) async {
  final shopId = effectiveShopIdFromAuth(ref.read(authSessionProvider).shopId);
  final snapKey = OrderItemSnapshotKey(
    orderInternalId: order.internalId,
    orderItemInternalId: item.internalId,
  );
  final snap = await ref.read(orderItemMeasurementSnapshotProvider(snapKey).future);
  final initialItems = <OrderMeasurementSnapshotItemInput>[
    for (final it in snap?.items ?? [])
      OrderMeasurementSnapshotItemInput(
        measurementTypeInternalId: it.measurementTypeInternalId,
        typeName: it.typeName,
        value: it.value,
        unitCode: it.unitCode,
        sortOrder: it.sortOrder,
      ),
  ];
  final profiles = ref
          .read(measurementProfilesForCustomerProvider(order.customerInternalId))
          .valueOrNull ??
      const <MeasurementProfileSummary>[];

  if (!context.mounted) return;
  final r = await showOrderMeasurementsEditorSheet(
    context: context,
    ref: ref,
    l10n: l10n,
    shopId: shopId,
    customerId: order.customerInternalId,
    initialSnapshotText: item.measurementsSnapshot,
    initialItems: initialItems,
    initialProfileId: item.sourceMeasurementProfileId,
    initialProfileLabel: item.sourceMeasurementProfileLabel,
    profiles: profiles,
  );
  if (!context.mounted || r == null) return;

  final repo = await ref.read(orderListRepositoryProvider.future);
  if (!context.mounted) return;
  await _applyItemUpdate(
    context,
    ref,
    l10n,
    order,
    item,
    patch: () => repo.upsertOrderItem(
      orderInternalId: order.internalId,
      input: orderItemCreateInputFromSummary(
        item,
        measurementsSnapshot: r.measurementsSnapshot,
        sourceMeasurementProfileId: r.sourceMeasurementProfileId,
        sourceMeasurementProfileLabel: r.sourceMeasurementProfileLabel,
        measurementSnapshotItems: r.measurementSnapshotItems,
      ),
    ),
    syncPayload: {
      'measurements_snapshot': r.measurementsSnapshot,
      if (r.sourceMeasurementProfileId != null)
        'source_measurement_profile_id': r.sourceMeasurementProfileId,
      'source_measurement_profile_label': r.sourceMeasurementProfileLabel,
    },
  );
}

Future<void> orderDetailItemEditStyle(
  BuildContext context,
  WidgetRef ref,
  AppLocalizations l10n,
  OrderSummary order,
  OrderItemSummary item,
) async {
  final selection = StyleOrderSelection.fromJsonString(item.styleSelectionJson);
  final result = await showOrderComposerStyleSheet(
    context: context,
    ref: ref,
    garmentType: item.garmentType,
    initialMainStyle: item.styleName,
    initialStyleNameInternalId: item.styleNameInternalId,
    initialSelection: selection,
    initialCatalogItemInternalId: item.catalogItemInternalId,
    initialCatalogDesignName: item.catalogDesignNameSnapshot,
    initialCatalogDesignerShopName: item.catalogDesignerShopNameSnapshot,
    initialCatalogImagePath: item.catalogImagePathSnapshot,
    initialCatalogThumbnailPath: item.catalogThumbnailPathSnapshot,
  );
  if (!context.mounted || result == null) return;

  final repo = await ref.read(orderListRepositoryProvider.future);
  if (!context.mounted) return;
  await _applyItemUpdate(
    context,
    ref,
    l10n,
    order,
    item,
    patch: () => repo.upsertOrderItem(
      orderInternalId: order.internalId,
      input: orderItemCreateInputFromSummary(
        item,
        styleName: result.mainStyleName,
        styleNameInternalId: result.styleNameInternalId,
        styleSelectionJson: result.selection.toJsonString(),
        styleSummary: result.summary,
        catalogItemInternalId: result.catalogItemInternalId,
        catalogDesignNameSnapshot: result.catalogDesignName,
        catalogDesignerShopNameSnapshot: result.catalogDesignerShopName,
        catalogSourceImagePath: result.catalogImagePath,
        catalogSourceThumbnailPath: result.catalogThumbnailPath,
      ),
    ),
    syncPayload: {
      'style_name': result.mainStyleName,
      if (result.styleNameInternalId != null)
        'style_name_internal_id': result.styleNameInternalId,
      if (result.selection.selectedFigureIds.isNotEmpty)
        'style_selection_json': result.selection.toJsonString(),
      if (result.summary.trim().isNotEmpty) 'style_summary': result.summary,
      if (result.catalogItemInternalId != null)
        'catalog_item_internal_id': result.catalogItemInternalId,
      if (result.catalogDesignName.trim().isNotEmpty)
        'catalog_design_name_snapshot': result.catalogDesignName.trim(),
    },
  );
}

Future<void> orderDetailItemEditFabric(
  BuildContext context,
  WidgetRef ref,
  AppLocalizations l10n,
  OrderSummary order,
  OrderItemSummary item,
) async {
  final result = await showOrderComposerFabricSheet(
    context: context,
    initialName: item.fabricNameSnapshot,
    initialColor: item.fabricColorSnapshot,
    initialFabricId: item.fabricIdSnapshot,
    initialNamePresetId: item.fabricNamePresetInternalId,
    initialColorPresetId: item.fabricColorPresetInternalId,
  );
  if (!context.mounted) return;

  final repo = await ref.read(orderListRepositoryProvider.future);
  if (!context.mounted) return;
  if (result == null || result.isEmpty) {
    await _applyItemUpdate(
      context,
      ref,
      l10n,
      order,
      item,
      patch: () => repo.upsertOrderItem(
        orderInternalId: order.internalId,
        input: orderItemCreateInputFromSummary(
          item,
          fabricNameSnapshot: '',
          fabricColorSnapshot: '',
          fabricIdSnapshot: '',
          fabricNamePresetInternalId: '',
          fabricColorPresetInternalId: '',
        ),
      ),
      syncPayload: {
        'fabric_name': '',
        'fabric_color': '',
        'fabric_id': '',
      },
    );
    return;
  }

  await _applyItemUpdate(
    context,
    ref,
    l10n,
    order,
    item,
    patch: () => repo.upsertOrderItem(
      orderInternalId: order.internalId,
      input: orderItemCreateInputFromSummary(
        item,
        fabricNameSnapshot: result.fabricName,
        fabricColorSnapshot: result.fabricColor,
        fabricIdSnapshot: result.fabricId,
        fabricNamePresetInternalId: result.fabricNamePresetInternalId,
        fabricColorPresetInternalId: result.fabricColorPresetInternalId,
      ),
    ),
    syncPayload: {
      if (result.fabricName.trim().isNotEmpty)
        'fabric_name': result.fabricName.trim(),
      if (result.fabricColor.trim().isNotEmpty)
        'fabric_color': result.fabricColor.trim(),
      if (result.fabricId.trim().isNotEmpty) 'fabric_id': result.fabricId.trim(),
    },
  );
}
