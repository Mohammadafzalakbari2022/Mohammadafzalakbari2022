import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/shell/shell_primary_tab.dart';

void main() {
  test('shellPathIsPrimaryTab matches tab paths with query params', () {
    expect(shellPathIsPrimaryTab('/app/orders'), isTrue);
    expect(shellPathIsPrimaryTab('/app/orders?orderId=abc'), isTrue);
    expect(shellPathIsPrimaryTab('/app/customers?customerId=x'), isTrue);
    expect(shellPathIsPrimaryTab('/app/orders/order-1'), isFalse);
    expect(shellPathIsPrimaryTab('/app/settings/account'), isFalse);
  });
}
