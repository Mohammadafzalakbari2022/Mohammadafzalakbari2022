import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/afghan_pride_app.dart';
import 'pride_bootstrap_shell.dart';
import 'pride_startup_loader.dart';
import 'pride_startup_payload.dart';

const _startupTimeout = Duration(seconds: 25);

/// Root widget: paints immediately, then swaps to [AfghanPrideApp] when ready.
class PrideBootstrapRoot extends StatefulWidget {
  const PrideBootstrapRoot({super.key});

  @override
  State<PrideBootstrapRoot> createState() => _PrideBootstrapRootState();
}

class _PrideBootstrapRootState extends State<PrideBootstrapRoot> {
  late Future<PrideStartupPayload> _startupFuture;

  @override
  void initState() {
    super.initState();
    _startupFuture = _loadWithTimeout();
  }

  Future<PrideStartupPayload> _loadWithTimeout() {
    return loadPrideStartupPayload().timeout(
      _startupTimeout,
      onTimeout: () => throw TimeoutException(
        'Startup did not finish within ${_startupTimeout.inSeconds}s',
      ),
    );
  }

  void _retryStartup() {
    setState(() {
      _startupFuture = _loadWithTimeout();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PrideStartupPayload>(
      future: _startupFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return PrideBootstrapMaterialHost(
            child: PrideBootstrapErrorView(
              error: snapshot.error!,
              onRetry: _retryStartup,
            ),
          );
        }
        if (snapshot.connectionState != ConnectionState.done) {
          return const PrideBootstrapMaterialHost(
            child: PrideBootstrapLoadingView(),
          );
        }
        final payload = snapshot.data!;
        return ProviderScope(
          overrides: payload.overrides,
          child: const AfghanPrideApp(),
        );
      },
    );
  }
}
