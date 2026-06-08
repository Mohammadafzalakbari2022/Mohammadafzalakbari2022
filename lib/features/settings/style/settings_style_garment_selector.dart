import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../../data/local/entities/garment_type.dart';
import 'settings_style_garment_provider.dart';

class SettingsStyleGarmentSelector extends ConsumerWidget {
  const SettingsStyleGarmentSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final selected = ref.watch(settingsStyleGarmentProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.settingsStyleGarmentTabsLabel,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 8),
          SegmentedButton<GarmentType>(
            segments: [
              ButtonSegment(
                value: GarmentType.perahanTunban,
                label: Text(l10n.garmentPerahanTunban),
              ),
              ButtonSegment(
                value: GarmentType.waistcoat,
                label: Text(l10n.garmentWaistcoat),
              ),
            ],
            selected: {selected},
            onSelectionChanged: (value) {
              ref.read(settingsStyleGarmentProvider.notifier).state =
                  value.first;
            },
          ),
        ],
      ),
    );
  }
}
