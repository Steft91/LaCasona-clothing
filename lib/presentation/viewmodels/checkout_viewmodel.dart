import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../../domain/use_cases/payment_use_cases.dart';

class CheckoutViewModel extends ChangeNotifier {
  CheckoutViewModel({
    required this.createPaymentIntentUseCase,
    required this.savePaymentRecordUseCase,
  });

  final CreatePaymentIntentUseCase createPaymentIntentUseCase;
  final SavePaymentRecordUseCase savePaymentRecordUseCase;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<bool> processPayment({
    required double amount,
    required String currency,
    required String userId,
    required Future<String?> Function() createOrder,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final payment = await createPaymentIntentUseCase(
        amount: amount,
        currency: currency,
      );

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: payment.clientSecret,
          merchantDisplayName: 'La Casona',
          style: ThemeMode.light,
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      final orderId = await createOrder();
      if (orderId == null) {
        throw Exception('No se pudo crear la orden despues del pago.');
      }

      await savePaymentRecordUseCase(
        userId: userId,
        payment: payment,
        orderId: orderId,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } on StripeException catch (e) {
      _error = 'Pago cancelado o fallido: ${e.error.localizedMessage}';
    } catch (e) {
      _error = 'Ocurrio un error inesperado al procesar el pago.';
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }
}
