import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/app_utils.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/cart_viewmodel.dart';
import '../viewmodels/orders_viewmodel.dart';
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
              title: 'Tu carrito está vacío',
              message: 'Agrega prendas desde el catálogo.',
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: cart.items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = cart.items[index];
                return ListTile(
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      item.imagenUrl,
                      width: 58,
                      height: 58,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image_not_supported_outlined),
                    ),
                  ),
                  title: Text(item.nombre),
                  subtitle: Text(
                    '${item.talla} · ${item.color}\n${AppUtils.formatCurrency(item.subtotal)}',
                  ),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: userId == null
                            ? null
                            : () => cart.updateQuantity(
                                userId,
                                item.productoId,
                                item.cantidad - 1,
                              ),
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Text('${item.cantidad}'),
                      IconButton(
                        onPressed: userId == null
                            ? null
                            : () => cart.updateQuantity(
                                userId,
                                item.productoId,
                                item.cantidad + 1,
                              ),
                        icon: const Icon(Icons.add_circle_outline),
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
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        AppUtils.formatCurrency(cart.total),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: userId == null ? null : () => _confirm(userId),
                      child: const Text('Confirmar pedido'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _confirm(String userId) async {
    var typedAddress = '';
    final address = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dirección de entrega'),
        content: TextField(
          onChanged: (value) {
            typedAddress = value;
          },
          decoration: const InputDecoration(
            hintText: 'Ej. Centro histórico, Quito',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, typedAddress),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );

    if (address == null || address.trim().isEmpty || !mounted) return;

    final success = await context.read<OrdersViewModel>().confirmOrder(
      userId: userId,
      direccionEntrega: address,
    );
    if (!mounted) return;
    if (success) {
      await context.read<CartViewModel>().loadCart(userId);
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.check_circle, color: AppTheme.successColor),
          title: const Text('Pedido confirmado'),
          content: const Text('Tu pedido quedó registrado como pendiente.'),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Listo'),
            ),
          ],
        ),
      );
    } else {
      final message =
          context.read<OrdersViewModel>().error ??
          'No se pudo crear el pedido.';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }
}
