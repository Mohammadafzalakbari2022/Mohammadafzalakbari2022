import 'package:pride_v3/l10n/app_localizations.dart';

import 'order_shape_selection_formatter.dart';

OrderShapeSelectionFormatLabels orderShapeFormatLabels(AppLocalizations l10n) {
  return OrderShapeSelectionFormatLabels(
    mainStyle: l10n.orderStyleDisplayMainStyleLabel,
    shape: l10n.orderStyleDisplayShapeLabel,
    detail: l10n.orderStyleDisplayDetailLabel,
    size: l10n.orderStyleDisplaySizeLabel,
    note: l10n.orderStyleDisplayNoteLabel,
  );
}
