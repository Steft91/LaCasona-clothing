/// Domain entity representing a payment transaction.
class PaymentEntity {
  final String id;
  final double amount;
  final String currency;
  final String status;
  final String clientSecret; // Requerido por Stripe para abrir el formulario

  const PaymentEntity({
    required this.id,
    required this.amount,
    required this.currency,
    required this.status,
    required this.clientSecret,
  });
}