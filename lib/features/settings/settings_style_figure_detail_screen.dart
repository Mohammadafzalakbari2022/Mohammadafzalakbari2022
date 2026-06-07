import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/app/app_theme.dart';
import 'package:pride_v3/core/widgets/pride_action_buttons.dart';
import 'package:pride_v3/core/widgets/pride_carved_section.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../auth/auth_providers.dart';
import '../../data/local/measurement_unit_codes.dart';
import '../../data/local/style/style_figure_display_name.dart';
import '../../data/local/style/style_figure_image_ref.dart';
import '../../data/local/style/style_figure_inch_display.dart';
import '../../data/local/style_figure_size_option_summary.dart';
import '../../data/local/style_figure_summary.dart';
import '../../data/local/style_figure_text_option_summary.dart';
import '../../data/providers/local_data_providers.dart';
import '../../licensing/license_providers.dart';
import 'style/style_figure_image.dart';
import 'style/style_sync_helpers.dart';
import 'style/style_figure_settings_validation.dart';

Future<void> showStyleFigureTextOptionDialog({
  required BuildContext context,
  required AppLocalizations l10n,
  required String title,
  StyleFigureTextOptionSummary? existing,
  required Future<void> Function({
    required String label,
    required bool isActive,
  }) onSubmit,
}) async {
  final labelCtrl = TextEditingController(text: existing?.label ?? '');
  final isActive = existing?.isActive ?? true;

  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: labelCtrl,
        decoration: InputDecoration(
          labelText: l10n.settingsStyleFigureTextOptionLabelField,
          border: const OutlineInputBorder(),
        ),
        autofocus: true,
      ),
      actions: prideDialogCancelSave(
        context: ctx,
        onCancel: () => Navigator.pop(ctx, false),
        onConfirm: () => Navigator.pop(ctx, true),
        saveLabel: l10n.saveCta,
      ),
    ),
  );

  final label = labelCtrl.text.trim();
  labelCtrl.dispose();

  if (ok != true || !context.mounted) return;
  if (!isNonEmptyShapeOptionLabel(label)) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.settingsStyleFigureLabelRequired)),
    );
    return;
  }
  await onSubmit(label: label, isActive: isActive);
}

Future<void> showStyleFigureSizeOptionDialog({
  required BuildContext context,
  required AppLocalizations l10n,
  required String title,
  StyleFigureSizeOptionSummary? existing,
  required Future<void> Function({
    required String label,
    required double valueInches,
    required bool isActive,
  }) onSubmit,
}) async {
  final valueCtrl = TextEditingController(
    text: existing != null
        ? displayInchOptionLabel(
            valueInches: existing.valueInches,
            label: existing.label,
          )
        : '',
  );
  final isActive = existing?.isActive ?? true;

  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: valueCtrl,
        decoration: InputDecoration(
          labelText: l10n.settingsStyleFigureValueInchesLabel,
          border: const OutlineInputBorder(),
        ),
        autofocus: true,
      ),
      actions: prideDialogCancelSave(
        context: ctx,
        onCancel: () => Navigator.pop(ctx, false),
        onConfirm: () => Navigator.pop(ctx, true),
        saveLabel: l10n.saveCta,
      ),
    ),
  );

  final valueText = valueCtrl.text.trim();
  valueCtrl.dispose();

  if (ok != true || !context.mounted) return;
  if (!isValidInchMeasurementText(valueText)) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.settingsStyleFigureValuePositiveRequired)),
    );
    return;
  }
  final stored = parseInchMeasurementForStorage(valueText);
  await onSubmit(
    label: stored.label,
    valueInches: stored.valueInches,
    isActive: isActive,
  );
}

class SettingsStyleFigureDetailScreen extends ConsumerStatefulWidget {
  const SettingsStyleFigureDetailScreen({
    super.key,
    required this.figureId,
  });

  final String figureId;

  @override
  ConsumerState<SettingsStyleFigureDetailScreen> createState() =>
      _SettingsStyleFigureDetailScreenState();
}

class _SettingsStyleFigureDetailScreenState
    extends ConsumerState<SettingsStyleFigureDetailScreen> {
  final _nameCtrl = TextEditingController();
  String? _loadedFigureId;
  bool _savingMeta = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _syncFields(StyleFigureSummary figure) {
    if (_loadedFigureId == figure.internalId) return;
    _loadedFigureId = figure.internalId;
    _nameCtrl.text = figure.name;
  }

  Future<void> _saveFigureMeta(StyleFigureSummary figure) async {
    final l10n = AppLocalizations.of(context)!;
    if (ref.read(licenseEditingBlockedProvider)) {
      final license = ref.read(licenseNotifierProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(licenseWriteBlockedMessage(license, l10n))),
      );
      return;
    }
    setState(() => _savingMeta = true);
    try {
      final repo = await ref.read(styleCatalogRepositoryProvider.future);
      await repo.updateStyleFigure(
        internalId: figure.internalId,
        name: _nameCtrl.text.trim(),
        sortOrder: figure.sortOrder,
        isActive: figure.isActive,
      );
      enqueueStyleFigureUpsert(
        ref,
        internalId: figure.internalId,
        partInternalId: figure.partInternalId,
        name: _nameCtrl.text.trim(),
        imageRef: figure.imageRef,
        sortOrder: figure.sortOrder,
        isActive: figure.isActive,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.settingsStyleFigureSaved)),
        );
      }
    } finally {
      if (mounted) setState(() => _savingMeta = false);
    }
  }

  Future<void> _setFigureActive(
    StyleFigureSummary figure,
    bool isActive,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    if (ref.read(licenseEditingBlockedProvider)) {
      final license = ref.read(licenseNotifierProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(licenseWriteBlockedMessage(license, l10n))),
      );
      return;
    }
    final repo = await ref.read(styleCatalogRepositoryProvider.future);
    await repo.updateStyleFigure(
      internalId: figure.internalId,
      name: figure.name,
      sortOrder: figure.sortOrder,
      isActive: isActive,
    );
    enqueueStyleFigureUpsert(
      ref,
      internalId: figure.internalId,
      partInternalId: figure.partInternalId,
      name: figure.name,
      imageRef: figure.imageRef,
      sortOrder: figure.sortOrder,
      isActive: isActive,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final figuresAsync = ref.watch(styleAllFiguresStreamProvider);
    final canEdit = !ref.watch(licenseEditingBlockedProvider);
    final textOptionsAsync =
        ref.watch(styleFigureTextOptionsProvider(widget.figureId));
    final sizeOptionsAsync =
        ref.watch(styleFigureSizeOptionsProvider(widget.figureId));
    return figuresAsync.when(
      data: (figures) {
        StyleFigureSummary? figure;
        for (final f in figures) {
          if (f.internalId == widget.figureId) {
            figure = f;
            break;
          }
        }
        if (figure == null) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
              title: Text(l10n.settingsStyleFigureDetailTitle),
            ),
            body: Center(child: Text(l10n.settingsStyleFigureNotFound)),
          );
        }
        final f = figure;
        _syncFields(f);
        final displayName = resolveStyleFigureSummaryDisplayName(f);
        final isBundled = StyleFigureImageRef.isBundledAssetRef(f.imageRef);

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
            title: Text(l10n.settingsStyleFigureDetailTitle),
          ),
          body: ListView(
            children: [
              PrideCarvedSection(
                title: l10n.settingsStyleFigureDetailTitle,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AspectRatio(
                      aspectRatio: 1.2,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: StyleFigureImage(
                            imageRef: f.imageRef,
                            fit: BoxFit.contain,
                            expand: true,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _nameCtrl,
                      enabled: canEdit,
                      decoration: InputDecoration(
                        labelText: l10n.settingsStyleFigureNameLabel,
                        helperText: l10n.settingsStyleFigureNameHelper(
                          displayName,
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.settingsStyleFigureActiveLabel),
                      value: f.isActive,
                      onChanged:
                          canEdit ? (v) => _setFigureActive(f, v) : null,
                    ),
                    if (canEdit)
                      Align(
                        alignment: Alignment.centerRight,
                        child: FilledButton(
                          onPressed:
                              _savingMeta ? null : () => _saveFigureMeta(f),
                          child: _savingMeta
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(l10n.saveCta),
                        ),
                      ),
                    if (isBundled)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          l10n.settingsStyleFigureBundledHint,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                      ),
                  ],
                ),
              ),
              PrideCarvedSection(
                title: l10n.settingsStyleFigureTextOptionsTitle,
                trailing: canEdit
                    ? IconButton(
                        icon: const Icon(Icons.add),
                        tooltip: l10n.settingsStyleFigureTextOptionAddCta,
                        onPressed: () => _addTextOption(context, f),
                      )
                    : null,
                child: textOptionsAsync.when(
                  data: (options) => _TextOptionList(
                    options: options,
                    canEdit: canEdit,
                    l10n: l10n,
                    onEdit: (o) => _editTextOption(context, o),
                    onDelete: (o) => _deleteTextOption(context, o),
                    onToggleActive: (o, active) =>
                        _toggleTextOptionActive(o, active),
                  ),
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) => Text('$e'),
                ),
              ),
              PrideCarvedSection(
                title: l10n.settingsStyleFigureSizeOptionsTitle,
                trailing: canEdit
                    ? IconButton(
                        icon: const Icon(Icons.add),
                        tooltip: l10n.settingsStyleFigureSizeOptionAddCta,
                        onPressed: () => _addSizeOption(context, f),
                      )
                    : null,
                child: sizeOptionsAsync.when(
                  data: (options) => _SizeOptionList(
                    options: options,
                    canEdit: canEdit,
                    l10n: l10n,
                    onEdit: (o) => _editSizeOption(context, o),
                    onDelete: (o) => _deleteSizeOption(context, o),
                    onToggleActive: (o, active) =>
                        _toggleSizeOptionActive(o, active),
                  ),
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) => Text('$e'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          title: Text(l10n.settingsStyleFigureDetailTitle),
        ),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          title: Text(l10n.settingsStyleFigureDetailTitle),
        ),
        body: Center(child: Text('$e')),
      ),
    );
  }

  Future<void> _addTextOption(
    BuildContext context,
    StyleFigureSummary figure,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    await showStyleFigureTextOptionDialog(
      context: context,
      l10n: l10n,
      title: l10n.settingsStyleFigureTextOptionAddCta,
      onSubmit: ({
        required label,
        required isActive,
      }) async {
        final repo = await ref.read(styleCatalogRepositoryProvider.future);
        final id = await repo.createStyleFigureTextOption(
          shopId: ref.read(effectiveShopIdProvider),
          styleFigureInternalId: figure.internalId,
          label: label,
        );
        final options = await repo
            .watchTextOptionsForFigure(
              ref.read(effectiveShopIdProvider),
              figure.internalId,
            )
            .first;
        var sortOrder = 10;
        for (final o in options) {
          if (o.internalId == id) {
            sortOrder = o.sortOrder;
            break;
          }
        }
        if (!isActive) {
          await repo.updateStyleFigureTextOption(
            internalId: id,
            isActive: false,
          );
        }
        enqueueStyleFigureTextOptionUpsert(
          ref,
          internalId: id,
          styleFigureInternalId: figure.internalId,
          label: label,
          sortOrder: sortOrder,
          isActive: isActive,
        );
      },
    );
  }

  Future<void> _editTextOption(
    BuildContext context,
    StyleFigureTextOptionSummary option,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    await showStyleFigureTextOptionDialog(
      context: context,
      l10n: l10n,
      title: l10n.settingsStyleFigureTextOptionEditTitle,
      existing: option,
      onSubmit: ({
        required label,
        required isActive,
      }) async {
        final repo = await ref.read(styleCatalogRepositoryProvider.future);
        await repo.updateStyleFigureTextOption(
          internalId: option.internalId,
          label: label,
          sortOrder: option.sortOrder,
          isActive: isActive,
        );
        enqueueStyleFigureTextOptionUpsert(
          ref,
          internalId: option.internalId,
          styleFigureInternalId: option.styleFigureInternalId,
          label: label,
          sortOrder: option.sortOrder,
          isActive: isActive,
        );
      },
    );
  }

  Future<void> _deleteTextOption(
    BuildContext context,
    StyleFigureTextOptionSummary option,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.settingsStyleFigureTextOptionDeleteTitle),
        content: Text(l10n.settingsStyleFigureTextOptionDeleteBody),
        actions: prideDialogCancelDelete(
          context: ctx,
          onCancel: () => Navigator.pop(ctx, false),
          onConfirm: () => Navigator.pop(ctx, true),
          deleteLabel: l10n.deleteCta,
        ),
      ),
    );
    if (ok != true || !mounted) return;
    final repo = await ref.read(styleCatalogRepositoryProvider.future);
    await repo.softDeleteStyleFigureTextOption(option.internalId);
    enqueueStyleFigureTextOptionDelete(ref, internalId: option.internalId);
  }

  Future<void> _toggleTextOptionActive(
    StyleFigureTextOptionSummary option,
    bool isActive,
  ) async {
    final repo = await ref.read(styleCatalogRepositoryProvider.future);
    await repo.updateStyleFigureTextOption(
      internalId: option.internalId,
      label: option.label,
      sortOrder: option.sortOrder,
      isActive: isActive,
    );
    enqueueStyleFigureTextOptionUpsert(
      ref,
      internalId: option.internalId,
      styleFigureInternalId: option.styleFigureInternalId,
      label: option.label,
      sortOrder: option.sortOrder,
      isActive: isActive,
    );
  }

  Future<void> _addSizeOption(
    BuildContext context,
    StyleFigureSummary figure,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    await showStyleFigureSizeOptionDialog(
      context: context,
      l10n: l10n,
      title: l10n.settingsStyleFigureSizeOptionAddCta,
      onSubmit: ({
        required label,
        required valueInches,
        required isActive,
      }) async {
        final repo = await ref.read(styleCatalogRepositoryProvider.future);
        final id = await repo.createStyleFigureSizeOption(
          shopId: ref.read(effectiveShopIdProvider),
          styleFigureInternalId: figure.internalId,
          label: label,
          valueInches: valueInches,
          unitCode: MeasurementUnitCodes.inch,
        );
        final options = await repo
            .watchSizeOptionsForFigure(
              ref.read(effectiveShopIdProvider),
              figure.internalId,
            )
            .first;
        var sortOrder = 10;
        for (final o in options) {
          if (o.internalId == id) {
            sortOrder = o.sortOrder;
            break;
          }
        }
        if (!isActive) {
          await repo.updateStyleFigureSizeOption(
            internalId: id,
            isActive: false,
          );
        }
        enqueueStyleFigureSizeOptionUpsert(
          ref,
          internalId: id,
          styleFigureInternalId: figure.internalId,
          label: label,
          valueInches: valueInches,
          unitCode: MeasurementUnitCodes.inch,
          sortOrder: sortOrder,
          isActive: isActive,
        );
      },
    );
  }

  Future<void> _editSizeOption(
    BuildContext context,
    StyleFigureSizeOptionSummary option,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    await showStyleFigureSizeOptionDialog(
      context: context,
      l10n: l10n,
      title: l10n.settingsStyleFigureSizeOptionEditTitle,
      existing: option,
      onSubmit: ({
        required label,
        required valueInches,
        required isActive,
      }) async {
        final repo = await ref.read(styleCatalogRepositoryProvider.future);
        await repo.updateStyleFigureSizeOption(
          internalId: option.internalId,
          label: label,
          valueInches: valueInches,
          sortOrder: option.sortOrder,
          isActive: isActive,
        );
        enqueueStyleFigureSizeOptionUpsert(
          ref,
          internalId: option.internalId,
          styleFigureInternalId: option.styleFigureInternalId,
          label: label,
          valueInches: valueInches,
          unitCode: option.unitCode,
          sortOrder: option.sortOrder,
          isActive: isActive,
        );
      },
    );
  }

  Future<void> _deleteSizeOption(
    BuildContext context,
    StyleFigureSizeOptionSummary option,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.settingsStyleFigureSizeOptionDeleteTitle),
        content: Text(l10n.settingsStyleFigureSizeOptionDeleteBody),
        actions: prideDialogCancelDelete(
          context: ctx,
          onCancel: () => Navigator.pop(ctx, false),
          onConfirm: () => Navigator.pop(ctx, true),
          deleteLabel: l10n.deleteCta,
        ),
      ),
    );
    if (ok != true || !mounted) return;
    final repo = await ref.read(styleCatalogRepositoryProvider.future);
    await repo.softDeleteStyleFigureSizeOption(option.internalId);
    enqueueStyleFigureSizeOptionDelete(ref, internalId: option.internalId);
  }

  Future<void> _toggleSizeOptionActive(
    StyleFigureSizeOptionSummary option,
    bool isActive,
  ) async {
    final repo = await ref.read(styleCatalogRepositoryProvider.future);
    await repo.updateStyleFigureSizeOption(
      internalId: option.internalId,
      label: option.label,
      valueInches: option.valueInches,
      sortOrder: option.sortOrder,
      isActive: isActive,
    );
    enqueueStyleFigureSizeOptionUpsert(
      ref,
      internalId: option.internalId,
      styleFigureInternalId: option.styleFigureInternalId,
      label: option.label,
      valueInches: option.valueInches,
      unitCode: option.unitCode,
      sortOrder: option.sortOrder,
      isActive: isActive,
    );
  }

}

class _TextOptionList extends StatelessWidget {
  const _TextOptionList({
    required this.options,
    required this.canEdit,
    required this.l10n,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleActive,
  });

  final List<StyleFigureTextOptionSummary> options;
  final bool canEdit;
  final AppLocalizations l10n;
  final Future<void> Function(StyleFigureTextOptionSummary) onEdit;
  final Future<void> Function(StyleFigureTextOptionSummary) onDelete;
  final Future<void> Function(StyleFigureTextOptionSummary, bool) onToggleActive;

  @override
  Widget build(BuildContext context) {
    if (options.isEmpty) {
      return Text(l10n.settingsStyleFigureTextOptionsEmpty);
    }
    return Column(
      children: [
        for (final option in options)
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text(option.label),
              subtitle: Text(
                option.isActive
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
                          onPressed: () => onEdit(option),
                        ),
                        PrideIconAction(
                          icon: Icons.delete_outline,
                          variant: PrideButtonVariant.delete,
                          onPressed: () => onDelete(option),
                        ),
                        Switch(
                          value: option.isActive,
                          onChanged: (v) => onToggleActive(option, v),
                        ),
                      ],
                    )
                  : null,
            ),
          ),
      ],
    );
  }
}

class _SizeOptionList extends StatelessWidget {
  const _SizeOptionList({
    required this.options,
    required this.canEdit,
    required this.l10n,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleActive,
  });

  final List<StyleFigureSizeOptionSummary> options;
  final bool canEdit;
  final AppLocalizations l10n;
  final Future<void> Function(StyleFigureSizeOptionSummary) onEdit;
  final Future<void> Function(StyleFigureSizeOptionSummary) onDelete;
  final Future<void> Function(StyleFigureSizeOptionSummary, bool) onToggleActive;

  @override
  Widget build(BuildContext context) {
    if (options.isEmpty) {
      return Text(l10n.settingsStyleFigureSizeOptionsEmpty);
    }
    return Column(
      children: [
        for (final option in options)
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text(
                displayInchOptionLabel(
                  valueInches: option.valueInches,
                  label: option.label,
                ),
              ),
              subtitle: Text(
                option.isActive
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
                          onPressed: () => onEdit(option),
                        ),
                        PrideIconAction(
                          icon: Icons.delete_outline,
                          variant: PrideButtonVariant.delete,
                          onPressed: () => onDelete(option),
                        ),
                        Switch(
                          value: option.isActive,
                          onChanged: (v) => onToggleActive(option, v),
                        ),
                      ],
                    )
                  : null,
            ),
          ),
      ],
    );
  }
}
