import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/app_constants.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
class StripeService {
  static const String _baseUrl = 'https://api.stripe.com/v1';

  /// Llama a la API de Stripe para crear un "Intento de Pago"
  Future<Map<String, dynamic>> createPaymentIntent({
    required double amount,
    required String currency,
  }) async {
    try {
      // Stripe espera el monto en la unidad más pequeña (ej. centavos)
      final int amountInCents = (amount * 100).toInt();

    final secretKey = dotenv.env['STRIPE_SECRET_KEY'] ?? '';

      final response = await http.post(
        Uri.parse('$_baseUrl/payment_intents'),
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'amount': amountInCents.toString(),
          'currency': currency.toLowerCase(),
          'payment_method_types[]': 'card',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error al crear PaymentIntent: ${response.body}');
      }
    } catch (e) {
      throw Exception('Stripe Service Error: $e');
    }
  }
}