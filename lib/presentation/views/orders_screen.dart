import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/app_utils.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/orders_viewmodel.dart';
import '../widgets/empty_state.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthViewModel>().user;
      if (user != null) context.read<OrdersViewModel>().loadOrders(user.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrdersViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Pedidos')),
      body: orders.isLoading
          ? const Center(child: CircularProgressIndicator())
          : orders.orders.isEmpty
          ? const EmptyState(
              icon: Icons.receipt_long_outlined,
              title: 'Aún no tienes pedidos',
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: orders.orders.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final order = orders.orders[index];
                return ListTile(
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: Text(
                    'Pedido ${order.id.isEmpty ? index + 1 : order.id}',
                  ),
                  subtitle: Text(
                    '${order.items.length} prendas · ${AppUtils.formatDate(order.fechaCreacion)}\n${AppUtils.formatCurrency(order.total)}',
                  ),
                  isThreeLine: true,
                  trailing: Chip(
                    label: Text(order.estado),
                    backgroundColor: _statusColor(
                      order.estado,
                    ).withValues(alpha: 0.16),
                  ),
                );
              },
            ),
    );
  }

  Color _statusColor(String status) {
    return switch (status) {
      'confirmado' => AppTheme.accentGold,
      'enviado' => Colors.blue,
      'entregado' => AppTheme.successColor,
      _ => AppTheme.accentBeige,
    };
  }
}
