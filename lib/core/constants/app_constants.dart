/// Application-wide constants for La Casona.
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'La Casona';
  static const String appTagline = 'Moda con alma colonial';
  static const String packageName = 'com.lacasona.app';

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
    'Outerwear',
    'Pantalones',
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
  ];

  // Pagination
  static const int defaultPageSize = 20;

  // Cache
  static const Duration cacheDuration = Duration(hours: 1);

  // Currency
  static const String currencySymbol = '\$';
  static const String currencyCode = 'USD';


  
  // Stripe (Modo Test)
  // Nota: En un entorno real, la Secret Key NUNCA debe ir en la app.
  // La colocaremos aquí temporalmente para tu presentación académica.
  static const String stripePublishableKey = 'pk_test_TU_CLAVE_PUBLICA_AQUI'; 
  static const String stripeSecretKey = 'sk_test_TU_CLAVE_SECRETA_AQUI'; 

  // Firestore Collections (Nueva)
  static const String paymentsCollection = 'pagos';
}
