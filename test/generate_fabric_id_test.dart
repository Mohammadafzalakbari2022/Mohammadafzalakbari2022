import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/core/fabric/generate_fabric_id.dart';

void main() {
  test('generateFabricId returns six digits', () {
    final id = generateFabricId(Random(42));
    expect(id, hasLength(6));
    expect(int.tryParse(id), isNotNull);
    expect(int.parse(id), greaterThanOrEqualTo(0));
    expect(int.parse(id), lessThan(1000000));
  });

  test('generateFabricId pads leading zeros', () {
    final id = generateFabricId(_ZeroRandom());
    expect(id, '000000');
  });
}

class _ZeroRandom implements Random {
  @override
  int nextInt(int max) => 0;

  @override
  bool nextBool() => false;

  @override
  double nextDouble() => 0;
}
