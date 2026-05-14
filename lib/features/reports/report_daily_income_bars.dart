import 'package:flutter/material.dart';

import '../../data/local/payment_summary.dart';

/// Simple bar chart: payment totals per calendar day in \[monthStart, monthEndExclusive).
class ReportDailyIncomeBars extends StatelessWidget {
  const ReportDailyIncomeBars({
    super.key,
    required this.monthStart,
    required this.monthEndExclusive,
    required this.payments,
  });

  final DateTime monthStart;
  final DateTime monthEndExclusive;
  final List<PaymentSummary> payments;

  static const double _height = 120;

  List<MapEntry<DateTime, int>> _orderedBuckets() {
    final map = <DateTime, int>{};
    for (var d = DateTime(monthStart.year, monthStart.month, monthStart.day);
        d.isBefore(monthEndExclusive);
        d = d.add(const Duration(days: 1))) {
      map[d] = 0;
    }
    for (final p in payments) {
      final k = DateTime(p.createdAt.year, p.createdAt.month, p.createdAt.day);
      if (map.containsKey(k)) {
        map[k] = (map[k] ?? 0) + p.amountMinor;
      }
    }
    return map.entries.toList();
  }

  @override
  Widget build(BuildContext context) {
    final entries = _orderedBuckets();
    if (entries.isEmpty) {
      return const SizedBox.shrink();
    }
    final maxV = entries.fold<int>(0, (m, e) => e.value > m ? e.value : m);
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: _height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final e in entries)
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
                        color: scheme.primaryContainer,
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
