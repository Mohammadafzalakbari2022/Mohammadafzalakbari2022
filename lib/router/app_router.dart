import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../auth/auth_providers.dart';
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
import '../features/reports/payments_ledger_report_screen.dart';
import '../features/reports/reports_tab_screen.dart';
import '../features/reports/unpaid_report_screen.dart';
import '../features/developer_portal/developer_portal_screen.dart';
import '../features/settings/settings_backup_restore_screen.dart';
import '../features/settings/settings_notifications_screen.dart';
import '../features/settings/settings_sync_diagnostics_screen.dart';
import '../features/settings/settings_measurement_types_screen.dart';
import '../features/settings/settings_tasks_screen.dart';
import '../features/settings/settings_tab_screen.dart';
import '../features/settings/settings_printer_screen.dart';
import '../features/settings/settings_shop_profile_screen.dart';
import '../features/settings/settings_about_screen.dart';
import '../features/settings/settings_appearance_language_screen.dart';
import '../features/settings/settings_users_screen.dart';
import '../features/subscription/subscription_screen.dart';
import '../licensing/license_providers.dart';
import '../shell/app_shell.dart';
import 'license_paths.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final goRouterProvider = Provider<GoRouter>((ref) {
  final auth = ref.read(authSessionProvider);
  final license = ref.read(licenseNotifierProvider);
  final listenable = Listenable.merge([auth, license]);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/auth/login',
    refreshListenable: listenable,
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

      if (loggedIn && license.isExpired) {
        final path = state.uri.path;
        if (isPathBlockedWhenLicenseExpired(path)) {
          return subscriptionPath;
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
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) =>
                        const OrderComposerScreen(),
                  ),
                  GoRoute(
                    path: ':orderId',
                    parentNavigatorKey: _rootNavigatorKey,
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
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) =>
                        const NewCustomerScreen(),
                  ),
                  GoRoute(
                    path: ':customerId',
                    parentNavigatorKey: _rootNavigatorKey,
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
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) =>
                        const CatalogNewDesignScreen(),
                  ),
                  GoRoute(
                    path: ':catalogItemId',
                    parentNavigatorKey: _rootNavigatorKey,
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
                    path: 'unpaid',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const UnpaidReportScreen(),
                  ),
                  GoRoute(
                    path: 'monthly-income',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) =>
                        const MonthlyIncomeReportScreen(),
                  ),
                  GoRoute(
                    path: 'delivered',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) =>
                        const DeliveredReportScreen(),
                  ),
                  GoRoute(
                    path: 'payments',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) =>
                        const PaymentsLedgerReportScreen(),
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
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) =>
                        const SettingsShopProfileScreen(),
                  ),
                  GoRoute(
                    path: 'measurement-types',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) =>
                        const SettingsMeasurementTypesScreen(),
                  ),
                  GoRoute(
                    path: 'tasks',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const SettingsTasksScreen(),
                  ),
                  GoRoute(
                    path: 'users',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) =>
                        const SettingsUsersScreen(),
                  ),
                  GoRoute(
                    path: 'backup-restore',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) =>
                        const SettingsBackupRestoreScreen(),
                  ),
                  GoRoute(
                    path: 'notifications',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) =>
                        const SettingsNotificationsScreen(),
                  ),
                  GoRoute(
                    path: 'printer',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) =>
                        const SettingsPrinterScreen(),
                  ),
                  GoRoute(
                    path: 'sync-diagnostics',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) =>
                        const SettingsSyncDiagnosticsScreen(),
                  ),
                  GoRoute(
                    path: 'appearance-language',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) =>
                        const SettingsAppearanceLanguageScreen(),
                  ),
                  GoRoute(
                    path: 'about',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const SettingsAboutScreen(),
                  ),
                  GoRoute(
                    path: 'developer-portal',
                    parentNavigatorKey: _rootNavigatorKey,
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
