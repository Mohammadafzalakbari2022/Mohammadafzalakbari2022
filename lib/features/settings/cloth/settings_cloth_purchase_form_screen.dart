import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/core/calendar/app_date_picker.dart';
import 'package:pride_v3/l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

import '../../../auth/auth_providers.dart';
import '../../../data/local/dev_shop_constants.dart';
import '../../../core/calendar/date_calendar_notifier.dart';
import '../../../core/calendar/date_calendar_system.dart';
import '../../../data/local/cloth_stock_models.dart';
import '../../../data/providers/local_data_providers.dart';
import 'cloth_sync_helpers.dart';

class SettingsClothPurchaseFormScreen extends ConsumerStatefulWidget {
  const SettingsClothPurchaseFormScreen({super.key});

  @override
  ConsumerState<SettingsClothPurchaseFormScreen> createState() =>
      _SettingsClothPurchaseFormScreenState();
}

class _LineDraft {
  _LineDraft({required this.skuInternalId});

  String skuInternalId;
  final qtyCtrl = TextEditingController();
  final costCtrl = TextEditingController();
}

class _SettingsClothPurchaseFormScreenState
    extends ConsumerState<SettingsClothPurchaseFormScreen> {
  String? _supplierId;
  DateTime _purchaseDate = DateTime.now();
  final _lines = <_LineDraft>[];

  @override
  void dispose() {
    for (final line in _lines) {
      line.qtyCtrl.dispose();
      line.costCtrl.dispose();
    }
    super.dispose();
  }

  void _addLine() {
    setState(() {
      _lines.add(_LineDraft(skuInternalId: ''));
    });
  }

  Future<void> _save() async {
    if (_supplierId == null || _supplierId!.isEmpty) return;
    final lineInputs = <ClothPurchaseLineInput>[];
    for (final line in _lines) {
      final qtyMilli = parseMetersToMilli(line.qtyCtrl.text);
      final cost = int.tryParse(line.costCtrl.text.trim()) ?? 0;
      if (line.skuInternalId.isEmpty || qtyMilli <= 0 || cost <= 0) continue;
      lineInputs.add(
        ClothPurchaseLineInput(
          skuInternalId: line.skuInternalId,
          qtyMilli: qtyMilli,
          unitCostAmountMinor: cost,
        ),
      );
    }
    if (lineInputs.isEmpty) return;
    final shopId = effectiveShopIdFromAuth(ref.read(authSessionProvider).shopId);
    final id = const Uuid().v4();
    final repo = await ref.read(clothStockRepositoryProvider.future);
    await repo.upsertPurchase(
      shopId: shopId,
      input: ClothPurchaseUpsertInput(
        internalId: id,
        supplierInternalId: _supplierId!,
        purchaseDate: _purchaseDate,
        lines: lineInputs,
      ),
    );
    enqueueClothPurchaseUpsert(
      ref,
      internalId: id,
      supplierInternalId: _supplierId!,
      purchaseDate: _purchaseDate,
      lines: lineInputs
          .map(
            (l) => {
              'sku_internal_id': l.skuInternalId,
              'qty_milli': l.qtyMilli,
              'unit_cost_amount_minor': l.unitCostAmountMinor,
            },
          )
          .toList(),
    );
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final calendar = ref.watch(dateCalendarSystemProvider);
    final suppliers = ref.watch(clothSuppliersStreamProvider).valueOrNull ?? [];
    final skus = ref.watch(clothStockSkusStreamProvider).valueOrNull ?? [];
    if (_lines.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_lines.isEmpty && mounted) _addLine();
      });
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.settingsClothPurchaseAddCta),
        actions: [
          IconButton(icon: const Icon(Icons.check), onPressed: _save),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<String>(
            value: _supplierId,
            decoration: InputDecoration(
              labelText: l10n.settingsClothPurchaseSupplierLabel,
              border: const OutlineInputBorder(),
            ),
            items: [
              for (final s in suppliers)
                DropdownMenuItem(value: s.internalId, child: Text(s.name)),
            ],
            onChanged: (v) => setState(() => _supplierId = v),
          ),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.settingsClothPurchaseDateLabel),
            subtitle: Text(_purchaseDate.toString().split(' ').first),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final picked = await showAppDatePicker(
                context: context,
                l10n: l10n,
                system: calendar,
                initialDate: _purchaseDate,
                firstDate: DateTime(DateTime.now().year - 5),
                lastDate: DateTime(DateTime.now().year + 1),
              );
              if (picked != null) setState(() => _purchaseDate = picked);
            },
          ),
          const Divider(height: 24),
          for (var i = 0; i < _lines.length; i++) ...[
            DropdownButtonFormField<String>(
              value: _lines[i].skuInternalId.isEmpty ? null : _lines[i].skuInternalId,
              decoration: InputDecoration(
                labelText: l10n.clothStockSkuLabel,
                border: const OutlineInputBorder(),
              ),
              items: [
                for (final sku in skus)
                  DropdownMenuItem(
                    value: sku.internalId,
                    child: Text(sku.name),
                  ),
              ],
              onChanged: (v) => setState(() => _lines[i].skuInternalId = v ?? ''),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _lines[i].qtyCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: l10n.settingsClothPurchaseLineQtyLabel,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _lines[i].costCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.settingsClothPurchaseLineCostLabel,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
          ],
          OutlinedButton.icon(
            onPressed: _addLine,
            icon: const Icon(Icons.add),
            label: Text(l10n.settingsClothPurchaseAddCta),
          ),
        ],
      ),
    );
  }
}
