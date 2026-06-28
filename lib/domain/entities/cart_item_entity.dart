/// Domain entity representing a single item in the shopping cart.
class CartItemEntity {
  final String productoId;
  final String nombre;
  final String imagenUrl;
  final double precio;
  final int cantidad;
  final String talla;
  final String color;

  const CartItemEntity({
    required this.productoId,
    required this.nombre,
    required this.imagenUrl,
    required this.precio,
    required this.cantidad,
    required this.talla,
    required this.color,
  });

  double get subtotal => precio * cantidad;
}
