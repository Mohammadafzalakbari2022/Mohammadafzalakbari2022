import 'package:flutter/foundation.dart';

/// Holds authentication state for [GoRouter] redirects (`plan-04` / `plan-19`).
class AuthSession extends ChangeNotifier {
  AuthSession();

  bool _authenticated = false;
  String? _username;
  String? _shopId;
  String? _accessToken;
  String? _userId;
  bool _isShopOwner = false;

  bool get authenticated => _authenticated;

  /// Display name from last mock/API sign-in (null = guest / dev bypass).
  String? get username => _username;

  /// Shop identifier from login (API or mock).
  String? get shopId => _shopId;

  /// Server-issued bearer token after `POST /auth/login`, when used.
  String? get accessToken => _accessToken;

  /// Server user id when logged in via API.
  String? get userId => _userId;

  bool get isShopOwner => _isShopOwner;

  bool get hasApiSession => _accessToken != null;

  /// Local-only dev sign-in when `API_BASE_URL` is not configured.
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
    _accessToken = null;
    _userId = null;
    _isShopOwner = false;
    if (!_authenticated) {
      _authenticated = true;
    }
    notifyListeners();
  }

  /// Successful `POST /auth/login` (`plan-04`).
  void signInFromApi({
    required String accessToken,
    required String userId,
    required String username,
    required String shopId,
    required bool isShopOwner,
  }) {
    _accessToken = accessToken;
    _userId = userId;
    _username = username.trim();
    _shopId = shopId.trim();
    _isShopOwner = isShopOwner;
    _authenticated = true;
    notifyListeners();
  }

  void setAuthenticated(bool value) {
    if (_authenticated == value) return;
    _authenticated = value;
    if (!value) {
      _username = null;
      _shopId = null;
      _accessToken = null;
      _userId = null;
      _isShopOwner = false;
    }
    notifyListeners();
  }

  /// Clears the session and returns the app to the login gate (plan-04).
  void signOut() => setAuthenticated(false);
}
