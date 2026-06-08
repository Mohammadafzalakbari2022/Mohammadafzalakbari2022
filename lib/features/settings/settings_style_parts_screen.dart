import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/app/app_theme.dart';
import 'package:pride_v3/core/widgets/pride_action_buttons.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/local/entities/garment_type.dart';
import '../../data/local/style/style_part_section_label.dart';
import '../../data/providers/local_data_providers.dart';
import '../../auth/auth_providers.dart';
import '../../licensing/license_providers.dart';
import 'style/settings_style_garment_provider.dart';
import 'style/settings_style_garment_selector.dart';
import 'style/style_sync_helpers.dart';

Future<void> _showPartNameDialog({
  required BuildContext context,
  required AppLocalizations l10n,
  required String title,
  String initial = '',
  required ValueChanged<String> onSubmit,
}) async {
  final ctrl = TextEditingController(text: initial);
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: ctrl,
        decoration: InputDecoration(
          labelText: l10n.settingsStylePartFieldLabel,
          border: const OutlineInputBorder(),
        ),
        autofocus: true,
        onSubmitted: (_) => Navigator.pop(ctx, true),
      ),
      actions: prideDialogCancelSave(
        context: ctx,
        onCancel: () => Navigator.pop(ctx, false),
        onConfirm: () => Navigator.pop(ctx, true),
        saveLabel: l10n.saveCta,
      ),
    ),
  );
  final text = ctrl.text.trim();
  ctrl.dispose();
  if (ok == true && text.isNotEmpty) onSubmit(text);
}

class SettingsStylePartsScreen extends ConsumerWidget {
  const SettingsStylePartsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final garment = ref.watch(settingsStyleGarmentProvider);
    final partsAsync = ref.watch(stylePartsForGarmentProvider(garment));
    final canEdit = !ref.watch(licenseEditingBlockedProvider);
    final emptyMessage = garment == GarmentType.waistcoat
        ? l10n.settingsStyleWaistcoatEmptyTitle
        : l10n.settingsStylePartsEmpty;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.settingsStylePartsTitle),
      ),
      floatingActionButton: canEdit
          ? FloatingActionButton.extended(
              onPressed: () async {
                await _showPartNameDialog(
                  context: context,
                  l10n: l10n,
                  title: l10n.settingsStylePartAddCta,
                  onSubmit: (name) async {
                    final repo =
                        await ref.read(styleCatalogRepositoryProvider.future);
                    final id = await repo.createStylePart(
                      shopId: ref.read(effectiveShopIdProvider),
                      name: name,
                      garmentTypeIndex: garment.code,
                    );
                    enqueueStylePartUpsert(
                      ref,
                      internalId: id,
                      name: name,
                      garmentTypeIndex: garment.code,
                      isActive: true,
                    );
                  },
                );
              },
              icon: const Icon(Icons.add),
              label: Text(l10n.settingsStylePartAddCta),
            )
          : null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SettingsStyleGarmentSelector(),
          Expanded(
            child: partsAsync.when(
              data: (parts) {
                if (parts.isEmpty) {
                  return Center(child: Text(emptyMessage));
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
                  itemCount: parts.length,
                  itemBuilder: (context, index) {
                    final p = parts[index];
                    final title = garment == GarmentType.waistcoat
                        ? stylePartSectionLabel(p.name)
                        : p.name;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(title),
                  subtitle: Text(
                    p.isActive
                        ? l10n.settingsStyleActiveLabel
                        : l10n.settingsStyleInactiveLabel,
                  ),
                  trailing: canEdit
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            PrideIconAction(
                              icon: Icons.edit_outlined,
                              variant: PrideButtonVariant.edit,
                              onPressed: () async {
                                await _showPartNameDialog(
                                  context: context,
                                  l10n: l10n,
                                  title: l10n.settingsStylePartRenameTitle,
                                  initial: p.name,
                                  onSubmit: (name) async {
                                    final repo = await ref.read(
                                      styleCatalogRepositoryProvider.future,
                                    );
                                    await repo.updateStylePart(
                                      internalId: p.internalId,
                                      name: name,
                                      sortOrder: p.sortOrder,
                                      isActive: p.isActive,
                                    );
                                    enqueueStylePartUpsert(
                                      ref,
                                      internalId: p.internalId,
                                      name: name,
                                      sortOrder: p.sortOrder,
                                      isActive: p.isActive,
                                    );
                                  },
                                );
                              },
                            ),
                            PrideIconAction(
                              icon: Icons.delete_outline,
                              variant: PrideButtonVariant.delete,
                              onPressed: () async {
                                final ok = await showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title:
                                        Text(l10n.settingsStylePartDeleteTitle),
                                    content:
                                        Text(l10n.settingsStylePartDeleteBody),
                                    actions: prideDialogCancelDelete(
                                      context: ctx,
                                      onCancel: () =>
                                          Navigator.pop(ctx, false),
                                      onConfirm: () =>
                                          Navigator.pop(ctx, true),
                                      deleteLabel: l10n.deleteCta,
                                    ),
                                  ),
                                );
                                if (ok != true || !context.mounted) return;
                                enqueueStylePartDelete(
                                  ref,
                                  internalId: p.internalId,
                                );
                                final repo = await ref.read(
                                  styleCatalogRepositoryProvider.future,
                                );
                                await repo.softDeleteStylePart(p.internalId);
                              },
                            ),
                            Switch(
                              value: p.isActive,
                              onChanged: (v) async {
                                final repo = await ref.read(
                                  styleCatalogRepositoryProvider.future,
                                );
                                await repo.updateStylePart(
                                  internalId: p.internalId,
                                  name: p.name,
                                  sortOrder: p.sortOrder,
                                  isActive: v,
                                );
                                enqueueStylePartUpsert(
                                  ref,
                                  internalId: p.internalId,
                                  name: p.name,
                                  sortOrder: p.sortOrder,
                                  isActive: v,
                                );
                              },
                            ),
                          ],
                        )
                      : null,
                ),
              );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('$e')),
            ),
          ),
        ],
      ),
    );
  }
}
