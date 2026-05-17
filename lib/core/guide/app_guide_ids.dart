/// Stable ids for per-screen tips (one tip per main area until dismissed).
abstract final class AppGuideIds {
  static const orders = 'orders';
  static const customers = 'customers';
  static const catalog = 'catalog';
  static const reports = 'reports';
  static const settings = 'settings';
  static const dashboard = 'dashboard';

  /// Maps a shell route path to a guide id, or null when no tip applies.
  static String? forPath(String path) {
    if (path == '/app/orders' || path.startsWith('/app/orders/')) {
      return orders;
    }
    if (path == '/app/customers' || path.startsWith('/app/customers/')) {
      return customers;
    }
    if (path == '/app/catalog' || path.startsWith('/app/catalog/')) {
      return catalog;
    }
    if (path == '/app/reports' || path.startsWith('/app/reports/')) {
      return reports;
    }
    if (path == '/app/settings' || path.startsWith('/app/settings/')) {
      return settings;
    }
    return null;
  }
}
