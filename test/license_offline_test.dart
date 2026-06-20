import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/licensing/license_notifier.dart';

void main() {
  group('LicenseNotifier.isEditingBlocked', () {
    test('developer exempt is never blocked', () {
      final n = LicenseNotifier()..setStatus(LicenseStatus.expired);
      expect(
        n.isEditingBlocked(online: false, developerExempt: true),
        isFalse,
      );
    });

    test('paid active offline honors expires_at beyond grace window', () {
      final n = LicenseNotifier()
        ..setStatus(LicenseStatus.active)
        ..restoreTimingFromIso(
          expiresAtIso: DateTime.utc(2030, 1, 1).toIso8601String(),
          lastSuccessfulCheckAtIso:
              DateTime.utc(2020, 1, 1).toIso8601String(),
        );

      expect(n.isEditingBlocked(online: false), isFalse);
    });

    test('paid active offline blocks after cached expires_at', () {
      final n = LicenseNotifier()
        ..setStatus(LicenseStatus.active)
        ..restoreTimingFromIso(
          expiresAtIso: DateTime.utc(2020, 1, 1).toIso8601String(),
          lastSuccessfulCheckAtIso:
              DateTime.utc(2020, 1, 1).toIso8601String(),
        );

      expect(n.isEditingBlocked(online: false), isTrue);
    });

    test('trial offline within expires_at is allowed', () {
      final n = LicenseNotifier()
        ..setStatus(LicenseStatus.trialActive)
        ..restoreTimingFromIso(
          expiresAtIso: DateTime.utc(2030, 6, 1).toIso8601String(),
          lastSuccessfulCheckAtIso:
              DateTime.utc(2020, 1, 1).toIso8601String(),
        );

      expect(n.isEditingBlocked(online: false), isFalse);
    });

    test('offline grace applies when expires_at missing', () {
      final recent = DateTime.now().toUtc().subtract(const Duration(days: 1));
      final n = LicenseNotifier()
        ..setStatus(LicenseStatus.trialActive)
        ..restoreTimingFromIso(lastSuccessfulCheckAtIso: recent.toIso8601String());

      expect(n.isEditingBlocked(online: false), isFalse);

      final stale = DateTime.now().toUtc().subtract(const Duration(days: 5));
      n.restoreTimingFromIso(lastSuccessfulCheckAtIso: stale.toIso8601String());
      expect(n.isEditingBlocked(online: false), isTrue);
    });

    test('expired status blocks even when online grace would pass', () {
      final n = LicenseNotifier()
        ..setStatus(LicenseStatus.expired)
        ..restoreTimingFromIso(
          expiresAtIso: DateTime.utc(2030, 1, 1).toIso8601String(),
        );

      expect(n.isEditingBlocked(online: false), isTrue);
      expect(n.isEditingBlocked(online: true), isTrue);
    });

    test('online never blocks on client', () {
      final n = LicenseNotifier()
        ..setStatus(LicenseStatus.trialActive)
        ..restoreTimingFromIso(
          lastSuccessfulCheckAtIso:
              DateTime.utc(2020, 1, 1).toIso8601String(),
        );

      expect(n.isEditingBlocked(online: true), isFalse);
    });
  });
}
