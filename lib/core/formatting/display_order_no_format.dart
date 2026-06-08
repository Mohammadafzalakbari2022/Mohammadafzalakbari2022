import 'package:pride_v3/l10n/app_localizations.dart';

/// Display-only formatter for canonical 8-digit stored order numbers.
///
/// Storage, sync, backup, search, and filenames keep the full stored value.
String formatDisplayOrderNo(String stored) {
  final trimmed = stored.trim();
  if (trimmed.isEmpty) return trimmed;

  final n = int.tryParse(trimmed);
  if (n == null || n <= 0) return trimmed;

  final width = n > 99999 ? n.toString().length : 5;
  return n.toString().padLeft(width, '0');
}

/// Localized order number label for UI surfaces (list, detail, PDF header, share).
String displayOrderNumberLabel(AppLocalizations l10n, String storedOrderNo) {
  return l10n.ordersNumberPrefix(formatDisplayOrderNo(storedOrderNo));
}
