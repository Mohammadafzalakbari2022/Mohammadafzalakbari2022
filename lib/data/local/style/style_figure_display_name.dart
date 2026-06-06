import '../style_figure_summary.dart';
import 'style_figure_image_ref.dart';

/// Resolves the user-visible name for a style figure (shape).
String resolveStyleFigureDisplayName({
  required String name,
  required String imageRef,
  required int sortOrder,
  String Function(int shapeNumber)? defaultNameBuilder,
}) {
  final custom = name.trim();
  if (custom.isNotEmpty) return custom;

  final bundled = StyleFigureImageRef.bundledShapeNumber(imageRef);
  if (bundled != null) {
    return defaultNameBuilder?.call(bundled) ?? 'Shape $bundled';
  }

  if (sortOrder > 0) {
    final index = (sortOrder / 10).round();
    if (index > 0) {
      return defaultNameBuilder?.call(index) ?? 'Shape $index';
    }
  }

  return defaultNameBuilder?.call(0) ?? 'Shape';
}

/// Convenience wrapper for [StyleFigureSummary].
String resolveStyleFigureSummaryDisplayName(
  StyleFigureSummary figure, {
  String Function(int shapeNumber)? defaultNameBuilder,
}) {
  return resolveStyleFigureDisplayName(
    name: figure.name,
    imageRef: figure.imageRef,
    sortOrder: figure.sortOrder,
    defaultNameBuilder: defaultNameBuilder,
  );
}
