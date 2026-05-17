import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'app_guide_banner.dart';
import 'app_guide_ids.dart';
import 'app_guide_providers.dart';

/// Shows contextual tips above tab content when the in-app guide is active.
class AppGuideHost extends ConsumerStatefulWidget {
  const AppGuideHost({
    super.key,
    required this.child,
    this.drawerGuideVisible = false,
  });

  final Widget child;
  final bool drawerGuideVisible;

  @override
  ConsumerState<AppGuideHost> createState() => _AppGuideHostState();
}

class _AppGuideHostState extends ConsumerState<AppGuideHost> {
  String? _lastPath;

  @override
  void didUpdateWidget(covariant AppGuideHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.drawerGuideVisible != widget.drawerGuideVisible) {
      setState(() {});
    }
  }

  String? _resolveGuideId(String path) {
    if (widget.drawerGuideVisible) {
      return AppGuideIds.dashboard;
    }
    return AppGuideIds.forPath(path);
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(appGuideStateProvider);
    final path = GoRouterState.of(context).uri.path;
    if (path != _lastPath) {
      _lastPath = path;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(appGuideStateProvider.notifier).refreshExpiry();
      });
    }

    final guideState = ref.watch(appGuideStateProvider);
    final guideId = _resolveGuideId(path);
    final showGuide = guideId != null && guideState.shouldShow(guideId);

    return Stack(
      fit: StackFit.expand,
      children: [
        widget.child,
        if (showGuide)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AppGuideBanner(guideId: guideId),
          ),
      ],
    );
  }
}
