import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  CartRepositoryImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _cart =>
      _firestore.collection(AppConstants.cartCollection);

  CollectionReference<Map<String, dynamic>> get _products =>
      _firestore.collection(AppConstants.productsCollection);

  @override
  Future<List<CartItemEntity>> getCartItems(String userId) async {
    final snapshot = await _cart.doc(userId).collection('items').get();
    final items = <CartItemEntity>[];

    for (final doc in snapshot.docs) {
      final data = doc.data();
      final productDoc = await _products.doc(doc.id).get();
      final product = productDoc.data() ?? {};

      items.add(
        CartItemEntity(
          productoId: doc.id,
          nombre: product['nombre'] ?? 'Producto',
          imagenUrl: product['imagenUrl'] ?? '',
          precio: (product['precio'] ?? 0).toDouble(),
          cantidad: data['cantidad'] ?? 1,
          talla: data['talla'] ?? '',
          color: data['color'] ?? '',
        ),
      );
    }

    return items;
  }

  @override
  Future<void> addToCart(String userId, CartItemEntity item) async {
    final ref = _cart.doc(userId).collection('items').doc(item.productoId);
    final current = await ref.get();
    final currentQuantity = current.data()?['cantidad'] ?? 0;

    await ref.set({
      'cantidad': currentQuantity + item.cantidad,
      'talla': item.talla,
      'color': item.color,
    });
  }

  @override
  Future<void> removeFromCart(String userId, String productoId) {
    return _cart.doc(userId).collection('items').doc(productoId).delete();
  }

  @override
  Future<void> updateQuantity(String userId, String productoId, int cantidad) {
    if (cantidad <= 0) return removeFromCart(userId, productoId);
    return _cart.doc(userId).collection('items').doc(productoId).update({
      'cantidad': cantidad,
    });
  }

  @override
  Future<void> clearCart(String userId) async {
    final snapshot = await _cart.doc(userId).collection('items').get();
    final batch = _firestore.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
