import 'package:flutter/material.dart';

import 'core/bootstrap/pride_bootstrap_root.dart';
import 'core/crash/pride_app_bootstrap.dart';

Future<void> main() async {
  await bootstrapPrideApp(() => runApp(const PrideBootstrapRoot()));
}
