import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/app_constants.dart';

class SeedDataService {
  SeedDataService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<void> seedProductsIfEmpty() async {
    final products = _firestore.collection(AppConstants.productsCollection);
    final existing = await products.limit(1).get();
    if (existing.docs.isNotEmpty) return;

    final batch = _firestore.batch();
    for (final product in _sampleProducts) {
      final doc = products.doc();
      batch.set(doc, product);
    }
    await batch.commit();
  }

  static final List<Map<String, dynamic>> _sampleProducts = [
    {
      'nombre': 'Blusa Encaje San Marcos',
      'descripcion':
          'Blusa ligera con textura delicada, pensada para tardes frescas en el centro histórico.',
      'precio': 34.90,
      'precioOriginal': 44.90,
      'categoria': 'Tops',
      'tallas': ['XS', 'S', 'M', 'L'],
      'colores': ['Blanco', 'Beige'],
      'imagenUrl':
          'https://images.unsplash.com/photo-1551489186-cf8726f514f8?auto=format&fit=crop&w=900&q=80',
      'stock': 18,
      'destacado': true,
    },
    {
      'nombre': 'Vestido Patio Colonial',
      'descripcion':
          'Vestido midi de caída suave con silueta elegante para una salida casual o una cena.',
      'precio': 69.90,
      'precioOriginal': 82.00,
      'categoria': 'Vestidos',
      'tallas': ['S', 'M', 'L'],
      'colores': ['Marfil', 'Terracota'],
      'imagenUrl':
          'https://images.unsplash.com/photo-1595777457583-95e059d581b8?auto=format&fit=crop&w=900&q=80',
      'stock': 10,
      'destacado': true,
    },
    {
      'nombre': 'Chaqueta Balcón Quiteño',
      'descripcion':
          'Chaqueta versátil de tono cálido para combinar con denim, vestidos o pantalón sastre.',
      'precio': 89.90,
      'precioOriginal': 110.00,
      'categoria': 'Outerwear',
      'tallas': ['S', 'M', 'L', 'XL'],
      'colores': ['Camel', 'Café'],
      'imagenUrl':
          'https://images.unsplash.com/photo-1548624313-0396c75e4b1a?auto=format&fit=crop&w=900&q=80',
      'stock': 8,
      'destacado': true,
    },
    {
      'nombre': 'Pantalón Piedra Clara',
      'descripcion':
          'Pantalón de corte recto, cómodo y pulido para uso diario.',
      'precio': 52.50,
      'precioOriginal': 52.50,
      'categoria': 'Pantalones',
      'tallas': ['26', '28', '30', '32'],
      'colores': ['Beige', 'Negro'],
      'imagenUrl':
          'https://images.unsplash.com/photo-1594633312681-425c7b97ccd1?auto=format&fit=crop&w=900&q=80',
      'stock': 15,
      'destacado': true,
    },
    {
      'nombre': 'Top Panecillo',
      'descripcion':
          'Top básico con detalle femenino, fácil de combinar con capas y accesorios.',
      'precio': 28.00,
      'precioOriginal': 35.00,
      'categoria': 'Tops',
      'tallas': ['XS', 'S', 'M'],
      'colores': ['Crema', 'Verde Oliva'],
      'imagenUrl':
          'https://images.unsplash.com/photo-1503342217505-b0a15ec3261c?auto=format&fit=crop&w=900&q=80',
      'stock': 22,
      'destacado': false,
    },
    {
      'nombre': 'Abrigo Plaza Grande',
      'descripcion':
          'Abrigo estructurado con presencia clásica para noches frías.',
      'precio': 119.00,
      'precioOriginal': 145.00,
      'categoria': 'Outerwear',
      'tallas': ['M', 'L', 'XL'],
      'colores': ['Negro', 'Café'],
      'imagenUrl':
          'https://images.unsplash.com/photo-1539533018447-63fcce2678e3?auto=format&fit=crop&w=900&q=80',
      'stock': 6,
      'destacado': false,
    },
  ];
}
