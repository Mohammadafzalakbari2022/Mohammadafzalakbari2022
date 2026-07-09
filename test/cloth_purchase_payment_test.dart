import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/data/local/cloth_stock_models.dart';
import 'package:pride_v3/data/local/memory_cloth_stock_repository.dart';

void main() {
  group('Cloth purchase payments', () {
    late MemoryClothStockRepository repo;
    const shopId = 'shop-1';

    setUp(() async {
      repo = MemoryClothStockRepository();
      await repo.upsertSupplier(
        shopId: shopId,
        internalId: 'sup-1',
        name: 'Vendor',
      );
      await repo.upsertSku(
        shopId: shopId,
        internalId: 'sku-1',
        skuCode: 'X',
        name: 'Silk',
      );
    });

    test('append-only payments reduce balance', () async {
      await repo.upsertPurchase(
        shopId: shopId,
        input: ClothPurchaseUpsertInput(
          internalId: 'pur-1',
          supplierInternalId: 'sup-1',
          purchaseDate: DateTime(2026, 3, 1),
          lines: const [
            ClothPurchaseLineInput(
              skuInternalId: 'sku-1',
              qtyMilli: 2000,
              unitCostAmountMinor: 500,
            ),
          ],
        ),
      );
      final purchases = await repo.watchPurchases(shopId).first;
      expect(purchases.single.totalAmountMinor, 1000);

      await repo.appendPurchasePayment(
        shopId: shopId,
        purchaseInternalId: 'pur-1',
        amountMinor: 400,
        paidAt: DateTime(2026, 3, 2),
        internalId: 'pay-1',
      );
      await repo.appendPurchasePayment(
        shopId: shopId,
        purchaseInternalId: 'pur-1',
        amountMinor: 200,
        paidAt: DateTime(2026, 3, 3),
        internalId: 'pay-2',
      );

      final payments = await repo.watchPurchasePayments(shopId).first;
      expect(
        purchaseBalanceMinor(purchases.single, payments),
        400,
      );
      expect(totalPaidForPurchase('pur-1', payments), 600);
    });
  });
}
