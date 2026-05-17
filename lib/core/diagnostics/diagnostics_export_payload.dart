/// Sanitized device snapshot for support (plan-15 / plan-18). No tokens or passwords.
class DiagnosticsExportSnapshot {
  const DiagnosticsExportSnapshot({
    required this.appName,
    required this.appVersion,
    required this.buildNumber,
    required this.isWeb,
    required this.defaultTargetPlatformName,
    required this.locale,
    required this.connectivityOnline,
    required this.apiBaseConfigured,
    this.apiBaseHost,
    required this.authMode,
    required this.authHasSession,
    this.shopId,
    required this.isShopOwner,
    required this.licenseStatus,
    this.lastSuccessfulSyncUtcIso,
    required this.outboxPendingCount,
    required this.countOrders,
    required this.countCustomers,
    required this.countPayments,
    required this.countTasks,
    required this.countNotifications,
    required this.countUnreadNotifications,
    this.recentErrors = const [],
  });

  final String appName;
  final String appVersion;
  final String buildNumber;
  final bool isWeb;
  final String defaultTargetPlatformName;
  final String locale;
  final bool connectivityOnline;
  final bool apiBaseConfigured;
  final String? apiBaseHost;
  final String authMode;
  final bool authHasSession;
  final String? shopId;
  final bool isShopOwner;
  final String licenseStatus;
  final String? lastSuccessfulSyncUtcIso;
  final int outboxPendingCount;
  final int countOrders;
  final int countCustomers;
  final int countPayments;
  final int countTasks;
  final int countNotifications;
  final int countUnreadNotifications;
  final List<Map<String, dynamic>> recentErrors;
}

Map<String, dynamic> buildDiagnosticsExportMap(DiagnosticsExportSnapshot s) {
  return <String, dynamic>{
    'schemaVersion': 1,
    'kind': 'pride_diagnostics_bundle',
    'createdAtUtc': DateTime.now().toUtc().toIso8601String(),
    'app': <String, dynamic>{
      'name': s.appName,
      'version': s.appVersion,
      'buildNumber': s.buildNumber,
    },
    'runtime': <String, dynamic>{
      'isWeb': s.isWeb,
      'defaultTargetPlatform': s.defaultTargetPlatformName,
      'locale': s.locale,
      'connectivityOnline': s.connectivityOnline,
    },
    'api': <String, dynamic>{
      'baseUrlConfigured': s.apiBaseConfigured,
      if (s.apiBaseHost != null) 'baseHost': s.apiBaseHost,
    },
    'auth': <String, dynamic>{
      'mode': s.authMode,
      'hasSession': s.authHasSession,
      if (s.shopId != null) 'shopId': s.shopId,
      'isShopOwner': s.isShopOwner,
    },
    'license': <String, dynamic>{
      'status': s.licenseStatus,
    },
    'sync': <String, dynamic>{
      if (s.lastSuccessfulSyncUtcIso != null)
        'lastSuccessfulSyncUtc': s.lastSuccessfulSyncUtcIso,
      'outboxPendingCount': s.outboxPendingCount,
    },
    'localCounts': <String, dynamic>{
      'orders': s.countOrders,
      'customers': s.countCustomers,
      'payments': s.countPayments,
      'tasks': s.countTasks,
      'notifications': s.countNotifications,
      'unreadNotifications': s.countUnreadNotifications,
    },
    if (s.recentErrors.isNotEmpty)
      'recentErrors': s.recentErrors,
  };
}
