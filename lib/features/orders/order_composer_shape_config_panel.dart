import 'package:flutter/material.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/local/style/style_figure_display_name.dart';
import '../../data/local/style_figure_config_summary.dart';
import '../../data/local/style_figure_preset_summary.dart';
import '../../data/local/style_figure_summary.dart';
import '../settings/style/style_figure_image.dart';
import 'order_composer_shape_config_draft.dart';

class OrderComposerShapeConfigPanel extends StatelessWidget {
  const OrderComposerShapeConfigPanel({
    super.key,
    required this.selectedFigureIds,
    required this.allFigures,
    required this.configs,
    required this.drafts,
    required this.expandedShapeId,
    required this.onExpandedShapeChanged,
    required this.onDraftChanged,
  });

  final Set<String> selectedFigureIds;
  final List<StyleFigureSummary> allFigures;
  final Map<String, StyleFigureConfigSummary> configs;
  final Map<String, ShapeConfigDraft> drafts;
  final String? expandedShapeId;
  final ValueChanged<String?> onExpandedShapeChanged;
  final void Function(String shapeId, ShapeConfigDraft draft) onDraftChanged;

  List<StyleFigureSummary> get _selectedFigures {
    final byId = {for (final f in allFigures) f.internalId: f};
    final list = selectedFigureIds
        .map((id) => byId[id])
        .whereType<StyleFigureSummary>()
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final figures = _selectedFigures;
    if (figures.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.ordersComposerShapeConfigureTitle,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        for (final figure in figures)
          _ShapeConfigCard(
            figure: figure,
            config: configs[figure.internalId],
            draft: drafts[figure.internalId] ?? ShapeConfigDraft(shapeId: figure.internalId),
            expanded: expandedShapeId == figure.internalId,
            onExpansionChanged: (expanded) {
              onExpandedShapeChanged(expanded ? figure.internalId : null);
            },
            onDraftChanged: (draft) => onDraftChanged(figure.internalId, draft),
            l10n: l10n,
          ),
      ],
    );
  }
}

class _ShapeConfigCard extends StatelessWidget {
  const _ShapeConfigCard({
    required this.figure,
    required this.config,
    required this.draft,
    required this.expanded,
    required this.onExpansionChanged,
    required this.onDraftChanged,
    required this.l10n,
  });

  final StyleFigureSummary figure;
  final StyleFigureConfigSummary? config;
  final ShapeConfigDraft draft;
  final bool expanded;
  final ValueChanged<bool> onExpansionChanged;
  final ValueChanged<ShapeConfigDraft> onDraftChanged;
  final AppLocalizations l10n;

  void _updateDraft(void Function(ShapeConfigDraft draft) mutate) {
    final next = draft.copy();
    mutate(next);
    onDraftChanged(next);
  }

  List<StyleFigurePresetSummary> get _activePresets =>
      config?.presets.where((p) => p.isActive).toList(growable: false) ??
      const [];

  @override
  Widget build(BuildContext context) {
    final displayName = resolveStyleFigureSummaryDisplayName(figure);
    final textOptions =
        config?.textOptions.where((o) => o.isActive).toList(growable: false) ??
            const [];
    final sizeOptions =
        config?.sizeOptions.where((o) => o.isActive).toList(growable: false) ??
            const [];

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        key: ValueKey('${figure.internalId}-$expanded'),
        initiallyExpanded: expanded,
        onExpansionChanged: onExpansionChanged,
        leading: SizedBox(
          width: 44,
          height: 44,
          child: StyleFigureImage(
            imageRef: figure.imageRef,
            fit: BoxFit.contain,
            expand: true,
          ),
        ),
        title: Text(displayName),
        subtitle: _buildSubtitle(context),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.ordersComposerShapePresetsTitle,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 8),
                if (_activePresets.isEmpty)
                  Text(
                    l10n.ordersComposerShapeNoPresets,
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      for (final preset in _activePresets)
                        ChoiceChip(
                          label: Text(preset.name),
                          selected: draft.selectedPresetId == preset.internalId,
                          onSelected: (_) {
                            _updateDraft(
                              (d) => applyPresetToDraft(
                                draft: d,
                                preset: preset,
                              ),
                            );
                          },
                        ),
                      if (draft.selectedPresetId != null)
                        ActionChip(
                          label: Text(l10n.ordersComposerShapeClearPreset),
                          onPressed: () {
                            _updateDraft((d) => d.selectedPresetId = null);
                          },
                        ),
                    ],
                  ),
                const SizedBox(height: 16),
                Text(
                  l10n.ordersComposerShapeTextOptionsTitle,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 8),
                if (textOptions.isEmpty)
                  Text(
                    l10n.ordersComposerShapeNoTextOptions,
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      for (final option in textOptions)
                        FilterChip(
                          label: Text(option.label),
                          selected: draft.selectedTextOptionIds
                              .contains(option.internalId),
                          onSelected: (selected) {
                            _updateDraft((d) {
                              if (selected) {
                                d.selectedTextOptionIds.add(option.internalId);
                              } else {
                                d.selectedTextOptionIds
                                    .remove(option.internalId);
                              }
                            });
                          },
                        ),
                    ],
                  ),
                const SizedBox(height: 16),
                Text(
                  l10n.ordersComposerShapeSizeOptionsTitle,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 8),
                if (sizeOptions.isEmpty)
                  Text(
                    l10n.ordersComposerShapeNoSizeOptions,
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      for (final option in sizeOptions)
                        FilterChip(
                          label: Text(option.label),
                          selected: draft.selectedSizeOptionIds
                              .contains(option.internalId),
                          onSelected: (selected) {
                            _updateDraft((d) {
                              if (selected) {
                                d.selectedSizeOptionIds.add(option.internalId);
                              } else {
                                d.selectedSizeOptionIds
                                    .remove(option.internalId);
                              }
                            });
                          },
                        ),
                    ],
                  ),
                const SizedBox(height: 16),
                Text(
                  l10n.ordersComposerShapeSelectedDetailsTitle,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  _buildPreviewBody(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget? _buildSubtitle(BuildContext context) {
    if (!figure.isActive) {
      return Text(
        l10n.ordersComposerShapeInactiveHint,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
      );
    }
    final preview = _buildPreviewSubtitle();
    if (preview == null) return null;
    return Text(
      preview,
      style: Theme.of(context).textTheme.bodySmall,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  String? _buildPreviewSubtitle() {
    final body = _buildPreviewBody();
    if (body.isEmpty) return null;
    final line = body.split('\n').first.trim();
    return line.isEmpty ? null : line;
  }

  String _buildPreviewBody() {
    final lines = <String>[];
    if (draft.selectedPresetId != null && config != null) {
      for (final preset in config!.presets) {
        if (preset.internalId == draft.selectedPresetId) {
          lines.add(preset.name);
          break;
        }
      }
    }

    if (config != null) {
      final textById = {
        for (final o in config!.textOptions) o.internalId: o.label,
      };
      for (final id in draft.selectedTextOptionIds) {
        final label = textById[id];
        if (label != null && label.isNotEmpty) {
          lines.add('· $label');
        }
      }

      final sizeById = {
        for (final o in config!.sizeOptions) o.internalId: o.label,
      };
      for (final id in draft.selectedSizeOptionIds) {
        final label = sizeById[id];
        if (label != null && label.isNotEmpty) {
          lines.add('· $label');
        }
      }
    }

    return lines.join('\n');
  }
}
