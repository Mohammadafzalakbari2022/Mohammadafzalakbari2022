import 'package:flutter/material.dart';
import 'package:pride_v3/app/app_theme.dart';
import 'package:pride_v3/core/widgets/pride_action_buttons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/local/entities/garment_type.dart';
import '../../data/local/style_name_summary.dart';
import '../../data/providers/local_data_providers.dart';
import '../../auth/auth_providers.dart';
import '../../licensing/license_providers.dart';
import 'style/settings_style_garment_provider.dart';
import 'style/settings_style_garment_selector.dart';
import 'style/style_sync_helpers.dart';
import 'style/style_catalog_refresh.dart';

Future<void> _showNameDialog({
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
          labelText: l10n.settingsStyleNameFieldLabel,
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

class SettingsStyleNamesScreen extends ConsumerWidget {
  const SettingsStyleNamesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final garment = ref.watch(settingsStyleGarmentProvider);
    final namesAsync = ref.watch(styleNamesForGarmentProvider(garment));
    final canEdit = !ref.watch(licenseEditingBlockedProvider);
    final emptyMessage = garment == GarmentType.waistcoat
        ? l10n.settingsStyleWaistcoatEmptyTitle
        : l10n.settingsStyleNamesEmpty;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.settingsStyleNamesTitle),
      ),
      floatingActionButton: canEdit
          ? FloatingActionButton.extended(
              onPressed: () async {
                await _showNameDialog(
                  context: context,
                  l10n: l10n,
                  title: l10n.settingsStyleNameAddCta,
                  onSubmit: (name) async {
                    final repo =
                        await ref.read(styleCatalogRepositoryProvider.future);
                    final id = await repo.createStyleName(
                      shopId: ref.read(effectiveShopIdProvider),
                      name: name,
                      garmentTypeIndex: garment.code,
                    );
                    enqueueStyleNameUpsert(
                      ref,
                      internalId: id,
                      name: name,
                      garmentTypeIndex: garment.code,
                      isActive: true,
                    );
                    refreshStyleCatalogProviders(ref, garment);
                  },
                );
              },
              icon: const Icon(Icons.add),
              label: Text(l10n.settingsStyleNameAddCta),
            )
          : null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SettingsStyleGarmentSelector(),
          Expanded(
            child: namesAsync.when(
              data: (names) => _NamesList(
                names: names,
                canEdit: canEdit,
                l10n: l10n,
                emptyMessage: emptyMessage,
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('$e')),
            ),
          ),
        ],
      ),
    );
  }
}

class _NamesList extends ConsumerWidget {
  const _NamesList({
    required this.names,
    required this.canEdit,
    required this.l10n,
    required this.emptyMessage,
  });

  final List<StyleNameSummary> names;
  final bool canEdit;
  final AppLocalizations l10n;
  final String emptyMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final garment = ref.watch(settingsStyleGarmentProvider);
    if (names.isEmpty) {
      return Center(child: Text(emptyMessage));
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
      itemCount: names.length,
      itemBuilder: (context, index) {
        final n = names[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(n.name),
            subtitle: Text(
              n.isActive
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
                          await _showNameDialog(
                            context: context,
                            l10n: l10n,
                            title: l10n.settingsStyleNameRenameTitle,
                            initial: n.name,
                            onSubmit: (name) async {
                              final repo = await ref.read(
                                styleCatalogRepositoryProvider.future,
                              );
                              await repo.updateStyleName(
                                internalId: n.internalId,
                                name: name,
                                sortOrder: n.sortOrder,
                                isActive: n.isActive,
                              );
                              enqueueStyleNameUpsert(
                                ref,
                                internalId: n.internalId,
                                name: name,
                                sortOrder: n.sortOrder,
                                isActive: n.isActive,
                              );
                              refreshStyleCatalogProviders(ref, garment);
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
                              title: Text(l10n.settingsStyleNameDeleteTitle),
                              content: Text(l10n.settingsStyleNameDeleteBody),
                              actions: prideDialogCancelDelete(
                                context: ctx,
                                onCancel: () => Navigator.pop(ctx, false),
                                onConfirm: () => Navigator.pop(ctx, true),
                                deleteLabel: l10n.deleteCta,
                              ),
                            ),
                          );
                          if (ok != true || !context.mounted) return;
                          enqueueStyleNameDelete(ref, internalId: n.internalId);
                          final repo = await ref.read(
                            styleCatalogRepositoryProvider.future,
                          );
                          await repo.softDeleteStyleName(n.internalId);
                          refreshStyleCatalogProviders(ref, garment);
                        },
                      ),
                      Switch(
                        value: n.isActive,
                        onChanged: (v) async {
                          final repo = await ref.read(
                            styleCatalogRepositoryProvider.future,
                          );
                          await repo.updateStyleName(
                            internalId: n.internalId,
                            name: n.name,
                            sortOrder: n.sortOrder,
                            isActive: v,
                          );
                          enqueueStyleNameUpsert(
                            ref,
                            internalId: n.internalId,
                            name: n.name,
                            sortOrder: n.sortOrder,
                            isActive: v,
                          );
                          refreshStyleCatalogProviders(ref, garment);
                        },
                      ),
                    ],
                  )
                : null,
          ),
        );
      },
    );
  }
}
