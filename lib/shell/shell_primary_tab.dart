/// Bottom-nav destinations only (exact paths).
bool shellPathIsPrimaryTab(String path) {
  const tabs = <String>{
    '/app/orders',
    '/app/customers',
    '/app/catalog',
    '/app/reports',
    '/app/settings',
  };
  return tabs.contains(path);
}
