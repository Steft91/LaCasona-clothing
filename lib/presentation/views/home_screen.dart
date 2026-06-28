import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/routes/app_router.dart';
import '../../core/theme/app_theme.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/favorites_viewmodel.dart';
import '../viewmodels/product_viewmodel.dart';
import '../widgets/empty_state.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductViewModel>().loadHome();
      final user = context.read<AuthViewModel>().user;
      if (user != null) {
        context.read<FavoritesViewModel>().loadFavorites(user.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();
    final products = context.watch<ProductViewModel>();
    final favorites = context.watch<FavoritesViewModel>();
    final userId = auth.user?.id;

    return Scaffold(
      appBar: AppBar(title: const Text(AppConstants.appName)),
      body: RefreshIndicator(
        onRefresh: products.loadHome,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Hola, ${auth.user?.nombre ?? 'bienvenida'}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 6),
            Text(
              'Encuentra piezas con alma quiteña.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            TextField(
              readOnly: true,
              onTap: () => context.goNamed(AppRouter.search),
              decoration: InputDecoration(
                hintText: 'Buscar prendas',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.photo_camera_outlined),
                  onPressed: () => context.pushNamed(AppRouter.visualSearch),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 42,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: AppConstants.categories.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final category = AppConstants.categories[index];
                  return ActionChip(
                    label: Text(category),
                    onPressed: () {
                      context.read<ProductViewModel>().filterByCategory(
                        category,
                      );
                      context.goNamed(AppRouter.search);
                    },
                    backgroundColor: AppTheme.accentBeige.withValues(
                      alpha: 0.16,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Destacados',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            if (products.isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (products.featured.isEmpty)
              const SizedBox(
                height: 220,
                child: EmptyState(
                  icon: Icons.storefront_outlined,
                  title: 'Aún no hay productos destacados',
                ),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: products.featured.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.68,
                ),
                itemBuilder: (context, index) {
                  final product = products.featured[index];
                  return ProductCard(
                    product: product,
                    isFavorite: favorites.favoriteIds.contains(product.id),
                    onFavorite: userId == null
                        ? null
                        : () => favorites.toggle(userId, product),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
