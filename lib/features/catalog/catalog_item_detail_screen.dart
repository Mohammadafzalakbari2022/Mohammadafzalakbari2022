import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/core/calendar/app_calendar_format.dart';
import 'package:pride_v3/core/calendar/date_calendar_notifier.dart';
import 'package:pride_v3/core/feedback/app_feedback.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../auth/auth_providers.dart';
import '../../data/local/catalog_item_detail.dart';
import '../../data/local/sync_outbox_kinds.dart';
import '../../data/providers/local_data_providers.dart';
import '../../licensing/license_providers.dart';
import '../../shell/shell_sync_providers.dart';
import 'catalog_item_image.dart';
import 'catalog_sharing_provider.dart';

class CatalogItemDetailScreen extends ConsumerWidget {
  const CatalogItemDetailScreen({super.key, required this.itemId});

  final String itemId;

  Future<void> _edit(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    CatalogItemDetail item,
  ) async {
    final license = ref.read(licenseNotifierProvider);
    if (ref.read(licenseEditingBlockedProvider)) {
      showAppFeedback(
        context,
        ref,
        kind: AppFeedbackKind.error,
        message: licenseWriteBlockedMessage(license, l10n),
      );
      return;
    }

    final nameCtrl = TextEditingController(text: item.designName);

    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.catalogEditMetadataTitle),
        content: TextField(
          controller: nameCtrl,
          decoration: InputDecoration(
            labelText: l10n.catalogDesignNameLabel,
            hintText: l10n.catalogDesignNameHint,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.saveCta),
          ),
        ],
      ),
    );

    if (ok != true) return;
    final nextName = nameCtrl.text.trim();
    if (nextName.isEmpty) return;
    final repo = await ref.read(catalogRepositoryProvider.future);
    await repo.updateMetadata(
      internalId: item.internalId,
      designName: nextName,
      notes: item.notes,
    );
    final shopId = ref.read(effectiveShopIdProvider);
    final now = DateTime.now();
    recordSyncOutboxMutation(
      ref,
      kind: SyncOutboxKinds.catalogItemUpsert,
      entityRef: item.internalId,
      shopId: shopId,
      payloadJson: _catalogItemUpsertPayloadJson(
        item,
        designName: nextName,
        notes: item.notes,
        isSharedPublic: item.isSharedPublic,
        updatedAt: now,
      ),
    );
    ref.invalidate(catalogItemDetailProvider(item.internalId));

    if (!context.mounted) return;
    showAppFeedback(
      context,
      ref,
      kind: AppFeedbackKind.success,
      message: l10n.saved,
    );
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    CatalogItemDetail item,
  ) async {
    final license = ref.read(licenseNotifierProvider);
    if (ref.read(licenseEditingBlockedProvider)) {
      showAppFeedback(
        context,
        ref,
        kind: AppFeedbackKind.error,
        message: licenseWriteBlockedMessage(license, l10n),
      );
      return;
    }

    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteConfirmTitle),
        content: Text(l10n.catalogDeleteConfirmBody(item.designName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.deleteCta),
          ),
        ],
      ),
    );
    if (ok != true) return;

    final shopId = ref.read(effectiveShopIdProvider);
    recordSyncOutboxMutation(
      ref,
      kind: SyncOutboxKinds.catalogItemDelete,
      entityRef: item.internalId,
      shopId: shopId,
    );
    final repo = await ref.read(catalogRepositoryProvider.future);
    await repo.softDelete(item.internalId);

    if (!context.mounted) return;
    showAppFeedback(
      context,
      ref,
      kind: AppFeedbackKind.success,
      message: l10n.deleted,
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final calendar = ref.watch(dateCalendarSystemProvider);
    final myShopId = ref.watch(effectiveShopIdProvider);
    final itemAsync = ref.watch(catalogItemDetailProvider(itemId));
    final sharingEnabled = ref.watch(catalogSharingEnabledProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.catalogDetailTitle),
        actions: [
          itemAsync.maybeWhen(
            data: (item) {
              if (item == null || item.shopId != myShopId) {
                return const SizedBox.shrink();
              }
              return IconButton(
                tooltip: l10n.editCta,
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => _edit(context, ref, l10n, item),
              );
            },
            orElse: () => const SizedBox.shrink(),
          ),
          itemAsync.maybeWhen(
            data: (item) {
              if (item == null || item.shopId != myShopId) {
                return const SizedBox.shrink();
              }
              return IconButton(
                tooltip: l10n.deleteCta,
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _delete(context, ref, l10n, item),
              );
            },
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: itemAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text('$e', textAlign: TextAlign.center),
        )),
        data: (item) {
          if (item == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(l10n.catalogItemNotFound, textAlign: TextAlign.center),
              ),
            );
          }

          final isOwnShop = item.shopId == myShopId;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              CatalogItemImage(imagePath: item.imagePath),
              const SizedBox(height: 16),
              Text(item.designName, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(
                l10n.catalogDesignerAndDate(
                  item.designerShopName,
                  AppCalendarFormat.mediumDate(
                    l10n,
                    calendar,
                    item.createdAt,
                    locale,
                  ),
                ),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.catalogDescriptionSheetTitle,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Text(
                item.notes != null && item.notes!.trim().isNotEmpty
                    ? item.notes!.trim()
                    : l10n.catalogNoDescription,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: item.notes != null && item.notes!.trim().isNotEmpty
                          ? null
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 16),
              if (!isOwnShop)
                Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(l10n.catalogCommunityReadOnlyBanner),
                  ),
                ),
              if (!isOwnShop) const SizedBox(height: 12),
              if (isOwnShop)
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      SwitchListTile.adaptive(
                        title: Text(l10n.catalogSharePublicTitle),
                        subtitle: Text(
                          sharingEnabled
                              ? l10n.catalogSharePublicSubtitle
                              : l10n.catalogSharePublicDisabledSubtitle,
                        ),
                        value: item.isSharedPublic && sharingEnabled,
                        onChanged: sharingEnabled
                            ? (v) async {
                                final license = ref.read(licenseNotifierProvider);
                                if (ref.read(licenseEditingBlockedProvider)) {
                                  showAppFeedback(
                                    context,
                                    ref,
                                    kind: AppFeedbackKind.error,
                                    message: licenseWriteBlockedMessage(
                                      license,
                                      l10n,
                                    ),
                                  );
                                  return;
                                }
                                final repo =
                                    await ref.read(catalogRepositoryProvider.future);
                                await repo.setSharedPublic(
                                  internalId: item.internalId,
                                  isSharedPublic: v,
                                );
                                final now = DateTime.now();
                                recordSyncOutboxMutation(
                                  ref,
                                  kind: SyncOutboxKinds.catalogItemUpsert,
                                  entityRef: item.internalId,
                                  shopId: ref.read(effectiveShopIdProvider),
                                  payloadJson: _catalogItemUpsertPayloadJson(
                                    item,
                                    designName: item.designName,
                                    notes: item.notes,
                                    isSharedPublic: v,
                                    updatedAt: now,
                                  ),
                                );
                                ref.invalidate(
                                  catalogItemDetailProvider(itemId),
                                );
                              }
                            : null,
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

String _catalogItemUpsertPayloadJson(
  CatalogItemDetail item, {
  required String designName,
  String? notes,
  required bool isSharedPublic,
  required DateTime updatedAt,
}) {
  return jsonEncode({
    'design_name': designName,
    'designer_shop_name': item.designerShopName,
    'notes': notes,
    'is_shared_public': isSharedPublic,
    'created_at': item.createdAt.toUtc().toIso8601String(),
    'updated_at': updatedAt.toUtc().toIso8601String(),
    'image_path': item.imagePath,
    'thumbnail_path': item.thumbnailPath,
  });
}

