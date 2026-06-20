import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/app/app_theme.dart';
import 'package:pride_v3/core/formatting/digit_normalizer.dart';
import 'package:pride_v3/core/widgets/pride_money_field.dart';
import 'package:pride_v3/core/widgets/pride_optional_field.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../auth/auth_providers.dart';
import '../../data/local/entities/garment_type.dart';
import '../../data/local/measurement_profile_summary.dart';
import '../../data/local/order_item_draft.dart';
import '../../data/local/order_item_summary.dart';
import '../../data/local/order_summary.dart';
import '../../data/local/style/style_order_selection.dart';
import '../../data/local/dev_shop_constants.dart';
import 'order_composer_fabric_panel.dart';
import 'order_composer_item_card.dart';
import 'order_composer_measurements_panel.dart';
import 'order_composer_style_sheet.dart';

/// Always-expanded per-garment receipt block (measurements, style, fabric, price).
class OrderComposerReceiptGarmentBlock extends ConsumerWidget {
  const OrderComposerReceiptGarmentBlock({
    super.key,
    required this.l10n,
    required this.garmentType,
    required this.draft,
    required this.styleSelection,
    required this.priceController,
    required this.onDraftChanged,
    required this.onStyleSelectionChanged,
    this.referenceOrder,
    this.referenceItem,
    this.onUsePreviousMeasurements,
    this.onUsePreviousStyle,
    this.onUsePreviousDesign,
    this.onUsePreviousFabric,
    this.onUseSameFabric,
    this.moneyFormatter,
    this.customerId,
    this.measurementProfiles = const [],
  });

  final AppLocalizations l10n;
  final GarmentType garmentType;
  final OrderItemDraft draft;
  final StyleOrderSelection styleSelection;
  final TextEditingController priceController;
  final ValueChanged<OrderItemDraft> onDraftChanged;
  final ValueChanged<StyleOrderSelection> onStyleSelectionChanged;
  final OrderSummary? referenceOrder;
  final OrderItemSummary? referenceItem;
  final VoidCallback? onUsePreviousMeasurements;
  final VoidCallback? onUsePreviousStyle;
  final VoidCallback? onUsePreviousDesign;
  final VoidCallback? onUsePreviousFabric;
  final VoidCallback? onUseSameFabric;
  final String Function(AppLocalizations l10n, int minor)? moneyFormatter;
  final String? customerId;
  final List<MeasurementProfileSummary> measurementProfiles;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = composerGarmentLabel(l10n, garmentType);
    final colorIndex = garmentType == GarmentType.perahanTunban ? 1 : 2;
    final shopId = effectiveShopIdFromAuth(ref.watch(authSessionProvider).shopId);

    return Card(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                PrideColoredLeading(
                  icon: garmentType == GarmentType.perahanTunban
                      ? Icons.checkroom_outlined
                      : Icons.layers_outlined,
                  color: prideSettingsIconColor(colorIndex),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              l10n.ordersComposerMeasurementsTitle,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            OrderComposerMeasurementsPanel(
              l10n: l10n,
              shopId: shopId,
              customerId: customerId,
              initialSnapshotText: draft.measurementsSnapshot,
              initialItems: draft.measurementSnapshotItems,
              initialProfileId: draft.sourceMeasurementProfileId,
              initialProfileLabel: draft.sourceMeasurementProfileLabel,
              profiles: measurementProfiles,
              referenceOrder: referenceOrder,
              referenceItem: referenceItem,
              onUsePreviousMeasurements: onUsePreviousMeasurements,
              moneyFormatter: moneyFormatter,
              onChanged: (result) {
                onDraftChanged(
                  draft.copyWith(
                    measurementsSnapshot: result.measurementsSnapshot,
                    measurementSnapshotItems: result.measurementSnapshotItems,
                    sourceMeasurementProfileId: result.sourceMeasurementProfileId,
                    sourceMeasurementProfileLabel:
                        result.sourceMeasurementProfileLabel,
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Text(
              l10n.ordersComposerStyleTitle,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            OrderComposerStylePanel(
              garmentType: garmentType,
              initialMainStyle: draft.styleName,
              initialStyleNameInternalId: draft.styleNameInternalId,
              initialSelection: styleSelection,
              initialCatalogItemInternalId: draft.catalogItemInternalId,
              initialCatalogDesignName: draft.catalogDesignName,
              initialCatalogDesignerShopName: draft.catalogDesignerShopName,
              initialCatalogImagePath: draft.catalogImagePath,
              initialCatalogThumbnailPath: draft.catalogThumbnailPath,
              referenceOrder: referenceOrder,
              referenceItem: referenceItem,
              onUsePreviousStyle: onUsePreviousStyle,
              onUsePreviousDesign: onUsePreviousDesign,
              moneyFormatter: moneyFormatter,
              initialStyleSummary: draft.styleSummary,
              embedded: true,
              onChanged: (result) {
                if (result == null) return;
                onStyleSelectionChanged(result.selection);
                onDraftChanged(
                  draft.copyWith(
                    styleName: result.mainStyleName,
                    styleNameInternalId: result.styleNameInternalId,
                    styleSelectionJson: result.selection.toJsonString(),
                    styleSummary: result.summary,
                    catalogItemInternalId: result.catalogItemInternalId,
                    catalogDesignName: result.catalogDesignName,
                    catalogDesignerShopName: result.catalogDesignerShopName,
                    catalogImagePath: result.catalogImagePath,
                    catalogThumbnailPath: result.catalogThumbnailPath,
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Text(
              l10n.ordersComposerFabricTitle,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            OrderComposerFabricPanel(
              l10n: l10n,
              initialName: draft.fabricName,
              initialColor: draft.fabricColor,
              initialFabricId: draft.fabricId,
              initialNamePresetId: draft.fabricNamePresetInternalId,
              initialColorPresetId: draft.fabricColorPresetInternalId,
              referenceOrder: referenceOrder,
              referenceItem: referenceItem,
              onUsePreviousFabric: onUsePreviousFabric,
              moneyFormatter: moneyFormatter,
              initialFabricSummary: draft.fabricName,
              onChanged: (result) {
                if (result == null) {
                  onDraftChanged(
                    draft.copyWith(
                      fabricName: '',
                      fabricColor: '',
                      fabricId: '',
                    ),
                  );
                  return;
                }
                onDraftChanged(
                  draft.copyWith(
                    fabricName: result.fabricName,
                    fabricColor: result.fabricColor,
                    fabricId: result.fabricId,
                    fabricNamePresetInternalId: result.fabricNamePresetInternalId,
                    fabricColorPresetInternalId: result.fabricColorPresetInternalId,
                  ),
                );
              },
            ),
            if (onUseSameFabric != null) ...[
              const SizedBox(height: 8),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton.icon(
                  onPressed: onUseSameFabric,
                  icon: const Icon(Icons.copy_outlined, size: 18),
                  label: Text(l10n.ordersComposerUseSameFabricCta),
                ),
              ),
            ],
            const SizedBox(height: 12),
            Text(
              l10n.ordersComposerItemPriceLabel,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            _ReceiptPriceField(
              l10n: l10n,
              controller: priceController,
            ),
          ],
        ),
      ),
    );
  }
}

class _ReceiptPriceField extends StatefulWidget {
  const _ReceiptPriceField({
    required this.l10n,
    required this.controller,
  });

  final AppLocalizations l10n;
  final TextEditingController controller;

  @override
  State<_ReceiptPriceField> createState() => _ReceiptPriceFieldState();
}

class _ReceiptPriceFieldState extends State<_ReceiptPriceField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_rebuild);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final isEmpty = tryParseMoneyAmount(widget.controller.text) == null ||
        (tryParseMoneyAmount(widget.controller.text) ?? 0) <= 0;
    return PrideOptionalPanel(
      isEmpty: isEmpty,
      padding: EdgeInsets.zero,
      child: PrideMoneyField(
        controller: widget.controller,
        labelText: widget.l10n.ordersComposerItemPriceLabel,
      ),
    );
  }
}
