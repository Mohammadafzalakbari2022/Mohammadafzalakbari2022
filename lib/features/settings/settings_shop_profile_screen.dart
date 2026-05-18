import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../core/validation/afghan_phone_input.dart';
import '../../core/widgets/shop_logo_image.dart';
import '../../licensing/license_providers.dart';
import 'shop_profile.dart';
import 'shop_profile_logo_actions.dart';
import 'shop_profile_provider.dart';

class SettingsShopProfileScreen extends ConsumerStatefulWidget {
  const SettingsShopProfileScreen({super.key});

  @override
  ConsumerState<SettingsShopProfileScreen> createState() =>
      _SettingsShopProfileScreenState();
}

class _SettingsShopProfileScreenState
    extends ConsumerState<SettingsShopProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _address;
  late final TextEditingController _phone;
  late final TextEditingController _notes;
  late final TextEditingController _receiptThanks;
  bool _seeded = false;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController();
    _address = TextEditingController();
    _phone = TextEditingController();
    _notes = TextEditingController();
    _receiptThanks = TextEditingController();
  }

  @override
  void dispose() {
    _name.dispose();
    _address.dispose();
    _phone.dispose();
    _notes.dispose();
    _receiptThanks.dispose();
    super.dispose();
  }

  void _applyShop(ShopProfile shop) {
    _name.text = shop.name;
    _address.text = shop.address ?? '';
    _phone.text = shop.phone ?? '';
    _notes.text = shop.notes ?? '';
    _receiptThanks.text = shop.receiptThankYouMessage ?? '';
  }

  Future<void> _save(AppLocalizations l10n) async {
    final license = ref.read(licenseNotifierProvider);
    if (ref.read(licenseEditingBlockedProvider)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(licenseWriteBlockedMessage(license, l10n))),
      );
      return;
    }

    if (!(_formKey.currentState?.validate() ?? false)) return;

    final next = ShopProfile(
      name: _name.text,
      address: _address.text.trim().isEmpty ? null : _address.text.trim(),
      phone: _phone.text.trim().isEmpty
          ? null
          : normalizeAfghanPhoneDigits(_phone.text.trim()),
      notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
      receiptThankYouMessage: _receiptThanks.text.trim().isEmpty
          ? null
          : _receiptThanks.text.trim(),
      logoRelativePath: ref.read(shopProfileProvider).valueOrNull?.logoRelativePath,
    );

    await ref.read(shopProfileProvider.notifier).save(next);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.shopProfileSaved)),
    );
    if (context.canPop()) context.pop();
  }

  String _resolvedShopNameForSave() {
    final typed = _name.text.trim();
    if (typed.length >= 2) return typed;
    final existing = ref.read(shopProfileProvider).valueOrNull?.name.trim();
    if (existing != null && existing.length >= 2) return existing;
    return typed;
  }

  Future<void> _pickLogo(BuildContext context, AppLocalizations l10n) async {
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.shopProfileLogoWebHint)),
      );
      return;
    }
    final name = _resolvedShopNameForSave();
    if (name.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.shopProfileNameTooShort)),
      );
      return;
    }
    final path = await pickShopLogoRelativePath();
    if (!mounted || path == null) return;
    final next = ShopProfile(
      name: name,
      address: _address.text.trim().isEmpty ? null : _address.text.trim(),
      phone: _phone.text.trim().isEmpty
          ? null
          : normalizeAfghanPhoneDigits(_phone.text.trim()),
      notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
      receiptThankYouMessage: _receiptThanks.text.trim().isEmpty
          ? null
          : _receiptThanks.text.trim(),
      logoRelativePath: path,
    );
    await ref.read(shopProfileProvider.notifier).save(next);
    if (!context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.shopProfileLogoSaved)),
    );
  }

  Future<void> _removeLogo(BuildContext context, AppLocalizations l10n) async {
    if (kIsWeb) return;
    final name = _resolvedShopNameForSave();
    if (name.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.shopProfileNameTooShort)),
      );
      return;
    }
    await deleteShopLogoFile();
    final next = ShopProfile(
      name: name,
      address: _address.text.trim().isEmpty ? null : _address.text.trim(),
      phone: _phone.text.trim().isEmpty
          ? null
          : normalizeAfghanPhoneDigits(_phone.text.trim()),
      notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
      receiptThankYouMessage: _receiptThanks.text.trim().isEmpty
          ? null
          : _receiptThanks.text.trim(),
      logoRelativePath: null,
    );
    await ref.read(shopProfileProvider.notifier).save(next);
    if (!context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.shopProfileSaved)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final readOnly = ref.watch(licenseEditingBlockedProvider);
    final async = ref.watch(shopProfileProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.settingsShopProfileTitle),
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (shop) {
          if (!_seeded) {
            _seeded = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _applyShop(shop);
            });
          }

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (readOnly)
                  Card(
                    color: Theme.of(context).colorScheme.errorContainer,
                    child: ListTile(
                      leading: Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                      title: Text(l10n.shopProfileReadOnlyBanner),
                    ),
                  ),
                if (readOnly) const SizedBox(height: 12),
                Text(
                  l10n.shopProfileIntro,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _name,
                  readOnly: readOnly,
                  decoration: InputDecoration(
                    labelText: l10n.shopProfileNameLabel,
                    hintText: l10n.shopProfileNameHint,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (v) {
                    final s = (v ?? '').trim();
                    if (s.isEmpty) return l10n.shopProfileNameRequired;
                    if (s.length < 2) return l10n.shopProfileNameTooShort;
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phone,
                  readOnly: readOnly,
                  keyboardType: TextInputType.phone,
                  inputFormatters: const [AfghanPhoneInputFormatter()],
                  decoration: InputDecoration(
                    labelText: l10n.shopProfileShopPhoneLabel,
                    hintText: l10n.shopProfileShopPhoneHint,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _address,
                  readOnly: readOnly,
                  minLines: 2,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: l10n.shopProfileAddressLabel,
                    hintText: l10n.shopProfileAddressHint,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _receiptThanks,
                  readOnly: readOnly,
                  minLines: 2,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: l10n.shopProfileReceiptThanksLabel,
                    hintText: l10n.shopProfileReceiptThanksHint,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _notes,
                  readOnly: readOnly,
                  minLines: 2,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: l10n.shopProfileNotesLabel,
                    hintText: l10n.shopProfileNotesHint,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.shopProfileLogoSectionTitle,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.shopProfileLogoSubtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                ShopLogoImage(
                  logoRelativePath: shop.logoRelativePath,
                  size: 96,
                  borderRadius: 8,
                ),
                const SizedBox(height: 8),
                Text(
                  (shop.logoRelativePath ?? '').isNotEmpty
                      ? l10n.shopProfileLogoStatusOnFile
                      : l10n.shopProfileLogoDefaultCaption,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (kIsWeb) ...[
                  const SizedBox(height: 8),
                  Text(
                    l10n.shopProfileLogoWebHint,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ] else ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      OutlinedButton.icon(
                        onPressed: readOnly
                            ? null
                            : () => _pickLogo(context, l10n),
                        icon: const Icon(Icons.add_photo_alternate_outlined),
                        label: Text(l10n.shopProfileLogoPickCta),
                      ),
                      if (!readOnly &&
                          (shop.logoRelativePath ?? '').isNotEmpty)
                        TextButton(
                          onPressed: () => _removeLogo(context, l10n),
                          child: Text(l10n.shopProfileLogoRemoveCta),
                        ),
                    ],
                  ),
                ],
                if (!readOnly) ...[
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () => _save(l10n),
                    icon: const Icon(Icons.check),
                    label: Text(l10n.saveCta),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
