import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/app/app_theme.dart';
import 'package:pride_v3/core/widgets/pride_action_buttons.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../auth/auth_providers.dart';
import '../../data/local/fabric_preset_summary.dart';
import '../../data/providers/local_data_providers.dart';
import '../../licensing/license_providers.dart';
import 'fabric/fabric_sync_helpers.dart';

enum FabricPresetListKind { names, colors }

Future<void> _showPresetDialog({
  required BuildContext context,
  required AppLocalizations l10n,
  required String title,
  required String fieldLabel,
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
          labelText: fieldLabel,
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

class SettingsFabricPresetsScreen extends ConsumerWidget {
  const SettingsFabricPresetsScreen({super.key, required this.kind});

  final FabricPresetListKind kind;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final presetsAsync = kind == FabricPresetListKind.names
        ? ref.watch(fabricNamesStreamProvider)
        : ref.watch(fabricColorsStreamProvider);
    final canEdit = !ref.watch(licenseEditingBlockedProvider);

    final title = kind == FabricPresetListKind.names
        ? l10n.settingsFabricNamesTitle
        : l10n.settingsFabricColorsTitle;
    final empty = kind == FabricPresetListKind.names
        ? l10n.settingsFabricNamesEmpty
        : l10n.settingsFabricColorsEmpty;
    final addCta = kind == FabricPresetListKind.names
        ? l10n.settingsFabricNameAddCta
        : l10n.settingsFabricColorAddCta;
    final fieldLabel = kind == FabricPresetListKind.names
        ? l10n.settingsFabricNameFieldLabel
        : l10n.settingsFabricColorFieldLabel;
    final renameTitle = kind == FabricPresetListKind.names
        ? l10n.settingsFabricNameRenameTitle
        : l10n.settingsFabricColorRenameTitle;
    final deleteTitle = kind == FabricPresetListKind.names
        ? l10n.settingsFabricNameDeleteTitle
        : l10n.settingsFabricColorDeleteTitle;
    final deleteBody = kind == FabricPresetListKind.names
        ? l10n.settingsFabricNameDeleteBody
        : l10n.settingsFabricColorDeleteBody;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(title),
      ),
      floatingActionButton: canEdit
          ? FloatingActionButton.extended(
              onPressed: () async {
                await _showPresetDialog(
                  context: context,
                  l10n: l10n,
                  title: addCta,
                  fieldLabel: fieldLabel,
                  onSubmit: (name) => _createPreset(ref, name),
                );
              },
              icon: const Icon(Icons.add),
              label: Text(addCta),
            )
          : null,
      body: presetsAsync.when(
        data: (presets) => _PresetsList(
          presets: presets,
          canEdit: canEdit,
          l10n: l10n,
          empty: empty,
          renameTitle: renameTitle,
          deleteTitle: deleteTitle,
          deleteBody: deleteBody,
          fieldLabel: fieldLabel,
          kind: kind,
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
      ),
    );
  }

  Future<void> _createPreset(WidgetRef ref, String name) async {
    final repo = await ref.read(fabricPresetRepositoryProvider.future);
    final shopId = ref.read(effectiveShopIdProvider);
    if (kind == FabricPresetListKind.names) {
      final id = await repo.createFabricName(shopId: shopId, name: name);
      enqueueFabricNameUpsert(ref, internalId: id, name: name, isActive: true);
    } else {
      final id = await repo.createFabricColor(shopId: shopId, name: name);
      enqueueFabricColorUpsert(ref, internalId: id, name: name, isActive: true);
    }
  }
}

class _PresetsList extends ConsumerWidget {
  const _PresetsList({
    required this.presets,
    required this.canEdit,
    required this.l10n,
    required this.empty,
    required this.renameTitle,
    required this.deleteTitle,
    required this.deleteBody,
    required this.fieldLabel,
    required this.kind,
  });

  final List<FabricPresetSummary> presets;
  final bool canEdit;
  final AppLocalizations l10n;
  final String empty;
  final String renameTitle;
  final String deleteTitle;
  final String deleteBody;
  final String fieldLabel;
  final FabricPresetListKind kind;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (presets.isEmpty) {
      return Center(child: Text(empty));
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
      itemCount: presets.length,
      itemBuilder: (context, index) {
        final p = presets[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(p.name),
            subtitle: Text(
              p.isActive
                  ? l10n.settingsFabricActiveLabel
                  : l10n.settingsFabricInactiveLabel,
            ),
            trailing: canEdit
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PrideIconAction(
                        icon: Icons.edit_outlined,
                        variant: PrideButtonVariant.edit,
                        onPressed: () async {
                          await _showPresetDialog(
                            context: context,
                            l10n: l10n,
                            title: renameTitle,
                            fieldLabel: fieldLabel,
                            initial: p.name,
                            onSubmit: (name) => _updatePreset(
                              ref,
                              p,
                              name: name,
                            ),
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
                              title: Text(deleteTitle),
                              content: Text(deleteBody),
                              actions: prideDialogCancelDelete(
                                context: ctx,
                                onCancel: () => Navigator.pop(ctx, false),
                                onConfirm: () => Navigator.pop(ctx, true),
                                deleteLabel: l10n.deleteCta,
                              ),
                            ),
                          );
                          if (ok != true || !context.mounted) return;
                          await _deletePreset(ref, p.internalId);
                        },
                      ),
                      Switch(
                        value: p.isActive,
                        onChanged: (v) => _updatePreset(
                          ref,
                          p,
                          isActive: v,
                        ),
                      ),
                    ],
                  )
                : null,
          ),
        );
      },
    );
  }

  Future<void> _updatePreset(
    WidgetRef ref,
    FabricPresetSummary p, {
    String? name,
    bool? isActive,
  }) async {
    final repo = await ref.read(fabricPresetRepositoryProvider.future);
    final n = name ?? p.name;
    if (kind == FabricPresetListKind.names) {
      await repo.updateFabricName(
        internalId: p.internalId,
        name: n,
        sortOrder: p.sortOrder,
        isActive: isActive ?? p.isActive,
      );
      enqueueFabricNameUpsert(
        ref,
        internalId: p.internalId,
        name: n,
        sortOrder: p.sortOrder,
        isActive: isActive ?? p.isActive,
      );
    } else {
      await repo.updateFabricColor(
        internalId: p.internalId,
        name: n,
        sortOrder: p.sortOrder,
        isActive: isActive ?? p.isActive,
      );
      enqueueFabricColorUpsert(
        ref,
        internalId: p.internalId,
        name: n,
        sortOrder: p.sortOrder,
        isActive: isActive ?? p.isActive,
      );
    }
  }

  Future<void> _deletePreset(WidgetRef ref, String internalId) async {
    if (kind == FabricPresetListKind.names) {
      enqueueFabricNameDelete(ref, internalId: internalId);
    } else {
      enqueueFabricColorDelete(ref, internalId: internalId);
    }
    final repo = await ref.read(fabricPresetRepositoryProvider.future);
    if (kind == FabricPresetListKind.names) {
      await repo.softDeleteFabricName(internalId);
    } else {
      await repo.softDeleteFabricColor(internalId);
    }
  }
}
