import 'cloud_functions_service.dart';

class StripeService {
  StripeService({CloudFunctionsService? functionsService})
    : _functionsService = functionsService ?? CloudFunctionsService();

  final CloudFunctionsService _functionsService;

  /// Llama a la API de Stripe para crear un "Intento de Pago"
  Future<Map<String, dynamic>> createPaymentIntent({
    required double amount,
    required String currency,
  }) async {
    try {
      return await _functionsService.createPaymentIntent(
        amount: amount,
        currency: currency,
      );
    } catch (e) {
      throw Exception('Stripe Service Error: $e');
    }
  }
}
