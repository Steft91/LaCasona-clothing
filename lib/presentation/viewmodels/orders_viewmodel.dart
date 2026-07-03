import 'package:flutter/foundation.dart';

import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../domain/repositories/order_repository.dart';

class OrdersViewModel extends ChangeNotifier {
  OrdersViewModel(this._orderRepository, this._cartRepository);

  final OrderRepository _orderRepository;
  final CartRepository _cartRepository;

  List<OrderEntity> orders = [];
  bool isLoading = false;
  String? error;

  Future<void> loadOrders(String userId) async {
    await _guard(() async {
      orders = await _orderRepository.getOrders(userId);
    });
  }

  Future<String?> confirmOrder({
    required String userId,
    required String direccionEntrega,
  }) async {
    String? orderId;
    await _guard(() async {
      final cartItems = await _cartRepository.getCartItems(userId);
      if (cartItems.isEmpty) {
        error = 'Tu carrito está vacío';
        return;
      }

      final order = OrderEntity(
        id: '',
        usuarioId: userId,
        items: cartItems
            .map(
              (item) => OrderItemEntity(
                productoId: item.productoId,
                nombre: item.nombre,
                imagenUrl: item.imagenUrl,
                precio: item.precio,
                cantidad: item.cantidad,
                talla: item.talla,
                color: item.color,
              ),
            )
            .toList(),
        total: cartItems.fold(0, (sum, item) => sum + item.subtotal),
        estado: 'pendiente',
        fechaCreacion: DateTime.now(),
        direccionEntrega: direccionEntrega.trim(),
      );

      orderId = await _orderRepository.createOrder(order);
      await _cartRepository.clearCart(userId);
      orders = await _orderRepository.getOrders(userId);
    });
    return orderId;
  }

  Future<void> _guard(Future<void> Function() action) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      await action();
    } catch (exception) {
      error = _friendlyError(exception);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String _friendlyError(Object exception) {
    final message = exception.toString();
    if (message.contains('failed-precondition') &&
        message.contains('requires an index')) {
      return 'No se pudo cargar el historial de pedidos. Intenta de nuevo.';
    }
    if (message.contains('permission-denied')) {
      return 'No tienes permiso para realizar esta acción.';
    }
    return 'No se pudo completar la operación. Intenta de nuevo.';
  }
}
