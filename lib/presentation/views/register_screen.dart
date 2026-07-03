import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_router.dart';
import '../../core/theme/app_theme.dart';
import '../design_system/atoms/casona_button.dart';
import '../design_system/atoms/casona_text_field.dart';
import '../design_system/molecules/casona_section_card.dart';
import '../viewmodels/auth_viewmodel.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Crear cuenta')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CasonaSectionCard(
              icon: Icons.person_add_alt_1_outlined,
              title: 'Nueva cuenta',
              subtitle: 'Crea tu perfil para guardar pedidos y favoritos.',
              child: Column(
                children: [
                  CasonaTextField(
                    controller: _nameController,
                    labelText: 'Nombre',
                    prefixIcon: Icons.person_outline,
                  ),
                  const SizedBox(height: 16),
                  CasonaTextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    labelText: 'Email',
                    prefixIcon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 16),
                  CasonaTextField(
                    controller: _passwordController,
                    obscureText: true,
                    labelText: 'Contrasena',
                    prefixIcon: Icons.lock_outline,
                  ),
                  const SizedBox(height: 16),
                  CasonaTextField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    labelText: 'Confirmar contrasena',
                    prefixIcon: Icons.lock_reset,
                  ),
                ],
              ),
            ),
            if (auth.error != null) ...[
              const SizedBox(height: 12),
              Text(
                auth.error!,
                style: const TextStyle(color: AppTheme.errorColor),
              ),
            ],
            const SizedBox(height: 24),
            CasonaButton(
              text: 'Registrarme',
              icon: Icons.how_to_reg,
              isLoading: auth.isLoading,
              onPressed: auth.isLoading ? null : _register,
            ),
            CasonaButton(
              text: 'Ya tengo cuenta',
              variant: CasonaButtonVariant.ghost,
              onPressed: () => context.goNamed(AppRouter.login),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _register() async {
    final success = await context.read<AuthViewModel>().register(
      nombre: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
    );
    if (success && mounted) context.goNamed(AppRouter.home);
  }
}
