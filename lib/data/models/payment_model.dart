import '../../domain/entities/payment_entity.dart';

/// Modelo de datos que maneja la conversión entre la API de Stripe, Firestore y nuestra Entidad.
class PaymentModel extends PaymentEntity {
  const PaymentModel({
    required super.id,
    required super.amount,
    required super.currency,
    required super.status,
    required super.clientSecret,
  });

  /// Crea un modelo a partir de la respuesta JSON de Stripe
  factory PaymentModel.fromStripeJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] ?? '',
      // Stripe maneja los montos en centavos, así que lo dividimos por 100
      amount: (json['amount'] ?? 0).toDouble() / 100.0,
      currency: json['currency'] ?? 'usd',
      status: json['status'] ?? '',
      clientSecret: json['client_secret'] ?? '',
    );
  }

  /// Crea un modelo a partir de una Entidad genérica (útil para guardar en BD)
  factory PaymentModel.fromEntity(PaymentEntity entity) {
    return PaymentModel(
      id: entity.id,
      amount: entity.amount,
      currency: entity.currency,
      status: entity.status,
      clientSecret: entity.clientSecret,
    );
  }

  /// Convierte los datos para guardarlos en Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'amount': amount,
      'currency': currency,
      'status': status,
      'fechaPago': DateTime.now().toIso8601String(),
    };
  }
}