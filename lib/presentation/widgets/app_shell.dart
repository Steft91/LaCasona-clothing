import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/routes/app_router.dart';
import '../../core/theme/app_theme.dart';

class AppShell extends StatelessWidget {
  const AppShell({required this.child, super.key});

  final Widget child;

  static const _routes = [
    AppRouter.homePath,
    AppRouter.searchPath,
    AppRouter.favoritesPath,
    AppRouter.cartPath,
    AppRouter.profilePath,
  ];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final currentIndex = _currentIndex(location);

    return Scaffold(
      body: child,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.accentBeige,
        foregroundColor: AppTheme.darkText,
        onPressed: () => context.pushNamed(AppRouter.chatbot),
        child: const Icon(Icons.auto_awesome),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) => context.go(_routes[index]),
        backgroundColor: Colors.white,
        indicatorColor: AppTheme.accentBeige.withValues(alpha: 0.22),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            selectedIcon: Icon(Icons.search),
            label: 'Buscar',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            selectedIcon: Icon(Icons.shopping_bag),
            label: 'Carrito',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  int _currentIndex(String location) {
    if (location.startsWith(AppRouter.searchPath)) return 1;
    if (location.startsWith(AppRouter.favoritesPath)) return 2;
    if (location.startsWith(AppRouter.cartPath)) return 3;
    if (location.startsWith(AppRouter.profilePath)) return 4;
    return 0;
  }
}
