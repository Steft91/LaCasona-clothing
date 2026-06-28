import '../entities/product_entity.dart';

/// Contract for user favorites operations.
abstract class FavoritesRepository {
  /// Get all favorite products for a user.
  Future<List<ProductEntity>> getFavorites(String userId);

  /// Add a product to favorites.
  Future<void> addFavorite(String userId, String productoId);

  /// Remove a product from favorites.
  Future<void> removeFavorite(String userId, String productoId);

  /// Check if a product is in the user's favorites.
  Future<bool> isFavorite(String userId, String productoId);
}
