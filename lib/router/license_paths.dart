/// Paths blocked when license is expired (plan-19: edit entry points).
/// Subscription and view routes stay reachable.
const licenseBlockedPathsWhenExpired = <String>{
  '/app/orders/new',
  '/app/customers/new',
  '/app/catalog/new',
  '/app/settings/users',
  '/app/settings/backup-restore',
};

const subscriptionPath = '/app/settings/subscription';

bool isPathBlockedWhenLicenseExpired(String path) {
  if (path == subscriptionPath) return false;
  return licenseBlockedPathsWhenExpired.contains(path);
}
