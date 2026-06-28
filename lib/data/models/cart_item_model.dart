import '../../domain/entities/cart_item_entity.dart';

/// Firestore-backed data model for [CartItemEntity].
class CartItemModel extends CartItemEntity {
  const CartItemModel({
    required super.productoId,
    required super.nombre,
    required super.imagenUrl,
    required super.precio,
    required super.cantidad,
    required super.talla,
    required super.color,
  });

  /// Create from a Firestore document snapshot data map.
  factory CartItemModel.fromFirestore(String docId, Map<String, dynamic> data) {
    return CartItemModel(
      productoId: docId,
      nombre: data['nombre'] ?? '',
      imagenUrl: data['imagenUrl'] ?? '',
      precio: (data['precio'] ?? 0).toDouble(),
      cantidad: data['cantidad'] ?? 1,
      talla: data['talla'] ?? '',
      color: data['color'] ?? '',
    );
  }

  /// Convert to a Firestore-compatible map.
  Map<String, dynamic> toFirestore() {
    return {
      'nombre': nombre,
      'imagenUrl': imagenUrl,
      'precio': precio,
      'cantidad': cantidad,
      'talla': talla,
      'color': color,
    };
  }
}
