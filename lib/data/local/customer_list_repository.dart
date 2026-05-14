import 'customer_summary.dart';
import 'dev_shop_constants.dart';

abstract class CustomerListRepository {
  Stream<List<CustomerSummary>> watchCustomers([String shopId = kDevShopId]);

  Future<void> seedIfEmpty();

  Future<String> createCustomer({
    required String shopId,
    required String name,
    String? phone,
    String? address,
    String? notes,
  });

  Future<void> updateCustomer({
    required String internalId,
    required String name,
    String? phone,
    String? address,
    String? notes,
  });

  /// Soft-delete (plan-13); hidden from [watchCustomers] results.
  Future<void> softDeleteCustomer(String internalId);

  /// Apply one row from `GET /sync/pull` (`plan-03`). [data] is the server payload map.
  Future<void> mergeRemoteCustomer({
    required String shopId,
    required String internalId,
    required String operation,
    Object? data,
  });
}

