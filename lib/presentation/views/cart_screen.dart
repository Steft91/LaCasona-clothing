import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/app_utils.dart';
import '../design_system/atoms/casona_button.dart';
import '../design_system/organisms/casona_list_tile.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/cart_viewmodel.dart';
import '../widgets/empty_state.dart';
import '../widgets/login_required.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthViewModel>().user;
      if (user != null) context.read<CartViewModel>().loadCart(user.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();
    final cart = context.watch<CartViewModel>();
    final userId = auth.user?.id;

    return Scaffold(
      appBar: AppBar(title: const Text('Carrito')),
      body: userId == null
          ? const LoginRequired(
              icon: Icons.shopping_bag_outlined,
              title: 'Inicia sesión para usar el carrito',
              message:
                  'Puedes mirar el catálogo como invitadx, pero necesitas una cuenta para comprar.',
            )
          : cart.isLoading
          ? const Center(child: CircularProgressIndicator())
          : cart.items.isEmpty
          ? const EmptyState(
              icon: Icons.shopping_bag_outlined,
              title: 'Tu carrito esta vacio',
              message: 'Agrega prendas desde el catalogo.',
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: cart.items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = cart.items[index];
                return CasonaListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item.imagenUrl,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.image_not_supported_outlined,
                        color: AppTheme.caramelLight,
                      ),
                    ),
                  ),
                  title: item.nombre,
                  subtitle:
                      '${item.talla} - ${item.color}\n${AppUtils.formatCurrency(item.subtotal)}',
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton.filledTonal(
                        onPressed: () => _updateQuantity(
                          userId,
                          item.productoId,
                          item.cantidad - 1,
                        ),
                        icon: const Icon(Icons.remove_circle_outline),
                        iconSize: 18,
                        constraints: const BoxConstraints.tightFor(
                          width: 34,
                          height: 34,
                        ),
                        padding: EdgeInsets.zero,
                        style: IconButton.styleFrom(
                          backgroundColor: AppTheme.elevatedBlack,
                          foregroundColor: AppTheme.caramelLight,
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppTheme.caramel.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: AppTheme.hairline),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 5,
                          ),
                          child: Text(
                            '${item.cantidad}',
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(color: AppTheme.cream),
                          ),
                        ),
                      ),
                      IconButton.filledTonal(
                        onPressed: () => _updateQuantity(
                          userId,
                          item.productoId,
                          item.cantidad + 1,
                        ),
                        icon: const Icon(Icons.add_circle_outline),
                        iconSize: 18,
                        constraints: const BoxConstraints.tightFor(
                          width: 34,
                          height: 34,
                        ),
                        padding: EdgeInsets.zero,
                        style: IconButton.styleFrom(
                          backgroundColor: AppTheme.elevatedBlack,
                          foregroundColor: AppTheme.caramelLight,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: cart.items.isEmpty || userId == null
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: SizedBox(
                  height: 72,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppTheme.softBlack,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppTheme.hairline),
                      boxShadow: const [
                        BoxShadow(
                          color: AppTheme.warmShadow,
                          offset: Offset(0, 12),
                          blurRadius: 24,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: AppTheme.taupe,
                                        fontWeight: FontWeight.w800,
                                      ),
                                ),
                                Text(
                                  AppUtils.formatCurrency(cart.total),
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        color: AppTheme.cream,
                                        fontWeight: FontWeight.w900,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          CasonaButton(
                            text: 'Confirmar',
                            icon: Icons.shopping_bag_outlined,
                            fullWidth: false,
                            compact: true,
                            onPressed: () =>
                                context.pushNamed(AppRouter.checkout),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Future<void> _updateQuantity(
    String userId,
    String productId,
    int quantity,
  ) async {
    final cart = context.read<CartViewModel>();
    await cart.updateQuantity(userId, productId, quantity);
    if (!mounted || cart.error == null) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(cart.error!)));
  }
}
