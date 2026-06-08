import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/data/local/entities/garment_type.dart';

void main() {
  group('GarmentType codes', () {
    test('enum codes are stable', () {
      expect(GarmentType.perahanTunban.code, kGarmentTypePerahanTunbanCode);
      expect(GarmentType.waistcoat.code, kGarmentTypeWaistcoatCode);
      expect(kGarmentTypePerahanTunbanCode, 0);
      expect(kGarmentTypeWaistcoatCode, 1);
    });

    test('garmentTypeFromCode parses known codes', () {
      expect(
        garmentTypeFromCode(kGarmentTypePerahanTunbanCode),
        GarmentType.perahanTunban,
      );
      expect(
        garmentTypeFromCode(kGarmentTypeWaistcoatCode),
        GarmentType.waistcoat,
      );
    });

    test('garmentTypeFromCode falls back to perahanTunban', () {
      expect(garmentTypeFromCode(null), GarmentType.perahanTunban);
      expect(garmentTypeFromCode(-1), GarmentType.perahanTunban);
      expect(garmentTypeFromCode(99), GarmentType.perahanTunban);
    });
  });

  group('GarmentType API keys', () {
    test('api keys are stable', () {
      expect(GarmentType.perahanTunban.apiKey, kGarmentTypePerahanTunbanApiKey);
      expect(GarmentType.waistcoat.apiKey, kGarmentTypeWaistcoatApiKey);
    });

    test('garmentTypeFromApiKey parses known keys', () {
      expect(
        garmentTypeFromApiKey('perahan_tunban'),
        GarmentType.perahanTunban,
      );
      expect(garmentTypeFromApiKey('waistcoat'), GarmentType.waistcoat);
    });

    test('garmentTypeFromApiKey falls back to perahanTunban', () {
      expect(garmentTypeFromApiKey(null), GarmentType.perahanTunban);
      expect(garmentTypeFromApiKey(''), GarmentType.perahanTunban);
      expect(garmentTypeFromApiKey('unknown'), GarmentType.perahanTunban);
    });
  });

  group('GarmentType sort order', () {
    test('Perahan/Tunban sorts before Waistcoat', () {
      expect(
        compareGarmentTypeSortOrder(
          GarmentType.perahanTunban,
          GarmentType.waistcoat,
        ),
        lessThan(0),
      );
      expect(GarmentType.perahanTunban.defaultSortOrder, 0);
      expect(GarmentType.waistcoat.defaultSortOrder, 1);
    });
  });
}
