import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/routes/app_router.dart';
import '../../core/theme/app_theme.dart';

class AppShell extends StatefulWidget {
  const AppShell({required this.child, super.key});

  final Widget child;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  static const _routes = [
    AppRouter.homePath,
    AppRouter.searchPath,
    AppRouter.favoritesPath,
    AppRouter.cartPath,
    AppRouter.profilePath,
  ];

  bool _showAiHint = true;
  Timer? _hintTimer;

  @override
  void initState() {
    super.initState();
    _hintTimer = Timer(const Duration(seconds: 6), () {
      if (mounted) setState(() => _showAiHint = false);
    });
  }

  @override
  void dispose() {
    _hintTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final currentIndex = _currentIndex(location);

    return Scaffold(
      body: widget.child,
      floatingActionButton: _AiFloatingButton(
        showHint: _showAiHint,
        onPressed: () {
          setState(() => _showAiHint = false);
          context.pushNamed(AppRouter.chatbot);
        },
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppTheme.espressoBlack,
          boxShadow: [
            BoxShadow(
              color: AppTheme.heavyShadow,
              offset: Offset(0, -10),
              blurRadius: 26,
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: NavigationBar(
                selectedIndex: currentIndex,
                onDestinationSelected: (index) => context.go(_routes[index]),
                backgroundColor: AppTheme.softBlack,
                indicatorColor: AppTheme.caramel.withValues(alpha: 0.22),
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
            ),
          ),
        ),
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

class _AiFloatingButton extends StatelessWidget {
  const _AiFloatingButton({required this.showHint, required this.onPressed});

  final bool showHint;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          child: showHint
              ? Padding(
                  key: const ValueKey('ai-hint'),
                  padding: const EdgeInsets.only(right: 10, bottom: 4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppTheme.espressoBlack.withValues(alpha: 0.62),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppTheme.cream.withValues(alpha: 0.14),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 13,
                            vertical: 9,
                          ),
                          child: Text(
                            'Casona AI te ayuda',
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  color: AppTheme.cream,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(key: ValueKey('ai-hidden')),
        ),
        FloatingActionButton(
          tooltip: 'Casona AI',
          onPressed: onPressed,
          child: const Icon(Icons.smart_toy_outlined),
        ),
      ],
    );
  }
}
