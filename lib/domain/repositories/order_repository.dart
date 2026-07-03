import '../entities/order_entity.dart';

/// Contract for order operations.
abstract class OrderRepository {
  /// Create a new order from cart contents.
  Future<String> createOrder(OrderEntity order);

  /// Get all orders for a user, most recent first.
  Future<List<OrderEntity>> getOrders(String userId);
}
