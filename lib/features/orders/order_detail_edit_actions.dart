import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/core/calendar/app_date_picker.dart';
import 'package:pride_v3/core/calendar/date_calendar_notifier.dart';
import 'package:pride_v3/core/feedback/app_feedback.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../auth/auth_providers.dart';
import '../../data/local/dev_shop_constants.dart' show effectiveShopIdFromAuth;
import '../../data/local/measurement_profile_summary.dart';
import '../../data/local/order_measurement_snapshot_item_input.dart';
import '../../data/local/order_summary.dart';
import '../../data/local/style/style_order_selection.dart';
import '../../data/local/sync_outbox_kinds.dart';
import '../../data/providers/local_data_providers.dart';
import '../../licensing/license_providers.dart';
import '../../shell/shell_sync_providers.dart';
import 'order_composer_fabric_sheet.dart';
import 'order_detail_customer_edit_sheet.dart';
import 'order_composer_measurements_sheet.dart';
import 'order_composer_style_sheet.dart';
import 'order_detail_edit_helpers.dart';

Widget orderDetailEditTrailing({
  required AppLocalizations l10n,
  required VoidCallback? onPressed,
}) {
  if (onPressed == null) return const SizedBox.shrink();
  return IconButton(
    icon: const Icon(Icons.edit_outlined),
    tooltip: l10n.ordersDetailEditCta,
    onPressed: onPressed,
  );
}

Future<void> _applyOrderUpdate(
  BuildContext context,
  WidgetRef ref,
  AppLocalizations l10n,
  OrderSummary o, {
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
    'updated_at': DateTime.now().toUtc().toIso8601String(),
  };
  recordSyncOutboxMutation(
    ref,
    kind: SyncOutboxKinds.orderUpdate,
    entityRef: o.internalId,
    shopId: o.shopId,
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

Future<void> orderDetailEditCustomer(
  BuildContext context,
  WidgetRef ref,
  AppLocalizations l10n,
  OrderSummary o,
) async {
  var customers = ref.read(customersListStreamProvider).valueOrNull;
  if (customers == null) {
    await ref.read(customersListStreamProvider.future);
    if (!context.mounted) return;
    customers = ref.read(customersListStreamProvider).valueOrNull;
  }
  final list = customers ?? const [];

  final edited = await showOrderDetailCustomerEditSheet(
    context: context,
    l10n: l10n,
    order: o,
    customers: list,
  );
  if (!context.mounted || edited == null) return;

  final sameId = edited.customerInternalId == o.customerInternalId;
  final sameName = edited.name.trim() == o.customerName.trim();
  final samePhone = (edited.phone ?? '').trim() ==
      (o.customerPhone ?? '').trim();
  if (sameId && sameName && samePhone) return;

  if (!context.mounted) return;
  final repo = await ref.read(orderListRepositoryProvider.future);
  if (!context.mounted) return;

  final payload = <String, dynamic>{
    'customer_internal_id': edited.customerInternalId,
    'customer_snapshot_name': edited.name.trim(),
    if (edited.phone != null && edited.phone!.trim().isNotEmpty)
      'customer_snapshot_phone': edited.phone!.trim(),
    'updated_at': DateTime.now().toUtc().toIso8601String(),
  };

  await _applyOrderUpdate(
    context,
    ref,
    l10n,
    o,
    patch: () => repo.updateOrderDetails(
      orderInternalId: o.internalId,
      customerInternalId: edited.customerInternalId,
      customerSnapshotName: edited.name,
      customerSnapshotPhone: edited.phone ?? '',
    ),
    syncPayload: payload,
  );
}

Future<void> orderDetailEditMeasurements(
  BuildContext context,
  WidgetRef ref,
  AppLocalizations l10n,
  OrderSummary o,
) async {
  final shopId = effectiveShopIdFromAuth(ref.read(authSessionProvider).shopId);
  final snap =
      await ref.read(orderMeasurementSnapshotProvider(o.internalId).future);
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
          .read(measurementProfilesForCustomerProvider(o.customerInternalId))
          .valueOrNull ??
      const <MeasurementProfileSummary>[];

  if (!context.mounted) return;
  final r = await showOrderMeasurementsEditorSheet(
    context: context,
    ref: ref,
    l10n: l10n,
    shopId: shopId,
    customerId: o.customerInternalId,
    initialSnapshotText: o.measurementsSnapshot,
    initialItems: initialItems,
    initialProfileId: o.sourceMeasurementProfileId,
    initialProfileLabel: o.sourceMeasurementProfileLabel,
    profiles: profiles,
  );
  if (!context.mounted || r == null) return;

  final repo = await ref.read(orderListRepositoryProvider.future);
  if (!context.mounted) return;
  await _applyOrderUpdate(
    context,
    ref,
    l10n,
    o,
    patch: () => repo.updateOrderDetails(
      orderInternalId: o.internalId,
      measurementsSnapshot: r.measurementsSnapshot,
      sourceMeasurementProfileId: r.sourceMeasurementProfileId,
      sourceMeasurementProfileLabel: r.sourceMeasurementProfileLabel,
      measurementSnapshotItems: r.measurementSnapshotItems,
    ),
    syncPayload: {
      'measurements_snapshot': r.measurementsSnapshot,
      if (r.sourceMeasurementProfileId != null)
        'source_measurement_profile_id': r.sourceMeasurementProfileId,
      'source_measurement_profile_label': r.sourceMeasurementProfileLabel,
    },
  );
}

Future<void> orderDetailEditStyle(
  BuildContext context,
  WidgetRef ref,
  AppLocalizations l10n,
  OrderSummary o,
) async {
  final selection = StyleOrderSelection.fromJsonString(o.styleSelectionJson);
  final result = await showOrderComposerStyleSheet(
    context: context,
    ref: ref,
    initialMainStyle: o.styleName,
    initialStyleNameInternalId: o.styleNameInternalId,
    initialSelection: selection,
    initialCatalogItemInternalId: o.catalogItemInternalId,
    initialCatalogDesignName: o.catalogDesignNameSnapshot,
    initialCatalogDesignerShopName: o.catalogDesignerShopNameSnapshot,
    initialCatalogImagePath: o.catalogImagePathSnapshot,
    initialCatalogThumbnailPath: o.catalogThumbnailPathSnapshot,
  );
  if (!context.mounted || result == null) return;

  final repo = await ref.read(orderListRepositoryProvider.future);
  if (!context.mounted) return;
  await _applyOrderUpdate(
    context,
    ref,
    l10n,
    o,
    patch: () => repo.updateOrderDetails(
      orderInternalId: o.internalId,
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

Future<void> orderDetailEditFabric(
  BuildContext context,
  WidgetRef ref,
  AppLocalizations l10n,
  OrderSummary o,
) async {
  final result = await showOrderComposerFabricSheet(
    context: context,
    initialName: o.fabricNameSnapshot,
    initialColor: o.fabricColorSnapshot,
    initialFabricId: o.fabricIdSnapshot,
    initialNamePresetId: o.fabricNamePresetInternalId,
    initialColorPresetId: o.fabricColorPresetInternalId,
  );
  if (!context.mounted) return;

  final repo = await ref.read(orderListRepositoryProvider.future);
  if (!context.mounted) return;
  if (result == null || result.isEmpty) {
    await _applyOrderUpdate(
      context,
      ref,
      l10n,
      o,
      patch: () => repo.updateOrderDetails(
        orderInternalId: o.internalId,
        fabricNameSnapshot: '',
        fabricColorSnapshot: '',
        fabricIdSnapshot: '',
        fabricNamePresetInternalId: '',
        fabricColorPresetInternalId: '',
      ),
      syncPayload: {
        'fabric_name': '',
        'fabric_color': '',
        'fabric_id': '',
      },
    );
    return;
  }

  await _applyOrderUpdate(
    context,
    ref,
    l10n,
    o,
    patch: () => repo.updateOrderDetails(
      orderInternalId: o.internalId,
      fabricNameSnapshot: result.fabricName,
      fabricColorSnapshot: result.fabricColor,
      fabricIdSnapshot: result.fabricId,
      fabricNamePresetInternalId: result.fabricNamePresetInternalId,
      fabricColorPresetInternalId: result.fabricColorPresetInternalId,
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

Future<void> orderDetailEditDeliveryDate(
  BuildContext context,
  WidgetRef ref,
  AppLocalizations l10n,
  OrderSummary o,
) async {
  final now = DateTime.now();
  final calendar = ref.read(dateCalendarSystemProvider);
  final picked = await showAppDatePicker(
    context: context,
    l10n: l10n,
    system: calendar,
    initialDate: o.deliveryDate,
    firstDate: DateTime(now.year - 1),
    lastDate: DateTime(now.year + 3),
  );
  if (!context.mounted || picked == null || picked == o.deliveryDate) return;

  final repo = await ref.read(orderListRepositoryProvider.future);
  if (!context.mounted) return;
  await _applyOrderUpdate(
    context,
    ref,
    l10n,
    o,
    patch: () => repo.updateOrderDetails(
      orderInternalId: o.internalId,
      deliveryDate: picked,
    ),
    syncPayload: {'delivery_date': picked.toUtc().toIso8601String()},
  );
}
