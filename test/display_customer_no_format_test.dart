import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/core/formatting/display_customer_no_format.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

void main() {
  test('formatDisplayCustomerNo mirrors order display formatting', () {
    expect(formatDisplayCustomerNo('00000001'), '00001');
    expect(formatDisplayCustomerNo('00000042'), '00042');
    expect(formatDisplayCustomerNo('00099999'), '99999');
    expect(formatDisplayCustomerNo('000100000'), '100000');
  });

  test('displayCustomerNumberLabel uses localized prefix', () {
    final l10n = lookupAppLocalizations(const Locale('en'));
    expect(
      displayCustomerNumberLabel(l10n, '00000042'),
      l10n.customersIdPrefix('00042'),
    );
  });
}
