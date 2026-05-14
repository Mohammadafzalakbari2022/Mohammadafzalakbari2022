import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../auth/auth_providers.dart';
import '../../data/local/sync_outbox_kinds.dart';
import '../../data/providers/local_data_providers.dart';
import '../../licensing/license_providers.dart';
import '../../shell/shell_sync_providers.dart';

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
  final _notes = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _address.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _save(BuildContext context, AppLocalizations l10n) async {
    final license = ref.read(licenseNotifierProvider);
    if (license.isExpired) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.licenseExpiredReadOnly)),
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
        notes: _notes.text,
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
          if (_notes.text.trim().isNotEmpty) 'notes': _notes.text.trim(),
          'created_at': createdAt.toUtc().toIso8601String(),
        }),
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.customersCreated)),
      );
      context.go('/app/customers/$id');
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
        title: Text(l10n.customersAddCta),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
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
            const SizedBox(height: 12),
            TextFormField(
              controller: _notes,
              minLines: 2,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: l10n.customerNotesLabel,
                hintText: l10n.customerNotesHint,
                border: const OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              enabled: !_saving,
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
      ),
    );
  }
}

