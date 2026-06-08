import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pride_v3/core/widgets/shop_banner_file.dart';

void main() {
  group('shopBannerUploadConfigured', () {
    test('returns false for null or empty path', () {
      expect(shopBannerUploadConfigured(null), isFalse);
      expect(shopBannerUploadConfigured(''), isFalse);
      expect(shopBannerUploadConfigured('   '), isFalse);
    });

    test('returns false on web even with path', () {
      if (kIsWeb) {
        expect(shopBannerUploadConfigured('shop/banner.jpg'), isFalse);
      }
    });

    test('returns true on IO when path is set', () {
      if (!kIsWeb) {
        expect(shopBannerUploadConfigured('shop/banner.jpg'), isTrue);
      }
    });
  });

  group('resolveShopBannerFile', () {
    test('returns null for missing path', () async {
      expect(await resolveShopBannerFile(null), isNull);
      expect(await resolveShopBannerFile(''), isNull);
    });

    test('returns null for non-existent path', () async {
      if (kIsWeb) {
        expect(await resolveShopBannerFile('missing/banner.jpg'), isNull);
        return;
      }
      expect(
        await resolveShopBannerFile('nonexistent/banner_test_${DateTime.now().millisecondsSinceEpoch}.jpg'),
        isNull,
      );
    });
  });
}
