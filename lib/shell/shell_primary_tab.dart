/// Bottom-nav destinations only (path without query/fragment).
bool shellPathIsPrimaryTab(String path) {
  final basePath = Uri.tryParse(path)?.path ?? path;
  const tabs = <String>{
    '/app/orders',
    '/app/customers',
    '/app/catalog',
    '/app/reports',
    '/app/settings',
  };
  return tabs.contains(basePath);
}
