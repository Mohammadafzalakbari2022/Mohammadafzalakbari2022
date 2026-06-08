// Width-based responsive text scale helpers.
// Combined with the user font preset in prideEffectiveTextScale and applied
// once via MediaQuery.textScaler at the app root.

// Subtle width-based factor; does not replace the user preset.
double prideResponsiveTextScaleFactor(double width) {
  if (width < 360) return 0.94;
  if (width < 430) return 1.00;
  if (width < 600) return 1.02;
  if (width < 840) return 1.06;
  return 1.10;
}

// Final scale = user preset × responsive factor, clamped once.
double prideEffectiveTextScale({
  required double userScale,
  required double width,
  double minScale = 0.95,
  double maxScale = 1.35,
}) {
  return (userScale * prideResponsiveTextScaleFactor(width))
      .clamp(minScale, maxScale)
      .toDouble();
}
