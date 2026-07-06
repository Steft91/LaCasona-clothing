import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/app_utils.dart';
import '../design_system/atoms/casona_button.dart';
import '../design_system/atoms/casona_text_field.dart';
import '../design_system/molecules/casona_section_card.dart';
import '../design_system/organisms/casona_list_tile.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/cart_viewmodel.dart';
import '../viewmodels/checkout_viewmodel.dart';
import '../viewmodels/orders_viewmodel.dart';
import '../viewmodels/purchase_viewmodel.dart';
import '../widgets/login_required.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartViewModel>();
    final checkout = context.watch<CheckoutViewModel>();
    final user = context.watch<AuthViewModel>().user;
    final total = cart.total;

    return Scaffold(
      appBar: AppBar(title: const Text('Pago')),
      body: user == null
          ? const LoginRequired(
              icon: Icons.lock_outline,
              title: 'Inicia sesión para pagar',
              message:
                  'Necesitamos tu cuenta para registrar el pedido y actualizar el stock.',
            )
          : SafeArea(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    CasonaSectionCard(
                      icon: Icons.lock_outline,
                      title: 'Finaliza tu compra',
                      subtitle:
                          'Confirma la direccion de entrega y completa el pago seguro.',
                      child: CasonaTextField(
                        controller: _addressController,
                        minLines: 2,
                        maxLines: 3,
                        textInputAction: TextInputAction.done,
                        labelText: 'Direccion de entrega',
                        hintText: 'Ej. Centro historico, Quito',
                        prefixIcon: Icons.location_on_outlined,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Ingresa una direccion de entrega.';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    CasonaListTile(
                      title: 'Total a pagar',
                      subtitle: '${cart.items.length} producto(s)',
                      trailing: Text(
                        AppUtils.formatCurrency(total),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.carvedWood,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (checkout.error != null) ...[
                      Text(
                        checkout.error!,
                        style: const TextStyle(color: AppTheme.errorColor),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                    ],
                    CasonaButton(
                      text: 'Pagar de forma segura',
                      icon: Icons.lock_outline,
                      isLoading: checkout.isLoading,
                      onPressed: cart.items.isEmpty
                          ? null
                          : () => _handlePayment(
                              context,
                              total,
                              user.id,
                              user.nombre,
                              user.email,
                            ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _handlePayment(
    BuildContext context,
    double total,
    String userId,
    String userName,
    String userEmail,
  ) async {
    if (!_formKey.currentState!.validate()) return;

    final address = _addressController.text.trim();
    final checkoutViewModel = context.read<CheckoutViewModel>();
    final success = await checkoutViewModel.processPayment(
      amount: total,
      currency: 'usd',
      userId: userId,
      createOrder: () => context.read<OrdersViewModel>().confirmOrder(
        userId: userId,
        direccionEntrega: address,
      ),
    );

    if (!context.mounted) return;
    if (success) {
      await context.read<CartViewModel>().loadCart(userId);
      if (!context.mounted) return;

      final order = checkoutViewModel.lastCompletedOrder;
      var emailSent = false;
      String? emailError;
      if (order != null) {
        final purchaseViewModel = context.read<PurchaseViewModel>();
        emailSent = await purchaseViewModel.sendPurchaseConfirmation(
          userName: userName,
          recipientEmail: userEmail,
          order: order,
        );
        emailError = purchaseViewModel.emailError;
      }
      if (!context.mounted) return;

      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          icon: const Icon(
            Icons.check_circle_outline,
            color: AppTheme.successColor,
          ),
          title: const Text('Pago exitoso'),
          content: const Text('Tu pedido fue registrado correctamente.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                context.goNamed(AppRouter.home);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      emailSent
                          ? 'Se envio un correo con la factura de tu compra.'
                          : emailError ??
                                'Compra realizada. No se pudo enviar el correo.',
                    ),
                    backgroundColor: emailSent
                        ? AppTheme.successColor
                        : AppTheme.errorColor,
                  ),
                );
              },
              child: const Text('Entendido'),
            ),
          ],
        ),
      );
    }
  }
}
