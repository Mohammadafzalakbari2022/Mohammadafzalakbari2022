import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/local/entities/garment_type.dart';
import '../../../data/providers/local_data_providers.dart';

/// Refreshes order-composer style pickers after settings mutations or sync.
void refreshStyleCatalogProviders(WidgetRef ref, GarmentType garment) {
  ref.invalidate(styleFigureConfigsForGarmentProvider(garment));
  ref.invalidate(styleFiguresForGarmentProvider(garment));
  ref.invalidate(styleNamesForGarmentProvider(garment));
  ref.invalidate(stylePartsForGarmentProvider(garment));
}

void refreshAllGarmentStyleCatalogProviders(WidgetRef ref) {
  ref.invalidate(styleAllFigureConfigsProvider);
  for (final garment in GarmentType.values) {
    refreshStyleCatalogProviders(ref, garment);
  }
}
