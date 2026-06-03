import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/auth/offline_credential_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('verifyOwnerPasswordForShop matches cached owner login', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await OfflineCredentialStorage.upsertFromLogin(
      prefs,
      shopId: 'dev',
      username: 'owner',
      userId: 'u1',
      isShopOwner: true,
      password: 'changeme',
      accessToken: 'token',
      licenseStatusApi: 'trial_active',
    );
    expect(
      OfflineCredentialStorage.verifyOwnerPasswordForShop(
        prefs: prefs,
        shopId: 'dev',
        password: 'changeme',
      ),
      isTrue,
    );
    expect(
      OfflineCredentialStorage.verifyOwnerPasswordForShop(
        prefs: prefs,
        shopId: 'dev',
        password: 'wrong',
      ),
      isFalse,
    );
    expect(
      OfflineCredentialStorage.ownerUsernameForShop(prefs, 'dev'),
      'owner',
    );
  });
}
