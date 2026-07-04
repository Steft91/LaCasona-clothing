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
      body: cart.isLoading
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
                        color: AppTheme.carvedWood,
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
                        onPressed: userId == null
                            ? null
                            : () => _updateQuantity(
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
                          backgroundColor: AppTheme.colonialCream,
                          foregroundColor: AppTheme.mahogany,
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppTheme.softGold.withValues(alpha: 0.28),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.lineGold),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 5,
                          ),
                          child: Text(
                            '${item.cantidad}',
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(color: AppTheme.deepWood),
                          ),
                        ),
                      ),
                      IconButton.filledTonal(
                        onPressed: userId == null
                            ? null
                            : () => _updateQuantity(
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
                          backgroundColor: AppTheme.colonialCream,
                          foregroundColor: AppTheme.mahogany,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: cart.items.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: SizedBox(
                  height: 72,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: AppTheme.woodGradient,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTheme.lineGold, width: 1.2),
                      boxShadow: const [
                        BoxShadow(
                          color: AppTheme.warmShadow,
                          offset: Offset(0, 5),
                          blurRadius: 11,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(4, 4, 4, 7),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: AppTheme.parchmentGradient,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppTheme.burnishedGold),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: AppTheme.carvedWood,
                                            fontWeight: FontWeight.w800,
                                          ),
                                    ),
                                    Text(
                                      AppUtils.formatCurrency(cart.total),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            color: AppTheme.inkBrown,
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
                                onPressed: userId == null
                                    ? null
                                    : () =>
                                          context.pushNamed(AppRouter.checkout),
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
