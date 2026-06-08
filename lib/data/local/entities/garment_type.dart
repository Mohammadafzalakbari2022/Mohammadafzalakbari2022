/// Garment line on a multi-item order (Perahan/Tunban vs Waistcoat).
///
/// Pure Dart — no Flutter or Isar dependencies.
enum GarmentType {
  perahanTunban,
  waistcoat,
}

/// Stable integer stored in Isar/API payloads (`perahanTunban = 0`).
const int kGarmentTypePerahanTunbanCode = 0;

/// Stable integer stored in Isar/API payloads (`waistcoat = 1`).
const int kGarmentTypeWaistcoatCode = 1;

/// Stable snake_case API/sync key for [GarmentType.perahanTunban].
const String kGarmentTypePerahanTunbanApiKey = 'perahan_tunban';

/// Stable snake_case API/sync key for [GarmentType.waistcoat].
const String kGarmentTypeWaistcoatApiKey = 'waistcoat';

extension GarmentTypeCodes on GarmentType {
  int get code => switch (this) {
        GarmentType.perahanTunban => kGarmentTypePerahanTunbanCode,
        GarmentType.waistcoat => kGarmentTypeWaistcoatCode,
      };

  String get apiKey => switch (this) {
        GarmentType.perahanTunban => kGarmentTypePerahanTunbanApiKey,
        GarmentType.waistcoat => kGarmentTypeWaistcoatApiKey,
      };

  /// Default display/sort order: Perahan/Tunban first, Waistcoat second.
  int get defaultSortOrder => switch (this) {
        GarmentType.perahanTunban => 0,
        GarmentType.waistcoat => 1,
      };
}

/// Parses a stored integer code; unknown values fall back to [GarmentType.perahanTunban].
GarmentType garmentTypeFromCode(int? code) {
  switch (code) {
    case kGarmentTypeWaistcoatCode:
      return GarmentType.waistcoat;
    case kGarmentTypePerahanTunbanCode:
      return GarmentType.perahanTunban;
    default:
      return GarmentType.perahanTunban;
  }
}

/// Parses an API/sync string key; unknown values fall back to [GarmentType.perahanTunban].
GarmentType garmentTypeFromApiKey(String? key) {
  final normalized = key?.trim().toLowerCase() ?? '';
  switch (normalized) {
    case kGarmentTypeWaistcoatApiKey:
      return GarmentType.waistcoat;
    case kGarmentTypePerahanTunbanApiKey:
    case 'perahantunban':
      return GarmentType.perahanTunban;
    default:
      return GarmentType.perahanTunban;
  }
}

/// Compares garment types for stable list ordering (Perahan/Tunban before Waistcoat).
int compareGarmentTypeSortOrder(GarmentType a, GarmentType b) =>
    a.defaultSortOrder.compareTo(b.defaultSortOrder);
