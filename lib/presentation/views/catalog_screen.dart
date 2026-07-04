import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_router.dart';
import '../../core/theme/app_theme.dart';
import '../design_system/atoms/casona_text_field.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/favorites_viewmodel.dart';
import '../viewmodels/product_viewmodel.dart';
import '../widgets/empty_state.dart';
import '../widgets/product_card.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductViewModel>().loadCatalog();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductViewModel>();
    final favorites = context.watch<FavoritesViewModel>();
    final userId = context.watch<AuthViewModel>().user?.id;

    return Scaffold(
      appBar: AppBar(title: const Text('Buscar')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: CasonaTextField(
              controller: _searchController,
              onChanged: products.search,
              hintText: 'Buscar por nombre',
              prefixIcon: Icons.search,
              suffixIcon: Icons.photo_camera_outlined,
              onSuffixTap: () => context.pushNamed(AppRouter.visualSearch),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: products.categories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = products.categories[index];
                final selected = category == products.selectedCategory;
                return ChoiceChip(
                  label: Text(
                    category,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: selected ? AppTheme.espressoBlack : AppTheme.oat,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  selected: selected,
                  selectedColor: AppTheme.caramelLight,
                  backgroundColor: AppTheme.softBlack,
                  side: BorderSide(
                    color: selected ? AppTheme.caramelLight : AppTheme.hairline,
                  ),
                  onSelected: (_) => products.filterByCategory(category),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: products.isLoading
                ? const Center(child: CircularProgressIndicator())
                : products.products.isEmpty
                ? const EmptyState(
                    icon: Icons.search_off,
                    title: 'Sin resultados',
                    message: 'Prueba otra busqueda o categoria.',
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: products.products.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          childAspectRatio: 0.68,
                        ),
                    itemBuilder: (context, index) {
                      final product = products.products[index];
                      return ProductCard(
                        product: product,
                        isFavorite: favorites.favoriteIds.contains(product.id),
                        onFavorite: userId == null
                            ? null
                            : () => favorites.toggle(userId, product),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
