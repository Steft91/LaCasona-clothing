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
    for (final product in _curatedProducts) {
      batch.set(products.doc(), product);
    }
    await batch.commit();
  }

  Future<void> seedMissingProducts() async {
    final products = _firestore.collection(AppConstants.productsCollection);
    final existing = await products.get();
    final docsByName = {
      for (final doc in existing.docs)
        (doc.data()['nombre'] ?? '').toString().toLowerCase(): doc.reference,
    };

    final batch = _firestore.batch();
    var pendingWrites = 0;

    for (final product in _curatedProducts) {
      final name = (product['nombre'] ?? '').toString().toLowerCase();
      final existingDoc = docsByName[name];
      if (existingDoc == null) {
        batch.set(products.doc(), product);
      } else {
        batch.update(existingDoc, product);
      }
      pendingWrites++;
    }

    if (pendingWrites > 0) {
      await batch.commit();
    }
  }

  static final List<Map<String, dynamic>> _curatedProducts = [
    {
      'nombre': 'Camisa Lino Quito',
      'descripcion':
          'Camisa de lino de silueta relajada, fresca y sobria para combinar con prendas neutras.',
      'precio': 42.90,
      'precioOriginal': 52.00,
      'categoria': 'Tops',
      'tallas': ['S', 'M', 'L', 'XL'],
      'colores': ['Blanco', 'Arena'],
      'imagenUrl':
          'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?auto=format&fit=crop&w=900&q=80',
      'stock': 16,
      'destacado': true,
    },
    {
      'nombre': 'Blazer Alameda',
      'descripcion':
          'Blazer estructurado de líneas limpias para elevar vestidos, faldas o pantalones.',
      'precio': 94.90,
      'precioOriginal': 118.00,
      'categoria': 'Outerwear',
      'tallas': ['S', 'M', 'L'],
      'colores': ['Crema', 'Negro'],
      'imagenUrl':
          'https://images.unsplash.com/photo-1551836022-d5d88e9218df?auto=format&fit=crop&w=900&q=80',
      'stock': 9,
      'destacado': true,
    },
    {
      'nombre': 'Conjunto Ronda',
      'descripcion':
          'Set coordinado de top y pantalón fluido para un outfit completo, sereno y femenino.',
      'precio': 82.50,
      'precioOriginal': 98.00,
      'categoria': 'Conjuntos',
      'tallas': ['S', 'M', 'L'],
      'colores': ['Crema', 'Chocolate'],
      'imagenUrl':
          'https://images.unsplash.com/photo-1485968579580-b6d095142e6e?auto=format&fit=crop&w=900&q=80',
      'stock': 11,
      'destacado': true,
    },
    {
      'nombre': 'Blusa Negra Siena',
      'descripcion':
          'Blusa negra de presencia elegante, ideal para combinar con faldas, jeans o pantalón sastre.',
      'precio': 39.90,
      'precioOriginal': 49.00,
      'categoria': 'Tops',
      'tallas': ['XS', 'S', 'M', 'L'],
      'colores': ['Negro'],
      'imagenUrl':
          'https://images.unsplash.com/photo-1612731486606-2614b4d74921?auto=format&fit=crop&w=900&q=80',
      'stock': 15,
      'destacado': true,
    },
    {
      'nombre': 'Terno Ajedrez Caqui',
      'descripcion':
          'Conjunto de patrón tipo ajedrez en tono caqui, pensado para un look pulido y moderno.',
      'precio': 118.90,
      'precioOriginal': 145.00,
      'categoria': 'Conjuntos',
      'tallas': ['S', 'M', 'L', 'XL'],
      'colores': ['Caqui', 'Café claro'],
      'imagenUrl':
          'https://unsplash.com/photos/a-man-in-a-suit-sitting-on-a-bench-yad8QcBssbg/download?force=true&w=1200',
      'stock': 7,
      'destacado': true,
    },
    {
      'nombre': 'Blusa Calada Naranja',
      'descripcion':
          'Blusa manga larga con tejido calado en naranja suave, una pieza de acento cálido para looks neutros.',
      'precio': 36.90,
      'precioOriginal': 46.00,
      'categoria': 'Tops',
      'tallas': ['S', 'M', 'L'],
      'colores': ['Naranja'],
      'imagenUrl':
          'https://images.unsplash.com/photo-1718358345678-889a08b96114?auto=format&fit=crop&w=900&q=80',
      'stock': 12,
      'destacado': false,
    },
    {
      'nombre': 'Vestido Largo Crema',
      'descripcion':
          'Vestido largo en tono crema con caída delicada, perfecto para ocasiones especiales y looks elegantes.',
      'precio': 89.90,
      'precioOriginal': 112.00,
      'categoria': 'Vestidos',
      'tallas': ['XS', 'S', 'M', 'L'],
      'colores': ['Crema'],
      'imagenUrl':
          'https://unsplash.com/photos/a-woman-sitting-on-top-of-a-couch-wearing-a-dress-CNT_ujoNmAI/download?force=true&w=1200',
      'stock': 8,
      'destacado': true,
    },
    {
      'nombre': 'Enterizo Celeste Amalia',
      'descripcion':
          'Enterizo celeste de silueta fluida, cómodo y femenino para un outfit completo sin esfuerzo.',
      'precio': 76.90,
      'precioOriginal': 94.00,
      'categoria': 'Conjuntos',
      'tallas': ['S', 'M', 'L'],
      'colores': ['Celeste'],
      'imagenUrl':
          'https://unsplash.com/photos/woman-in-blue-patterned-outfit-sits-on-wooden-surface-UHOUmtH3CeY/download?force=true&w=1200',
      'stock': 9,
      'destacado': true,
    },
    {
      'nombre': 'Blazer Blanco Caqui',
      'descripcion':
          'Blazer en mezcla blanco y caqui, versátil para elevar jeans, vestidos o pantalones de sastre.',
      'precio': 98.90,
      'precioOriginal': 124.00,
      'categoria': 'Outerwear',
      'tallas': ['S', 'M', 'L', 'XL'],
      'colores': ['Blanco', 'Caqui'],
      'imagenUrl':
          'https://images.unsplash.com/photo-1662393792373-52f5477094f6?auto=format&fit=crop&w=900&q=80',
      'stock': 10,
      'destacado': true,
    },
    {
      'nombre': 'Camisa Azul Lino',
      'descripcion':
          'Camisa manga larga azul con textura ligera, sobria y fácil de llevar en el día a día.',
      'precio': 44.90,
      'precioOriginal': 54.00,
      'categoria': 'Tops',
      'tallas': ['S', 'M', 'L', 'XL'],
      'colores': ['Azul'],
      'imagenUrl':
          'https://images.unsplash.com/photo-1740711152088-88a009e877bb?auto=format&fit=crop&w=900&q=80',
      'stock': 18,
      'destacado': false,
    },
    {
      'nombre': 'Jean Azul Clásico',
      'descripcion':
          'Jean azul de corte clásico, una base atemporal para combinar con blusas, camisas y blazers.',
      'precio': 55.90,
      'precioOriginal': 68.00,
      'categoria': 'Pantalones',
      'tallas': ['26', '28', '30', '32', '34'],
      'colores': ['Azul'],
      'imagenUrl':
          'https://unsplash.com/photos/a-pair-of-hands-holding-a-pair-of-jeans-WBnjmUWwqVo/download?force=true&w=1200',
      'stock': 20,
      'destacado': true,
    },
    {
      'nombre': 'Falda Larga Blanca',
      'descripcion':
          'Falda larga blanca de estilo limpio y femenino, ideal para outfits frescos y elegantes.',
      'precio': 52.90,
      'precioOriginal': 66.00,
      'categoria': 'Faldas',
      'tallas': ['XS', 'S', 'M', 'L'],
      'colores': ['Blanco'],
      'imagenUrl':
          'https://unsplash.com/photos/a-woman-wearing-a-white-dress-and-sandals-0OCnb5o9le8/download?force=true&w=1200',
      'stock': 13,
      'destacado': false,
    },
    {
      'nombre': 'Falda Negra Larga',
      'descripcion':
          'Falda negra larga con caída sobria, perfecta para combinar con botas, blusas o tops claros.',
      'precio': 54.90,
      'precioOriginal': 69.00,
      'categoria': 'Faldas',
      'tallas': ['XS', 'S', 'M', 'L'],
      'colores': ['Negro'],
      'imagenUrl':
          'https://unsplash.com/photos/a-close-up-of-a-person-wearing-brown-boots--oY2XRtye7Q/download?force=true&w=1200',
      'stock': 11,
      'destacado': false,
    },
    {
      'nombre': 'Vestido Corto Menta',
      'descripcion':
          'Vestido corto en verde pastel menta, delicado y fresco para ocasiones de día.',
      'precio': 64.90,
      'precioOriginal': 78.00,
      'categoria': 'Vestidos',
      'tallas': ['XS', 'S', 'M', 'L'],
      'colores': ['Menta'],
      'imagenUrl':
          'https://unsplash.com/photos/woman-in-green-spaghetti-strap-dress-yAVyaJboNeY/download?force=true&w=1200',
      'stock': 10,
      'destacado': true,
    },
    {
      'nombre': 'Vestido Corto Blanco',
      'descripcion':
          'Vestido corto blanco de líneas simples, femenino y fácil de adaptar a looks casuales elegantes.',
      'precio': 62.90,
      'precioOriginal': 76.00,
      'categoria': 'Vestidos',
      'tallas': ['XS', 'S', 'M', 'L'],
      'colores': ['Blanco'],
      'imagenUrl':
          'https://unsplash.com/photos/a-woman-in-a-white-dress-standing-next-to-a-wall-6Z1ZodAmLFk/download?force=true&w=1200',
      'stock': 12,
      'destacado': false,
    },
    {
      'nombre': 'Top Blanco Sin Mangas',
      'descripcion':
          'Top blanco sin mangas de corte limpio, básico elevado para combinar con jeans o faldas.',
      'precio': 28.90,
      'precioOriginal': 36.00,
      'categoria': 'Tops',
      'tallas': ['XS', 'S', 'M', 'L'],
      'colores': ['Blanco'],
      'imagenUrl':
          'https://unsplash.com/photos/a-woman-sitting-on-top-of-a-green-stool-fHmVqLHgezU/download?force=true&w=1200',
      'stock': 22,
      'destacado': false,
    },
    {
      'nombre': 'Top Celeste Alba',
      'descripcion':
          'Top celeste de aire fresco y femenino, ideal para looks relajados con tonos claros.',
      'precio': 30.90,
      'precioOriginal': 38.00,
      'categoria': 'Tops',
      'tallas': ['XS', 'S', 'M', 'L'],
      'colores': ['Celeste'],
      'imagenUrl':
          'https://unsplash.com/photos/a-woman-in-a-crop-top-is-holding-her-arms-in-the-air-Dsbs1s2PFt4/download?force=true&w=1200',
      'stock': 19,
      'destacado': false,
    },
  ];
}
