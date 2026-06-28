import '../entities/cart_item_entity.dart';
import '../repositories/cart_repository.dart';

class GetCartItemsUseCase {
  GetCartItemsUseCase(this._repository);

  final CartRepository _repository;

  Future<List<CartItemEntity>> call(String userId) {
    return _repository.getCartItems(userId);
  }
}

class AddToCartUseCase {
  AddToCartUseCase(this._repository);

  final CartRepository _repository;

  Future<void> call(String userId, CartItemEntity item) {
    return _repository.addToCart(userId, item);
  }
}

class ClearCartUseCase {
  ClearCartUseCase(this._repository);

  final CartRepository _repository;

  Future<void> call(String userId) => _repository.clearCart(userId);
}
