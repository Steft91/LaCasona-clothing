import '../entities/payment_entity.dart';
import '../repositories/payment_repository.dart';

class CreatePaymentIntentUseCase {
  CreatePaymentIntentUseCase(this._repository);

  final PaymentRepository _repository;

  Future<PaymentEntity> call({required double amount, required String currency}) {
    return _repository.createPaymentIntent(amount: amount, currency: currency);
  }
}

class SavePaymentRecordUseCase {
  SavePaymentRecordUseCase(this._repository);

  final PaymentRepository _repository;

  Future<void> call({
    required String userId,
    required PaymentEntity payment,
    required String orderId,
  }) {
    return _repository.savePaymentRecord(
      userId: userId,
      payment: payment,
      orderId: orderId,
    );
  }
}