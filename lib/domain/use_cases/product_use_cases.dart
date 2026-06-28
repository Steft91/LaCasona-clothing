import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetFeaturedProductsUseCase {
  GetFeaturedProductsUseCase(this._repository);

  final ProductRepository _repository;

  Future<List<ProductEntity>> call() => _repository.getFeaturedProducts();
}

class GetCatalogProductsUseCase {
  GetCatalogProductsUseCase(this._repository);

  final ProductRepository _repository;

  Future<List<ProductEntity>> call() => _repository.getAllProducts();
}

class SearchProductsUseCase {
  SearchProductsUseCase(this._repository);

  final ProductRepository _repository;

  Future<List<ProductEntity>> call(String query) {
    return _repository.searchProducts(query);
  }
}
