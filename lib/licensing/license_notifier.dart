import 'package:flutter/foundation.dart';

/// Mirrors server `license_snapshot.status` (plan-06 / plan-04) until API exists.
enum LicenseStatus { trialActive, active, expired }

class LicenseNotifier extends ChangeNotifier {
  LicenseStatus _status = LicenseStatus.trialActive;

  LicenseStatus get status => _status;

  bool get isExpired => _status == LicenseStatus.expired;

  void setStatus(LicenseStatus value) {
    if (_status == value) return;
    _status = value;
    notifyListeners();
  }

  /// Applies `license_snapshot` from `POST /auth/login` or `GET /license/status`.
  void applyLicenseSnapshotMap(Map<String, dynamic> json) {
    final raw = json['status'];
    if (raw is! String) return;
    final next = switch (raw) {
      'trial_active' => LicenseStatus.trialActive,
      'active' => LicenseStatus.active,
      'expired' => LicenseStatus.expired,
      _ => null,
    };
    if (next == null) return;
    setStatus(next);
  }
}
