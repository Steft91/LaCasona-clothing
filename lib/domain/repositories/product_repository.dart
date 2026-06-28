import '../entities/product_entity.dart';

/// Contract for product catalogue operations.
abstract class ProductRepository {
  /// Get featured products (destacado == true).
  Future<List<ProductEntity>> getFeaturedProducts();

  /// Get all products.
  Future<List<ProductEntity>> getAllProducts();

  /// Get products filtered by [categoria].
  Future<List<ProductEntity>> getProductsByCategory(String categoria);

  /// Get products filtered by available visual-search categories.
  Future<List<ProductEntity>> getProductsByCategories(List<String> categorias);

  /// Search products by name (case-insensitive partial match).
  Future<List<ProductEntity>> searchProducts(String query);

  /// Get a single product by its Firestore document [id].
  Future<ProductEntity> getProductById(String id);
}
