import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/security/owner_password_verify.dart';

void main() {
  test('accepts default dev password', () {
    expect(verifyOwnerPasswordForLocalActions('pride-dev-owner'), isTrue);
  });

  test('rejects wrong password', () {
    expect(verifyOwnerPasswordForLocalActions('wrong'), isFalse);
    expect(verifyOwnerPasswordForLocalActions(''), isFalse);
    expect(verifyOwnerPasswordForLocalActions('   '), isFalse);
  });
}
