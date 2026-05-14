import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../auth/auth_providers.dart';
import '../../data/local/measurement_type_summary.dart';
import '../../data/local/sync_outbox_kinds.dart';
import '../../data/providers/local_data_providers.dart';
import '../../licensing/license_providers.dart';
import '../../shell/shell_sync_providers.dart';

void _enqueueMeasurementTypeUpsert(
  WidgetRef ref, {
  required String internalId,
  required String name,
  int? sortOrder,
  bool? isActive,
}) {
  final map = <String, dynamic>{'name': name};
  if (sortOrder != null) map['sort_order'] = sortOrder;
  if (isActive != null) map['is_active'] = isActive;
  recordSyncOutboxMutation(
    ref,
    kind: SyncOutboxKinds.measurementTypeUpsert,
    entityRef: internalId,
    shopId: ref.read(effectiveShopIdProvider),
    payloadJson: jsonEncode(map),
  );
}

void _enqueueMeasurementTypeDelete(WidgetRef ref, {required String internalId}) {
  recordSyncOutboxMutation(
    ref,
    kind: SyncOutboxKinds.measurementTypeDelete,
    entityRef: internalId,
    shopId: ref.read(effectiveShopIdProvider),
    payloadJson: '{}',
  );
}

Future<void> _applyReorder(
  WidgetRef ref,
  List<MeasurementTypeSummary> types,
  int oldIndex,
  int newIndex,
) async {
  if (newIndex > oldIndex) newIndex--;
  final list = List<MeasurementTypeSummary>.from(types);
  final item = list.removeAt(oldIndex);
  list.insert(newIndex, item);
  final repo = await ref.read(measurementProfileRepositoryProvider.future);
  for (var i = 0; i < list.length; i++) {
    final t = list[i];
    final sortOrder = (i + 1) * 10;
    await repo.updateMeasurementType(
      internalId: t.internalId,
      name: t.name,
      sortOrder: sortOrder,
      isActive: t.isActive,
    );
    _enqueueMeasurementTypeUpsert(
      ref,
      internalId: t.internalId,
      name: t.name,
      sortOrder: sortOrder,
      isActive: t.isActive,
    );
  }
}

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
    builder: (ctx) {
      return AlertDialog(
        title: Text(title),
        content: TextField(
          controller: ctrl,
          decoration: InputDecoration(
            labelText: l10n.measurementTypesFieldNameLabel,
            border: const OutlineInputBorder(),
          ),
          autofocus: true,
          onSubmitted: (_) => Navigator.pop(ctx, true),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.saveCta),
          ),
        ],
      );
    },
  );
  final text = ctrl.text.trim();
  ctrl.dispose();
  if (ok == true && text.isNotEmpty) onSubmit(text);
}

/// Shop-scoped measurement type labels (plan-02) — list, reorder, activate, rename, soft-delete.
class SettingsMeasurementTypesScreen extends ConsumerWidget {
  const SettingsMeasurementTypesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final license = ref.watch(licenseNotifierProvider);
    final typesAsync = ref.watch(measurementTypesAdminStreamProvider);
    final canEdit = !license.isExpired;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.measurementTypesScreenTitle),
      ),
      floatingActionButton: canEdit
          ? FloatingActionButton.extended(
              onPressed: () async {
                await _showNameDialog(
                  context: context,
                  l10n: l10n,
                  title: l10n.measurementTypesAddCta,
                  onSubmit: (name) async {
                    final repo = await ref.read(
                      measurementProfileRepositoryProvider.future,
                    );
                    final id = await repo.createMeasurementType(
                      shopId: ref.read(effectiveShopIdProvider),
                      name: name,
                    );
                    _enqueueMeasurementTypeUpsert(
                      ref,
                      internalId: id,
                      name: name.trim(),
                      isActive: true,
                    );
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.measurementTypesCreated)),
                    );
                  },
                );
              },
              icon: const Icon(Icons.add),
              label: Text(l10n.measurementTypesAddCta),
            )
          : null,
      body: typesAsync.when(
        data: (types) {
          if (types.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  l10n.measurementTypesEmpty,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (canEdit)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Text(
                    l10n.measurementTypesReorderHint,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              Expanded(
                child: canEdit
                    ? ReorderableListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
                        itemCount: types.length,
                        onReorder: (oldIndex, newIndex) async {
                          await _applyReorder(ref, types, oldIndex, newIndex);
                        },
                        itemBuilder: (context, index) {
                          final t = types[index];
                          return _TypeRowTile(
                            key: ValueKey(t.internalId),
                            type: t,
                            canEdit: canEdit,
                            onToggleActive: (v) async {
                              final repo = await ref.read(
                                measurementProfileRepositoryProvider.future,
                              );
                              await repo.updateMeasurementType(
                                internalId: t.internalId,
                                name: t.name,
                                sortOrder: t.sortOrder,
                                isActive: v,
                              );
                              _enqueueMeasurementTypeUpsert(
                                ref,
                                internalId: t.internalId,
                                name: t.name,
                                sortOrder: t.sortOrder,
                                isActive: v,
                              );
                            },
                            onRename: () async {
                              await _showNameDialog(
                                context: context,
                                l10n: l10n,
                                title: l10n.measurementTypesRenameTitle,
                                initial: t.name,
                                onSubmit: (name) async {
                                  final repo = await ref.read(
                                    measurementProfileRepositoryProvider.future,
                                  );
                                  await repo.updateMeasurementType(
                                    internalId: t.internalId,
                                    name: name,
                                    sortOrder: t.sortOrder,
                                    isActive: t.isActive,
                                  );
                                  _enqueueMeasurementTypeUpsert(
                                    ref,
                                    internalId: t.internalId,
                                    name: name.trim(),
                                    sortOrder: t.sortOrder,
                                    isActive: t.isActive,
                                  );
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        l10n.measurementTypesUpdated,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            onDelete: () async {
                              final ok = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text(l10n.measurementTypesDeleteTitle),
                                  content: Text(l10n.measurementTypesDeleteBody),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(ctx, false),
                                      child: Text(
                                        MaterialLocalizations.of(ctx)
                                            .cancelButtonLabel,
                                      ),
                                    ),
                                    FilledButton(
                                      onPressed: () =>
                                          Navigator.pop(ctx, true),
                                      child: Text(l10n.deleteCta),
                                    ),
                                  ],
                                ),
                              );
                              if (ok != true || !context.mounted) return;
                              _enqueueMeasurementTypeDelete(
                                ref,
                                internalId: t.internalId,
                              );
                              final repo = await ref.read(
                                measurementProfileRepositoryProvider.future,
                              );
                              await repo.softDeleteMeasurementType(t.internalId);
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(l10n.measurementTypesDeleted),
                                ),
                              );
                            },
                          );
                        },
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                        itemCount: types.length,
                        itemBuilder: (context, index) {
                          final t = types[index];
                          return _TypeRowTile(
                            key: ValueKey(t.internalId),
                            type: t,
                            canEdit: false,
                            onToggleActive: (_) {},
                            onRename: () {},
                            onDelete: () {},
                          );
                        },
                      ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
      ),
    );
  }
}

class _TypeRowTile extends StatelessWidget {
  const _TypeRowTile({
    super.key,
    required this.type,
    required this.canEdit,
    required this.onToggleActive,
    required this.onRename,
    required this.onDelete,
  });

  final MeasurementTypeSummary type;
  final bool canEdit;
  final ValueChanged<bool> onToggleActive;
  final VoidCallback onRename;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final subtitle = type.isActive
        ? l10n.measurementTypesActiveLabel
        : l10n.measurementTypesInactiveLabel;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(type.name),
        subtitle: Text(subtitle),
        trailing: canEdit
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: onRename,
                    tooltip: l10n.measurementTypesRenameTitle,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: onDelete,
                    tooltip: l10n.measurementTypesDeleteTitle,
                  ),
                  Switch(
                    value: type.isActive,
                    onChanged: onToggleActive,
                  ),
                ],
              )
            : null,
      ),
    );
  }
}
