import 'dart:convert';

import 'package:uuid/uuid.dart';

import '../../data/local/payment_repository.dart';

/// Shared local + sync payload shape for order payments (append-only server log).
abstract final class OrderPaymentMutations {
  static const _uuid = Uuid();

  static Map<String, Object?> appendPayload({
    required String orderInternalId,
    required int amountMinor,
    String method = 'cash',
    bool isAdjustment = false,
    DateTime? createdAt,
  }) {
    final at = (createdAt ?? DateTime.now()).toUtc();
    return {
      'order_internal_id': orderInternalId,
      'amount_minor': amountMinor,
      'method': method,
      'is_adjustment': isAdjustment,
      'created_at': at.toIso8601String(),
    };
  }

  static String appendPayloadJson({
    required String orderInternalId,
    required int amountMinor,
    String method = 'cash',
    bool isAdjustment = false,
    DateTime? createdAt,
  }) =>
      jsonEncode(
        appendPayload(
          orderInternalId: orderInternalId,
          amountMinor: amountMinor,
          method: method,
          isAdjustment: isAdjustment,
          createdAt: createdAt,
        ),
      );

  static Map<String, Object?> updatePayload({
    required String orderInternalId,
    required int amountMinor,
    required String method,
    required bool isAdjustment,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) {
    final at = (updatedAt ?? DateTime.now()).toUtc();
    return {
      'order_internal_id': orderInternalId,
      'amount_minor': amountMinor,
      'method': method,
      'is_adjustment': isAdjustment,
      'created_at': createdAt.toUtc().toIso8601String(),
      'updated_at': at.toIso8601String(),
    };
  }

  static String updatePayloadJson({
    required String orderInternalId,
    required int amountMinor,
    required String method,
    required bool isAdjustment,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) =>
      jsonEncode(
        updatePayload(
          orderInternalId: orderInternalId,
          amountMinor: amountMinor,
          method: method,
          isAdjustment: isAdjustment,
          createdAt: createdAt,
          updatedAt: updatedAt,
        ),
      );

  /// Persists one payment row locally; returns the payment [internalId].
  static Future<String> persistAppend({
    required PaymentRepository repo,
    required String shopId,
    required String orderInternalId,
    required int amountMinor,
    String? internalId,
    String method = 'cash',
    bool isAdjustment = false,
  }) async {
    final id = (internalId != null && internalId.isNotEmpty)
        ? internalId
        : _uuid.v4();
    await repo.addPayment(
      shopId: shopId,
      orderInternalId: orderInternalId,
      amountMinor: amountMinor,
      method: method,
      isAdjustment: isAdjustment,
      internalId: id,
    );
    return id;
  }

  static Future<void> persistUpdate({
    required PaymentRepository repo,
    required String internalId,
    required int amountMinor,
    String? method,
  }) =>
      repo.updatePayment(
        internalId: internalId,
        amountMinor: amountMinor,
        method: method,
      );
}
