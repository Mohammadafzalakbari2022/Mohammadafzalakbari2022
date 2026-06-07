import 'package:flutter/material.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/local/style/style_figure_display_name.dart';
import '../../data/local/style/style_figure_inch_display.dart';
import '../../data/local/style_figure_config_summary.dart';
import '../../data/local/style_figure_size_option_summary.dart';
import '../../data/local/style_figure_summary.dart';
import '../../data/local/style_figure_text_option_summary.dart';
import '../settings/style/style_figure_image.dart';
import 'order_composer_shape_config_draft.dart';

/// Responsive column count for the order style shape grid.
int orderComposerShapeGridColumns(double width) {
  if (width >= 700) return 3;
  if (width >= 360) return 2;
  return 1;
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

    final border = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: BorderSide(
        color: selected ? scheme.primary : scheme.outlineVariant,
        width: selected ? 2 : 1,
      ),
    );

    final imageBlock = AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: StyleFigureImage(
          imageRef: figure.imageRef,
          fit: BoxFit.contain,
          expand: true,
        ),
      ),
    );

    final nameBlock = Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Text(
        displayName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: theme.textTheme.labelLarge?.copyWith(
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
                  color: Colors.black54,
                  shape: const CircleBorder(),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: onToggleSelected,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.close,
                        size: 18,
                        color: scheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            if (!figure.isActive)
              Positioned(
                top: 4,
                left: 4,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2,
                    ),
                    child: Text(
                      l10n.settingsStyleInactiveLabel,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontSize: 10,
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
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_activeTextOptions.isNotEmpty) ...[
                  _OptionSection(
                    title: l10n.ordersComposerShapeDetailTitle,
                    children: [
                      for (final option in _activeTextOptions)
                        ChoiceChip(
                          label: Text(option.label),
                          visualDensity: VisualDensity.compact,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          selected:
                              draft.selectedTextOptionId == option.internalId,
                          onSelected: (_) {
                            _updateDraft((d) {
                              if (d.selectedTextOptionId == option.internalId) {
                                d.selectedTextOptionId = null;
                              } else {
                                d.selectedTextOptionId = option.internalId;
                              }
                            });
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                ],
                if (_activeSizeOptions.isNotEmpty) ...[
                  _OptionSection(
                    title: l10n.ordersComposerShapeInchTitle,
                    children: [
                      for (final option in _activeSizeOptions)
                        ChoiceChip(
                          label: Text(
                            displayInchOptionLabel(
                              valueInches: option.valueInches,
                              label: option.label,
                            ),
                          ),
                          visualDensity: VisualDensity.compact,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          selected:
                              draft.selectedSizeOptionId == option.internalId,
                          onSelected: (_) {
                            _updateDraft((d) {
                              if (d.selectedSizeOptionId == option.internalId) {
                                d.selectedSizeOptionId = null;
                              } else {
                                d.selectedSizeOptionId = option.internalId;
                              }
                            });
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                ],
                Text(
                  l10n.ordersComposerShapeNoteLabel,
                  style: theme.textTheme.labelMedium,
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: noteController,
                  maxLines: 2,
                  maxLength: kNoteMaxLength,
                  decoration: InputDecoration(
                    hintText: l10n.ordersComposerShapeNoteHint,
                    border: const OutlineInputBorder(),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
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

    return Material(
      color: selected
          ? scheme.primaryContainer.withValues(alpha: 0.22)
          : scheme.surfaceContainerLow,
      clipBehavior: Clip.antiAlias,
      shape: border,
      child: selected
          ? cardBody
          : InkWell(
              onTap: onToggleSelected,
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
