import 'package:flutter/foundation.dart';

/// Holds authentication state for [GoRouter] redirects.
/// Replace with real API-backed session per plan-04 / plan-19.
class AuthSession extends ChangeNotifier {
  AuthSession();

  bool _authenticated = false;
  String? _username;
  String? _shopId;

  bool get authenticated => _authenticated;

  /// Display name from last mock/API sign-in (null = guest / dev bypass).
  String? get username => _username;

  /// Optional shop identifier entered at login (until multi-shop API exists).
  String? get shopId => _shopId;

  /// Offline mock: accepts any non-empty username + password.
  /// [shopId] may be empty (single-shop dev).
  void signInMock({
    required String username,
    required String password,
    String? shopId,
  }) {
    final u = username.trim();
    if (u.isEmpty || password.isEmpty) return;
    final s = shopId?.trim();
    _username = u;
    _shopId = (s == null || s.isEmpty) ? null : s;
    if (!_authenticated) {
      _authenticated = true;
    }
    notifyListeners();
  }

  void setAuthenticated(bool value) {
    if (_authenticated == value) return;
    _authenticated = value;
    if (!value) {
      _username = null;
      _shopId = null;
    }
    notifyListeners();
  }

  /// Clears the session and returns the app to the login gate (plan-04).
  void signOut() => setAuthenticated(false);
}
