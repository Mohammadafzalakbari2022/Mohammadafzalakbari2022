import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/core/feedback/app_feedback.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../auth/auth_providers.dart';
import '../../core/api/pride_api_config.dart';
import '../../data/local/catalog_item_summary.dart';
import '../../data/providers/local_data_providers.dart';
import '../../licensing/license_providers.dart';
import 'catalog_p2p_service.dart';
import 'catalog_storage_io.dart' if (dart.library.html) 'catalog_storage_stub.dart' as catalog_storage;
import 'remote_public_catalog_provider.dart';

/// Downloads a remote shared catalog row into local My Designs (`plan-14`).
Future<void> downloadSharedCatalogItem(
  BuildContext context,
  WidgetRef ref,
  CatalogItemSummary item,
) async {
  final l10n = AppLocalizations.of(context)!;
  if (kIsWeb) {
    showAppFeedback(
      context,
      ref,
      kind: AppFeedbackKind.info,
      message: l10n.catalogP2pWebNotSupported,
    );
    return;
  }
  if (!PrideApiConfig.isConfigured) {
    showAppFeedback(
      context,
      ref,
      kind: AppFeedbackKind.error,
      message: l10n.settingsSyncRetrySignIn,
    );
    return;
  }
  final auth = ref.read(authSessionProvider);
  final token = auth.accessToken;
  final myShopId = ref.read(effectiveShopIdProvider);
  if (!auth.hasApiSession || token == null) {
    showAppFeedback(
      context,
      ref,
      kind: AppFeedbackKind.error,
      message: l10n.settingsSyncRetrySignIn,
    );
    return;
  }
  if (ref.read(licenseEditingBlockedProvider)) {
    showAppFeedback(
      context,
      ref,
      kind: AppFeedbackKind.error,
      message: licenseWriteBlockedMessage(
        ref.read(licenseNotifierProvider),
        l10n,
      ),
    );
    return;
  }
  if (item.shopId == myShopId) return;

  if (!context.mounted) return;
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.catalogP2pDownloading),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.catalogP2pWaitingSender),
          const SizedBox(height: 20),
          const LinearProgressIndicator(),
        ],
      ),
    ),
  );

  final p2p = CatalogP2pService(accessToken: token, myShopId: myShopId);
  final bytes = await p2p.downloadSharedDesign(
    senderShopId: item.shopId,
    catalogInternalId: item.internalId,
  );

  if (context.mounted) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  if (bytes == null || bytes.isEmpty) {
    if (context.mounted) {
      showAppFeedback(
        context,
        ref,
        kind: AppFeedbackKind.error,
        message: l10n.catalogP2pDownloadFailed,
      );
    }
    return;
  }

  try {
    final paths = await catalog_storage.storeCatalogImage(bytes);
    final repo = await ref.read(catalogRepositoryProvider.future);
    await repo.createItem(
      shopId: myShopId,
      designName: item.designName,
      designerShopName: item.designerShopName,
      imagePath: paths.imagePath,
      thumbnailPath: paths.thumbnailPath,
      isSharedPublic: false,
    );
    ref.invalidate(myCatalogStreamProvider);
    ref.invalidate(remotePublicCatalogProvider);
    if (context.mounted) {
      showAppFeedback(
        context,
        ref,
        kind: AppFeedbackKind.success,
        message: l10n.catalogP2pDownloadDone,
      );
    }
  } catch (_) {
    if (context.mounted) {
      showAppFeedback(
        context,
        ref,
        kind: AppFeedbackKind.error,
        message: l10n.catalogP2pDownloadFailed,
      );
    }
  }
}
