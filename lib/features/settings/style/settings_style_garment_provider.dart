import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/local/entities/garment_type.dart';

/// Selected garment library tab in Settings → Style screens.
final settingsStyleGarmentProvider = StateProvider<GarmentType>(
  (ref) => GarmentType.perahanTunban,
);
