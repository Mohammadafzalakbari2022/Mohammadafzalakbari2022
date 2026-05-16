import 'style_figure_summary.dart';
import 'style_name_summary.dart';
import 'style_part_summary.dart';

abstract class StyleCatalogRepository {
  Future<void> seedIfEmpty(String shopId);

  Stream<List<StyleNameSummary>> watchStyleNames(String shopId);
  Stream<List<StylePartSummary>> watchStyleParts(String shopId);
  Stream<List<StyleFigureSummary>> watchFiguresForPart(
    String shopId,
    String partInternalId,
  );
  Stream<List<StyleFigureSummary>> watchAllFigures(String shopId);

  Future<String> createStyleName({
    required String shopId,
    required String name,
    int? sortOrder,
  });
  Future<void> updateStyleName({
    required String internalId,
    required String name,
    int? sortOrder,
    bool? isActive,
  });
  Future<void> softDeleteStyleName(String internalId);

  Future<String> createStylePart({
    required String shopId,
    required String name,
    int? sortOrder,
  });
  Future<void> updateStylePart({
    required String internalId,
    required String name,
    int? sortOrder,
    bool? isActive,
  });
  Future<void> softDeleteStylePart(String internalId);

  Future<String> createStyleFigure({
    required String shopId,
    required String partInternalId,
    required String name,
    required String imageRef,
    int? sortOrder,
  });
  Future<void> updateStyleFigure({
    required String internalId,
    String? name,
    String? imageRef,
    int? sortOrder,
    bool? isActive,
  });
  Future<void> softDeleteStyleFigure(String internalId);

  Future<void> mergeRemoteStyleName({
    required String shopId,
    required String internalId,
    required String operation,
    Object? data,
  });
  Future<void> mergeRemoteStylePart({
    required String shopId,
    required String internalId,
    required String operation,
    Object? data,
  });
  Future<void> mergeRemoteStyleFigure({
    required String shopId,
    required String internalId,
    required String operation,
    Object? data,
  });
}
