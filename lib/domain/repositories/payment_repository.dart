import '../entities/payment_entity.dart';

/// Contract for payment processing operations.
abstract class PaymentRepository {
  /// Creates a PaymentIntent to process a transaction.
  Future<PaymentEntity> createPaymentIntent({
    required double amount,
    required String currency,
  });

  /// Saves the successful payment record to the database.
  Future<void> savePaymentRecord({
    required String userId,
    required PaymentEntity payment,
    required String orderId,
  });
}