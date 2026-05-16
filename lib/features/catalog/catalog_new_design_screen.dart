import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/local/sync_outbox_kinds.dart';
import '../../data/providers/local_data_providers.dart';
import '../../auth/auth_providers.dart';
import '../../licensing/license_providers.dart';
import '../../shell/shell_sync_providers.dart';
import '../settings/shop_profile_provider.dart';
import 'catalog_storage_stub.dart'
    if (dart.library.io) 'catalog_storage_io.dart';

class CatalogNewDesignScreen extends ConsumerStatefulWidget {
  const CatalogNewDesignScreen({super.key});

  @override
  ConsumerState<CatalogNewDesignScreen> createState() =>
      _CatalogNewDesignScreenState();
}

class _CatalogNewDesignScreenState extends ConsumerState<CatalogNewDesignScreen> {
  final _designName = TextEditingController();
  bool _saving = false;

  Uint8List? _previewBytes;

  @override
  void dispose() {
    _designName.dispose();
    super.dispose();
  }

  Future<void> _pick(ImageSource source) async {
    if (kIsWeb) return;
    final picker = ImagePicker();
    final xfile = await picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 2400,
    );
    if (!mounted) return;
    if (xfile == null) return;
    final bytes = await xfile.readAsBytes();
    if (!mounted) return;
    setState(() {
      _previewBytes = bytes;
    });
  }

  Future<void> _save(BuildContext context, AppLocalizations l10n) async {
    final license = ref.read(licenseNotifierProvider);
    if (ref.read(licenseEditingBlockedProvider)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(licenseWriteBlockedMessage(license, l10n))));
      return;
    }

    if (kIsWeb) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.catalogAddNotAvailableOnWeb)));
      return;
    }

    final name = _designName.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.catalogDesignNameRequired)));
      return;
    }
    final bytes = _previewBytes;
    if (bytes == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.catalogImageRequired)));
      return;
    }

    setState(() => _saving = true);
    try {
      // Store bytes into app storage (native only).
      final stored = await storeCatalogImage(bytes);
      if (!mounted) return;

      final repo = await ref.read(catalogRepositoryProvider.future);
      final shopId = ref.read(effectiveShopIdProvider);
      final shopLabel = ref.read(shopDisplayNameProvider);
      final designerName = shopLabel.isNotEmpty
          ? shopLabel
          : l10n.catalogMyShopNameFallback;
      final id = await repo.createItem(
        shopId: shopId,
        designName: name,
        designerShopName: designerName,
        imagePath: stored.imagePath,
        thumbnailPath: stored.thumbnailPath,
      );
      final now = DateTime.now();
      recordSyncOutboxMutation(
        ref,
        kind: SyncOutboxKinds.catalogItemUpsert,
        entityRef: id,
        shopId: shopId,
        payloadJson: jsonEncode({
          'design_name': name,
          'designer_shop_name': designerName,
          'is_shared_public': false,
          'created_at': now.toUtc().toIso8601String(),
          'updated_at': now.toUtc().toIso8601String(),
          'image_path': stored.imagePath,
          'thumbnail_path': stored.thumbnailPath,
        }),
      );

      if (!context.mounted) return;
      context.go('/app/catalog/$id');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.catalogCreated)));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _saving ? null : () => context.pop(),
        ),
        title: Text(l10n.catalogAddDesignCta),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (kIsWeb)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(l10n.catalogAddNotAvailableOnWeb),
              ),
            )
          else ...[
            if (_previewBytes == null)
              Container(
                width: double.infinity,
                height: 240,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Icon(Icons.add_a_photo_outlined, size: 56),
                ),
              )
            else
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.memory(
                  _previewBytes!,
                  width: double.infinity,
                  height: 240,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _saving ? null : () => _pick(ImageSource.camera),
                    icon: const Icon(Icons.photo_camera_outlined),
                    label: Text(l10n.cameraCta),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _saving ? null : () => _pick(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library_outlined),
                    label: Text(l10n.galleryCta),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          TextField(
            controller: _designName,
            decoration: InputDecoration(
              labelText: l10n.catalogDesignNameLabel,
              hintText: l10n.catalogDesignNameHint,
              border: const OutlineInputBorder(),
            ),
            enabled: !_saving,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _saving ? null : () => _save(context, l10n),
            icon: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check),
            label: Text(l10n.saveCta),
          ),
        ],
      ),
    );
  }
}

