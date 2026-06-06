import 'style_figure_preset_summary.dart';
import 'style_figure_size_option_summary.dart';
import 'style_figure_summary.dart';
import 'style_figure_text_option_summary.dart';

/// Active catalog configuration for one style figure (shape).
class StyleFigureConfigSummary {
  const StyleFigureConfigSummary({
    required this.figure,
    required this.textOptions,
    required this.sizeOptions,
    required this.presets,
  });

  final StyleFigureSummary figure;
  final List<StyleFigureTextOptionSummary> textOptions;
  final List<StyleFigureSizeOptionSummary> sizeOptions;
  final List<StyleFigurePresetSummary> presets;
}
