import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../models/order_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  OrderRepositoryImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _orders =>
      _firestore.collection(AppConstants.ordersCollection);

  CollectionReference<Map<String, dynamic>> get _products =>
      _firestore.collection(AppConstants.productsCollection);

  @override
  Future<String> createOrder(OrderEntity order) async {
    final docRef = _orders.doc();
    final model = OrderModel(
      id: order.id,
      usuarioId: order.usuarioId,
      items: order.items,
      total: order.total,
      estado: order.estado,
      fechaCreacion: order.fechaCreacion,
      direccionEntrega: order.direccionEntrega,
    );

    await _firestore.runTransaction((transaction) async {
      final stockByProductId = <String, int>{};

      for (final item in order.items) {
        final productRef = _products.doc(item.productoId);
        final productSnapshot = await transaction.get(productRef);
        final productData = productSnapshot.data();
        final stock = _stockFromData(productData);

        if (!productSnapshot.exists || productData == null) {
          throw Exception('${item.nombre} ya no está disponible.');
        }
        if (stock < item.cantidad) {
          throw Exception(
            'Stock insuficiente para ${item.nombre}. Solo quedan $stock unidad(es).',
          );
        }

        stockByProductId[item.productoId] = stock;
      }

      for (final item in order.items) {
        final productRef = _products.doc(item.productoId);
        final currentStock = stockByProductId[item.productoId]!;
        transaction.update(productRef, {'stock': currentStock - item.cantidad});
      }

      transaction.set(docRef, model.toFirestore());
    });

    return docRef.id;
  }

  @override
  Future<List<OrderEntity>> getOrders(String userId) async {
    final snapshot = await _orders.where('usuarioId', isEqualTo: userId).get();
    final orders = snapshot.docs.map(OrderModel.fromFirestore).toList()
      ..sort((a, b) => b.fechaCreacion.compareTo(a.fechaCreacion));
    return orders;
  }

  int _stockFromData(Map<String, dynamic>? data) {
    if (data == null) return 0;
    final stock = data['stock'];
    if (stock is int) return stock;
    if (stock is num) return stock.toInt();
    return 0;
  }
}
