/// Application-wide constants for La Casona.
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'La Casona';
  static const String appTagline = 'Moda con alma colonial';
  static const String packageName = 'com.lacasona.app';
  static const String logoAsset = 'assets/brand/la_casona_logo.png';

  // Firestore Collections
  static const String usersCollection = 'usuarios';
  static const String productsCollection = 'productos';
  static const String categoriesCollection = 'categorias';
  static const String ordersCollection = 'pedidos';
  static const String cartCollection = 'carrito';
  static const String favoritesCollection = 'favoritos';
  static const String reviewsCollection = 'reviews';

  // Catalogue
  static const List<String> categories = [
    'Tops',
    'Vestidos',
    'Pantalones',
    'Faldas',
    'Outerwear',
    'Conjuntos',
  ];

  static const List<String> clothingLabels = [
    'clothing',
    'dress',
    'shirt',
    'top',
    'jacket',
    'coat',
    'pants',
    'trousers',
    'jeans',
    'skirt',
    'sweater',
    'outerwear',
    'shorts',
  ];

  // Pagination
  static const int defaultPageSize = 20;

  // Cache
  static const Duration cacheDuration = Duration(hours: 1);

  // Currency
  static const String currencySymbol = '\$';
  static const String currencyCode = 'USD';

  static const String paymentsCollection = 'pagos';
}
