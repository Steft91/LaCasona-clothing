import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../models/product_model.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  FavoritesRepositoryImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _favoriteDoc(String userId) =>
      _firestore.collection(AppConstants.favoritesCollection).doc(userId);

  CollectionReference<Map<String, dynamic>> get _products =>
      _firestore.collection(AppConstants.productsCollection);

  @override
  Future<List<ProductEntity>> getFavorites(String userId) async {
    final doc = await _favoriteDoc(userId).get();
    final ids = List<String>.from(doc.data()?['productos'] ?? []);
    final products = <ProductEntity>[];

    for (final id in ids) {
      final productDoc = await _products.doc(id).get();
      if (productDoc.exists) {
        products.add(ProductModel.fromFirestore(productDoc));
      }
    }

    return products;
  }

  @override
  Future<void> addFavorite(String userId, String productoId) {
    return _favoriteDoc(userId).set({
      'usuarioId': userId,
      'productos': FieldValue.arrayUnion([productoId]),
    }, SetOptions(merge: true));
  }

  @override
  Future<void> removeFavorite(String userId, String productoId) {
    return _favoriteDoc(userId).set({
      'usuarioId': userId,
      'productos': FieldValue.arrayRemove([productoId]),
    }, SetOptions(merge: true));
  }

  @override
  Future<bool> isFavorite(String userId, String productoId) async {
    final doc = await _favoriteDoc(userId).get();
    final ids = List<String>.from(doc.data()?['productos'] ?? []);
    return ids.contains(productoId);
  }
}
