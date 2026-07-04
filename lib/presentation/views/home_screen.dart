import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/routes/app_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/app_utils.dart';
import '../../domain/entities/product_entity.dart';
import '../design_system/atoms/casona_text_field.dart';
import '../design_system/molecules/casona_section_card.dart';
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
  final _searchController = TextEditingController();

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
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
            CasonaSectionCard(
              icon: Icons.storefront_outlined,
              title: 'Hola, ${auth.user?.nombre ?? 'bienvenida'}',
              subtitle: 'Encuentra piezas con alma quitena.',
              child: const SizedBox.shrink(),
            ),
            const SizedBox(height: 20),
            CasonaTextField(
              controller: _searchController,
              readOnly: true,
              onTap: () => context.goNamed(AppRouter.search),
              hintText: 'Buscar prendas',
              prefixIcon: Icons.search,
              suffixIcon: Icons.photo_camera_outlined,
              onSuffixTap: () => context.pushNamed(AppRouter.visualSearch),
            ),
            const SizedBox(height: 20),
            _OfferBanner(product: _offerProduct(products.featured)),
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
                    label: Text(
                      category,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppTheme.espressoBlack,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    onPressed: () {
                      context.read<ProductViewModel>().filterByCategory(
                        category,
                      );
                      context.goNamed(AppRouter.search);
                    },
                    backgroundColor: AppTheme.caramelLight,
                    side: const BorderSide(color: AppTheme.caramel),
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
                  title: 'Aun no hay productos destacados',
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

  ProductEntity? _offerProduct(List<ProductEntity> products) {
    for (final product in products) {
      if (product.precioOriginal > product.precio) return product;
    }
    return products.isEmpty ? null : products.first;
  }
}

class _OfferBanner extends StatelessWidget {
  const _OfferBanner({required this.product});

  final ProductEntity? product;

  @override
  Widget build(BuildContext context) {
    final hasProduct = product != null;
    final discount = hasProduct && product!.precioOriginal > product!.precio
        ? ((1 - product!.precio / product!.precioOriginal) * 100).round()
        : 20;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: hasProduct
            ? () => context.pushNamed(
                AppRouter.productDetail,
                pathParameters: {'id': product!.id},
              )
            : () => context.goNamed(AppRouter.search),
        child: Ink(
          height: 168,
          decoration: BoxDecoration(
            color: AppTheme.softBlack,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppTheme.hairline),
            boxShadow: const [
              BoxShadow(
                color: AppTheme.warmShadow,
                blurRadius: 30,
                offset: Offset(0, 14),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (hasProduct)
                  Image.network(
                    product!.imagenUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: AppTheme.parchmentGradient,
                          ),
                        ),
                  )
                else
                  const DecoratedBox(
                    decoration: BoxDecoration(gradient: AppTheme.woodGradient),
                  ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        AppTheme.espressoBlack.withValues(alpha: 0.88),
                        AppTheme.espressoBlack.withValues(alpha: 0.54),
                        AppTheme.espressoBlack.withValues(alpha: 0.18),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: AppTheme.espressoBlack.withValues(
                              alpha: 0.46,
                            ),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: AppTheme.cream.withValues(alpha: 0.14),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 220),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$discount% OFF',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(
                                          color: AppTheme.caramelLight,
                                          fontWeight: FontWeight.w900,
                                        ),
                                  ),
                                  const SizedBox(height: 7),
                                  Text(
                                    hasProduct
                                        ? product!.nombre
                                        : 'Nueva seleccion',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          color: AppTheme.cream,
                                          fontWeight: FontWeight.w900,
                                        ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    hasProduct
                                        ? AppUtils.formatCurrency(
                                            product!.precio,
                                          )
                                        : 'Prendas destacadas por tiempo limitado',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(color: AppTheme.oat),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
