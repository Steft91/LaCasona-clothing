import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../../domain/entities/order_entity.dart';
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

  OrderEntity? _lastCompletedOrder;
  OrderEntity? get lastCompletedOrder => _lastCompletedOrder;

  Future<bool> processPayment({
    required double amount,
    required String currency,
    required String userId,
    required Future<OrderEntity?> Function() createOrder,
  }) async {
    _isLoading = true;
    _error = null;
    _lastCompletedOrder = null;
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
          style: ThemeMode.dark,
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      final order = await createOrder();
      if (order == null) {
        throw Exception('No se pudo crear la orden despues del pago.');
      }
      _lastCompletedOrder = order;

      await savePaymentRecordUseCase(
        userId: userId,
        payment: payment,
        orderId: order.id,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } on StripeException catch (exception) {
      _error = _stripeError(exception);
    } catch (e) {
      _error = 'Ocurrio un error al procesar el pago.';
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  String _stripeError(StripeException exception) {
    final localized = exception.error.localizedMessage;
    if (localized != null && localized.trim().isNotEmpty) {
      return localized;
    }
    return 'Pago cancelado o no completado.';
  }
}
