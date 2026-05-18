import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/input/pride_ltr_input.dart';
import '../../core/defaults/effective_shop_profile.dart';
import '../../core/printing/thermal_printer_prefs.dart';
import '../../core/printing/thermal_printer_socket.dart';
import '../../core/printing/thermal_receipt_escpos.dart';
import '../../core/persistence/shared_preferences_provider.dart';
import '../../l10n/app_localizations.dart';
import 'shop_profile_provider.dart';

class SettingsPrinterScreen extends ConsumerStatefulWidget {
  const SettingsPrinterScreen({super.key});

  @override
  ConsumerState<SettingsPrinterScreen> createState() =>
      _SettingsPrinterScreenState();
}

class _SettingsPrinterScreenState extends ConsumerState<SettingsPrinterScreen> {
  final _hostCtrl = TextEditingController();
  final _portCtrl = TextEditingController(text: '${ThermalPrinterPrefs.defaultPort}');
  String _paperMm = ThermalPrinterPrefs.paper58;
  bool _prefsLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_prefsLoaded) return;
    _prefsLoaded = true;
    final prefs = ref.read(sharedPreferencesProvider);
    _hostCtrl.text = ThermalPrinterPrefs.readHost(prefs);
    _portCtrl.text = '${ThermalPrinterPrefs.readPort(prefs)}';
    _paperMm = ThermalPrinterPrefs.readPaperMm(prefs);
  }

  @override
  void dispose() {
    _hostCtrl.dispose();
    _portCtrl.dispose();
    super.dispose();
  }

  int? _parsePort(AppLocalizations l10n) {
    final raw = _portCtrl.text.trim();
    final p = int.tryParse(raw);
    if (p == null || p < 1 || p > 65535) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.settingsPrinterPortInvalidError)),
      );
      return null;
    }
    return p;
  }

  Future<void> _save(AppLocalizations l10n) async {
    final host = _hostCtrl.text.trim();
    if (host.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.settingsPrinterHostEmptyError)),
      );
      return;
    }
    final port = _parsePort(l10n);
    if (port == null) return;

    final prefs = ref.read(sharedPreferencesProvider);
    await ThermalPrinterPrefs.write(
      prefs,
      host: host,
      port: port,
      paperMm: _paperMm,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.settingsPrinterSaved)),
    );
  }

  Future<void> _testPrint(AppLocalizations l10n) async {
    if (kIsWeb) return;
    final host = _hostCtrl.text.trim();
    if (host.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.settingsPrinterHostEmptyError)),
      );
      return;
    }
    final port = _parsePort(l10n);
    if (port == null) return;

    final shop = ref.read(shopProfileProvider).valueOrNull;
    final headline = effectiveShopProfile(shop, l10n).name.trim();

    if (!mounted) return;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const PopScope(
        canPop: false,
        child: Center(child: CircularProgressIndicator()),
      ),
    );

    try {
      final paper = paperSizeFromMm(_paperMm);
      final bytes = await buildThermalTestReceipt(
        paper: paper,
        headline: headline,
        detail: l10n.settingsPrinterTestDetail,
      );
      await sendThermalReceiptBytes(host: host, port: port, bytes: bytes);
      if (mounted) Navigator.of(context, rootNavigator: true).pop();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.settingsPrinterTestOk)),
        );
      }
    } catch (e) {
      if (mounted) Navigator.of(context, rootNavigator: true).pop();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.settingsPrinterTestFail(e.toString()))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.settingsPrinterScreenTitle),
      ),
      body: kIsWeb
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  l10n.settingsPrinterWebUnavailable,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  l10n.settingsPrinterIntro,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.settingsPrinterAsciiNotice,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.settingsPrinterRetryHint,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _hostCtrl,
                  decoration: InputDecoration(
                    labelText: l10n.settingsPrinterHostLabel,
                    hintText: l10n.settingsPrinterHostHint,
                    border: const OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                  autocorrect: false,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _portCtrl,
                  decoration: InputDecoration(
                    labelText: l10n.settingsPrinterPortLabel,
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  textDirection: PrideLtrInput.direction,
                  textAlign: PrideLtrInput.align,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.settingsPrinterPaperWidthLabel,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                SegmentedButton<String>(
                  segments: [
                    ButtonSegment(
                      value: ThermalPrinterPrefs.paper58,
                      label: Text(l10n.settingsPrinterPaper58Label),
                    ),
                    ButtonSegment(
                      value: ThermalPrinterPrefs.paper80,
                      label: Text(l10n.settingsPrinterPaper80Label),
                    ),
                  ],
                  selected: {_paperMm},
                  onSelectionChanged: (s) {
                    setState(() => _paperMm = s.first);
                  },
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => _save(l10n),
                  child: Text(l10n.saveCta),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => _testPrint(l10n),
                  child: Text(l10n.settingsPrinterTestCta),
                ),
              ],
            ),
    );
  }
}
