import '../entities/product_entity.dart';
import '../repositories/favorites_repository.dart';

class GetFavoritesUseCase {
  GetFavoritesUseCase(this._repository);

  final FavoritesRepository _repository;

  Future<List<ProductEntity>> call(String userId) {
    return _repository.getFavorites(userId);
  }
}

class ToggleFavoriteUseCase {
  ToggleFavoriteUseCase(this._repository);

  final FavoritesRepository _repository;

  Future<void> call({
    required String userId,
    required String productId,
    required bool isFavorite,
  }) {
    if (isFavorite) return _repository.removeFavorite(userId, productId);
    return _repository.addFavorite(userId, productId);
  }
}
