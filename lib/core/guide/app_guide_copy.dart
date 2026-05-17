import 'package:pride_v3/l10n/app_localizations.dart';

import 'app_guide_ids.dart';

class AppGuideCopy {
  const AppGuideCopy({required this.title, required this.body});

  final String title;
  final String body;
}

AppGuideCopy? appGuideCopyFor(AppLocalizations l10n, String guideId) {
  return switch (guideId) {
    AppGuideIds.orders => AppGuideCopy(
        title: l10n.appGuideOrdersTitle,
        body: l10n.appGuideOrdersBody,
      ),
    AppGuideIds.customers => AppGuideCopy(
        title: l10n.appGuideCustomersTitle,
        body: l10n.appGuideCustomersBody,
      ),
    AppGuideIds.catalog => AppGuideCopy(
        title: l10n.appGuideCatalogTitle,
        body: l10n.appGuideCatalogBody,
      ),
    AppGuideIds.reports => AppGuideCopy(
        title: l10n.appGuideReportsTitle,
        body: l10n.appGuideReportsBody,
      ),
    AppGuideIds.settings => AppGuideCopy(
        title: l10n.appGuideSettingsTitle,
        body: l10n.appGuideSettingsBody,
      ),
    AppGuideIds.dashboard => AppGuideCopy(
        title: l10n.appGuideDashboardTitle,
        body: l10n.appGuideDashboardBody,
      ),
    _ => null,
  };
}
