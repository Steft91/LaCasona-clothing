/// Domain entity representing a customer order.
class OrderEntity {
  final String id;
  final String usuarioId;
  final List<OrderItemEntity> items;
  final double total;
  final String estado; // pendiente | confirmado | enviado | entregado
  final DateTime fechaCreacion;
  final String direccionEntrega;

  const OrderEntity({
    required this.id,
    required this.usuarioId,
    required this.items,
    required this.total,
    required this.estado,
    required this.fechaCreacion,
    required this.direccionEntrega,
  });
}

/// A single line-item inside an [OrderEntity].
class OrderItemEntity {
  final String productoId;
  final String nombre;
  final String imagenUrl;
  final double precio;
  final int cantidad;
  final String talla;
  final String color;

  const OrderItemEntity({
    required this.productoId,
    required this.nombre,
    required this.imagenUrl,
    required this.precio,
    required this.cantidad,
    required this.talla,
    required this.color,
  });
}
