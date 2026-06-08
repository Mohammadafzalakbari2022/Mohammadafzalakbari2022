import 'style_figure_config_summary.dart';

import 'style_figure_size_option_summary.dart';

import 'style_figure_summary.dart';

import 'style_figure_text_option_summary.dart';

import 'style_name_summary.dart';

import 'style_part_summary.dart';



abstract class StyleCatalogRepository {

  Future<void> seedIfEmpty(String shopId);



  Stream<List<StyleNameSummary>> watchStyleNames(
    String shopId, {
    int garmentTypeIndex = 0,
  });

  Stream<List<StylePartSummary>> watchStyleParts(
    String shopId, {
    int garmentTypeIndex = 0,
  });

  Stream<List<StyleFigureSummary>> watchFiguresForPart(

    String shopId,

    String partInternalId,

  );

  Stream<List<StyleFigureSummary>> watchAllFigures(
    String shopId, {
    int garmentTypeIndex = 0,
  });



  Stream<List<StyleFigureTextOptionSummary>> watchTextOptionsForFigure(

    String shopId,

    String styleFigureInternalId,

  );



  Stream<List<StyleFigureSizeOptionSummary>> watchSizeOptionsForFigure(

    String shopId,

    String styleFigureInternalId,

  );



  /// Loads configuration for all non-deleted figures in the shop.

  Future<Map<String, StyleFigureConfigSummary>> loadAllFigureConfigs(
    String shopId, {
    bool activeFiguresOnly = false,
    int? garmentTypeIndex,
  });



  Future<String> createStyleName({
    required String shopId,
    required String name,
    int garmentTypeIndex = 0,
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
    int garmentTypeIndex = 0,
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



  Future<String> createStyleFigureTextOption({

    required String shopId,

    required String styleFigureInternalId,

    required String label,

    int? sortOrder,

  });

  Future<void> updateStyleFigureTextOption({

    required String internalId,

    String? label,

    int? sortOrder,

    bool? isActive,

  });

  Future<void> softDeleteStyleFigureTextOption(String internalId);



  Future<String> createStyleFigureSizeOption({

    required String shopId,

    required String styleFigureInternalId,

    required String label,

    required double valueInches,

    int? unitCode,

    int? sortOrder,

  });

  Future<void> updateStyleFigureSizeOption({

    required String internalId,

    String? label,

    double? valueInches,

    int? unitCode,

    int? sortOrder,

    bool? isActive,

  });

  Future<void> softDeleteStyleFigureSizeOption(String internalId);



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



  Future<void> mergeRemoteStyleFigureTextOption({

    required String shopId,

    required String internalId,

    required String operation,

    Object? data,

  });



  Future<void> mergeRemoteStyleFigureSizeOption({

    required String shopId,

    required String internalId,

    required String operation,

    Object? data,

  });

}
