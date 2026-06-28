import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/routes/app_router.dart';
import '../../core/theme/app_theme.dart';
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
              const SizedBox(height: 48),
              Text(
                AppConstants.appName,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 8),
              Text(
                AppConstants.appTagline,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.darkText.withValues(alpha: 0.65),
                ),
              ),
              const SizedBox(height: 48),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: Icon(Icons.lock_outline),
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
              ElevatedButton(
                onPressed: auth.isLoading ? null : _login,
                child: auth.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Iniciar sesión'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: auth.isLoading ? null : _biometricLogin,
                icon: const Icon(Icons.fingerprint),
                label: Text(
                  auth.isBiometricEnabled
                      ? 'Entrar con biometría'
                      : 'Biometría no configurada',
                ),
              ),
              if (!auth.isBiometricEnabled) ...[
                const SizedBox(height: 8),
                Text(
                  'Actívala desde Perfil después de iniciar sesión.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.darkText.withValues(alpha: 0.58),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.goNamed(AppRouter.register),
                child: const Text('Crear cuenta'),
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
