import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/core/widgets/pride_money_field.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../auth/auth_providers.dart';
import '../../data/local/entities/garment_type.dart';
import '../../data/local/measurement_profile_summary.dart';
import '../../data/local/order_item_draft.dart';
import '../../data/local/order_item_summary.dart';
import '../../data/local/order_summary.dart';
import '../../data/local/dev_shop_constants.dart';
import '../../data/local/style/style_order_selection.dart';
import '../settings/composer_visibility_provider.dart';
import 'order_composer_fabric_panel.dart';
import 'order_composer_item_card.dart';
import 'order_composer_measurements_panel.dart';
import 'order_composer_style_sheet.dart';

/// Always-expanded per-garment receipt block (measurements, style, cloth, price).
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
    final shopId = effectiveShopIdFromAuth(ref.watch(authSessionProvider).shopId);
    final theme = Theme.of(context);
    final visibility = ref.watch(composerVisibilitySettingsProvider);
    final showStyleSection =
        visibility.showStyleName || visibility.showCatalogPicker;
    final showCloth = visibility.showClothBlock;

    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                composerGarmentIcon(garmentType),
                size: 20,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
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
          if (showStyleSection) ...[
            const SizedBox(height: 12),
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
              onUsePreviousStyle: visibility.showStyleName
                  ? onUsePreviousStyle
                  : null,
              onUsePreviousDesign: visibility.showCatalogPicker
                  ? onUsePreviousDesign
                  : null,
              moneyFormatter: moneyFormatter,
              initialStyleSummary: draft.styleSummary,
              embedded: true,
              showStyleName: visibility.showStyleName,
              showCatalogPicker: visibility.showCatalogPicker,
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
          ] else ...[
            const SizedBox(height: 12),
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
              moneyFormatter: moneyFormatter,
              initialStyleSummary: draft.styleSummary,
              embedded: true,
              showStyleName: false,
              showCatalogPicker: false,
              onChanged: (result) {
                if (result == null) return;
                onStyleSelectionChanged(result.selection);
                onDraftChanged(
                  draft.copyWith(
                    styleSelectionJson: result.selection.toJsonString(),
                    styleSummary: result.summary,
                  ),
                );
              },
            ),
          ],
          if (showCloth) ...[
            const SizedBox(height: 12),
            OrderComposerFabricPanel(
              l10n: l10n,
              initialName: draft.fabricName,
              initialColor: draft.fabricColor,
              initialFabricId: draft.fabricId,
              initialNamePresetId: draft.fabricNamePresetInternalId,
              initialColorPresetId: draft.fabricColorPresetInternalId,
              initialClothMeters: draft.clothMeters,
              initialClothPriceMinor: draft.clothPriceAmountMinor,
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
                      clothMeters: '',
                      clothPriceAmountMinor: 0,
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
                    clothMeters: result.clothMeters,
                    clothPriceAmountMinor: result.clothPriceAmountMinor,
                  ),
                );
              },
            ),
            if (onUseSameFabric != null) ...[
              const SizedBox(height: 4),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton.icon(
                  onPressed: onUseSameFabric,
                  icon: const Icon(Icons.copy_outlined, size: 18),
                  label: Text(l10n.ordersComposerUseSameFabricCta),
                ),
              ),
            ],
          ],
          const SizedBox(height: 8),
          _ReceiptPriceField(
            l10n: l10n,
            controller: priceController,
          ),
        ],
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
  Widget build(BuildContext context) {
    return PrideMoneyField(
      controller: widget.controller,
      labelText: widget.l10n.ordersComposerItemPriceLabel,
    );
  }
}
