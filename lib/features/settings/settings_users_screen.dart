import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/core/api/pride_api_config.dart';
import 'package:pride_v3/core/api/pride_api_shop.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../auth/auth_providers.dart';
import '../../core/persistence/api_offline_cache_storage.dart';
import '../../core/persistence/shared_preferences_provider.dart';
import '../../shell/shell_sync_providers.dart';

/// Users management when API is connected (`plan-15` / `plan-04`).
class SettingsUsersScreen extends ConsumerStatefulWidget {
  const SettingsUsersScreen({super.key});

  @override
  ConsumerState<SettingsUsersScreen> createState() =>
      _SettingsUsersScreenState();
}

class _SettingsUsersScreenState extends ConsumerState<SettingsUsersScreen> {
  List<Map<String, dynamic>> _users = [];
  Map<String, dynamic>? _limits;
  String? _loadError;
  String? _limitsLoadError;
  bool _loading = true;
  bool _showingOfflineCache = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    if (!PrideApiConfig.isConfigured) {
      setState(() {
        _loading = false;
        _loadError = null;
        _limitsLoadError = null;
        _limits = null;
        _users = [];
        _showingOfflineCache = false;
      });
      return;
    }
    final auth = ref.read(authSessionProvider);
    final token = auth.accessToken;
    final shopId = auth.shopId?.trim() ?? '';
    if (token == null || token.isEmpty || shopId.isEmpty) {
      setState(() {
        _loading = false;
        _loadError = null;
        _limitsLoadError = null;
        _limits = null;
        _users = [];
        _showingOfflineCache = false;
      });
      return;
    }

    final online = ref.read(connectivityOnlineProvider);
    final prefs = ref.read(sharedPreferencesProvider);
    final cached = ApiOfflineCacheStorage.readShopUsers(prefs, shopId);

    if (cached != null) {
      setState(() {
        _users = cached.users;
        _limits = cached.limits;
        _loadError = null;
        _limitsLoadError = null;
        _loading = false;
        _showingOfflineCache = !online;
      });
    }

    if (!online) {
      if (cached == null && mounted) {
        setState(() {
          _loading = false;
          _users = [];
          _limits = null;
          _limitsLoadError = null;
          _showingOfflineCache = false;
        });
      }
      return;
    }

    if (cached == null) {
      setState(() {
        _loading = true;
        _loadError = null;
        _limitsLoadError = null;
      });
    }

    final limitsResult = await fetchShopUserLimits(accessToken: token);
    final usersResult = await fetchShopUsers(accessToken: token);
    if (!mounted) return;
    if (usersResult is PrideApiShopUsersFailure) {
      setState(() {
        _loading = false;
        _loadError = usersResult.message;
        _limitsLoadError = limitsResult is PrideApiShopUserLimitsFailure
            ? limitsResult.message
            : null;
        _showingOfflineCache = cached != null;
      });
      return;
    }
    final ok = usersResult as PrideApiShopUsersOk;
    Map<String, dynamic>? limits;
    String? limitsErr;
    if (limitsResult is PrideApiShopUserLimitsOk) {
      limits = limitsResult.limits;
    } else if (limitsResult is PrideApiShopUserLimitsFailure) {
      limitsErr = limitsResult.message;
    }
    await ApiOfflineCacheStorage.saveShopUsers(
      prefs,
      shopId,
      users: ok.users,
      limits: limits,
    );
    setState(() {
      _loading = false;
      _users = ok.users;
      _limits = limits;
      _loadError = null;
      _limitsLoadError = limitsErr;
      _showingOfflineCache = false;
    });
  }

  bool _boolFrom(dynamic v) => v == true;

  /// Owner may add when server says so, or when limits could not be loaded (server enforces).
  bool _canAddUser({
    required bool isOwner,
    required bool online,
    required bool tokenReady,
  }) {
    if (!isOwner || !tokenReady || !online) return false;
    final lim = _limits;
    if (lim != null) return _boolFrom(lim['can_add']);
    return _users.length < 5;
  }

  bool _licenseExpired() {
    final lim = _limits;
    if (lim == null) return false;
    return lim['license_status'] == 'expired' ||
        (_intFrom(lim['max_users']) ?? 1) <= 0;
  }

  String _limitsBody(AppLocalizations l10n) {
    final lim = _limits;
    if (lim == null) return l10n.settingsUsersLimitsBody;
    final max = _intFrom(lim['max_users']) ?? 0;
    final count = _intFrom(lim['active_count']) ?? 0;
    if (lim['is_trial'] == true) {
      return l10n.settingsUsersLimitsBodyTrial(max, count);
    }
    return l10n.settingsUsersLimitsBodyPaid(max, count);
  }

  int? _intFrom(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse('$v');
  }

  Future<void> _showAddDialog(AppLocalizations l10n) async {
    final userCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    final result = await showDialog<dynamic>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(l10n.settingsUsersAddDialogTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: userCtrl,
                decoration: InputDecoration(
                  labelText: l10n.settingsUsersAddUsernameLabel,
                  border: const OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.none,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: passCtrl,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: l10n.settingsUsersAddPasswordLabel,
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l10n.settingsSignOutCancel),
            ),
            FilledButton(
              onPressed: () async {
                final u = userCtrl.text.trim();
                final p = passCtrl.text;
                if (u.isEmpty || p.isEmpty) {
                  Navigator.pop(ctx, 'FIELD_REQUIRED');
                  return;
                }
                final token = ref.read(authSessionProvider).accessToken;
                if (token == null || token.isEmpty) {
                  Navigator.pop(ctx, 'NO_TOKEN');
                  return;
                }
                final err = await postShopUser(
                  accessToken: token,
                  username: u,
                  password: p,
                );
                if (!ctx.mounted) return;
                if (err == null) {
                  Navigator.pop(ctx, true);
                } else {
                  Navigator.pop(ctx, err);
                }
              },
              child: Text(l10n.settingsUsersAddSubmitCta),
            ),
          ],
        );
      },
    );
    userCtrl.dispose();
    passCtrl.dispose();
    if (!mounted) return;
    if (result == false) return;
    if (result == 'FIELD_REQUIRED') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.loginFieldRequired)),
      );
      return;
    }
    if (result == 'NO_TOKEN') return;
    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.settingsUsersAddedSnackbar)),
      );
      await _load();
      return;
    }
    if (result is String) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.settingsUsersAddError(result))),
      );
    }
  }

  Future<void> _confirmDelete(
    AppLocalizations l10n,
    String userId,
    String username,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.settingsUsersDeleteConfirmTitle),
        content: Text(l10n.settingsUsersDeleteConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.settingsSignOutCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.settingsUsersDeleteCta),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    final token = ref.read(authSessionProvider).accessToken;
    if (token == null) return;
    final err = await deleteShopUser(accessToken: token, userId: userId);
    if (!mounted) return;
    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.settingsUsersAddError(err))),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.settingsUsersRemovedSnackbar)),
    );
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final api = PrideApiConfig.isConfigured;
    final online = ref.watch(connectivityOnlineProvider);
    final session = ref.watch(authSessionProvider);
    final isOwner = session.isShopOwner;
    final tokenReady =
        session.hasApiSession && (session.accessToken?.isNotEmpty == true);
    final tokenReadyForList = api && tokenReady;
    final ready = tokenReadyForList && online;
    final canAdd = _canAddUser(
      isOwner: isOwner,
      online: online,
      tokenReady: tokenReadyForList,
    );
    final showAdd = ready && canAdd;
    final atLimit = ready &&
        isOwner &&
        _limits != null &&
        !canAdd &&
        !_licenseExpired() &&
        (_intFrom(_limits!['active_count']) ?? 0) >=
            (_intFrom(_limits!['max_users']) ?? 0);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsUsersTitle)),
      floatingActionButton: showAdd
          ? FloatingActionButton.extended(
              onPressed: () => _showAddDialog(l10n),
              icon: const Icon(Icons.person_add_alt_1),
              label: Text(l10n.settingsUsersAddCta),
            )
          : null,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.settingsUsersLimitsTitle,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(_limitsBody(l10n)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (!api || !tokenReady) ...[
            Text(
              l10n.settingsUsersAddDisabledHint,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ] else if (!isOwner) ...[
            Card(
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 20,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.settingsUsersNotOwnerBanner,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ] else if (!online) ...[
            Text(
              l10n.settingsUsersNeedOnline,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ] else if (_licenseExpired()) ...[
            Text(
              l10n.settingsUsersLicenseExpired,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ] else if (_limitsLoadError != null) ...[
            Text(
              l10n.settingsUsersLimitsLoadFailed(_limitsLoadError!),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton.icon(
                onPressed: _loading ? null : _load,
                icon: const Icon(Icons.refresh),
                label: Text(l10n.settingsUsersRetryCta),
              ),
            ),
          ],
          const SizedBox(height: 16),
          if (!api || !tokenReady) ...[
            const SizedBox.shrink(),
          ] else ...[
            if (_showingOfflineCache || (!online && _users.isNotEmpty)) ...[
              Card(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.wifi_off_outlined,
                        size: 20,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l10n.settingsUsersOfflineCacheNote,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ] else if (!online && _users.isEmpty && !_loading) ...[
              Text(
                l10n.settingsUsersNeedOnline,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
            ],
            if (isOwner && atLimit) ...[
              Text(
                l10n.settingsUsersAtLimit(
                  _intFrom(_limits!['active_count']) ?? 0,
                  _intFrom(_limits!['max_users']) ?? 0,
                ),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
              ),
              const SizedBox(height: 8),
            ],
            if (isOwner) ...[
              FilledButton.icon(
                onPressed: showAdd ? () => _showAddDialog(l10n) : null,
                icon: const Icon(Icons.person_add_alt_1),
                label: Text(l10n.settingsUsersAddCta),
              ),
              const SizedBox(height: 16),
            ],
            Row(
              children: [
                Text(
                  l10n.settingsUsersListTitle,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const Spacer(),
                if (_loadError != null || _limitsLoadError != null)
                  TextButton.icon(
                    onPressed: _loading ? null : _load,
                    icon: const Icon(Icons.refresh),
                    label: Text(l10n.settingsUsersRetryCta),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (_loading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_loadError != null)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  l10n.settingsUsersLoadError(_loadError!),
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              )
            else if (_users.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    Icon(
                      Icons.group_outlined,
                      size: 48,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.settingsUsersEmptyRowSubtitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              )
            else ...[
              if (!isOwner)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    l10n.settingsUsersReadOnlyHint,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              Card(
                child: Column(
                  children: [
                    for (var i = 0; i < _users.length; i++) ...[
                      if (i > 0) const Divider(height: 1),
                      _UserTile(
                        row: _users[i],
                        isOwnerViewer: isOwner,
                        onDelete: isOwner && ready
                            ? () => _confirmDelete(
                                  l10n,
                                  _users[i]['id']! as String,
                                  (_users[i]['username'] as String?) ?? '',
                                )
                            : null,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _UserTile extends StatelessWidget {
  const _UserTile({
    required this.row,
    required this.isOwnerViewer,
    this.onDelete,
  });

  final Map<String, dynamic> row;
  final bool isOwnerViewer;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final username = row['username'] as String? ?? '';
    final isOwner = row['is_shop_owner'] == true;
    return ListTile(
      leading: Icon(
        isOwner ? Icons.shield_outlined : Icons.person_outline,
      ),
      title: Text(username),
      subtitle: Text(
        isOwner ? l10n.settingsUsersOwnerRowSubtitle : l10n.settingsRoleUser,
      ),
      trailing: isOwnerViewer && !isOwner && onDelete != null
          ? IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: onDelete,
            )
          : isOwner
              ? Chip(
                  label: Text(l10n.settingsRoleOwner),
                  visualDensity: VisualDensity.compact,
                )
              : null,
    );
  }
}
