import '../seed_data.dart';
import 'style_figure_image_ref.dart';

/// Stable template for one built-in (bundled) design figure.
class BundledStyleFigureTemplate {
  const BundledStyleFigureTemplate({
    required this.internalId,
    required this.partInternalId,
    required this.shapeNumber,
  });

  final String internalId;
  final String partInternalId;
  final int shapeNumber;

  int get sortOrder => shapeNumber * 10;

  String get imageRef => StyleFigureImageRef.bundledAssetKey(shapeNumber);
}

/// All 15 bundled figures in catalog order.
const bundledStyleFigureTemplates = <BundledStyleFigureTemplate>[
  BundledStyleFigureTemplate(
    internalId: DevSeedIds.styleFigure1,
    partInternalId: DevSeedIds.stylePartSleeve,
    shapeNumber: 1,
  ),
  BundledStyleFigureTemplate(
    internalId: DevSeedIds.styleFigure2,
    partInternalId: DevSeedIds.stylePartSleeve,
    shapeNumber: 2,
  ),
  BundledStyleFigureTemplate(
    internalId: DevSeedIds.styleFigure3,
    partInternalId: DevSeedIds.stylePartSleeve,
    shapeNumber: 3,
  ),
  BundledStyleFigureTemplate(
    internalId: DevSeedIds.styleFigure4,
    partInternalId: DevSeedIds.stylePartCollar,
    shapeNumber: 4,
  ),
  BundledStyleFigureTemplate(
    internalId: DevSeedIds.styleFigure5,
    partInternalId: DevSeedIds.stylePartCollar,
    shapeNumber: 5,
  ),
  BundledStyleFigureTemplate(
    internalId: DevSeedIds.styleFigure6,
    partInternalId: DevSeedIds.stylePartPocket,
    shapeNumber: 6,
  ),
  BundledStyleFigureTemplate(
    internalId: DevSeedIds.styleFigure7,
    partInternalId: DevSeedIds.stylePartPocket,
    shapeNumber: 7,
  ),
  BundledStyleFigureTemplate(
    internalId: DevSeedIds.styleFigure8,
    partInternalId: DevSeedIds.stylePartCuff,
    shapeNumber: 8,
  ),
  BundledStyleFigureTemplate(
    internalId: DevSeedIds.styleFigure9,
    partInternalId: DevSeedIds.stylePartCuff,
    shapeNumber: 9,
  ),
  BundledStyleFigureTemplate(
    internalId: DevSeedIds.styleFigure10,
    partInternalId: DevSeedIds.stylePartNeck,
    shapeNumber: 10,
  ),
  BundledStyleFigureTemplate(
    internalId: DevSeedIds.styleFigure11,
    partInternalId: DevSeedIds.stylePartNeck,
    shapeNumber: 11,
  ),
  BundledStyleFigureTemplate(
    internalId: DevSeedIds.styleFigure12,
    partInternalId: DevSeedIds.stylePartFront,
    shapeNumber: 12,
  ),
  BundledStyleFigureTemplate(
    internalId: DevSeedIds.styleFigure13,
    partInternalId: DevSeedIds.stylePartFront,
    shapeNumber: 13,
  ),
  BundledStyleFigureTemplate(
    internalId: DevSeedIds.styleFigure14,
    partInternalId: DevSeedIds.stylePartBottom,
    shapeNumber: 14,
  ),
  BundledStyleFigureTemplate(
    internalId: DevSeedIds.styleFigure15,
    partInternalId: DevSeedIds.stylePartBottom,
    shapeNumber: 15,
  ),
];

/// Whether a bundled figure row needs metadata repair for [shopId].
bool bundledStyleFigureNeedsRepair({
  required String shopId,
  required BundledStyleFigureTemplate template,
  required String existingShopId,
  required String existingImageRef,
  required String existingPartInternalId,
  required int existingSortOrder,
  required bool isDeleted,
}) {
  if (isDeleted) return true;
  if (existingShopId != shopId) return true;
  if (existingImageRef.trim().isEmpty) return true;
  if (StyleFigureImageRef.bundledShapeNumber(existingImageRef) !=
      template.shapeNumber) {
    return true;
  }
  if (existingPartInternalId.trim().isEmpty) return true;
  if (existingPartInternalId != template.partInternalId) return true;
  if (existingSortOrder <= 0) return true;
  return false;
}
