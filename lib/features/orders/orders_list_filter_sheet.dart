import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/app/app_theme.dart';
import 'package:pride_v3/core/calendar/app_date_picker.dart';
import 'package:pride_v3/core/calendar/date_calendar_notifier.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/local/entities/order_status.dart';
import 'order_status_label.dart';
import 'orders_list_filter.dart';
import 'orders_list_filter_provider.dart';

extension OrdersListFilterActiveX on OrdersListFilter {
  bool get hasActiveFilters =>
      statusFilter.isNotEmpty ||
      onlyUnpaid ||
      onlyOverdue ||
      onlyDeliveredToday ||
      deliveryDatePreset != OrdersDeliveryDatePreset.any ||
      (customerInternalId != null && customerInternalId!.isNotEmpty);
}

/// Bottom sheet for orders list filters (compact toolbar entry point).
Future<void> showOrdersListFilterSheet({
  required BuildContext context,
  required WidgetRef ref,
  required AppLocalizations l10n,
}) async {
  var draft = ref.read(ordersListFilterProvider);

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (context, setModal) {
          Future<void> pickCustomRange() async {
            final now = DateTime.now();
            final calendar = ref.read(dateCalendarSystemProvider);
            final range = await showAppDateRangePicker(
              context: context,
              l10n: l10n,
              system: calendar,
              helpText: l10n.ordersDateCustomPickerHelp,
              firstDate: DateTime(now.year - 2),
              lastDate: DateTime(now.year + 3),
              initialDateRange: draft.customRangeStart != null &&
                      draft.customRangeEnd != null
                  ? DateTimeRange(
                      start: draft.customRangeStart!,
                      end: draft.customRangeEnd!,
                    )
                  : DateTimeRange(
                      start: DateTime(now.year, now.month, now.day),
                      end: DateTime(now.year, now.month, now.day)
                          .add(const Duration(days: 7)),
                    ),
            );
            if (range == null) return;
            setModal(() {
              draft = draft.copyWith(
                deliveryDatePreset: OrdersDeliveryDatePreset.custom,
                customRangeStart: range.start,
                customRangeEnd: range.end,
              );
            });
          }

          void toggleStatus(OrderLocalStatus status) {
            setModal(() {
              final next = Set<OrderLocalStatus>.from(draft.statusFilter);
              if (next.contains(status)) {
                next.remove(status);
              } else {
                next.add(status);
              }
              draft = draft.copyWith(statusFilter: next);
            });
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.ordersFilterSheetTitle,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.ordersFilterQuickSection,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FilterChip(
                        label: Text(l10n.ordersFilterOverdueChip),
                        selected: draft.onlyOverdue,
                        onSelected: (_) => setModal(() {
                          final on = !draft.onlyOverdue;
                          draft = draft.copyWith(
                            onlyOverdue: on,
                            onlyDeliveredToday:
                                on ? false : draft.onlyDeliveredToday,
                          );
                        }),
                      ),
                      FilterChip(
                        label: Text(l10n.ordersFilterDeliveredTodayChip),
                        selected: draft.onlyDeliveredToday,
                        onSelected: (_) => setModal(() {
                          final on = !draft.onlyDeliveredToday;
                          draft = draft.copyWith(
                            onlyDeliveredToday: on,
                            onlyOverdue: on ? false : draft.onlyOverdue,
                          );
                        }),
                      ),
                      FilterChip(
                        label: Text(l10n.ordersOnlyUnpaidChip),
                        selected: draft.onlyUnpaid,
                        onSelected: (_) => setModal(() {
                          draft = draft.copyWith(onlyUnpaid: !draft.onlyUnpaid);
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.ordersFilterDeliverySection,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final preset in OrdersDeliveryDatePreset.values)
                        FilterChip(
                          label: Text(_deliveryPresetLabel(l10n, preset)),
                          selected: draft.deliveryDatePreset == preset,
                          onSelected: (_) {
                            if (preset == OrdersDeliveryDatePreset.custom) {
                              pickCustomRange();
                              return;
                            }
                            setModal(() {
                              draft = draft.copyWith(
                                deliveryDatePreset: preset,
                                clearCustomRange:
                                    preset != OrdersDeliveryDatePreset.custom,
                              );
                            });
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.ordersFilterStatusSection,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final status in OrderLocalStatus.values)
                        FilterChip(
                          label: Text(orderStatusLabel(status, l10n)),
                          selected: draft.statusFilter.contains(status),
                          onSelected: (_) => toggleStatus(status),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          setModal(() {
                            draft = const OrdersListFilter();
                          });
                        },
                        style: prideButtonStyle(
                          context,
                          PrideButtonVariant.cancel,
                        ),
                        child: Text(l10n.ordersFilterClearAll),
                      ),
                      const Spacer(),
                      FilledButton(
                        onPressed: () {
                          ref.read(ordersListFilterProvider.notifier).state =
                              draft;
                          Navigator.of(sheetContext).pop();
                        },
                        style: prideButtonStyle(
                          context,
                          PrideButtonVariant.primary,
                        ),
                        child: Text(l10n.ordersFilterApply),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

String _deliveryPresetLabel(
  AppLocalizations l10n,
  OrdersDeliveryDatePreset preset,
) {
  switch (preset) {
    case OrdersDeliveryDatePreset.any:
      return l10n.ordersDateChipAny;
    case OrdersDeliveryDatePreset.today:
      return l10n.ordersDateChipToday;
    case OrdersDeliveryDatePreset.thisWeek:
      return l10n.ordersDateChipThisWeek;
    case OrdersDeliveryDatePreset.custom:
      return l10n.ordersDateChipCustom;
  }
}
