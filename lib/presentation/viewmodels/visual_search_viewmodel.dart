import 'package:flutter/foundation.dart';

import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../../data/services/visual_search_service.dart';

class VisualSearchViewModel extends ChangeNotifier {
  VisualSearchViewModel(this._visualSearchService, this._productRepository);

  final VisualSearchService _visualSearchService;
  final ProductRepository _productRepository;

  List<ProductEntity> results = [];
  List<String> detectedCategories = [];
  bool isLoading = false;
  String? error;

  Future<void> searchFromCamera() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      detectedCategories = await _visualSearchService.pickAndDetectCategories();
      results = await _productRepository.getProductsByCategories(
        detectedCategories,
      );
      if (detectedCategories.isEmpty) {
        error = 'No detecté una prenda clara. Intenta con otra foto.';
      }
    } catch (exception) {
      error = exception.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
