import 'package:flutter/foundation.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';

class ProductViewModel extends ChangeNotifier {
  ProductViewModel(this._productRepository);

  final ProductRepository _productRepository;

  List<ProductEntity> featured = [];
  List<ProductEntity> products = [];
  String selectedCategory = 'Todos';
  String searchQuery = '';
  bool isLoading = false;
  String? error;

  List<String> get categories => ['Todos', ...AppConstants.categories];

  Future<void> loadHome() async {
    await _guard(() async {
      featured = await _productRepository.getFeaturedProducts();
    });
  }

  Future<void> loadCatalog() async {
    await _guard(() async {
      products = await _productRepository.getAllProducts();
    });
  }

  Future<void> filterByCategory(String category) async {
    selectedCategory = category;
    await _guard(() async {
      products = category == 'Todos'
          ? await _productRepository.getAllProducts()
          : await _productRepository.getProductsByCategory(category);
      if (searchQuery.isNotEmpty) {
        products = _applyLocalSearch(products, searchQuery);
      }
    });
  }

  Future<void> search(String query) async {
    searchQuery = query;
    await _guard(() async {
      final base = selectedCategory == 'Todos'
          ? await _productRepository.searchProducts(query)
          : _applyLocalSearch(
              await _productRepository.getProductsByCategory(selectedCategory),
              query,
            );
      products = base;
    });
  }

  Future<ProductEntity> getProduct(String id) {
    return _productRepository.getProductById(id);
  }

  List<ProductEntity> _applyLocalSearch(
    List<ProductEntity> source,
    String query,
  ) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return source;
    return source
        .where((product) => product.nombre.toLowerCase().contains(normalized))
        .toList();
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
