import 'package:pride_v3/core/api/pride_api_auth.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

/// Maps API/transport failures to short, non-technical copy for login & signup.
String loginFailureUserMessage(
  AppLocalizations l10n,
  PrideApiLoginFailure failure,
) {
  return switch (_classifyFailure(failure)) {
    _AuthFailureKind.invalidCredentials => l10n.loginInvalidCredentials,
    _AuthFailureKind.noInternet => l10n.loginNoInternet,
    _AuthFailureKind.connectionSlow => l10n.loginConnectionSlow,
    _AuthFailureKind.serverBusy => l10n.loginServerBusy,
    _AuthFailureKind.generic => l10n.loginSomethingWrong,
  };
}

/// User-facing message when creating a new shop fails.
String shopCreateFailureUserMessage(
  AppLocalizations l10n,
  PrideApiLoginFailure failure,
) {
  final kind = _classifyFailure(failure);
  return switch (kind) {
    _AuthFailureKind.invalidCredentials => l10n.loginShopCreateFailed,
    _AuthFailureKind.noInternet => l10n.loginNoInternet,
    _AuthFailureKind.connectionSlow => l10n.loginConnectionSlow,
    _AuthFailureKind.serverBusy => l10n.loginServerBusy,
    _AuthFailureKind.generic => l10n.loginShopCreateFailed,
  };
}

enum _AuthFailureKind {
  invalidCredentials,
  noInternet,
  connectionSlow,
  serverBusy,
  generic,
}

_AuthFailureKind _classifyFailure(PrideApiLoginFailure failure) {
  final code = failure.statusCode;
  if (code == 401 || code == 403 || code == 404) {
    return _AuthFailureKind.invalidCredentials;
  }
  if (code != null && code >= 500) {
    return _AuthFailureKind.serverBusy;
  }

  final m = failure.message.toLowerCase();
  if (_looksLikeTimeout(m)) {
    return _AuthFailureKind.connectionSlow;
  }
  if (_looksLikeNetwork(m)) {
    return _AuthFailureKind.noInternet;
  }
  if (code != null && code >= 400 && code < 500) {
    return _AuthFailureKind.invalidCredentials;
  }

  return _AuthFailureKind.generic;
}

/// User-facing message when a password-reset request fails.
String passwordResetFailureUserMessage(
  AppLocalizations l10n, {
  int? statusCode,
  required String rawMessage,
}) {
  return switch (
      _classifyFailure(PrideApiLoginFailure(rawMessage, statusCode: statusCode))
  ) {
    _AuthFailureKind.invalidCredentials => l10n.loginForgotPasswordFailed,
    _AuthFailureKind.noInternet => l10n.loginNoInternet,
    _AuthFailureKind.connectionSlow => l10n.loginConnectionSlow,
    _AuthFailureKind.serverBusy => l10n.loginServerBusy,
    _AuthFailureKind.generic => l10n.loginForgotPasswordFailed,
  };
}

bool _looksLikeTimeout(String m) =>
    m.contains('timeout') || m.contains('timed out');

bool _looksLikeNetwork(String m) =>
    m.contains('socket') ||
    m.contains('failed host') ||
    m.contains('network is unreachable') ||
    m.contains('connection refused') ||
    m.contains('connection reset') ||
    m.contains('clientexception') ||
    m.contains('failed to fetch') ||
    m.contains('network error');

/// True when sign-in may succeed against a cached offline credential (`plan-04`).
bool isLoginFailureOfflineRecoverable(PrideApiLoginFailure failure) {
  return switch (_classifyFailure(failure)) {
    _AuthFailureKind.noInternet => true,
    _AuthFailureKind.connectionSlow => true,
    _ => false,
  };
}
