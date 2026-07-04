import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/favorites_viewmodel.dart';
import '../widgets/empty_state.dart';
import '../widgets/login_required.dart';
import '../widgets/product_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthViewModel>().user;
      if (user != null) {
        context.read<FavoritesViewModel>().loadFavorites(user.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.watch<AuthViewModel>().user?.id;
    final favorites = context.watch<FavoritesViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Favoritos')),
      body: userId == null
          ? const LoginRequired(
              icon: Icons.favorite_border,
              title: 'Inicia sesión para guardar favoritos',
              message:
                  'Explora como invitadx y crea una cuenta para guardar tus prendas favoritas.',
            )
          : favorites.isLoading
          ? const Center(child: CircularProgressIndicator())
          : favorites.favorites.isEmpty
          ? const EmptyState(
              icon: Icons.favorite_border,
              title: 'No hay favoritos todavia',
              message: 'Guarda prendas que quieras mirar despues.',
            )
          : GridView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: favorites.favorites.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.68,
              ),
              itemBuilder: (context, index) {
                final product = favorites.favorites[index];
                return ProductCard(
                  product: product,
                  isFavorite: true,
                  onFavorite: () => favorites.toggle(userId, product),
                );
              },
            ),
    );
  }
}
