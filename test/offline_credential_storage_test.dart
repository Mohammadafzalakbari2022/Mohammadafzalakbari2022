import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/auth/offline_credential_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('sha256PasswordHex matches server digest', () {
    final digest = sha256.convert('changeme'.codeUnits).toString();
    expect(OfflineCredentialStorage.sha256PasswordHex('changeme'), digest);
  });

  test('verify accepts cached credential after upsert', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await OfflineCredentialStorage.upsertFromLogin(
      prefs,
      shopId: 'shop-a',
      username: 'owner',
      userId: 'user-1',
      isShopOwner: true,
      password: 'secret',
      accessToken: 'jwt-token',
      licenseStatusApi: 'trial_active',
    );

    final ok = OfflineCredentialStorage.verify(
      prefs: prefs,
      username: 'owner',
      password: 'secret',
      shopId: 'shop-a',
    );
    expect(ok, isA<OfflineVerifyOk>());
    final cred = ok as OfflineVerifyOk;
    expect(cred.shopId, 'shop-a');
    expect(cred.accessToken, 'jwt-token');

    final bad = OfflineCredentialStorage.verify(
      prefs: prefs,
      username: 'owner',
      password: 'wrong',
      shopId: 'shop-a',
    );
    expect(bad, isA<OfflineVerifyWrongPassword>());
  });
}
