import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/core/api/pride_api_config.dart';
import 'package:pride_v3/core/api/pride_api_shop.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../auth/auth_providers.dart';

/// Users management when API is connected (`plan-15` / `plan-04`).
class SettingsUsersScreen extends ConsumerStatefulWidget {
  const SettingsUsersScreen({super.key});

  @override
  ConsumerState<SettingsUsersScreen> createState() =>
      _SettingsUsersScreenState();
}

class _SettingsUsersScreenState extends ConsumerState<SettingsUsersScreen> {
  List<Map<String, dynamic>> _users = [];
  String? _loadError;
  bool _loading = true;

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
      });
      return;
    }
    final token = ref.read(authSessionProvider).accessToken;
    if (token == null || token.isEmpty) {
      setState(() {
        _loading = false;
        _loadError = null;
      });
      return;
    }
    setState(() {
      _loading = true;
      _loadError = null;
    });
    final result = await fetchShopUsers(accessToken: token);
    if (!mounted) return;
    if (result is PrideApiShopUsersFailure) {
      setState(() {
        _loading = false;
        _loadError = result.message;
      });
      return;
    }
    final ok = result as PrideApiShopUsersOk;
    setState(() {
      _loading = false;
      _users = ok.users;
    });
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
    final session = ref.watch(authSessionProvider);
    final owner = session.isShopOwner;
    final tokenReady =
        session.hasApiSession && (session.accessToken?.isNotEmpty == true);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsUsersTitle)),
      floatingActionButton: api && owner && tokenReady
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
                  Text(l10n.settingsUsersLimitsBody),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (!api) ...[
            Text(
              l10n.settingsUsersAddDisabledHint,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ] else if (!tokenReady) ...[
            Text(
              l10n.settingsUsersAddDisabledHint,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ] else ...[
            Row(
              children: [
                Text(
                  l10n.settingsUsersListTitle,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const Spacer(),
                if (_loadError != null)
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
            else
              Card(
                child: Column(
                  children: [
                    for (var i = 0; i < _users.length; i++) ...[
                      if (i > 0) const Divider(height: 1),
                      _UserTile(
                        row: _users[i],
                        isOwnerViewer: owner,
                        onDelete: owner
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
