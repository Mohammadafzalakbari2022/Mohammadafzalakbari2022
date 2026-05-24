import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/auth_providers.dart';
import '../../core/api/pride_api_config.dart';
import '../../data/providers/local_data_providers.dart';
import 'catalog_p2p_service.dart';
import 'catalog_sharing_provider.dart';

/// Polls P2P inbox and serves catalog download requests while sharing is on.
class CatalogP2pServeHost extends ConsumerStatefulWidget {
  const CatalogP2pServeHost({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<CatalogP2pServeHost> createState() =>
      _CatalogP2pServeHostState();
}

class _CatalogP2pServeHostState extends ConsumerState<CatalogP2pServeHost> {
  Timer? _timer;
  var _busy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncTimer());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _syncTimer() {
    _timer?.cancel();
    final auth = ref.read(authSessionProvider);
    final sharing = ref.read(catalogSharingEnabledProvider);
    if (!auth.hasApiSession ||
        auth.accessToken == null ||
        !sharing ||
        !PrideApiConfig.isConfigured) {
      return;
    }
    _timer = Timer.periodic(const Duration(seconds: 4), (_) => _tick());
    _tick();
  }

  Future<void> _tick() async {
    if (_busy || !mounted) return;
    final auth = ref.read(authSessionProvider);
    final token = auth.accessToken;
    final shopId = auth.shopId;
    if (!auth.hasApiSession || token == null || shopId == null) return;
    if (!ref.read(catalogSharingEnabledProvider)) return;

    _busy = true;
    try {
      final catalog = await ref.read(catalogRepositoryProvider.future);
      final p2p = CatalogP2pService(accessToken: token, myShopId: shopId);
      await p2p.servePendingDownloadRequests(catalog);
    } catch (_) {
      // Offline / API down — try again on next tick.
    } finally {
      _busy = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authSessionProvider, (_, _) => _syncTimer());
    ref.listen(catalogSharingEnabledProvider, (_, _) => _syncTimer());
    return widget.child;
  }
}
