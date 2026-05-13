import 'dart:convert';

import 'package:crypto/crypto.dart';

/// SHA-256 (hex, lowercase) of the default **development** owner password.
///
/// See [TESTING.md] for the plain value. Real deployments should set
/// `PRIDE_OWNER_PASSWORD_SHA256` via `--dart-define` to the shop’s chosen
/// password digest, or replace this path with a verifier from the auth API
/// (plan-02 / plan-06).
const _kDefaultOwnerPasswordSha256Hex =
    'fd7427cb5fba6b49791ae82d06a48d7b4d0e449f2314fa43664d1e12d19aa470';

const _kOverrideSha256Hex = String.fromEnvironment(
  'PRIDE_OWNER_PASSWORD_SHA256',
  defaultValue: '',
);

/// Offline check for high-risk actions (e.g. Delivered / Cancelled on an order).
bool verifyOwnerPasswordForLocalActions(String input) {
  final trimmed = input.trim();
  if (trimmed.isEmpty) return false;
  final digest = sha256.convert(utf8.encode(trimmed)).toString();
  final expected = _expectedHex();
  if (expected == null || expected.length != digest.length) return false;
  return _timingSafeEqualsAsciiLower(digest, expected);
}

String? _expectedHex() {
  final o = _kOverrideSha256Hex.trim().toLowerCase();
  if (o.isEmpty) return _kDefaultOwnerPasswordSha256Hex;
  return o;
}

bool _timingSafeEqualsAsciiLower(String a, String b) {
  if (a.length != b.length) return false;
  var d = 0;
  for (var i = 0; i < a.length; i++) {
    d |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
  }
  return d == 0;
}
