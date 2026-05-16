import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/settings/settings_providers.dart';

enum AppFeedbackKind { success, error, info }

Duration _durationFor(AppFeedbackKind kind) {
  switch (kind) {
    case AppFeedbackKind.success:
      return const Duration(milliseconds: 2800);
    case AppFeedbackKind.error:
      return const Duration(milliseconds: 4200);
    case AppFeedbackKind.info:
      return const Duration(milliseconds: 2600);
  }
}

void showAppFeedback(
  BuildContext context,
  WidgetRef ref, {
  required AppFeedbackKind kind,
  required String message,
}) {
  if (!context.mounted) return;

  final reduceMotion =
      SchedulerBinding.instance.platformDispatcher.accessibilityFeatures
          .disableAnimations;
  final sounds = ref.read(uiSoundsEnabledProvider);
  final haptics = ref.read(uiHapticsEnabledProvider);

  if (kind == AppFeedbackKind.success && !reduceMotion) {
    if (haptics && !kIsWeb) {
      HapticFeedback.lightImpact();
    }
    if (sounds) {
      SystemSound.play(SystemSoundType.click);
    }
  }

  final scheme = Theme.of(context).colorScheme;
  final messenger = ScaffoldMessenger.of(context);

  final (Color bg, Color fg) = switch (kind) {
    AppFeedbackKind.success => (
      scheme.primaryContainer,
      scheme.onPrimaryContainer,
    ),
    AppFeedbackKind.error => (
      scheme.errorContainer,
      scheme.onErrorContainer,
    ),
    AppFeedbackKind.info => (
      scheme.surfaceContainerHighest,
      scheme.onSurface,
    ),
  };

  final duration = _durationFor(kind);
  messenger.showSnackBar(
    SnackBar(
      duration: duration,
      backgroundColor: bg,
      content: _SnackProgressMessage(
        message: message,
        duration: duration,
        foregroundColor: fg,
        progressColor: scheme.primary,
        animateProgress: !reduceMotion,
      ),
    ),
  );
}

class _SnackProgressMessage extends StatefulWidget {
  const _SnackProgressMessage({
    required this.message,
    required this.duration,
    required this.foregroundColor,
    required this.progressColor,
    required this.animateProgress,
  });

  final String message;
  final Duration duration;
  final Color foregroundColor;
  final Color progressColor;
  final bool animateProgress;

  @override
  State<_SnackProgressMessage> createState() => _SnackProgressMessageState();
}

class _SnackProgressMessageState extends State<_SnackProgressMessage>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.animateProgress) {
      _controller = AnimationController(
        vsync: this,
        duration: widget.duration,
      )..forward();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bar = widget.animateProgress && _controller != null
        ? AnimatedBuilder(
            animation: _controller!,
            builder: (context, _) {
              return ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
                child: LinearProgressIndicator(
                  value: 1.0 - _controller!.value,
                  minHeight: 3,
                  backgroundColor: widget.foregroundColor.withValues(
                    alpha: 0.25,
                  ),
                  color: widget.progressColor,
                ),
              );
            },
          )
        : ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            child: LinearProgressIndicator(
              value: 1,
              minHeight: 3,
              backgroundColor: widget.foregroundColor.withValues(alpha: 0.25),
              color: widget.progressColor,
            ),
          );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        bar,
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
          child: Text(
            widget.message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: widget.foregroundColor,
            ),
          ),
        ),
      ],
    );
  }
}
