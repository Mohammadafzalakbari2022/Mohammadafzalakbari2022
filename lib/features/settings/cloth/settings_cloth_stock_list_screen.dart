import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/app/app_theme.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../../auth/auth_providers.dart';
import '../../../data/local/dev_shop_constants.dart';
import '../../../data/local/cloth_stock_models.dart';
import '../../../data/providers/local_data_providers.dart';
import '../../../licensing/license_providers.dart';
import '../cloth/cloth_sync_helpers.dart';

class SettingsClothStockListScreen extends ConsumerWidget {
  const SettingsClothStockListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final skusAsync = ref.watch(clothStockSkusStreamProvider);
    final canEdit = !ref.watch(licenseEditingBlockedProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.settingsClothStockTitle),
      ),
      floatingActionButton: canEdit
          ? FloatingActionButton(
              onPressed: () => context.push('/app/settings/fabric/stock/new'),
              child: const Icon(Icons.add),
            )
          : null,
      body: skusAsync.when(
        data: (skus) {
          if (skus.isEmpty) {
            return Center(child: Text(l10n.settingsClothStockEmpty));
          }
          return ListView.separated(
            itemCount: skus.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final sku = skus[index];
              return ListTile(
                leading: PrideColoredLeading(
                  icon: Icons.inventory_2_outlined,
                  color: sku.isShortStock
                      ? Theme.of(context).colorScheme.error
                      : prideSettingsIconColor(2),
                ),
                title: Text(sku.name),
                subtitle: Text(
                  '${sku.skuCode} · ${l10n.settingsClothStockQtyLabel}: ${formatMilliMeters(sku.qtyOnHandMilli)}',
                ),
                trailing: sku.isShortStock
                    ? Icon(Icons.warning_amber, color: Theme.of(context).colorScheme.error)
                    : const Icon(Icons.chevron_right),
                onTap: canEdit
                    ? () => context.push('/app/settings/fabric/stock/${sku.internalId}')
                    : null,
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
      ),
    );
  }
}

class SettingsClothStockFormScreen extends ConsumerStatefulWidget {
  const SettingsClothStockFormScreen({super.key, this.skuId});

  final String? skuId;

  @override
  ConsumerState<SettingsClothStockFormScreen> createState() =>
      _SettingsClothStockFormScreenState();
}

class _SettingsClothStockFormScreenState
    extends ConsumerState<SettingsClothStockFormScreen> {
  final _codeCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _colorCtrl = TextEditingController();
  bool _loaded = false;

  @override
  void dispose() {
    _codeCtrl.dispose();
    _nameCtrl.dispose();
    _colorCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadExisting() async {
    if (_loaded || widget.skuId == null) {
      _loaded = true;
      return;
    }
    final repo = await ref.read(clothStockRepositoryProvider.future);
    final sku = await repo.getSku(widget.skuId!);
    if (sku != null && mounted) {
      _codeCtrl.text = sku.skuCode;
      _nameCtrl.text = sku.name;
      _colorCtrl.text = sku.color;
    }
    _loaded = true;
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;
    final shopId = effectiveShopIdFromAuth(ref.read(authSessionProvider).shopId);
    final id = widget.skuId ?? DateTime.now().microsecondsSinceEpoch.toString();
    final repo = await ref.read(clothStockRepositoryProvider.future);
    await repo.upsertSku(
      shopId: shopId,
      internalId: id,
      skuCode: _codeCtrl.text.trim(),
      name: name,
      color: _colorCtrl.text.trim(),
    );
    enqueueClothSkuUpsert(
      ref,
      internalId: id,
      skuCode: _codeCtrl.text.trim(),
      name: name,
      color: _colorCtrl.text.trim(),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.shopFinanceSave)),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FutureBuilder<void>(
      future: _loadExisting(),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
            title: Text(l10n.settingsClothStockTitle),
            actions: [
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: _save,
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextField(
                controller: _codeCtrl,
                decoration: InputDecoration(
                  labelText: l10n.clothStockSkuCodeLabel,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _nameCtrl,
                decoration: InputDecoration(
                  labelText: l10n.clothStockSkuNameLabel,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _colorCtrl,
                decoration: InputDecoration(
                  labelText: l10n.ordersComposerFabricColorLabel,
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
