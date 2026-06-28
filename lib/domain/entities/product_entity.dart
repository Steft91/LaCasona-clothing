/// Domain entity representing a product in the catalogue.
class ProductEntity {
  final String id;
  final String nombre;
  final String descripcion;
  final double precio;
  final double precioOriginal;
  final String categoria;
  final List<String> tallas;
  final List<String> colores;
  final String imagenUrl;
  final int stock;
  final bool destacado;

  const ProductEntity({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.precioOriginal,
    required this.categoria,
    required this.tallas,
    required this.colores,
    required this.imagenUrl,
    required this.stock,
    required this.destacado,
  });
}
