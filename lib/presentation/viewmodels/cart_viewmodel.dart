import 'package:flutter/foundation.dart';

import '../../domain/entities/cart_item_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/cart_repository.dart';

class CartViewModel extends ChangeNotifier {
  CartViewModel(this._cartRepository);

  final CartRepository _cartRepository;

  List<CartItemEntity> items = [];
  bool isLoading = false;
  String? error;

  double get total => items.fold(0, (sum, item) => sum + item.subtotal);

  Future<void> loadCart(String userId) async {
    await _guard(() async {
      items = await _cartRepository.getCartItems(userId);
    });
  }

  Future<void> addProduct({
    required String userId,
    required ProductEntity product,
    required String talla,
    required String color,
  }) async {
    await _guard(() async {
      await _cartRepository.addToCart(
        userId,
        CartItemEntity(
          productoId: product.id,
          nombre: product.nombre,
          imagenUrl: product.imagenUrl,
          precio: product.precio,
          cantidad: 1,
          talla: talla,
          color: color,
        ),
      );
      items = await _cartRepository.getCartItems(userId);
    });
  }

  Future<void> updateQuantity(String userId, String productId, int quantity) {
    return _guard(() async {
      await _cartRepository.updateQuantity(userId, productId, quantity);
      items = await _cartRepository.getCartItems(userId);
    });
  }

  Future<void> remove(String userId, String productId) {
    return _guard(() async {
      await _cartRepository.removeFromCart(userId, productId);
      items = await _cartRepository.getCartItems(userId);
    });
  }

  Future<void> clear(String userId) {
    return _guard(() async {
      await _cartRepository.clearCart(userId);
      items = [];
    });
  }

  Future<void> _guard(Future<void> Function() action) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      await action();
    } catch (exception) {
      error = exception.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
