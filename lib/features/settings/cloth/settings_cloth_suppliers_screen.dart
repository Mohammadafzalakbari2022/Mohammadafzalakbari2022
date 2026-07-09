import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/app/app_theme.dart';
import 'package:pride_v3/core/widgets/pride_action_buttons.dart';
import 'package:pride_v3/l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

import '../../../auth/auth_providers.dart';
import '../../../data/local/dev_shop_constants.dart';
import '../../../data/providers/local_data_providers.dart';
import '../../../licensing/license_providers.dart';
import 'cloth_sync_helpers.dart';

class SettingsClothSuppliersScreen extends ConsumerWidget {
  const SettingsClothSuppliersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final suppliersAsync = ref.watch(clothSuppliersStreamProvider);
    final canEdit = !ref.watch(licenseEditingBlockedProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.settingsClothSuppliersTitle),
      ),
      floatingActionButton: canEdit
          ? FloatingActionButton(
              onPressed: () => _showSupplierDialog(context, ref, l10n),
              child: const Icon(Icons.add),
            )
          : null,
      body: suppliersAsync.when(
        data: (suppliers) {
          if (suppliers.isEmpty) {
            return Center(child: Text(l10n.settingsClothSuppliersEmpty));
          }
          return ListView.separated(
            itemCount: suppliers.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final s = suppliers[index];
              return ListTile(
                leading: PrideColoredLeading(
                  icon: Icons.local_shipping_outlined,
                  color: prideSettingsIconColor(5),
                ),
                title: Text(s.name),
                subtitle: s.phone.trim().isNotEmpty ? Text(s.phone) : null,
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
      ),
    );
  }

  Future<void> _showSupplierDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.settingsClothSupplierAddCta),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(
                labelText: l10n.settingsClothSupplierNameLabel,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: phoneCtrl,
              decoration: InputDecoration(
                labelText: l10n.settingsClothSupplierPhoneLabel,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: prideDialogCancelSave(
          context: ctx,
          onCancel: () => Navigator.pop(ctx, false),
          onConfirm: () => Navigator.pop(ctx, true),
          saveLabel: l10n.saveCta,
        ),
      ),
    );
    final name = nameCtrl.text.trim();
    final phone = phoneCtrl.text.trim();
    nameCtrl.dispose();
    phoneCtrl.dispose();
    if (ok != true || name.isEmpty) return;
    final shopId = effectiveShopIdFromAuth(ref.read(authSessionProvider).shopId);
    final id = const Uuid().v4();
    final repo = await ref.read(clothStockRepositoryProvider.future);
    await repo.upsertSupplier(
      shopId: shopId,
      internalId: id,
      name: name,
      phone: phone,
    );
    enqueueClothSupplierUpsert(
      ref,
      internalId: id,
      name: name,
      phone: phone,
    );
  }
}
