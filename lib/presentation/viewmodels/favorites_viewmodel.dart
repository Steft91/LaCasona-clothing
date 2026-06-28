import 'package:flutter/foundation.dart';

import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/favorites_repository.dart';

class FavoritesViewModel extends ChangeNotifier {
  FavoritesViewModel(this._favoritesRepository);

  final FavoritesRepository _favoritesRepository;

  List<ProductEntity> favorites = [];
  final Set<String> favoriteIds = {};
  bool isLoading = false;
  String? error;

  Future<void> loadFavorites(String userId) async {
    await _guard(() async {
      favorites = await _favoritesRepository.getFavorites(userId);
      favoriteIds
        ..clear()
        ..addAll(favorites.map((product) => product.id));
    });
  }

  Future<void> toggle(String userId, ProductEntity product) async {
    await _guard(() async {
      if (favoriteIds.contains(product.id)) {
        await _favoritesRepository.removeFavorite(userId, product.id);
        favoriteIds.remove(product.id);
        favorites.removeWhere((item) => item.id == product.id);
      } else {
        await _favoritesRepository.addFavorite(userId, product.id);
        favoriteIds.add(product.id);
        favorites.add(product);
      }
    });
  }

  Future<bool> isFavorite(String userId, String productId) async {
    if (favoriteIds.contains(productId)) return true;
    return _favoritesRepository.isFavorite(userId, productId);
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
