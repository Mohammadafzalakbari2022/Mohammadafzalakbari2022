import 'package:flutter/foundation.dart';

import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';



import '../../features/settings/settings_providers.dart';

import 'app_feedback.dart';

import 'platform_ui_sound.dart';



/// Plays short sounds and optional haptics for UI actions.

void playUiSoundFeedback(

  WidgetRef ref,

  AppFeedbackKind kind, {

  bool deleted = false,

}) {

  final sounds = ref.read(uiSoundsEnabledProvider);

  final haptics = ref.read(uiHapticsEnabledProvider);

  if (!sounds && !haptics) return;



  if (haptics && !kIsWeb) {

    switch (kind) {

      case AppFeedbackKind.success:

        HapticFeedback.lightImpact();

      case AppFeedbackKind.error:

        HapticFeedback.mediumImpact();

      case AppFeedbackKind.info:

        HapticFeedback.selectionClick();

    }

    if (deleted) {

      HapticFeedback.heavyImpact();

    }

  }



  if (!sounds) return;



  final kindName = switch (kind) {

    AppFeedbackKind.success => 'success',

    AppFeedbackKind.error => 'error',

    AppFeedbackKind.info => 'info',

  };

  playPlatformUiSound(kindName, deleted: deleted);

}



/// Preview sound while toggling settings (ignores mute for the preview only).

void playUiSoundPreview(AppFeedbackKind kind) {

  final kindName = switch (kind) {

    AppFeedbackKind.success => 'success',

    AppFeedbackKind.error => 'error',

    AppFeedbackKind.info => 'info',

  };

  playPlatformUiSound(kindName);

}


