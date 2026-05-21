import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/core/input/pride_ltr_input.dart';
import 'package:pride_v3/core/validation/afghan_phone_input.dart';
import 'package:pride_v3/core/widgets/pride_form_bottom_bar.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/local/customer_summary.dart';
import '../../data/local/order_summary.dart';
import '../customers/new_customer_screen.dart';
import 'order_composer_customer_picker.dart';

/// Result of editing customer on an existing order.
class OrderCustomerEditResult {
  const OrderCustomerEditResult({
    required this.customerInternalId,
    required this.name,
    this.phone,
  });

  final String customerInternalId;
  final String name;
  final String? phone;
}

/// Name/phone editor with pick-from-list (order detail edit).
Future<OrderCustomerEditResult?> showOrderDetailCustomerEditSheet({
  required BuildContext context,
  required AppLocalizations l10n,
  required OrderSummary order,
  required List<CustomerSummary> customers,
}) {
  return showModalBottomSheet<OrderCustomerEditResult>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (ctx) => _OrderDetailCustomerEditSheet(
      l10n: l10n,
      order: order,
      customers: customers,
    ),
  );
}

class _OrderDetailCustomerEditSheet extends StatefulWidget {
  const _OrderDetailCustomerEditSheet({
    required this.l10n,
    required this.order,
    required this.customers,
  });

  final AppLocalizations l10n;
  final OrderSummary order;
  final List<CustomerSummary> customers;

  @override
  State<_OrderDetailCustomerEditSheet> createState() =>
      _OrderDetailCustomerEditSheetState();
}

class _OrderDetailCustomerEditSheetState
    extends State<_OrderDetailCustomerEditSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _phone;
  late final TextEditingController _search;
  String? _customerId;

  @override
  void initState() {
    super.initState();
    _customerId = widget.order.customerInternalId;
    _name = TextEditingController(text: widget.order.customerName);
    _phone = TextEditingController(text: widget.order.customerPhone ?? '');
    _search = TextEditingController();
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _search.dispose();
    super.dispose();
  }

  void _applyCustomer(CustomerSummary c) {
    setState(() {
      _customerId = c.internalId;
      _name.text = c.name;
      _phone.text = c.phone ?? '';
    });
  }

  Future<void> _pickFromList() async {
    final picked = await showOrderComposerCustomerPicker(
      context: context,
      customers: widget.customers,
      l10n: widget.l10n,
      selectedId: _customerId,
    );
    if (picked != null) _applyCustomer(picked);
  }

  Future<void> _openNewCustomer() async {
    final result = await context.push<Object?>(
      '/app/customers/new?returnTo=orderDetailCustomerEdit',
    );
    if (!mounted || result == null) return;
    if (result is NewCustomerForOrderResult) {
      _applyCustomer(
        CustomerSummary(
          shopId: widget.order.shopId,
          internalId: result.internalId,
          name: result.name,
          phone: result.phone,
          createdAt: DateTime.now(),
        ),
      );
      return;
    }
    if (result is String) {
      for (final c in widget.customers) {
        if (c.internalId == result) {
          _applyCustomer(c);
          return;
        }
      }
    }
  }

  void _tryMatchFromSearch(String q) {
    final lower = q.trim().toLowerCase();
    if (lower.isEmpty) return;
    for (final c in widget.customers) {
      final phone = (c.phone ?? '').toLowerCase();
      if (c.name.toLowerCase().contains(lower) || phone.contains(lower)) {
        _applyCustomer(c);
        return;
      }
    }
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final id = _customerId;
    if (id == null || id.isEmpty) return;
    final phoneRaw = _phone.text.trim();
    Navigator.of(context).pop(
      OrderCustomerEditResult(
        customerInternalId: id,
        name: _name.text.trim(),
        phone: phoneRaw.isEmpty
            ? null
            : normalizeAfghanPhoneDigits(phoneRaw),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    final pad = MediaQuery.paddingOf(context);
    final viewInsets = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: pad.bottom + viewInsets),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.72,
        minChildSize: 0.45,
        maxChildSize: 0.95,
        builder: (ctx, scrollController) {
          return Form(
            key: _formKey,
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              children: [
                Text(
                  l10n.ordersDetailEditCustomerTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _search,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: l10n.customersSearchHint,
                    border: const OutlineInputBorder(),
                    isDense: true,
                  ),
                  onChanged: (_) => setState(() {}),
                  onSubmitted: _tryMatchFromSearch,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _pickFromList,
                        icon: const Icon(Icons.people_outline),
                        label: Text(l10n.ordersDetailCustomerPickFromList),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _openNewCustomer,
                        icon: const Icon(Icons.person_add_outlined),
                        label: Text(l10n.customersAddCta),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _name,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: l10n.customerNameLabel,
                    hintText: l10n.customerNameHint,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (v) {
                    final value = (v ?? '').trim();
                    if (value.isEmpty) return l10n.customerNameRequired;
                    if (value.length < 2) return l10n.customerNameTooShort;
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  textDirection: PrideLtrInput.direction,
                  textAlign: PrideLtrInput.align,
                  inputFormatters: const [AfghanPhoneInputFormatter()],
                  decoration: InputDecoration(
                    labelText: l10n.customerPhoneLabel,
                    hintText: l10n.customerPhoneHint,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                PrideFormBottomBar(
                  onCancel: () => Navigator.of(context).pop(),
                  primary: FilledButton(
                    onPressed: _save,
                    child: Text(l10n.saveCta),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
