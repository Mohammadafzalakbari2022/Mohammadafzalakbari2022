import 'package:pride_v3/l10n/app_localizations.dart';

String shellAppBarTitle(String path, AppLocalizations l10n) {
  if (path.startsWith('/app/settings/subscription')) {
    return l10n.subscriptionTitle;
  }
  if (path.startsWith('/app/settings/shop')) {
    return l10n.settingsShopProfileTitle;
  }
  if (path.startsWith('/app/settings/users')) {
    return l10n.settingsUsersTitle;
  }
  if (path.startsWith('/app/settings/backup-restore')) {
    return l10n.settingsBackupRestoreTitle;
  }
  if (path.startsWith('/app/settings/notifications')) {
    return l10n.settingsNotificationsInboxTitle;
  }
  if (path.startsWith('/app/settings/sync-diagnostics')) {
    return l10n.settingsSyncDiagnosticsTitle;
  }
  if (path.startsWith('/app/settings/appearance-language')) {
    return l10n.settingsAppearanceLanguageTitle;
  }
  if (path.startsWith('/app/settings/about')) {
    return l10n.settingsAboutTitle;
  }
  if (path.startsWith('/app/settings/developer-portal')) {
    return l10n.devPortalTitle;
  }
  if (path == '/app/orders') return l10n.ordersNewTitle;
  if (path.startsWith('/app/orders/')) {
    return l10n.ordersDetailTitle;
  }
  if (path.startsWith('/app/customers/')) return l10n.customerProfileTitle;
  if (path == '/app/customers') return l10n.tabCustomers;
  if (path == '/app/catalog') return l10n.tabCatalog;
  if (path.startsWith('/app/catalog/new')) return l10n.catalogAddDesignCta;
  if (path.startsWith('/app/catalog/')) return l10n.catalogDetailTitle;
  if (path == '/app/reports') return l10n.tabReports;
  if (path.startsWith('/app/reports/unpaid')) return l10n.reportsUnpaidCardTitle;
  if (path.startsWith('/app/reports/monthly-income')) {
    return l10n.reportsMonthlyIncomeTitle;
  }
  if (path.startsWith('/app/reports/payments')) {
    return l10n.reportsPaymentsLedgerTitle;
  }
  if (path.startsWith('/app/settings/tasks')) {
    return l10n.tasksTitle;
  }
  if (path.startsWith('/app/settings')) return l10n.tabSettings;
  return l10n.appTitle;
}
