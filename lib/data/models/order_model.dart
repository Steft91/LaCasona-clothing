import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/order_entity.dart';

/// Firestore-backed data model for [OrderEntity].
class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.usuarioId,
    required super.items,
    required super.total,
    required super.estado,
    required super.fechaCreacion,
    required super.direccionEntrega,
  });

  /// Create from a Firestore document snapshot.
  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final itemsList = (data['items'] as List<dynamic>? ?? [])
        .map(
          (item) => OrderItemEntity(
            productoId: item['productoId'] ?? '',
            nombre: item['nombre'] ?? '',
            imagenUrl: item['imagenUrl'] ?? '',
            precio: (item['precio'] ?? 0).toDouble(),
            cantidad: item['cantidad'] ?? 1,
            talla: item['talla'] ?? '',
            color: item['color'] ?? '',
          ),
        )
        .toList();

    return OrderModel(
      id: doc.id,
      usuarioId: data['usuarioId'] ?? '',
      items: itemsList,
      total: (data['total'] ?? 0).toDouble(),
      estado: data['estado'] ?? 'pendiente',
      fechaCreacion:
          (data['fechaCreacion'] as Timestamp?)?.toDate() ?? DateTime.now(),
      direccionEntrega: data['direccionEntrega'] ?? '',
    );
  }

  /// Convert to a Firestore-compatible map.
  Map<String, dynamic> toFirestore() {
    return {
      'usuarioId': usuarioId,
      'items': items
          .map(
            (item) => {
              'productoId': item.productoId,
              'nombre': item.nombre,
              'imagenUrl': item.imagenUrl,
              'precio': item.precio,
              'cantidad': item.cantidad,
              'talla': item.talla,
              'color': item.color,
            },
          )
          .toList(),
      'total': total,
      'estado': estado,
      'fechaCreacion': Timestamp.fromDate(fechaCreacion),
      'direccionEntrega': direccionEntrega,
    };
  }
}
