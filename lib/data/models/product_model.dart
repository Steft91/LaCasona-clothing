import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/product_entity.dart';

/// Firestore-backed data model for [ProductEntity].
class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.nombre,
    required super.descripcion,
    required super.precio,
    required super.precioOriginal,
    required super.categoria,
    required super.tallas,
    required super.colores,
    required super.imagenUrl,
    required super.stock,
    required super.destacado,
  });

  /// Create from a Firestore document snapshot.
  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      id: doc.id,
      nombre: data['nombre'] ?? '',
      descripcion: data['descripcion'] ?? '',
      precio: (data['precio'] ?? 0).toDouble(),
      precioOriginal: (data['precioOriginal'] ?? 0).toDouble(),
      categoria: data['categoria'] ?? '',
      tallas: List<String>.from(data['tallas'] ?? []),
      colores: List<String>.from(data['colores'] ?? []),
      imagenUrl: data['imagenUrl'] ?? '',
      stock: data['stock'] ?? 0,
      destacado: data['destacado'] ?? false,
    );
  }

  /// Convert to a Firestore-compatible map.
  Map<String, dynamic> toFirestore() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
      'precioOriginal': precioOriginal,
      'categoria': categoria,
      'tallas': tallas,
      'colores': colores,
      'imagenUrl': imagenUrl,
      'stock': stock,
      'destacado': destacado,
    };
  }
}
