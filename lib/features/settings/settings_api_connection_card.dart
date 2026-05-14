import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/core/api/pride_api_config.dart';
import 'package:pride_v3/core/api/pride_api_health.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../shell/shell_sync_providers.dart';

String _shortUrlForDisplay(String url) {
  if (url.length <= 56) return url;
  return '${url.substring(0, 26)}…${url.substring(url.length - 26)}';
}

/// API base URL + `GET /health` probe (plan-04 / plan-20).
class SettingsApiConnectionCard extends ConsumerStatefulWidget {
  const SettingsApiConnectionCard({super.key});

  @override
  ConsumerState<SettingsApiConnectionCard> createState() =>
      _SettingsApiConnectionCardState();
}

class _SettingsApiConnectionCardState
    extends ConsumerState<SettingsApiConnectionCard> {
  bool _pinging = false;
  PrideApiHealthResult? _last;

  Future<void> _runPing(AppLocalizations l10n) async {
    final online = ref.read(connectivityOnlineProvider);
    if (!online) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.settingsApiTestNeedOnline)),
      );
      return;
    }
    if (!PrideApiConfig.isConfigured) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.settingsApiServerNotConfigured)),
      );
      return;
    }

    setState(() {
      _pinging = true;
      _last = null;
    });
    final result = await pingPrideApiHealth();
    if (!mounted) return;
    setState(() {
      _pinging = false;
      _last = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final online = ref.watch(connectivityOnlineProvider);
    final base = PrideApiConfig.normalizedBase;

    final subtitle = base == null
        ? l10n.settingsApiServerNotConfigured
        : l10n.settingsApiServerConfigured(_shortUrlForDisplay(base));

    Widget? statusChild;
    final last = _last;
    if (last != null) {
      final scheme = Theme.of(context).colorScheme;
      switch (last) {
        case PrideApiHealthOk():
          statusChild = Text(
            l10n.settingsApiHealthOk,
            style: TextStyle(color: scheme.primary),
          );
        case PrideApiHealthFailure(:final message):
          statusChild = Text(
            message.isEmpty
                ? l10n.settingsApiServerNotConfigured
                : l10n.settingsApiHealthFailed(message),
            style: TextStyle(color: scheme.error),
          );
      }
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              leading: const Icon(Icons.dns_outlined),
              title: Text(l10n.settingsApiServerTitle),
              subtitle: Text(subtitle),
            ),
            if (statusChild != null) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: statusChild,
              ),
            ],
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: FilledButton.tonalIcon(
                onPressed: (!online || _pinging || base == null)
                    ? null
                    : () => _runPing(l10n),
                icon: _pinging
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.wifi_tethering_outlined),
                label: Text(l10n.settingsApiTestConnection),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
