import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/app/app_theme.dart';
import 'package:pride_v3/core/feedback/app_feedback.dart';
import 'package:pride_v3/core/widgets/pride_close_button.dart';
import 'package:pride_v3/core/widgets/pride_form_bottom_bar.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../auth/auth_providers.dart';
import '../../data/local/customer_summary.dart';
import '../../data/local/sync_outbox_kinds.dart';
import '../../data/providers/local_data_providers.dart';
import '../orders/order_composer_customer_picker.dart';
import '../../licensing/license_providers.dart';
import '../../shell/shell_sync_providers.dart';

/// Popped back to [OrderComposerScreen] after save when `returnTo=orderComposer`.
class NewCustomerForOrderResult {
  const NewCustomerForOrderResult({
    required this.internalId,
    required this.name,
    this.phone,
  });

  final String internalId;
  final String name;
  final String? phone;
}

class NewCustomerScreen extends ConsumerStatefulWidget {
  const NewCustomerScreen({super.key});

  @override
  ConsumerState<NewCustomerScreen> createState() => _NewCustomerScreenState();
}

class _NewCustomerScreenState extends ConsumerState<NewCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _address.dispose();
    super.dispose();
  }

  Future<void> _pickExistingCustomer(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    var customers = ref.read(customersListStreamProvider).valueOrNull;
    if (customers == null) {
      await ref.read(customersListStreamProvider.future);
      if (!context.mounted) return;
      customers = ref.read(customersListStreamProvider).valueOrNull;
    }
    final list = customers ?? const <CustomerSummary>[];

    final picked = await showOrderComposerCustomerPicker(
      context: context,
      customers: list,
      l10n: l10n,
    );
    if (!context.mounted || picked == null) return;
    context.pop(
      NewCustomerForOrderResult(
        internalId: picked.internalId,
        name: picked.name,
        phone: picked.phone,
      ),
    );
  }

  Future<void> _save(BuildContext context, AppLocalizations l10n) async {
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

    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    setState(() => _saving = true);
    try {
      final repo = await ref.read(customerListRepositoryProvider.future);
      final shopId = ref.read(effectiveShopIdProvider);
      final id = await repo.createCustomer(
        shopId: shopId,
        name: _name.text,
        phone: _phone.text,
        address: _address.text,
        notes: '',
      );
      final createdAt = DateTime.now();
      recordSyncOutboxMutation(
        ref,
        kind: SyncOutboxKinds.customerUpsert,
        entityRef: id,
        shopId: shopId,
        payloadJson: jsonEncode({
          'name': _name.text.trim(),
          if (_phone.text.trim().isNotEmpty) 'phone': _phone.text.trim(),
          if (_address.text.trim().isNotEmpty) 'address': _address.text.trim(),
          'created_at': createdAt.toUtc().toIso8601String(),
        }),
      );
      if (!context.mounted) return;
      showAppFeedback(
        context,
        ref,
        kind: AppFeedbackKind.success,
        message: l10n.customersCreated,
      );
      final returnTo =
          GoRouterState.of(context).uri.queryParameters['returnTo'];
      if (returnTo == 'orderComposer') {
        context.pop(
          NewCustomerForOrderResult(
            internalId: id,
            name: _name.text.trim(),
            phone: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
          ),
        );
      } else {
        context.go('/app/customers/$id');
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final returnTo =
        GoRouterState.of(context).uri.queryParameters['returnTo'];
    final fromOrderComposer = returnTo == 'orderComposer';
    return Scaffold(
      appBar: AppBar(
        leading: PrideCloseIconButton(
          onPressed: _saving ? null : () => context.pop(),
        ),
        title: Text(
          fromOrderComposer
              ? l10n.ordersComposerCustomerTitle
              : l10n.customersAddCta,
        ),
        actions: [
          if (fromOrderComposer)
            IconButton(
              icon: const Icon(Icons.search),
              tooltip: l10n.customersSearchHint,
              onPressed:
                  _saving ? null : () => _pickExistingCustomer(context, l10n),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: prideFormScrollPadding(context),
          children: [
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
              enabled: !_saving,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: l10n.customerPhoneLabel,
                hintText: l10n.customerPhoneHint,
                border: const OutlineInputBorder(),
              ),
              enabled: !_saving,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _address,
              maxLines: 2,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: l10n.customerAddressLabel,
                hintText: l10n.customerAddressHint,
                border: const OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              enabled: !_saving,
            ),
          ],
        ),
      ),
      bottomNavigationBar: PrideFormBottomBar(
        onCancel: _saving ? null : () => context.pop(),
        primary: FilledButton.icon(
          onPressed: _saving ? null : () => _save(context, l10n),
          style: prideButtonStyle(context, PrideButtonVariant.add),
          icon: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.check),
          label: Text(l10n.saveCta),
        ),
      ),
    );
  }
}

