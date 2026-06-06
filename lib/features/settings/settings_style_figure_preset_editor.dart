import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../auth/auth_providers.dart';
import '../../data/local/style_figure_preset_summary.dart';
import '../../data/local/style_figure_size_option_summary.dart';
import '../../data/local/style_figure_text_option_summary.dart';
import '../../data/providers/local_data_providers.dart';
import '../../licensing/license_providers.dart';
import 'style/style_figure_settings_validation.dart';
import 'style/style_sync_helpers.dart';

class SettingsStyleFigurePresetEditor extends ConsumerStatefulWidget {
  const SettingsStyleFigurePresetEditor({
    super.key,
    required this.figureId,
    this.presetId,
  });

  final String figureId;
  final String? presetId;

  @override
  ConsumerState<SettingsStyleFigurePresetEditor> createState() =>
      _SettingsStyleFigurePresetEditorState();
}

class _SettingsStyleFigurePresetEditorState
    extends ConsumerState<SettingsStyleFigurePresetEditor> {
  final _nameCtrl = TextEditingController();
  final _sortCtrl = TextEditingController(text: '10');
  final Set<String> _selectedTextIds = {};
  final Set<String> _selectedSizeIds = {};
  bool _isActive = true;
  bool _loaded = false;
  bool _saving = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _sortCtrl.dispose();
    super.dispose();
  }

  void _loadPreset(StyleFigurePresetSummary? preset) {
    if (_loaded) return;
    if (preset == null) {
      _loaded = true;
      return;
    }
    _nameCtrl.text = preset.name;
    _sortCtrl.text = '${preset.sortOrder}';
    _isActive = preset.isActive;
    _selectedTextIds
      ..clear()
      ..addAll(preset.textOptionInternalIds);
    _selectedSizeIds
      ..clear()
      ..addAll(preset.sizeOptionInternalIds);
    _loaded = true;
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    if (ref.read(licenseEditingBlockedProvider)) {
      final license = ref.read(licenseNotifierProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(licenseWriteBlockedMessage(license, l10n))),
      );
      return;
    }
    final name = _nameCtrl.text.trim();
    if (!isNonEmptyPresetName(name)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.settingsStyleFigurePresetNameRequired)),
      );
      return;
    }
    final sortOrder = int.tryParse(_sortCtrl.text.trim());
    if (sortOrder == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.settingsStyleFigureSortOrderInvalid)),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      final repo = await ref.read(styleCatalogRepositoryProvider.future);
      final shopId = ref.read(effectiveShopIdProvider);
      final textIds = normalizeIdList(_selectedTextIds);
      final sizeIds = normalizeIdList(_selectedSizeIds);

      late final String presetId;
      if (widget.presetId == null) {
        presetId = await repo.createStyleFigurePreset(
          shopId: shopId,
          styleFigureInternalId: widget.figureId,
          name: name,
          textOptionInternalIds: textIds,
          sizeOptionInternalIds: sizeIds,
          sortOrder: sortOrder,
        );
        if (!_isActive) {
          await repo.updateStyleFigurePreset(
            internalId: presetId,
            isActive: false,
          );
        }
      } else {
        presetId = widget.presetId!;
        await repo.updateStyleFigurePreset(
          internalId: presetId,
          name: name,
          textOptionInternalIds: textIds,
          sizeOptionInternalIds: sizeIds,
          sortOrder: sortOrder,
          isActive: _isActive,
        );
      }
      enqueueStyleFigurePresetUpsert(
        ref,
        internalId: presetId,
        styleFigureInternalId: widget.figureId,
        name: name,
        textOptionInternalIds: textIds,
        sizeOptionInternalIds: sizeIds,
        sortOrder: sortOrder,
        isActive: _isActive,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.settingsStyleFigureSaved)),
        );
        context.pop();
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final canEdit = !ref.watch(licenseEditingBlockedProvider);
    final textOptionsAsync =
        ref.watch(styleFigureTextOptionsProvider(widget.figureId));
    final sizeOptionsAsync =
        ref.watch(styleFigureSizeOptionsProvider(widget.figureId));
    final presetsAsync =
        ref.watch(styleFigurePresetsProvider(widget.figureId));

    StyleFigurePresetSummary? existingPreset;
    final presets = presetsAsync.valueOrNull;
    if (presets != null && widget.presetId != null) {
      for (final p in presets) {
        if (p.internalId == widget.presetId) {
          existingPreset = p;
          break;
        }
      }
    }
    _loadPreset(existingPreset);

    final title = widget.presetId == null
        ? l10n.settingsStyleFigurePresetAddCta
        : l10n.settingsStyleFigurePresetEditTitle;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(title),
        actions: [
          if (canEdit)
            TextButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.saveCta),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          TextField(
            controller: _nameCtrl,
            enabled: canEdit,
            decoration: InputDecoration(
              labelText: l10n.settingsStyleFigurePresetNameLabel,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _sortCtrl,
            enabled: canEdit,
            decoration: InputDecoration(
              labelText: l10n.settingsStyleFigureSortOrderLabel,
              border: const OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.settingsStyleFigureActiveLabel),
            value: _isActive,
            onChanged: canEdit ? (v) => setState(() => _isActive = v) : null,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.settingsStyleFigurePresetSelectTextOptions,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          textOptionsAsync.when(
            data: (options) => _OptionChipSelector<StyleFigureTextOptionSummary>(
              options: options.where((o) => o.isActive).toList(),
              emptyLabel: l10n.settingsStyleFigureTextOptionsEmpty,
              labelBuilder: (o) => o.label,
              idBuilder: (o) => o.internalId,
              selectedIds: _selectedTextIds,
              canEdit: canEdit,
              onChanged: (ids) => setState(() {
                _selectedTextIds
                  ..clear()
                  ..addAll(ids);
              }),
            ),
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('$e'),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.settingsStyleFigurePresetSelectSizeOptions,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          sizeOptionsAsync.when(
            data: (options) => _OptionChipSelector<StyleFigureSizeOptionSummary>(
              options: options.where((o) => o.isActive).toList(),
              emptyLabel: l10n.settingsStyleFigureSizeOptionsEmpty,
              labelBuilder: (o) => o.label,
              idBuilder: (o) => o.internalId,
              selectedIds: _selectedSizeIds,
              canEdit: canEdit,
              onChanged: (ids) => setState(() {
                _selectedSizeIds
                  ..clear()
                  ..addAll(ids);
              }),
            ),
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('$e'),
          ),
        ],
      ),
    );
  }
}

class _OptionChipSelector<T> extends StatelessWidget {
  const _OptionChipSelector({
    required this.options,
    required this.emptyLabel,
    required this.labelBuilder,
    required this.idBuilder,
    required this.selectedIds,
    required this.canEdit,
    required this.onChanged,
  });

  final List<T> options;
  final String emptyLabel;
  final String Function(T) labelBuilder;
  final String Function(T) idBuilder;
  final Set<String> selectedIds;
  final bool canEdit;
  final ValueChanged<Set<String>> onChanged;

  @override
  Widget build(BuildContext context) {
    if (options.isEmpty) return Text(emptyLabel);
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        for (final option in options)
          FilterChip(
            label: Text(labelBuilder(option)),
            selected: selectedIds.contains(idBuilder(option)),
            onSelected: canEdit
                ? (selected) {
                    final next = Set<String>.from(selectedIds);
                    final id = idBuilder(option);
                    if (selected) {
                      next.add(id);
                    } else {
                      next.remove(id);
                    }
                    onChanged(next);
                  }
                : null,
          ),
      ],
    );
  }
}
