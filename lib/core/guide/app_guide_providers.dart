import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../persistence/shared_preferences_provider.dart';
import 'app_guide_storage.dart';

class AppGuideState {
  const AppGuideState({
    required this.enabledByUser,
    required this.expiredByAge,
    required this.dismissedIds,
  });

  final bool enabledByUser;
  final bool expiredByAge;
  final Set<String> dismissedIds;

  bool get active => enabledByUser && !expiredByAge;

  bool shouldShow(String guideId) =>
      active && !dismissedIds.contains(guideId);

  AppGuideState copyWith({
    bool? enabledByUser,
    bool? expiredByAge,
    Set<String>? dismissedIds,
  }) {
    return AppGuideState(
      enabledByUser: enabledByUser ?? this.enabledByUser,
      expiredByAge: expiredByAge ?? this.expiredByAge,
      dismissedIds: dismissedIds ?? this.dismissedIds,
    );
  }
}

final appGuideStateProvider =
    NotifierProvider<AppGuideNotifier, AppGuideState>(AppGuideNotifier.new);

class AppGuideNotifier extends Notifier<AppGuideState> {
  @override
  AppGuideState build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return AppGuideState(
      enabledByUser: !readGuideDisabledByUser(prefs),
      expiredByAge: guideExpiredByAge(prefs),
      dismissedIds: readDismissedGuideIds(prefs),
    );
  }

  Future<void> setEnabledByUser(bool enabled) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await writeGuideDisabledByUser(prefs, !enabled);
    if (enabled) {
      await writeDismissedGuideIds(prefs, {});
      state = state.copyWith(
        enabledByUser: true,
        dismissedIds: {},
      );
    } else {
      state = state.copyWith(enabledByUser: false);
    }
  }

  Future<void> dismissPage(String guideId) async {
    if (state.dismissedIds.contains(guideId)) return;
    final next = {...state.dismissedIds, guideId};
    final prefs = ref.read(sharedPreferencesProvider);
    await writeDismissedGuideIds(prefs, next);
    state = state.copyWith(dismissedIds: next);
  }

  Future<void> disablePermanently() async {
    await setEnabledByUser(false);
  }

  void refreshExpiry() {
    final prefs = ref.read(sharedPreferencesProvider);
    state = state.copyWith(expiredByAge: guideExpiredByAge(prefs));
  }
}
