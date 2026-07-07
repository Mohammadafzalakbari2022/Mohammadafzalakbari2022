import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Data produced during cold start, consumed by [PrideBootstrapRoot].
class PrideStartupPayload {
  const PrideStartupPayload({required this.overrides});

  final List<Override> overrides;
}
