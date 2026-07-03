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

  @override
  Future<String> createOrder(OrderEntity order) async {
    final model = OrderModel(
      id: order.id,
      usuarioId: order.usuarioId,
      items: order.items,
      total: order.total,
      estado: order.estado,
      fechaCreacion: order.fechaCreacion,
      direccionEntrega: order.direccionEntrega,
    );
    final docRef = await _orders.add(model.toFirestore());
    return docRef.id;
  }

  @override
  Future<List<OrderEntity>> getOrders(String userId) async {
    final snapshot = await _orders.where('usuarioId', isEqualTo: userId).get();
    final orders = snapshot.docs.map(OrderModel.fromFirestore).toList()
      ..sort((a, b) => b.fechaCreacion.compareTo(a.fechaCreacion));
    return orders;
  }
}
