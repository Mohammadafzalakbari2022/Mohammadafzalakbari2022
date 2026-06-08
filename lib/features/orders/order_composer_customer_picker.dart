import 'package:flutter/material.dart';
import 'package:pride_v3/core/formatting/display_customer_no_format.dart';
import 'package:pride_v3/core/widgets/pride_modal_bottom_sheet.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/local/customer_display_no.dart';
import '../../data/local/customer_summary.dart';
import '../customers/customer_search_filter.dart';

/// Search-and-pick sheet for existing customers (order composer search, new-customer search action).
Future<CustomerSummary?> showOrderComposerCustomerPicker({
  required BuildContext context,
  required List<CustomerSummary> customers,
  required AppLocalizations l10n,
  String? selectedId,
  String initialQuery = '',
}) {
  return showPrideModalBottomSheet<CustomerSummary>(
    context: context,
    builder: (ctx) => _OrderComposerCustomerPickerSheet(
      customers: customers,
      l10n: l10n,
      selectedId: selectedId,
      initialQuery: initialQuery,
    ),
  );
}

class _OrderComposerCustomerPickerSheet extends StatefulWidget {
  const _OrderComposerCustomerPickerSheet({
    required this.customers,
    required this.l10n,
    this.selectedId,
    this.initialQuery = '',
  });

  final List<CustomerSummary> customers;
  final AppLocalizations l10n;
  final String? selectedId;
  final String initialQuery;

  @override
  State<_OrderComposerCustomerPickerSheet> createState() =>
      _OrderComposerCustomerPickerSheetState();
}

class _OrderComposerCustomerPickerSheetState
    extends State<_OrderComposerCustomerPickerSheet> {
  late final TextEditingController _query;
  late final FocusNode _searchFocusNode;

  @override
  void initState() {
    super.initState();
    _query = TextEditingController(text: widget.initialQuery);
    _searchFocusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _query.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _query.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.paddingOf(context);
    final viewInsets = MediaQuery.viewInsetsOf(context).bottom;
    final hasQuery = _query.text.isNotEmpty;
    return Padding(
      padding: EdgeInsets.only(bottom: pad.bottom + viewInsets),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: kPrideSheetInitialChildSize,
        minChildSize: kPrideSheetMinChildSize,
        maxChildSize: kPrideSheetMaxChildSize,
        builder: (ctx, scrollController) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: SearchBar(
                  focusNode: _searchFocusNode,
                  hintText: widget.l10n.customersSearchHint,
                  controller: _query,
                  leading: const Icon(Icons.search),
                  trailing: [
                    if (hasQuery)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        tooltip: MaterialLocalizations.of(context)
                            .clearButtonTooltip,
                        onPressed: _clearSearch,
                      ),
                  ],
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
    final list = filterCustomersBySearchQuery(customers, query);

    if (list.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            customers.isEmpty
                ? l10n.customersEmptyTitle
                : l10n.customersFilteredEmpty,
            style: Theme.of(context).textTheme.titleMedium,
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
        final idLabel = parseStoredDisplayCustomerNo(c.displayCustomerNo) > 0
            ? displayCustomerNumberLabel(l10n, c.displayCustomerNo)
            : null;
        return ListTile(
          leading: Icon(
            selected ? Icons.check_circle : Icons.person_outline,
            color: selected ? Theme.of(context).colorScheme.primary : null,
          ),
          title: Text(c.name),
          subtitle: Text(
            [
              if (idLabel != null) idLabel,
              c.phone ?? l10n.customersPhoneMissing,
            ].join(' • '),
          ),
          onTap: () => onSelected(c),
        );
      },
    );
  }
}
