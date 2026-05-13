import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'license_notifier.dart';

final licenseNotifierProvider =
    ChangeNotifierProvider<LicenseNotifier>((ref) => LicenseNotifier());
