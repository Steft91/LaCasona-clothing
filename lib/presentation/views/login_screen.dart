import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/routes/app_router.dart';
import '../../core/theme/app_theme.dart';
import '../design_system/atoms/casona_button.dart';
import '../design_system/atoms/casona_text_field.dart';
import '../design_system/molecules/casona_section_card.dart';
import '../viewmodels/auth_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthViewModel>().loadCurrentUser();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 42),
              Center(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppTheme.softGold.withValues(alpha: 0.28),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppTheme.lineGold),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(18),
                    child: Icon(
                      Icons.storefront_rounded,
                      size: 42,
                      color: AppTheme.carvedWood,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                AppConstants.appName,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 8),
              Text(
                AppConstants.appTagline,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 34),
              CasonaSectionCard(
                title: 'Bienvenida',
                subtitle: 'Ingresa para continuar tu compra.',
                child: Column(
                  children: [
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
                text: 'Iniciar sesion',
                icon: Icons.login,
                isLoading: auth.isLoading,
                onPressed: auth.isLoading ? null : _login,
              ),
              const SizedBox(height: 12),
              CasonaButton(
                text: auth.isBiometricEnabled
                    ? 'Entrar con biometria'
                    : 'Biometria no configurada',
                icon: Icons.fingerprint,
                variant: CasonaButtonVariant.secondary,
                onPressed: auth.isLoading ? null : _biometricLogin,
              ),
              if (!auth.isBiometricEnabled) ...[
                const SizedBox(height: 8),
                Text(
                  'Activala desde Perfil despues de iniciar sesion.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: 16),
              CasonaButton(
                text: 'Crear cuenta',
                variant: CasonaButtonVariant.ghost,
                onPressed: () => context.goNamed(AppRouter.register),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    final success = await context.read<AuthViewModel>().login(
      _emailController.text,
      _passwordController.text,
    );
    if (success && mounted) context.goNamed(AppRouter.home);
  }

  Future<void> _biometricLogin() async {
    final success = await context.read<AuthViewModel>().biometricLogin();
    if (success && mounted) context.goNamed(AppRouter.home);
  }
}
