import 'package:shared_preferences/shared_preferences.dart';

const prideGuideFirstLaunchMsKey = 'pride_guide_first_launch_ms';
const prideGuideDisabledKey = 'pride_guide_disabled';
const prideGuideDismissedIdsKey = 'pride_guide_dismissed_ids';

const guideAutoHideAfterDays = 5;

Future<void> ensureGuideFirstLaunchRecorded(SharedPreferences prefs) async {
  if (!prefs.containsKey(prideGuideFirstLaunchMsKey)) {
    await prefs.setInt(
      prideGuideFirstLaunchMsKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }
}

Set<String> readDismissedGuideIds(SharedPreferences prefs) {
  final raw = prefs.getString(prideGuideDismissedIdsKey);
  if (raw == null || raw.isEmpty) return {};
  return raw.split(',').where((s) => s.isNotEmpty).toSet();
}

Future<void> writeDismissedGuideIds(
  SharedPreferences prefs,
  Set<String> ids,
) async {
  await prefs.setString(prideGuideDismissedIdsKey, ids.join(','));
}

bool readGuideDisabledByUser(SharedPreferences prefs) =>
    prefs.getBool(prideGuideDisabledKey) ?? false;

Future<void> writeGuideDisabledByUser(SharedPreferences prefs, bool value) async {
  await prefs.setBool(prideGuideDisabledKey, value);
}

bool guideExpiredByAge(SharedPreferences prefs) {
  final ms = prefs.getInt(prideGuideFirstLaunchMsKey);
  if (ms == null) return false;
  final first = DateTime.fromMillisecondsSinceEpoch(ms);
  return DateTime.now().difference(first).inDays >= guideAutoHideAfterDays;
}
