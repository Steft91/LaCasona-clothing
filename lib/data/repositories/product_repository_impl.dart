import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _products =>
      _firestore.collection(AppConstants.productsCollection);

  @override
  Future<List<ProductEntity>> getFeaturedProducts() async {
    final snapshot = await _products
        .where('destacado', isEqualTo: true)
        .limit(24)
        .get();
    return snapshot.docs.map(ProductModel.fromFirestore).toList();
  }

  @override
  Future<List<ProductEntity>> getAllProducts() async {
    final snapshot = await _products.orderBy('nombre').get();
    return snapshot.docs.map(ProductModel.fromFirestore).toList();
  }

  @override
  Future<List<ProductEntity>> getProductsByCategory(String categoria) async {
    final snapshot = await _products
        .where('categoria', isEqualTo: categoria)
        .get();
    return snapshot.docs.map(ProductModel.fromFirestore).toList();
  }

  @override
  Future<List<ProductEntity>> getProductsByCategories(
    List<String> categorias,
  ) async {
    if (categorias.isEmpty) return getAllProducts();
    final normalized = categorias.take(10).toList();
    final snapshot = await _products
        .where('categoria', whereIn: normalized)
        .get();
    return snapshot.docs.map(ProductModel.fromFirestore).toList();
  }

  @override
  Future<List<ProductEntity>> searchProducts(String query) async {
    final products = await getAllProducts();
    final normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) return products;

    return products
        .where(
          (product) =>
              product.nombre.toLowerCase().contains(normalizedQuery) ||
              product.descripcion.toLowerCase().contains(normalizedQuery) ||
              product.categoria.toLowerCase().contains(normalizedQuery),
        )
        .toList();
  }

  @override
  Future<ProductEntity> getProductById(String id) async {
    final doc = await _products.doc(id).get();
    if (!doc.exists) {
      throw StateError('Producto no encontrado');
    }
    return ProductModel.fromFirestore(doc);
  }
}
