import '../entities/cart_item_entity.dart';

/// Contract for shopping cart operations.
abstract class CartRepository {
  /// Get all cart items for a user.
  Future<List<CartItemEntity>> getCartItems(String userId);

  /// Add or update an item in the cart.
  Future<void> addToCart(String userId, CartItemEntity item);

  /// Remove an item from the cart.
  Future<void> removeFromCart(String userId, String productoId);

  /// Update item quantity.
  Future<void> updateQuantity(String userId, String productoId, int cantidad);

  /// Clear all items from the cart.
  Future<void> clearCart(String userId);
}
