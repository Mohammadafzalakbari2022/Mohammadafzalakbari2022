import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/app/app_theme.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

class SettingsFabricScreen extends StatelessWidget {
  const SettingsFabricScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.settingsFabricHubTitle),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: PrideColoredLeading(
              icon: Icons.texture_outlined,
              color: prideSettingsIconColor(3),
            ),
            title: Text(l10n.settingsFabricNamesTitle),
            subtitle: Text(l10n.settingsFabricNamesSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/app/settings/fabric/names'),
          ),
          const Divider(height: 1),
          ListTile(
            leading: PrideColoredLeading(
              icon: Icons.palette_outlined,
              color: prideSettingsIconColor(4),
            ),
            title: Text(l10n.settingsFabricColorsTitle),
            subtitle: Text(l10n.settingsFabricColorsSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/app/settings/fabric/colors'),
          ),
          const Divider(height: 1),
          ListTile(
            leading: PrideColoredLeading(
              icon: Icons.inventory_2_outlined,
              color: prideSettingsIconColor(5),
            ),
            title: Text(l10n.settingsClothStockTitle),
            subtitle: Text(l10n.settingsClothStockSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/app/settings/fabric/stock'),
          ),
          const Divider(height: 1),
          ListTile(
            leading: PrideColoredLeading(
              icon: Icons.local_shipping_outlined,
              color: prideSettingsIconColor(6),
            ),
            title: Text(l10n.settingsClothSuppliersTitle),
            subtitle: Text(l10n.settingsClothSuppliersSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/app/settings/fabric/suppliers'),
          ),
          const Divider(height: 1),
          ListTile(
            leading: PrideColoredLeading(
              icon: Icons.receipt_long_outlined,
              color: prideSettingsIconColor(7),
            ),
            title: Text(l10n.settingsClothPurchasesTitle),
            subtitle: Text(l10n.settingsClothPurchasesSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/app/settings/fabric/purchases'),
          ),
        ],
      ),
    );
  }
}
