import 'package:flutter/foundation.dart';

/// Mirrors server `license_snapshot` (`plan-06` / `plan-04`).
enum LicenseStatus { trialActive, active, expired }

class LicenseNotifier extends ChangeNotifier {
  LicenseStatus _status = LicenseStatus.trialActive;
  DateTime? _expiresAtUtc;
  DateTime? _lastSuccessfulCheckAtUtc;

  LicenseStatus get status => _status;

  bool get isExpired => _status == LicenseStatus.expired;

  DateTime? get expiresAtUtc => _expiresAtUtc;

  DateTime? get lastSuccessfulCheckAtUtc => _lastSuccessfulCheckAtUtc;

  bool _suspectedTimeTamper = false;

  bool get suspectedTimeTamper => _suspectedTimeTamper;

  void setSuspectedTimeTamper(bool value) {
    if (_suspectedTimeTamper == value) return;
    _suspectedTimeTamper = value;
    notifyListeners();
  }

  /// When true, creating/updating business data and sync must be blocked
  /// (`plan-06`: expired, or offline past the post-check grace window).
  bool isEditingBlocked({required bool online}) {
    if (_suspectedTimeTamper) return true;
    if (isExpired) return true;
    if (online) return false;
    final last = _lastSuccessfulCheckAtUtc;
    if (last == null) return false;
    final deadline = last.add(const Duration(days: 3));
    return DateTime.now().toUtc().isAfter(deadline);
  }

  void setStatus(LicenseStatus value) {
    if (_status == value) return;
    _status = value;
    notifyListeners();
  }

  /// Restores timing fields from cold-start prefs (no status change).
  void restoreTimingFromIso({
    String? expiresAtIso,
    String? lastSuccessfulCheckAtIso,
  }) {
    var changed = false;
    final e = _parseIsoToUtc(expiresAtIso);
    if (e != _expiresAtUtc) {
      _expiresAtUtc = e;
      changed = true;
    }
    final l = _parseIsoToUtc(lastSuccessfulCheckAtIso);
    if (l != _lastSuccessfulCheckAtUtc) {
      _lastSuccessfulCheckAtUtc = l;
      changed = true;
    }
    if (changed) notifyListeners();
  }

  /// Applies `license_snapshot` from `POST /auth/login` or `GET /license/status`.
  void applyLicenseSnapshotMap(Map<String, dynamic> json) {
    final raw = json['status'];
    if (raw is String) {
      final next = switch (raw) {
        'trial_active' => LicenseStatus.trialActive,
        'active' => LicenseStatus.active,
        'expired' => LicenseStatus.expired,
        _ => null,
      };
      if (next != null && next != _status) {
        _status = next;
      }
    }
    _applyTimingFromSnapshot(json);
    notifyListeners();
  }

  void _applyTimingFromSnapshot(Map<String, dynamic> json) {
    final exp = _parseIsoToUtc(json['expires_at']);
    if (exp != null) _expiresAtUtc = exp;
    final last = _parseIsoToUtc(json['last_successful_check_at']) ??
        _parseIsoToUtc(json['server_now']);
    if (last != null) _lastSuccessfulCheckAtUtc = last;
  }

  static DateTime? _parseIsoToUtc(dynamic v) {
    if (v is! String || v.isEmpty) return null;
    final d = DateTime.tryParse(v);
    return d?.toUtc();
  }

  /// Resets license state after sign-out so guards do not apply to the login gate.
  void clearForSignOut() {
    var changed = false;
    if (_status != LicenseStatus.trialActive) {
      _status = LicenseStatus.trialActive;
      changed = true;
    }
    if (_expiresAtUtc != null) {
      _expiresAtUtc = null;
      changed = true;
    }
    if (_lastSuccessfulCheckAtUtc != null) {
      _lastSuccessfulCheckAtUtc = null;
      changed = true;
    }
    if (_suspectedTimeTamper) {
      _suspectedTimeTamper = false;
      changed = true;
    }
    if (changed) notifyListeners();
  }
}
