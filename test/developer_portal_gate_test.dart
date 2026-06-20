import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/auth/auth_session.dart';
import 'package:pride_v3/auth/developer_portal_gate.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('showDeveloperPortalInSettings', () {
    late SharedPreferences prefs;
    late AuthSession auth;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      auth = AuthSession();
    });

    test('regular user never sees portal from persisted flag alone', () {
      prefs.setBool(pridePersistedDeveloperFlagKey, true);
      prefs.setString(pridePersistedDeveloperIdentityKey, 'dev-shop|devuser');
      auth.signInFromApi(
        accessToken: 'token',
        userId: 'u1',
        username: 'tailor1',
        shopId: 'shop-a',
        isShopOwner: true,
      );

      expect(
        showDeveloperPortalInSettings(
          auth: auth,
          adminCheck: null,
          devSimulated: false,
          persistedDeveloperFlag: true,
          prefs: prefs,
        ),
        isFalse,
      );
    });

    test('developer sees portal when persisted identity matches session', () {
      prefs.setBool(pridePersistedDeveloperFlagKey, true);
      prefs.setString(
        pridePersistedDeveloperIdentityKey,
        developerSessionIdentityKey(shopId: 'dev-shop', username: 'devuser'),
      );
      auth.signInFromApi(
        accessToken: 'token',
        userId: 'u1',
        username: 'devuser',
        shopId: 'dev-shop',
        isShopOwner: true,
      );

      expect(
        showDeveloperPortalInSettings(
          auth: auth,
          adminCheck: null,
          devSimulated: false,
          persistedDeveloperFlag: true,
          prefs: prefs,
        ),
        isTrue,
      );
    });
  });
}
