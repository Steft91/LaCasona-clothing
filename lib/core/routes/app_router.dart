import 'package:go_router/go_router.dart';

import '../../presentation/views/cart_screen.dart';
import '../../presentation/views/catalog_screen.dart';
import '../../presentation/views/chatbot_screen.dart';
import '../../presentation/views/favorites_screen.dart';
import '../../presentation/views/home_screen.dart';
import '../../presentation/views/login_screen.dart';
import '../../presentation/views/orders_screen.dart';
import '../../presentation/views/product_detail_screen.dart';
import '../../presentation/views/profile_screen.dart';
import '../../presentation/views/register_screen.dart';
import '../../presentation/views/splash_view.dart';
import '../../presentation/views/visual_search_screen.dart';
import '../../presentation/widgets/app_shell.dart';

/// Application route configuration using go_router.
///
/// All named routes are defined here. Screen widgets will be added
/// as they are implemented.
class AppRouter {
  AppRouter._();

  // ── Route Names ─────────────────────────────────────────────────────────
  static const String splash = 'splash';
  static const String login = 'login';
  static const String register = 'register';
  static const String home = 'home';
  static const String productDetail = 'product-detail';
  static const String category = 'category';
  static const String cart = 'cart';
  static const String checkout = 'checkout';
  static const String orders = 'orders';
  static const String orderDetail = 'order-detail';
  static const String profile = 'profile';
  static const String favorites = 'favorites';
  static const String search = 'search';
  static const String visualSearch = 'visual-search';
  static const String chatbot = 'chatbot';

  // ── Route Paths ─────────────────────────────────────────────────────────
  static const String splashPath = '/';
  static const String loginPath = '/login';
  static const String registerPath = '/register';
  static const String homePath = '/home';
  static const String productDetailPath = '/product/:id';
  static const String categoryPath = '/category/:id';
  static const String cartPath = '/cart';
  static const String checkoutPath = '/checkout';
  static const String ordersPath = '/orders';
  static const String orderDetailPath = '/orders/:id';
  static const String profilePath = '/profile';
  static const String favoritesPath = '/favorites';
  static const String searchPath = '/search';
  static const String visualSearchPath = '/visual-search';
  static const String chatbotPath = '/chatbot';

  // ── Router ──────────────────────────────────────────────────────────────
  static final GoRouter router = GoRouter(
    initialLocation: splashPath,
    debugLogDiagnostics: true,
    routes: <RouteBase>[
      GoRoute(
        path: splashPath,
        name: splash,
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: loginPath,
        name: login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: registerPath,
        name: register,
        builder: (context, state) => const RegisterScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: homePath,
            name: home,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: searchPath,
            name: search,
            builder: (context, state) => const CatalogScreen(),
          ),
          GoRoute(
            path: favoritesPath,
            name: favorites,
            builder: (context, state) => const FavoritesScreen(),
          ),
          GoRoute(
            path: cartPath,
            name: cart,
            builder: (context, state) => const CartScreen(),
          ),
          GoRoute(
            path: profilePath,
            name: profile,
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: productDetailPath,
        name: productDetail,
        builder: (context, state) =>
            ProductDetailScreen(productId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: ordersPath,
        name: orders,
        builder: (context, state) => const OrdersScreen(),
      ),
      GoRoute(
        path: visualSearchPath,
        name: visualSearch,
        builder: (context, state) => const VisualSearchScreen(),
      ),
      GoRoute(
        path: chatbotPath,
        name: chatbot,
        builder: (context, state) => const ChatbotScreen(),
      ),
    ],
  );
}
