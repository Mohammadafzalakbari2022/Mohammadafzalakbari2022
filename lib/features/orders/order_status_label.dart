import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/local/entities/order_status.dart';

String orderStatusLabel(OrderLocalStatus status, AppLocalizations l10n) {
  switch (status) {
    case OrderLocalStatus.newOrder:
      return l10n.orderStatusNew;
    case OrderLocalStatus.inProgress:
      return l10n.orderStatusInProgress;
    case OrderLocalStatus.ready:
      return l10n.orderStatusReady;
    case OrderLocalStatus.delivered:
      return l10n.orderStatusDelivered;
    case OrderLocalStatus.cancelled:
      return l10n.orderStatusCancelled;
  }
}
