import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/app/app_theme.dart';
import 'package:pride_v3/core/feedback/app_feedback.dart';
import 'package:pride_v3/core/feedback/app_sound_feedback.dart';
import 'package:pride_v3/core/feedback/notification_sound_bridge.dart';
import 'package:pride_v3/core/persistence/shared_preferences_provider.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import 'settings_providers.dart';

/// Sound and haptic toggles with preview buttons (used on Settings tab and Appearance).
class SettingsSoundFeedbackTiles extends ConsumerWidget {
  const SettingsSoundFeedbackTiles({super.key, this.dense = false});

  final bool dense;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final sounds = ref.watch(uiSoundsEnabledProvider);
    final haptics = ref.watch(uiHapticsEnabledProvider);
    final prefs = ref.read(sharedPreferencesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SwitchListTile(
          secondary: PrideColoredLeading(
            icon: Icons.volume_up_outlined,
            color: prideSettingsIconColor(8),
          ),
          title: Text(l10n.settingsUiSoundsTitle),
          subtitle: Text(l10n.settingsUiSoundsSubtitle),
          value: sounds,
          onChanged: (v) async {
            ref.read(uiSoundsEnabledProvider.notifier).state = v;
            await persistUiSounds(prefs, v);
            NotificationSoundBridge.configure(
              soundsEnabled: v,
              muted: ref.read(notificationsMutedProvider),
            );
            if (v) playUiSoundPreview(AppFeedbackKind.success);
          },
        ),
        if (sounds && !dense) ...[
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _PreviewChip(
                  label: l10n.settingsSoundPreviewSuccess,
                  icon: Icons.check_circle_outline,
                  onPressed: () =>
                      playUiSoundPreview(AppFeedbackKind.success),
                ),
                _PreviewChip(
                  label: l10n.settingsSoundPreviewError,
                  icon: Icons.error_outline,
                  onPressed: () => playUiSoundPreview(AppFeedbackKind.error),
                ),
                _PreviewChip(
                  label: l10n.settingsSoundPreviewDelete,
                  icon: Icons.delete_outline,
                  onPressed: () {
                    SystemSound.play(SystemSoundType.alert);
                  },
                ),
              ],
            ),
          ),
        ],
        if (!dense) const Divider(height: 1),
        SwitchListTile(
          secondary: PrideColoredLeading(
            icon: Icons.vibration,
            color: prideSettingsIconColor(9),
          ),
          title: Text(l10n.settingsUiHapticsTitle),
          subtitle: Text(
            kIsWeb ? l10n.settingsUiHapticsWebHint : l10n.settingsUiHapticsSubtitle,
          ),
          value: haptics,
          onChanged: kIsWeb
              ? null
              : (v) async {
                  ref.read(uiHapticsEnabledProvider.notifier).state = v;
                  await persistUiHaptics(prefs, v);
                  if (v) HapticFeedback.lightImpact();
                },
        ),
      ],
    );
  }
}

class _PreviewChip extends StatelessWidget {
  const _PreviewChip({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: onPressed,
    );
  }
}
