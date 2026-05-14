import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/core/diagnostics/diagnostics_export_payload.dart';

void main() {
  test('buildDiagnosticsExportMap includes schema and counts', () {
    const s = DiagnosticsExportSnapshot(
      appName: 'Pride',
      appVersion: '1.0.0',
      buildNumber: '1',
      isWeb: false,
      defaultTargetPlatformName: 'android',
      locale: 'en',
      connectivityOnline: true,
      apiBaseConfigured: true,
      apiBaseHost: 'example.com',
      authMode: 'api',
      authHasSession: true,
      shopId: 'shop-1',
      isShopOwner: true,
      licenseStatus: 'trial_active',
      lastSuccessfulSyncUtcIso: '2026-01-01T00:00:00.000Z',
      outboxPendingCount: 2,
      countOrders: 3,
      countCustomers: 4,
      countPayments: 5,
      countTasks: 6,
      countNotifications: 7,
      countUnreadNotifications: 1,
    );
    final m = buildDiagnosticsExportMap(s);
    expect(m['schemaVersion'], 1);
    expect(m['kind'], 'pride_diagnostics_bundle');
    expect((m['localCounts'] as Map)['orders'], 3);
    expect((m['api'] as Map)['baseHost'], 'example.com');
    expect((m['sync'] as Map)['outboxPendingCount'], 2);
  });
}
