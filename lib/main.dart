import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/cart_repository_impl.dart';
import 'data/repositories/favorites_repository_impl.dart';
import 'data/repositories/order_repository_impl.dart';
import 'data/repositories/product_repository_impl.dart';
import 'data/services/seed_data_service.dart';
import 'data/services/visual_search_service.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/cart_repository.dart';
import 'domain/repositories/favorites_repository.dart';
import 'domain/repositories/order_repository.dart';
import 'domain/repositories/product_repository.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_router.dart';
import 'core/constants/app_constants.dart';
import 'presentation/viewmodels/auth_viewmodel.dart';
import 'presentation/viewmodels/cart_viewmodel.dart';
import 'presentation/viewmodels/chatbot_viewmodel.dart';
import 'presentation/viewmodels/favorites_viewmodel.dart';
import 'presentation/viewmodels/orders_viewmodel.dart';
import 'presentation/viewmodels/product_viewmodel.dart';
import 'presentation/viewmodels/visual_search_viewmodel.dart';
import 'package:flutter_stripe/flutter_stripe.dart'; // <--- NUEVO
import 'presentation/viewmodels/checkout_viewmodel.dart'; // <--- NUEVO
import 'domain/use_cases/payment_use_cases.dart'; // <--- NUEVO
import 'data/repositories/payment_repository_impl.dart'; // <--- NUEVO
import 'data/services/stripe_service.dart'; // <--- NUEVO

/// La Casona — Fashion e-commerce with colonial Quito aesthetic.
///
/// Entry point: loads environment variables, initialises Firebase,
/// sets up Provider-based state management, and launches the app
/// with the colonial warm-tone theme.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables (.env)
  await dotenv.load(fileName: '.env');

  // Initialise Firebase
  await Firebase.initializeApp();
  await SeedDataService().seedMissingProducts();
  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';
  // Lock orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style to match the colonial theme
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.deepWood,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const LaCasonaApp());
}

/// Root application widget.
///
/// Wraps the widget tree with [MultiProvider] for MVVM state management
/// and applies the colonial Quito [ThemeData].
class LaCasonaApp extends StatelessWidget {
  const LaCasonaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthRepository>(create: (_) => AuthRepositoryImpl()),
        Provider<ProductRepository>(create: (_) => ProductRepositoryImpl()),
        Provider<CartRepository>(create: (_) => CartRepositoryImpl()),
        Provider<OrderRepository>(create: (_) => OrderRepositoryImpl()),
        Provider<FavoritesRepository>(create: (_) => FavoritesRepositoryImpl()),
        Provider<VisualSearchService>(create: (_) => VisualSearchService()),
        Provider<StripeService>(create: (_) => StripeService()),
        Provider<PaymentRepositoryImpl>(
          create: (context) => PaymentRepositoryImpl(
            stripeService: context.read<StripeService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => CheckoutViewModel(
            createPaymentIntentUseCase: CreatePaymentIntentUseCase(
              context.read<PaymentRepositoryImpl>(),
            ),
            savePaymentRecordUseCase: SavePaymentRecordUseCase(
              context.read<PaymentRepositoryImpl>(),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthViewModel(context.read<AuthRepository>()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              ProductViewModel(context.read<ProductRepository>()),
        ),
        ChangeNotifierProvider(
          create: (context) => CartViewModel(context.read<CartRepository>()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              FavoritesViewModel(context.read<FavoritesRepository>()),
        ),
        ChangeNotifierProvider(
          create: (context) => OrdersViewModel(
            context.read<OrderRepository>(),
            context.read<CartRepository>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => VisualSearchViewModel(
            context.read<VisualSearchService>(),
            context.read<ProductRepository>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              ChatbotViewModel(context.read<ProductRepository>()),
        ),
      ],
      child: MaterialApp.router(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        builder: (context, child) {
          return DecoratedBox(
            decoration: const BoxDecoration(gradient: AppTheme.wallGradient),
            child: child ?? const SizedBox.shrink(),
          );
        },
        routerConfig: AppRouter.router,
      ),
    );
  }
}
