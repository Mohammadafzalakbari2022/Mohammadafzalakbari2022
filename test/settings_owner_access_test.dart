import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/auth/admin_me_provider.dart';
import 'package:pride_v3/auth/auth_session.dart';
import 'package:pride_v3/features/settings/settings_owner_access.dart';

void main() {
  group('settingsEffectiveShopOwner', () {
    test('shop owner with API session', () {
      final auth = AuthSession()
        ..signInFromApi(
          accessToken: 't',
          userId: 'u',
          username: 'owner',
          shopId: 's',
          isShopOwner: true,
        );
      expect(
        settingsEffectiveShopOwner(
          auth: auth,
          devOwnerSimulated: false,
          devDeveloperSimulated: false,
        ),
        isTrue,
      );
    });

    test('team user without developer flags is locked', () {
      final auth = AuthSession()
        ..signInFromApi(
          accessToken: 't',
          userId: 'u',
          username: 'staff',
          shopId: 's',
          isShopOwner: false,
        );
      expect(
        settingsEffectiveShopOwner(
          auth: auth,
          devOwnerSimulated: false,
          devDeveloperSimulated: false,
        ),
        isFalse,
      );
    });

    test('server developer is unlocked even when not shop owner', () {
      final auth = AuthSession()
        ..signInFromApi(
          accessToken: 't',
          userId: 'u',
          username: 'devop',
          shopId: 's',
          isShopOwner: false,
        );
      expect(
        settingsEffectiveShopOwner(
          auth: auth,
          devOwnerSimulated: false,
          devDeveloperSimulated: false,
          adminCheck: const AdminMeCheckResult.ok(isDeveloper: true),
        ),
        isTrue,
      );
    });

    test('mock session uses dev owner simulator', () {
      final auth = AuthSession()..restoreMockSession(username: 'local');
      expect(
        settingsEffectiveShopOwner(
          auth: auth,
          devOwnerSimulated: true,
          devDeveloperSimulated: false,
        ),
        isTrue,
      );
      expect(
        settingsEffectiveShopOwner(
          auth: auth,
          devOwnerSimulated: false,
          devDeveloperSimulated: false,
        ),
        isFalse,
      );
    });
  });
}
