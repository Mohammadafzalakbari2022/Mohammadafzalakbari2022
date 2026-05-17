import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../auth/auth_providers.dart';
import '../auth/auth_session.dart';
import '../auth/forgot_password_screen.dart';
import '../auth/login_screen.dart';
import '../features/customers/customer_profile_screen.dart';
import '../features/customers/customers_tab_screen.dart';
import '../features/customers/new_customer_screen.dart';
import '../features/catalog/catalog_item_detail_screen.dart';
import '../features/catalog/catalog_new_design_screen.dart';
import '../features/catalog/catalog_tab_screen.dart';
import '../features/orders/order_composer_screen.dart';
import '../features/orders/order_detail_screen.dart';
import '../features/orders/orders_tab_screen.dart';
import '../features/reports/delivered_report_screen.dart';
import '../features/reports/monthly_income_report_screen.dart';
import '../features/reports/open_unpaid_report_screen.dart';
import '../features/reports/orders_by_status_report_screen.dart';
import '../features/reports/payments_ledger_report_screen.dart';
import '../features/reports/reports_tab_screen.dart';
import '../features/reports/this_month_income_report_screen.dart';
import '../features/reports/unpaid_report_screen.dart';
import '../features/shop_finance/shop_finance_hub_screen.dart';
import '../features/developer_portal/developer_portal_screen.dart';
import '../features/settings/settings_backup_restore_screen.dart';
import '../features/settings/settings_notifications_screen.dart';
import '../features/settings/settings_sync_diagnostics_screen.dart';
import '../features/settings/settings_measurement_types_screen.dart';
import '../features/settings/settings_style_screen.dart';
import '../features/settings/settings_fabric_presets_screen.dart';
import '../features/settings/settings_fabric_screen.dart';
import '../features/settings/settings_style_names_screen.dart';
import '../features/settings/settings_style_parts_screen.dart';
import '../features/settings/settings_style_figures_screen.dart';
import '../features/settings/settings_tasks_screen.dart';
import '../features/settings/settings_tab_screen.dart';
import '../features/settings/settings_printer_screen.dart';
import '../features/settings/settings_shop_profile_screen.dart';
import '../features/settings/settings_about_screen.dart';
import '../features/settings/settings_appearance_language_screen.dart';
import '../features/settings/settings_users_screen.dart';
import '../features/subscription/subscription_screen.dart';
import '../licensing/license_providers.dart';
import '../licensing/license_notifier.dart';
import '../shell/app_shell.dart';
import '../shell/shell_sync_providers.dart';
import 'license_paths.dart';

/// Root navigator for [MaterialApp.router] and explicit post-logout navigation.
final appRootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// Notifies [GoRouter] on auth, license, or connectivity changes (plan-06 grace).
///
/// Caches [AuthSession] and [LicenseNotifier] so [dispose] never calls [Ref.read]
/// after the [ProviderScope] has disposed its [ProviderContainer] (widget tests).
class _GoRouterRefresh extends ChangeNotifier {
  _GoRouterRefresh(Ref ref)
      : _auth = ref.read(authSessionProvider),
        _license = ref.read(licenseNotifierProvider) {
    _auth.addListener(notifyListeners);
    _license.addListener(notifyListeners);
    ref.listen<AsyncValue<List<ConnectivityResult>>>(
      connectivityListProvider,
      (previous, next) => notifyListeners(),
    );
  }

  final AuthSession _auth;
  final LicenseNotifier _license;

  @override
  void dispose() {
    _auth.removeListener(notifyListeners);
    _license.removeListener(notifyListeners);
    super.dispose();
  }
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final auth = ref.read(authSessionProvider);
  final refresh = _GoRouterRefresh(ref);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    navigatorKey: appRootNavigatorKey,
    initialLocation: '/auth/login',
    refreshListenable: refresh,
    redirect: (context, state) {
      final loggedIn = auth.authenticated;
      final atLogin = state.matchedLocation == '/auth/login';
      final atForgot = state.matchedLocation == '/auth/forgot-password';

      if (!loggedIn && !atLogin && !atForgot) {
        return '/auth/login';
      }
      if (loggedIn && atLogin) {
        return '/app/orders';
      }

      if (loggedIn) {
        final editingBlocked = ref.read(licenseEditingBlockedProvider);
        if (editingBlocked) {
          final path = state.uri.path;
          if (isPathBlockedWhenLicenseEditingBlocked(path)) {
            return subscriptionPath;
          }
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/auth/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/auth/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/app/orders',
                builder: (context, state) => const OrdersTabScreen(),
                routes: [
                  GoRoute(
                    path: 'new',
                    parentNavigatorKey: appRootNavigatorKey,
                    builder: (context, state) =>
                        const OrderComposerScreen(),
                  ),
                  GoRoute(
                    path: ':orderId',
                    parentNavigatorKey: appRootNavigatorKey,
                    builder: (context, state) {
                      final id = state.pathParameters['orderId']!;
                      return OrderDetailScreen(orderId: id);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/app/customers',
                builder: (context, state) => const CustomersTabScreen(),
                routes: [
                  GoRoute(
                    path: 'new',
                    parentNavigatorKey: appRootNavigatorKey,
                    builder: (context, state) =>
                        const NewCustomerScreen(),
                  ),
                  GoRoute(
                    path: ':customerId',
                    parentNavigatorKey: appRootNavigatorKey,
                    builder: (context, state) {
                      final id = state.pathParameters['customerId']!;
                      return CustomerProfileScreen(customerId: id);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/app/catalog',
                builder: (context, state) => const CatalogTabScreen(),
                routes: [
                  GoRoute(
                    path: 'new',
                    parentNavigatorKey: appRootNavigatorKey,
                    builder: (context, state) =>
                        const CatalogNewDesignScreen(),
                  ),
                  GoRoute(
                    path: ':catalogItemId',
                    parentNavigatorKey: appRootNavigatorKey,
                    builder: (context, state) {
                      final id = state.pathParameters['catalogItemId']!;
                      return CatalogItemDetailScreen(itemId: id);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/app/reports',
                builder: (context, state) => const ReportsTabScreen(),
                routes: [
                  GoRoute(
                    path: 'this-month-income',
                    parentNavigatorKey: appRootNavigatorKey,
                    builder: (context, state) =>
                        const ThisMonthIncomeReportScreen(),
                  ),
                  GoRoute(
                    path: 'open-unpaid',
                    parentNavigatorKey: appRootNavigatorKey,
                    builder: (context, state) =>
                        const OpenUnpaidReportScreen(),
                  ),
                  GoRoute(
                    path: 'orders-by-status',
                    parentNavigatorKey: appRootNavigatorKey,
                    builder: (context, state) =>
                        const OrdersByStatusReportScreen(),
                  ),
                  GoRoute(
                    path: 'unpaid',
                    parentNavigatorKey: appRootNavigatorKey,
                    builder: (context, state) => const UnpaidReportScreen(),
                  ),
                  GoRoute(
                    path: 'monthly-income',
                    parentNavigatorKey: appRootNavigatorKey,
                    builder: (context, state) =>
                        const MonthlyIncomeReportScreen(),
                  ),
                  GoRoute(
                    path: 'delivered',
                    parentNavigatorKey: appRootNavigatorKey,
                    builder: (context, state) =>
                        const DeliveredReportScreen(),
                  ),
                  GoRoute(
                    path: 'payments',
                    parentNavigatorKey: appRootNavigatorKey,
                    builder: (context, state) =>
                        const PaymentsLedgerReportScreen(),
                  ),
                  GoRoute(
                    path: 'shop-finance',
                    parentNavigatorKey: appRootNavigatorKey,
                    builder: (context, state) =>
                        const ShopFinanceHubScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/app/settings',
                builder: (context, state) => const SettingsTabScreen(),
                routes: [
                  GoRoute(
                    path: 'subscription',
                    builder: (context, state) =>
                        const SubscriptionScreen(),
                  ),
                  GoRoute(
                    path: 'shop',
                    parentNavigatorKey: appRootNavigatorKey,
                    builder: (context, state) =>
                        const SettingsShopProfileScreen(),
                  ),
                  GoRoute(
                    path: 'measurement-types',
                    parentNavigatorKey: appRootNavigatorKey,
                    builder: (context, state) =>
                        const SettingsMeasurementTypesScreen(),
                  ),
                  GoRoute(
                    path: 'fabric',
                    parentNavigatorKey: appRootNavigatorKey,
                    builder: (context, state) => const SettingsFabricScreen(),
                    routes: [
                      GoRoute(
                        path: 'names',
                        parentNavigatorKey: appRootNavigatorKey,
                        builder: (context, state) =>
                            const SettingsFabricPresetsScreen(
                          kind: FabricPresetListKind.names,
                        ),
                      ),
                      GoRoute(
                        path: 'colors',
                        parentNavigatorKey: appRootNavigatorKey,
                        builder: (context, state) =>
                            const SettingsFabricPresetsScreen(
                          kind: FabricPresetListKind.colors,
                        ),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'style',
                    parentNavigatorKey: appRootNavigatorKey,
                    builder: (context, state) => const SettingsStyleScreen(),
                    routes: [
                      GoRoute(
                        path: 'names',
                        parentNavigatorKey: appRootNavigatorKey,
                        builder: (context, state) =>
                            const SettingsStyleNamesScreen(),
                      ),
                      GoRoute(
                        path: 'parts',
                        parentNavigatorKey: appRootNavigatorKey,
                        builder: (context, state) =>
                            const SettingsStylePartsScreen(),
                      ),
                      GoRoute(
                        path: 'figures',
                        parentNavigatorKey: appRootNavigatorKey,
                        builder: (context, state) =>
                            const SettingsStyleFiguresScreen(),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'tasks',
                    parentNavigatorKey: appRootNavigatorKey,
                    builder: (context, state) => const SettingsTasksScreen(),
                  ),
                  GoRoute(
                    path: 'users',
                    parentNavigatorKey: appRootNavigatorKey,
                    builder: (context, state) =>
                        const SettingsUsersScreen(),
                  ),
                  GoRoute(
                    path: 'backup-restore',
                    parentNavigatorKey: appRootNavigatorKey,
                    builder: (context, state) =>
                        const SettingsBackupRestoreScreen(),
                  ),
                  GoRoute(
                    path: 'notifications',
                    parentNavigatorKey: appRootNavigatorKey,
                    builder: (context, state) =>
                        const SettingsNotificationsScreen(),
                  ),
                  GoRoute(
                    path: 'printer',
                    parentNavigatorKey: appRootNavigatorKey,
                    builder: (context, state) =>
                        const SettingsPrinterScreen(),
                  ),
                  GoRoute(
                    path: 'sync-diagnostics',
                    parentNavigatorKey: appRootNavigatorKey,
                    builder: (context, state) =>
                        const SettingsSyncDiagnosticsScreen(),
                  ),
                  GoRoute(
                    path: 'appearance-language',
                    parentNavigatorKey: appRootNavigatorKey,
                    builder: (context, state) =>
                        const SettingsAppearanceLanguageScreen(),
                  ),
                  GoRoute(
                    path: 'about',
                    parentNavigatorKey: appRootNavigatorKey,
                    builder: (context, state) => const SettingsAboutScreen(),
                  ),
                  GoRoute(
                    path: 'developer-portal',
                    parentNavigatorKey: appRootNavigatorKey,
                    builder: (context, state) =>
                        const DeveloperPortalScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
