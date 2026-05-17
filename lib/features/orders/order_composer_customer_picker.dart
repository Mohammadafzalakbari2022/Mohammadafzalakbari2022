import 'package:flutter/material.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/local/customer_summary.dart';

/// Search-and-pick sheet for existing customers (order composer search, new-customer search action).
Future<CustomerSummary?> showOrderComposerCustomerPicker({
  required BuildContext context,
  required List<CustomerSummary> customers,
  required AppLocalizations l10n,
  String? selectedId,
}) {
  return showModalBottomSheet<CustomerSummary>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (ctx) => _OrderComposerCustomerPickerSheet(
      customers: customers,
      l10n: l10n,
      selectedId: selectedId,
    ),
  );
}

class _OrderComposerCustomerPickerSheet extends StatefulWidget {
  const _OrderComposerCustomerPickerSheet({
    required this.customers,
    required this.l10n,
    this.selectedId,
  });

  final List<CustomerSummary> customers;
  final AppLocalizations l10n;
  final String? selectedId;

  @override
  State<_OrderComposerCustomerPickerSheet> createState() =>
      _OrderComposerCustomerPickerSheetState();
}

class _OrderComposerCustomerPickerSheetState
    extends State<_OrderComposerCustomerPickerSheet> {
  final _query = TextEditingController();

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.paddingOf(context);
    final viewInsets = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: pad.bottom + viewInsets),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.55,
        minChildSize: 0.35,
        maxChildSize: 0.92,
        builder: (ctx, scrollController) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: TextField(
                  controller: _query,
                  autofocus: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: widget.l10n.customersSearchHint,
                    border: const OutlineInputBorder(),
                    isDense: true,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              Expanded(
                child: _CustomerPickerList(
                  customers: widget.customers,
                  query: _query.text,
                  selectedId: widget.selectedId,
                  l10n: widget.l10n,
                  scrollController: scrollController,
                  onSelected: (c) => Navigator.of(context).pop(c),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CustomerPickerList extends StatelessWidget {
  const _CustomerPickerList({
    required this.customers,
    required this.query,
    required this.selectedId,
    required this.l10n,
    required this.scrollController,
    required this.onSelected,
  });

  final List<CustomerSummary> customers;
  final String query;
  final String? selectedId;
  final AppLocalizations l10n;
  final ScrollController scrollController;
  final ValueChanged<CustomerSummary> onSelected;

  @override
  Widget build(BuildContext context) {
    final q = query.trim().toLowerCase();
    final list = customers.where((c) {
      if (q.isEmpty) return true;
      final phone = (c.phone ?? '').toLowerCase();
      return c.name.toLowerCase().contains(q) || phone.contains(q);
    }).toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    if (list.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            l10n.customersFilteredEmpty,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.separated(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
      itemCount: list.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final c = list[i];
        final selected = selectedId == c.internalId;
        return ListTile(
          leading: Icon(
            selected ? Icons.check_circle : Icons.person_outline,
            color: selected ? Theme.of(context).colorScheme.primary : null,
          ),
          title: Text(c.name),
          subtitle: Text(c.phone ?? l10n.customersPhoneMissing),
          onTap: () => onSelected(c),
        );
      },
    );
  }
}
