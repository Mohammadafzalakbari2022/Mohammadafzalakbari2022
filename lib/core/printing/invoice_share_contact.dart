import 'package:flutter/foundation.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

/// Saves the customer to the device address book when sharing an invoice.
///
/// Returns `true` when a new contact was inserted, `false` when skipped or
/// already present, or `null` when contacts are unavailable (e.g. web).
Future<bool?> saveCustomerContactForInvoiceShare({
  required String name,
  required String phone,
  bool skipPermissionRequest = false,
}) async {
  if (kIsWeb) return null;

  final trimmedName = name.trim();
  final trimmedPhone = phone.trim();
  if (trimmedName.isEmpty || trimmedPhone.isEmpty) return false;

  if (!skipPermissionRequest && !await FlutterContacts.requestPermission()) {
    return false;
  }

  final existing = await FlutterContacts.getContacts(
    withProperties: true,
  );
  for (final c in existing) {
    for (final p in c.phones) {
      if (_phonesMatch(p.number, trimmedPhone)) {
        return false;
      }
    }
  }

  final contact = Contact()
    ..name.first = trimmedName
    ..phones = [Phone(trimmedPhone)];
  await contact.insert();
  return true;
}

bool _phonesMatch(String a, String b) {
  final da = a.replaceAll(RegExp(r'\D'), '');
  final db = b.replaceAll(RegExp(r'\D'), '');
  if (da.isEmpty || db.isEmpty) return false;
  if (da == db) return true;
  if (da.endsWith(db) || db.endsWith(da)) return true;
  return false;
}
