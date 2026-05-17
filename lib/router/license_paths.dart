/// Paths blocked when editing is disallowed (expired or offline grace, plan-06).
/// Subscription and view routes stay reachable.
const licenseBlockedPathsWhenEditingBlocked = <String>{
  '/app/orders/new',
  '/app/customers/new',
  '/app/catalog/new',
  '/app/settings/users',
  '/app/settings/backup-restore',
  '/app/settings/measurement-types',
  '/app/settings/fabric',
  '/app/settings/fabric/names',
  '/app/settings/fabric/colors',
  '/app/settings/style',
  '/app/settings/style/names',
  '/app/settings/style/parts',
  '/app/settings/style/figures',
  '/app/settings/tasks',
};

const subscriptionPath = '/app/settings/subscription';

bool isPathBlockedWhenLicenseEditingBlocked(String path) {
  if (path == subscriptionPath) return false;
  return licenseBlockedPathsWhenEditingBlocked.contains(path);
}
