import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/entities/payment_entity.dart';
import '../../domain/repositories/payment_repository.dart';
import '../models/payment_model.dart';
import '../services/stripe_service.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  PaymentRepositoryImpl({
    required this.stripeService,
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final StripeService stripeService;
  final FirebaseFirestore _firestore;

  @override
  Future<PaymentEntity> createPaymentIntent({
    required double amount,
    required String currency,
  }) async {
    // 1. Llamamos al servicio de Stripe
    final jsonResponse = await stripeService.createPaymentIntent(
      amount: amount,
      currency: currency,
    );
    
    // 2. Mapeamos el JSON al modelo/entidad
    return PaymentModel.fromStripeJson(jsonResponse);
  }

  @override
  Future<void> savePaymentRecord({
    required String userId,
    required PaymentEntity payment,
    required String orderId,
  }) async {
    final paymentModel = PaymentModel.fromEntity(payment);
    
    // Guardamos en la colección 'pagos' de Firestore
    final docRef = _firestore
        .collection(AppConstants.paymentsCollection)
        .doc(payment.id);

    await docRef.set({
      ...paymentModel.toFirestore(),
      'userId': userId,
      'orderId': orderId,
    });
  }
}