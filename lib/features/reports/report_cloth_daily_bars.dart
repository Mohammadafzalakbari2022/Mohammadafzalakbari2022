import 'package:flutter/material.dart';

/// Bar chart of cloth revenue per calendar day in \[monthStart, monthEndExclusive).
class ReportClothDailyBars extends StatelessWidget {
  const ReportClothDailyBars({
    super.key,
    required this.buckets,
  });

  final List<MapEntry<DateTime, int>> buckets;

  static const double _height = 120;

  @override
  Widget build(BuildContext context) {
    if (buckets.isEmpty) return const SizedBox.shrink();
    final maxV = buckets.fold<int>(0, (m, e) => e.value > m ? e.value : m);
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: _height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final e in buckets)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.5),
                child: Tooltip(
                  message: '${e.value}',
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      height: maxV == 0
                          ? 0.0
                          : (_height * (e.value / maxV)).clamp(2.0, _height),
                      decoration: BoxDecoration(
                        color: scheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
