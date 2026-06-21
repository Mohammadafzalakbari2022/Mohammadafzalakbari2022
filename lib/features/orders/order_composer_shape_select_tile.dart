import 'package:flutter/material.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../core/input/pride_ltr_input.dart';
import '../../data/local/style/style_figure_display_name.dart';
import '../../data/local/style/style_figure_inch_display.dart';
import '../../data/local/style_figure_config_summary.dart';
import '../../data/local/style_figure_size_option_summary.dart';
import '../../data/local/style_figure_summary.dart';
import '../../data/local/style_figure_text_option_summary.dart';
import '../settings/style/style_figure_image.dart';
import 'order_composer_shape_config_draft.dart';

/// Responsive column count for the order style shape grid (~4–7 by width).
int orderComposerShapeGridColumns(double width) {
  if (width >= 900) return 7;
  if (width >= 720) return 6;
  if (width >= 520) return 4;
  if (width >= 360) return 3;
  return 2;
}

/// One shape card in the order style sheet: large image, compact card, inline
/// detail/inch/note when selected.
class OrderComposerShapeSelectTile extends StatelessWidget {
  const OrderComposerShapeSelectTile({
    super.key,
    required this.figure,
    required this.config,
    required this.draft,
    required this.selected,
    required this.onToggleSelected,
    required this.onDraftChanged,
    required this.l10n,
    this.noteController,
  });

  final StyleFigureSummary figure;
  final StyleFigureConfigSummary? config;
  final ShapeConfigDraft draft;
  final bool selected;
  final VoidCallback onToggleSelected;
  final ValueChanged<ShapeConfigDraft> onDraftChanged;
  final AppLocalizations l10n;
  final TextEditingController? noteController;

  static const int kNoteMaxLength = 120;

  void _updateDraft(void Function(ShapeConfigDraft d) mutate) {
    final next = draft.copy();
    mutate(next);
    onDraftChanged(next);
  }

  List<StyleFigureTextOptionSummary> get _activeTextOptions =>
      config?.textOptions.where((o) => o.isActive).toList(growable: false) ??
      const [];

  List<StyleFigureSizeOptionSummary> get _activeSizeOptions =>
      config?.sizeOptions.where((o) => o.isActive).toList(growable: false) ??
      const [];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final displayName = resolveStyleFigureSummaryDisplayName(figure);

    final imageBlock = AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: StyleFigureImage(
          imageRef: figure.imageRef,
          fit: BoxFit.contain,
          expand: true,
        ),
      ),
    );

    final nameBlock = Padding(
      padding: const EdgeInsets.fromLTRB(2, 0, 2, 4),
      child: Text(
        displayName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );

    final cardBody = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            imageBlock,
            if (selected)
              Positioned(
                top: 0,
                right: 0,
                child: Material(
                  color: scheme.primary,
                  shape: const CircleBorder(),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: onToggleSelected,
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: Icon(
                        Icons.close,
                        size: 14,
                        color: scheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            if (!figure.isActive)
              Positioned(
                top: 2,
                left: 2,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 1,
                    ),
                    child: Text(
                      l10n.settingsStyleInactiveLabel,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontSize: 9,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        nameBlock,
        if (selected)
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 0, 2, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_activeTextOptions.isNotEmpty) ...[
                  _OptionSection(
                    title: l10n.ordersComposerShapeDetailTitle,
                    children: [
                      for (final option in _activeTextOptions)
                        FilterChip(
                          label: Text(option.label),
                          visualDensity: VisualDensity.compact,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          selected: draft.selectedTextOptionIds
                              .contains(option.internalId),
                          onSelected: (selected) {
                            _updateDraft((d) {
                              if (selected) {
                                d.selectedTextOptionIds.add(option.internalId);
                              } else {
                                d.selectedTextOptionIds.remove(option.internalId);
                              }
                            });
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                ],
                if (_activeSizeOptions.isNotEmpty) ...[
                  _OptionSection(
                    title: l10n.ordersComposerShapeInchTitle,
                    children: [
                      for (final option in _activeSizeOptions)
                        FilterChip(
                          label: PrideLtrText(
                            text: displayInchOptionLabel(
                              valueInches: option.valueInches,
                              label: option.label,
                            ),
                          ),
                          visualDensity: VisualDensity.compact,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          selected: draft.selectedSizeOptionIds
                              .contains(option.internalId),
                          onSelected: (selected) {
                            _updateDraft((d) {
                              if (selected) {
                                d.selectedSizeOptionIds.add(option.internalId);
                              } else {
                                d.selectedSizeOptionIds.remove(option.internalId);
                              }
                            });
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                ],
                TextField(
                  controller: noteController,
                  maxLines: 2,
                  maxLength: kNoteMaxLength,
                  decoration: InputDecoration(
                    hintText: l10n.ordersComposerShapeNoteHint,
                    border: const OutlineInputBorder(),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    counterText: '',
                  ),
                  style: theme.textTheme.bodySmall,
                  onChanged: (value) {
                    _updateDraft((d) => d.note = value);
                  },
                ),
              ],
            ),
          ),
      ],
    );

    return InkWell(
      onTap: selected ? null : onToggleSelected,
      borderRadius: BorderRadius.circular(6),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: selected
              ? scheme.primaryContainer.withValues(alpha: 0.18)
              : null,
          borderRadius: BorderRadius.circular(6),
        ),
        child: cardBody,
      ),
    );
  }
}

class _OptionSection extends StatelessWidget {
  const _OptionSection({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: theme.textTheme.labelMedium),
        const SizedBox(height: 4),
        Wrap(
          spacing: 6,
          runSpacing: 4,
          children: children,
        ),
      ],
    );
  }
}
